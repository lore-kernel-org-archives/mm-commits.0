From: akpm@linux-foundation.org
Subject: [merged] ksm-check-for-err_ptr-from-follow_page.patch removed from -mm tree
Date: Mon, 26 Apr 2010 10:26:57 -0400
Message-ID: <201004261728.o3QHSV56009129@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46121 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752865Ab0DZR3C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Apr 2010 13:29:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: error27@gmail.com, aarcange@redhat.com, hannes@cmpxchg.org, ieidus@redhat.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ksm: check for ERR_PTR from follow_page()
has been removed from the -mm tree.  Its filename was
     ksm-check-for-err_ptr-from-follow_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ksm: check for ERR_PTR from follow_page()
From: Dan Carpenter <error27@gmail.com>

The follow_page() function can potentially return -EFAULT so I added
checks for this.

Also I silenced an uninitialized variable warning on my version of gcc
(version 4.3.2).

Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Izik Eidus <ieidus@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/ksm.c~ksm-check-for-err_ptr-from-follow_page mm/ksm.c
--- a/mm/ksm.c~ksm-check-for-err_ptr-from-follow_page
+++ a/mm/ksm.c
@@ -365,7 +365,7 @@ static int break_ksm(struct vm_area_stru
 	do {
 		cond_resched();
 		page = follow_page(vma, addr, FOLL_GET);
-		if (!page)
+		if (IS_ERR_OR_NULL(page))
 			break;
 		if (PageKsm(page))
 			ret = handle_mm_fault(vma->vm_mm, vma, addr,
@@ -447,7 +447,7 @@ static struct page *get_mergeable_page(s
 		goto out;
 
 	page = follow_page(vma, addr, FOLL_GET);
-	if (!page)
+	if (IS_ERR_OR_NULL(page))
 		goto out;
 	if (PageAnon(page)) {
 		flush_anon_page(vma, page, addr);
@@ -1086,7 +1086,7 @@ struct rmap_item *unstable_tree_search_i
 		cond_resched();
 		tree_rmap_item = rb_entry(*new, struct rmap_item, node);
 		tree_page = get_mergeable_page(tree_rmap_item);
-		if (!tree_page)
+		if (IS_ERR_OR_NULL(tree_page))
 			return NULL;
 
 		/*
@@ -1294,7 +1294,7 @@ next_mm:
 			if (ksm_test_exit(mm))
 				break;
 			*page = follow_page(vma, ksm_scan.address, FOLL_GET);
-			if (*page && PageAnon(*page)) {
+			if (!IS_ERR_OR_NULL(*page) && PageAnon(*page)) {
 				flush_anon_page(vma, *page, ksm_scan.address);
 				flush_dcache_page(*page);
 				rmap_item = get_next_rmap_item(slot,
@@ -1308,7 +1308,7 @@ next_mm:
 				up_read(&mm->mmap_sem);
 				return rmap_item;
 			}
-			if (*page)
+			if (!IS_ERR_OR_NULL(*page))
 				put_page(*page);
 			ksm_scan.address += PAGE_SIZE;
 			cond_resched();
@@ -1367,7 +1367,7 @@ next_mm:
 static void ksm_do_scan(unsigned int scan_npages)
 {
 	struct rmap_item *rmap_item;
-	struct page *page;
+	struct page *uninitialized_var(page);
 
 	while (scan_npages--) {
 		cond_resched();
_

Patches currently in -mm which might be from error27@gmail.com are

origin.patch
linux-next.patch
power_meter-acpi_device_class-power_meter_resource-too-long.patch
sbshc-acpi_device_class-smbus_host_controller-too-long.patch
acpi_pad-processor_aggregator-name-too-long.patch
acpi_pad-processor_aggregator-name-too-long-fix.patch
drivers-gpu-drm-via-via_videoc-fix-off-by-one-issue.patch
drivers-gpu-drm-radeon-radeon_atombiosc-range-check-issues.patch
drivers-gpu-drm-drm_sysfsc-sysfs-files-error-handling.patch
drivers-gpu-drm-drm_memoryc-fix-check-for-end-of-loop.patch
drivers-media-video-au0828-au0828-videoc-off-by-one-bug.patch
drivers-media-video-zc0301-zc0301_corec-improve-error-handling.patch
drivers-media-video-et61x251-et61x251_corec-improve-error-handling.patch
drivers-media-video-sn9c102-sn9c102_corec-improve-error-handling.patch
cx88-improve-error-handling.patch
ir-keytable-avoid-double-lock.patch
cx231xx-improve-error-handling.patch
backlight-backlight_device_register-return-err_ptr.patch
scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch
drivers-staging-otus-hal-hpanic-using-the-wrong-variable.patch
drivers-staging-comedi-drivers-dt2801c-off-by-one-issue.patch
musb-potential-use-after-free.patch
usb-oxu210hp-release-spinlock-on-error-path.patch
mm-document-follow_page.patch
dynamic_debug-small-cleanup-in-ddebug_proc_write.patch
sis-strcpy-=-strlcpy.patch
proc-cleanup-remove-unused-assignments.patch
fs-sysv-dereferencing-err_ptr.patch

