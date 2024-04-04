Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA5D4C6F
	for <mm-commits@vger.kernel.org>; Thu,  4 Apr 2024 01:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712195514; cv=none; b=ntCIEzJko2+ru8MfdvhGFk7kTD6oGPSDnf4GP4F4Fq/osYS/ajklpEZ5iLFRn/NgQBZom+I1l7SjGTICZihfgsrd+SQrOtKlh/u8Due5NAAIakNrLxh3mPh6SQrN7pV+1xgvGcuh4f1Fw+qcxJFvDa+FH9zjGgzszOewDXRu0Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712195514; c=relaxed/simple;
	bh=mf3EwHdV4h7/YlbszBw8r5oBBEikPcKGYMk5byJVP34=;
	h=Date:To:From:Subject:Message-Id; b=drOVRLhQaCxUybS+5zWNDogCERs3YorQiav9ysFV2IVmGG1m686G/hiE92CG1jxjIYieOVjWemm6P2klq+61VTrBXWJF+8gpWfLjBVImFUDgbzpgtOhe980VQz7aJdWgF19TVCCEHPie+UhmvfFGWEyvK/ZDROZgvmv6OF4ka58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q8Mlziy6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q8Mlziy6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34199C433F1;
	Thu,  4 Apr 2024 01:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712195514;
	bh=mf3EwHdV4h7/YlbszBw8r5oBBEikPcKGYMk5byJVP34=;
	h=Date:To:From:Subject:From;
	b=q8Mlziy6Ll2ijz562qAXHuo6UTJDUeboOrmCCkw600QRWbnkBuXiBxDePL1yDf2Kz
	 DyM0b6omSvn+a7owk4m5xnVxoyNllIG8BTUFi2IvMhlmunCz9JppGPGpsLHgTCU2oK
	 12GMGCwxX//g07g82H7DQxps+uBnA7vxlMONhqmo=
Date: Wed, 03 Apr 2024 18:51:53 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,ghe@suse.com,gechangwei@live.cn,glass.su@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-races-between-hole-punching-and-aiodio.patch added to mm-nonmm-unstable branch
Message-Id: <20240404015154.34199C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: fix races between hole punching and AIO+DIO
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-fix-races-between-hole-punching-and-aiodio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-races-between-hole-punching-and-aiodio.patch

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
Subject: ocfs2: fix races between hole punching and AIO+DIO
Date: Tue, 2 Apr 2024 09:46:49 +0800

After commit "ocfs2: return real error code in ocfs2_dio_wr_get_block",
fstests/generic/300 become from always failed to sometimes failed:

========================================================================
[  473.293420 ] run fstests generic/300

[  475.296983 ] JBD2: Ignoring recovery information on journal
[  475.302473 ] ocfs2: Mounting device (253,1) on (node local, slot 0)
with ordered data mode.
[  494.290998 ] OCFS2: ERROR (device dm-1): ocfs2_change_extent_flag:
Owner 5668 has an extent at cpos 78723 which can no longer be found
[  494.291609 ] On-disk corruption discovered. Please run fsck.ocfs2
once the filesystem is unmounted.
[  494.292018 ] OCFS2: File system is now read-only.
[  494.292224 ] (kworker/19:11,2628,19):ocfs2_mark_extent_written:5272
ERROR: status = -30
[  494.292602 ] (kworker/19:11,2628,19):ocfs2_dio_end_io_write:2374
ERROR: status = -3
fio: io_u error on file /mnt/scratch/racer: Read-only file system: write
offset=460849152, buflen=131072
=========================================================================

In __blockdev_direct_IO, ocfs2_dio_wr_get_block is called to add unwritten
extents to a list.  extents are also inserted into extent tree in
ocfs2_write_begin_nolock.  Then another thread call fallocate to puch a
hole at one of the unwritten extent.  The extent at cpos was removed by
ocfs2_remove_extent().  At end io worker thread, ocfs2_search_extent_list
found there is no such extent at the cpos.

    T1                        T2                T3
                              inode lock
                                ...
                                insert extents
                                ...
                              inode unlock
ocfs2_fallocate
 __ocfs2_change_file_space
  inode lock
  lock ip_alloc_sem
  ocfs2_remove_inode_range inode
   ocfs2_remove_btree_range
    ocfs2_remove_extent
    ^---remove the extent at cpos 78723
  ...
  unlock ip_alloc_sem
  inode unlock
                                       ocfs2_dio_end_io
                                        ocfs2_dio_end_io_write
                                         lock ip_alloc_sem
                                         ocfs2_mark_extent_written
                                          ocfs2_change_extent_flag
                                           ocfs2_search_extent_list
                                           ^---failed to find extent
                                          ...
                                          unlock ip_alloc_sem

In most filesystems, fallocate is not compatible with racing with
AIO+DIO, so fix it by adding to wait for all dio before
fallocate/punch_hole like ext4.

Link: https://lkml.kernel.org/r/20240402014651.13723-3-glass.su@suse.com
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

 fs/ocfs2/file.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ocfs2/file.c~ocfs2-fix-races-between-hole-punching-and-aiodio
+++ a/fs/ocfs2/file.c
@@ -1936,6 +1936,8 @@ static int __ocfs2_change_file_space(str
 
 	inode_lock(inode);
 
+	/* Wait all existing dio workers, newcomers will block on i_rwsem */
+	inode_dio_wait(inode);
 	/*
 	 * This prevents concurrent writes on other nodes
 	 */
_

Patches currently in -mm which might be from glass.su@suse.com are

ocfs2-update-inode-ctime-in-ocfs2_fileattr_set.patch
ocfs2-return-real-error-code-in-ocfs2_dio_wr_get_block.patch
ocfs2-fix-races-between-hole-punching-and-aiodio.patch
ocfs2-update-inode-fsync-transaction-id-in-ocfs2_unlink-and-ocfs2_link.patch
ocfs2-use-coarse-time-for-new-created-files.patch

