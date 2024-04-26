Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88B8763F8;
	Fri, 26 Apr 2024 04:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104482; cv=none; b=nqyjGGfYDxszLhaIltTPy9jMjFOe0r/93tpZ0clCDfiH74MSPKJX4ooFTLaQzcYYN555YuIS0Yl0+EBOiDSIa0hXcTTs6ehDBuWfiGS3oosVjSAxnDndOHv0rTmxPRj0VadqjStKrqLw62K5YJvqiZir3Q/A1hQkZAg7jQdXY+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104482; c=relaxed/simple;
	bh=yrzFl0lxWb3DG04pxPxw2mWTQ4M43sxM5VXhky+dEd0=;
	h=Date:To:From:Subject:Message-Id; b=JkXquyVojGbx/mc/rK8e1SNG1V9jTkAM3qLP6g9eamJX/usaZFgb588T2zDK+ZJS66FDVnLHnhpBCMRhYlCAZJQ7NjZ188YcPuUosUakEBFAWfG0lD8F3SwBNrxSZNF255xW1T0TVqjaN531JZLRr6ubGQhb1yZ4gqUQwuFDyjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oKU01lRf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oKU01lRf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D396C113CD;
	Fri, 26 Apr 2024 04:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104482;
	bh=yrzFl0lxWb3DG04pxPxw2mWTQ4M43sxM5VXhky+dEd0=;
	h=Date:To:From:Subject:From;
	b=oKU01lRfFMopYPbkCEd8HZpakJdv0gNCKIdvzq4rSwSfOYyk10ZjngMkUtvmffTjB
	 Xsky8lKLtWL+rzluQmZnzc8JQNm606xNrMoKuWvlcl5ybvryHDRhmToFwp+vZDgszQ
	 q7Xfd4cDDaFrBu653vdUN6sPkyKMdQs8M7wzQtAc=
Date: Thu, 25 Apr 2024 21:08:02 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,ghe@suse.com,gechangwei@live.cn,glass.su@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-use-coarse-time-for-new-created-files.patch removed from -mm tree
Message-Id: <20240426040802.7D396C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: use coarse time for new created files
has been removed from the -mm tree.  Its filename was
     ocfs2-use-coarse-time-for-new-created-files.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Su Yue <glass.su@suse.com>
Subject: ocfs2: use coarse time for new created files
Date: Mon, 8 Apr 2024 16:20:41 +0800

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

Link: https://lkml.kernel.org/r/20240408082041.20925-5-glass.su@suse.com
Fixes: c62c38f6b91b ("ocfs2: replace CURRENT_TIME macro")
Signed-off-by: Su Yue <glass.su@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
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


