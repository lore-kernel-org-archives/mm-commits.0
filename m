From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-elevate-mnt-writers-for-vfs_unlink-callers.patch removed from -mm tree
Date: Mon, 05 Nov 2007 15:07:30 -0800
Message-ID: <200711052307.lA5N7UTI024364@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50575 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754470AbXKEXJY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 18:09:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haveblue@us.ibm.com, hch@infradead.org, mm-commits@vger.kernel.org


The patch titled
     r/o bind mounts: elevate mnt writers for vfs_unlink() callers
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-elevate-mnt-writers-for-vfs_unlink-callers.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: r/o bind mounts: elevate mnt writers for vfs_unlink() callers
From: Dave Hansen <haveblue@us.ibm.com>

Acked-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c   |    4 ++++
 ipc/mqueue.c |    5 ++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff -puN fs/namei.c~r-o-bind-mounts-elevate-mnt-writers-for-vfs_unlink-callers fs/namei.c
--- a/fs/namei.c~r-o-bind-mounts-elevate-mnt-writers-for-vfs_unlink-callers
+++ a/fs/namei.c
@@ -2256,7 +2256,11 @@ static long do_unlinkat(int dfd, const c
 		inode = dentry->d_inode;
 		if (inode)
 			atomic_inc(&inode->i_count);
+		error = mnt_want_write(nd.mnt);
+		if (error)
+			goto exit2;
 		error = vfs_unlink(nd.dentry->d_inode, dentry);
+		mnt_drop_write(nd.mnt);
 	exit2:
 		dput(dentry);
 	}
diff -puN ipc/mqueue.c~r-o-bind-mounts-elevate-mnt-writers-for-vfs_unlink-callers ipc/mqueue.c
--- a/ipc/mqueue.c~r-o-bind-mounts-elevate-mnt-writers-for-vfs_unlink-callers
+++ a/ipc/mqueue.c
@@ -746,8 +746,11 @@ asmlinkage long sys_mq_unlink(const char
 	inode = dentry->d_inode;
 	if (inode)
 		atomic_inc(&inode->i_count);
-
+	err = mnt_want_write(mqueue_mnt);
+	if (err)
+		goto out_err;
 	err = vfs_unlink(dentry->d_parent->d_inode, dentry);
+	mnt_drop_write(mqueue_mnt);
 out_err:
 	dput(dentry);
 
_

Patches currently in -mm which might be from haveblue@us.ibm.com are

markers-fix-warnings.patch
maps4-add-proportional-set-size-accounting-in-smaps.patch
maps4-rework-task_size-macros.patch
maps4-move-is_swap_pte.patch
maps4-introduce-a-generic-page-walker.patch
maps4-use-pagewalker-in-clear_refs-and-smaps.patch
maps4-simplify-interdependence-of-maps-and-smaps.patch
maps4-move-clear_refs-code-to-task_mmuc.patch
maps4-regroup-task_mmu-by-interface.patch
maps4-add-proc-pid-pagemap-interface.patch
maps4-add-proc-kpagecount-interface.patch
maps4-add-proc-kpageflags-interface.patch
maps4-make-page-monitoring-proc-file-optional.patch
maps4-make-page-monitoring-proc-file-optional-fix.patch
hugetlb-split-alloc_huge_page-into-private-and-shared-components.patch
hugetlb-split-alloc_huge_page-into-private-and-shared-components-checkpatch-fixes.patch
hugetlb-fix-quota-management-for-private-mappings.patch
hugetlb-debit-quota-in-alloc_huge_page.patch
hugetlb-allow-bulk-updating-in-hugetlb__quota.patch
hugetlb-enforce-quotas-during-reservation-for-shared-mappings.patch
add-remove_memory-for-ppc64-2.patch
enable-hotplug-memory-remove-for-ppc64.patch
add-arch-specific-walk_memory_remove-for-ppc64.patch
r-o-bind-mounts-elevate-mnt-writers-for-vfs_unlink-callers.patch
r-o-bind-mounts-do_rmdir-elevate-write-count.patch
r-o-bind-mounts-track-number-of-mount-writers.patch
r-o-bind-mounts-track-number-of-mount-writers-make-lockdep-happy-with-r-o-bind-mounts.patch
r-o-bind-mounts-track-number-of-mount-writers-fix.patch
r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
