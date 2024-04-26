Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A9181752;
	Fri, 26 Apr 2024 04:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104479; cv=none; b=AMs2mdhmlQ4NrDIBooomSt0arzTxgPaFxssaHnjqcX/XqzDtvSakeI3VJjPscS5Fhf6kycHrEDEjzHLkgOXHmmPOl0iCAu3BefvdMg2iaqXgw/563oiK7TZqBUlu6b2UZUt+bI7Vs+a0/Rdfs8Zi+uf3uL9bCPjnTLIzCOSwE1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104479; c=relaxed/simple;
	bh=FcPGeTfDSDoHSVsRs8uk3aucdQlnp0Utnf2jlZ8Nc6E=;
	h=Date:To:From:Subject:Message-Id; b=G59BmbSH6LgqOd0RtXzS0dGLAHvbNGA1m2+dDzGxx1tp1r899D9OynWkoenoOqwkqmO5XZRM+MLV9ychn4/nZPKq/fbMwC3Sg/Y8Ed/v8aCMdSLPOWxZI59Rk7XPAuFis9k+o/OgigJxZYGBg2rcQKFP3tIZh/X6120YsJb5VjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kIg12gLN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kIg12gLN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE7E5C113CD;
	Fri, 26 Apr 2024 04:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104479;
	bh=FcPGeTfDSDoHSVsRs8uk3aucdQlnp0Utnf2jlZ8Nc6E=;
	h=Date:To:From:Subject:From;
	b=kIg12gLNjB/br3yUQDBmABYbP0zbPIMI2jPFMm5AAwQeKJZpvyjNSjKonDv7xHhIQ
	 3w3avZpqFqUMEIC02FjR9qbaFIlZtFxsxsmkMHrguhr9XZwtEgoYH7d66kAh5jsddi
	 Sj1mWf2AYAA/a9WJ2icdYNsIU+PfVk1al/YYiK3U=
Date: Thu, 25 Apr 2024 21:07:59 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,ghe@suse.com,gechangwei@live.cn,glass.su@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-fix-races-between-hole-punching-and-aiodio.patch removed from -mm tree
Message-Id: <20240426040759.AE7E5C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: fix races between hole punching and AIO+DIO
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-races-between-hole-punching-and-aiodio.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Su Yue <glass.su@suse.com>
Subject: ocfs2: fix races between hole punching and AIO+DIO
Date: Mon, 8 Apr 2024 16:20:39 +0800

After commit "ocfs2: return real error code in ocfs2_dio_wr_get_block",
fstests/generic/300 become from always failed to sometimes failed:

========================================================================
[  473.293420 ] run fstests generic/300

[  475.296983 ] JBD2: Ignoring recovery information on journal
[  475.302473 ] ocfs2: Mounting device (253,1) on (node local, slot 0) with ordered data mode.
[  494.290998 ] OCFS2: ERROR (device dm-1): ocfs2_change_extent_flag: Owner 5668 has an extent at cpos 78723 which can no longer be found
[  494.291609 ] On-disk corruption discovered. Please run fsck.ocfs2 once the filesystem is unmounted.
[  494.292018 ] OCFS2: File system is now read-only.
[  494.292224 ] (kworker/19:11,2628,19):ocfs2_mark_extent_written:5272 ERROR: status = -30
[  494.292602 ] (kworker/19:11,2628,19):ocfs2_dio_end_io_write:2374 ERROR: status = -3
fio: io_u error on file /mnt/scratch/racer: Read-only file system: write offset=460849152, buflen=131072
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

In most filesystems, fallocate is not compatible with racing with AIO+DIO,
so fix it by adding to wait for all dio before fallocate/punch_hole like
ext4.

Link: https://lkml.kernel.org/r/20240408082041.20925-3-glass.su@suse.com
Fixes: b25801038da5 ("ocfs2: Support xfs style space reservation ioctls")
Signed-off-by: Su Yue <glass.su@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: <stable@vger.kernel.org>
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


