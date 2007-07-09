From: akpm@linux-foundation.org
Subject: - rd-remove-ramdisk_set_page_dirty.patch removed from -mm tree
Date: Mon, 09 Jul 2007 14:48:41 -0700
Message-ID: <200707092148.l69LmfMp014129@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34910 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755470AbXGIVss (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 17:48:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     rd: remove ramdisk_set_page_dirty
has been removed from the -mm tree.  Its filename was
     rd-remove-ramdisk_set_page_dirty.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: rd: remove ramdisk_set_page_dirty
From: Eric W. Biederman <ebiederm@xmission.com>

The generic function __set_page_dirty_buffers called by default by
set_page_dirty appears to be a correct superset of ramdisk_set_page_dirty. 
So remove the specialized ramdisk version.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/rd.c |   27 ---------------------------
 1 files changed, 27 deletions(-)

diff -puN drivers/block/rd.c~rd-remove-ramdisk_set_page_dirty drivers/block/rd.c
--- a/drivers/block/rd.c~rd-remove-ramdisk_set_page_dirty
+++ a/drivers/block/rd.c
@@ -114,37 +114,10 @@ static int ramdisk_readpage(struct file 
 	return 0;
 }
 
-/*
- * ramdisk blockdev pages have their own ->set_page_dirty() because we don't
- * want them to contribute to dirty memory accounting.
- */
-static int ramdisk_set_page_dirty(struct page *page)
-{
-	struct address_space * const mapping = page->mapping;
-
-	spin_lock(&mapping->private_lock);
-	if (page_has_buffers(page)) {
-		struct buffer_head *head = page_buffers(page);
-		struct buffer_head *bh = head;
-
-		do {
-			set_buffer_uptodate(bh);
-			set_buffer_dirty(bh);
-			bh = bh->b_this_page;
-		} while (bh != head);
-	}
-	spin_unlock(&mapping->private_lock);
-
-	if (!TestSetPageDirty(page))
-		return 1;
-	return 0;
-}
-
 static const struct address_space_operations ramdisk_aops = {
 	.readpage	= ramdisk_readpage,
 	.prepare_write	= simple_prepare_write,
 	.commit_write	= simple_commit_write,
-	.set_page_dirty	= ramdisk_set_page_dirty,
 };
 
 static int rd_blkdev_pagecache_IO(int rw, struct bio_vec *vec, sector_t sector,
_

Patches currently in -mm which might be from ebiederm@xmission.com are

dvb_en_50221-convert-to-kthread-api.patch
git-kbuild.patch
fix-i-oat-for-kexec.patch
fix-x86_64-mm-add-common-orderly_poweroff.patch
x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3.patch
i386-trim-memory-not-covered-by-wb-mtrrs.patch
x86-64-disable-the-gart-in-shutdown.patch
x86_84-move-iommu-declaration-from-proto-to-iommuh.patch
x86_64-add-ioapic-nmi-support.patch
xen-suppress-abs-symbol-warnings-for-unused-reloc-pointers.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
buffer-kill-old-incorrect-comment.patch
remove-config_uts_ns-and-config_ipc_ns.patch
user-namespace-add-the-framework.patch
user-namespace-add-unshare.patch
mm-fix-create_new_namespaces-return-value.patch
add-a-kmem_cache-for-nsproxy-objects.patch
update-procfs-guide-doc-of-read_func.patch
namespace-ensure-clone_flags-are-always-stored-in-an-unsigned-long.patch
add-documentation-sysctl-ctl_unnumberedtxt.patch
sysctlc-add-text-telling-people-to-use-ctl_unnumbered.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
containersv10-basic-container-framework.patch
containersv10-basic-container-framework-fix.patch
containersv10-example-cpu-accounting-subsystem.patch
containersv10-example-cpu-accounting-subsystem-fix.patch
containersv10-add-tasks-file-interface.patch
containersv10-add-tasks-file-interface-fix.patch
containersv10-add-fork-exit-hooks.patch
containersv10-add-fork-exit-hooks-fix.patch
containersv10-add-container_clone-interface.patch
containersv10-add-container_clone-interface-fix.patch
containersv10-add-procfs-interface.patch
containersv10-add-procfs-interface-fix.patch
containersv10-make-cpusets-a-client-of-containers.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-cpuset-zero-malloc-fix-for-new-containers.patch
containersv10-simple-debug-info-subsystem.patch
containersv10-simple-debug-info-subsystem-fix.patch
containersv10-simple-debug-info-subsystem-fix-2.patch
containersv10-support-for-automatic-userspace-release-agents.patch
containers-implement-subsys-post_clone.patch
containers-implement-namespace-tracking-subsystem-v3.patch
