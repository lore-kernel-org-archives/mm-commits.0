Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242094C6F
	for <mm-commits@vger.kernel.org>; Thu,  4 Apr 2024 01:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712195518; cv=none; b=XMTTdFZ6SfStNZ7s6L/UZ3EN/xLJaayeCAvVfj3uVlRSXs6tW8kNU45piwtiVmBg3y/cH35G7VVa0DHI3f811ieYBr7OyoZ5NdMl7I28dekQYuFcRxhtpwzJ6LzNQYFoeDetgUV10US52MarFhC6NK50nwebZyCWb75sqzyhJMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712195518; c=relaxed/simple;
	bh=avaV9m7DCFJPn9RouMIC4K0hkJ2z5AMnIVFgLRaHd44=;
	h=Date:To:From:Subject:Message-Id; b=gDrYdbFFEPri9UWNgjfaR/N1pVv4ChIvEfkO2iwDqSfls9Yb+v1ca9QoN4Ly7Krry7S7mc/PqFDzcjnVTZ1TPfllC6vpBJOeN93SpHZ7ICQjjuHI3cRNxMq3CYCEp5rT0tUTobiekPelG2Ams2R1CftmUHHFW5w9FU7ha1+HjW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tApj3aLl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tApj3aLl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8442C433C7;
	Thu,  4 Apr 2024 01:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712195518;
	bh=avaV9m7DCFJPn9RouMIC4K0hkJ2z5AMnIVFgLRaHd44=;
	h=Date:To:From:Subject:From;
	b=tApj3aLldHs1aI27n8GckMJo/mS4dDyl6aaRNPuZIfVMDe561fW377VpyhCaMP+/R
	 /ZC7nWsKG+HoMV2L4J96SIn3xR0tIdvzWGWZUGNA0+srbpeCiXR5Ap9/sVLj4FbUao
	 9Osuf6+TQD3XeR2lZRNBisNYSHKc4TwPTfWmGZBM=
Date: Wed, 03 Apr 2024 18:51:57 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,ghe@suse.com,gechangwei@live.cn,glass.su@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-use-coarse-time-for-new-created-files.patch added to mm-nonmm-unstable branch
Message-Id: <20240404015157.E8442C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: use coarse time for new created files
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-use-coarse-time-for-new-created-files.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-use-coarse-time-for-new-created-files.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Su Yue <glass.su@suse.com>
Subject: ocfs2: use coarse time for new created files
Date: Tue, 2 Apr 2024 09:46:51 +0800

The default atime related mount option is '-o realtime' which means file
atime should be updated if atime <= ctime or atime <= mtime.  atime should
be updated in the following scenario, but it is not:

==========================================================
$ rm /mnt/testfile;
$ echo test > /mnt/testfile
$ stat -c "%X %Y %Z" /mnt/testfile
1711881646 1711881646 1711881646
$ sleep 5
$ cat /mnt/testfile > /dev/null
$ stat -c "%X %Y %Z" /mnt/testfile
1711881646 1711881646 1711881646
==========================================================

And the reason the atime in the test is not updated is that ocfs2 calls
ktime_get_real_ts64() in __ocfs2_mknod_locked during file creation.  Then
inode_set_ctime_current() is called in inode_set_ctime_current() calls
ktime_get_coarse_real_ts64() to get current time.

ktime_get_real_ts64() is more accurate than ktime_get_coarse_real_ts64(). 
In my test box, I saw ctime set by ktime_get_coarse_real_ts64() is less
than ktime_get_real_ts64() even ctime is set later.  The ctime of the new
inode is smaller than atime.

The call trace is like:

ocfs2_create
  ocfs2_mknod
    __ocfs2_mknod_locked
    ....

      ktime_get_real_ts64 <------- set atime,ctime,mtime, more accurate
      ocfs2_populate_inode
    ...
    ocfs2_init_acl
      ocfs2_acl_set_mode
        inode_set_ctime_current
          current_time
            ktime_get_coarse_real_ts64 <-------less accurate

ocfs2_file_read_iter
  ocfs2_inode_lock_atime
    ocfs2_should_update_atime
      atime <= ctime ? <-------- false, ctime < atime due to accuracy

So here call ktime_get_coarse_real_ts64 to set inode time coarser while
creating new files.  It may lower the accuracy of file times.  But it's
not a big deal since we already use coarse time in other places like
ocfs2_update_inode_atime and inode_set_ctime_current.

Link: https://lkml.kernel.org/r/20240402014651.13723-5-glass.su@suse.com
Signed-off-by: Su Yue <glass.su@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/namei.c~ocfs2-use-coarse-time-for-new-created-files
+++ a/fs/ocfs2/namei.c
@@ -566,7 +566,7 @@ static int __ocfs2_mknod_locked(struct i
 	fe->i_last_eb_blk = 0;
 	strcpy(fe->i_signature, OCFS2_INODE_SIGNATURE);
 	fe->i_flags |= cpu_to_le32(OCFS2_VALID_FL);
-	ktime_get_real_ts64(&ts);
+	ktime_get_coarse_real_ts64(&ts);
 	fe->i_atime = fe->i_ctime = fe->i_mtime =
 		cpu_to_le64(ts.tv_sec);
 	fe->i_mtime_nsec = fe->i_ctime_nsec = fe->i_atime_nsec =
_

Patches currently in -mm which might be from glass.su@suse.com are

ocfs2-update-inode-ctime-in-ocfs2_fileattr_set.patch
ocfs2-return-real-error-code-in-ocfs2_dio_wr_get_block.patch
ocfs2-fix-races-between-hole-punching-and-aiodio.patch
ocfs2-update-inode-fsync-transaction-id-in-ocfs2_unlink-and-ocfs2_link.patch
ocfs2-use-coarse-time-for-new-created-files.patch

