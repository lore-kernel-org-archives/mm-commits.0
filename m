From: akpm@linux-foundation.org
Subject: [folded] hugetlb-add-phys-addr-to-struct-huge_bootmem_page-fix.patch removed from -mm tree
Date: Mon, 25 Jul 2011 16:52:53 -0700
Message-ID: <201107252352.p6PNqrcK005998@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752847Ab1GYXxX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jul 2011 19:53:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, beckyb@kernel.crashing.org, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     hugetlb-add-phys-addr-to-struct-huge_bootmem_page-fix
has been removed from the -mm tree.  Its filename was
     hugetlb-add-phys-addr-to-struct-huge_bootmem_page-fix.patch

This patch was dropped because it was folded into hugetlb-add-phys-addr-to-struct-huge_bootmem_page.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb-add-phys-addr-to-struct-huge_bootmem_page-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Becky Bruce <beckyb@kernel.crashing.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-add-phys-addr-to-struct-huge_bootmem_page-fix mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-add-phys-addr-to-struct-huge_bootmem_page-fix
+++ a/mm/hugetlb.c
@@ -1106,12 +1106,14 @@ static void __init gather_bootmem_preall
 
 	list_for_each_entry(m, &huge_boot_pages, list) {
 		struct hstate *h = m->hstate;
+		struct page *page;
+
 #ifdef CONFIG_HIGHMEM
-		struct page *page = pfn_to_page(m->phys >> PAGE_SHIFT);
+		page = pfn_to_page(m->phys >> PAGE_SHIFT);
 		free_bootmem_late((unsigned long)m,
 				  sizeof(struct huge_bootmem_page));
 #else
-		struct page *page = virt_to_page(m);
+		page = virt_to_page(m);
 #endif
 		__ClearPageReserved(page);
 		WARN_ON(page_count(page) != 1);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
hugetlb-add-phys-addr-to-struct-huge_bootmem_page.patch
mm-make-some-struct-pages-const-fix.patch
mm-use-const-struct-page-for-r-o-page-flag-accessor-methods-checkpatch-fixes.patch
xtensa-prevent-arbitrary-read-in-ptrace-fix.patch
mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines-fix.patch
pagewalk-add-locking-rule-comments-fix.patch
mm-memoryc-remove-zap_block_size.patch
mm-memblockc-avoid-abuse-of-red_inactive.patch
mm-preallocate-page-before-lock_page-at-filemap-cow.patch
mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young-checkpatch-fixes.patch
mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young-fix.patch
drivers-misc-add-support-the-fsa9480-usb-switch-fix.patch
lib-make-_tolower-public-checkpatch-fixes.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch
checkpatch-add-a-prefer-__aligned-check.patch
init-skip-calibration-delay-if-previously-done-fix.patch
init-skip-calibration-delay-if-previously-done-fix-fix.patch
init-skip-calibration-delay-if-previously-done-4.patch
drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix.patch
drivers-connector-cn_procc-remove-unused-local.patch
drivers-staging-gma500-psb_intel_displayc-fix-bad-udelay.patch

