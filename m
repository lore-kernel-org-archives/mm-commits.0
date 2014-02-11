From: akpm@linux-foundation.org
Subject: [merged]
 mm-memory-failurec-move-refcount-only-in-mf_count_increased.patch removed
 from -mm tree
Date: Tue, 11 Feb 2014 11:23:48 -0800
Message-ID: <52fa78c4.pyHwQ815AsaOvuu/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40916 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945AbaBKTXt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Feb 2014 14:23:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, liwanp@linux.vnet.ibm.com, gong.chen@linux.intel.com, andi@firstfloor.org, n-horiguchi@ah.jp.nec.com

Subject: [merged] mm-memory-failurec-move-refcount-only-in-mf_count_increased.patch removed from -mm tree
To: n-horiguchi@ah.jp.nec.com,andi@firstfloor.org,gong.chen@linux.intel.com,liwanp@linux.vnet.ibm.com,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 11 Feb 2014 11:23:48 -0800


The patch titled
     Subject: mm/memory-failure.c: move refcount only in !MF_COUNT_INCREASED
has been removed from the -mm tree.  Its filename was
     mm-memory-failurec-move-refcount-only-in-mf_count_increased.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm/memory-failure.c: move refcount only in !MF_COUNT_INCREASED

mce-test detected a test failure when injecting error to a thp tail page. 
This is because we take page refcount of the tail page in
madvise_hwpoison() while the fix in commit a3e0f9e47d5e
("mm/memory-failure.c: transfer page count from head page to tail page
after split thp") assumes that we always take refcount on the head page.

When a real memory error happens we take refcount on the head page where
memory_failure() is called without MF_COUNT_INCREASED set, so it seems to
me that testing memory error on thp tail page using madvise makes little
sense.

This patch cancels moving refcount in !MF_COUNT_INCREASED for valid testing.

[akpm@linux-foundation.org: s/&&/&/]
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Chen Gong <gong.chen@linux.intel.com>
Cc: <stable@vger.kernel.org>	[3.9+: a3e0f9e47d5e]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/memory-failure.c~mm-memory-failurec-move-refcount-only-in-mf_count_increased mm/memory-failure.c
--- a/mm/memory-failure.c~mm-memory-failurec-move-refcount-only-in-mf_count_increased
+++ a/mm/memory-failure.c
@@ -945,8 +945,10 @@ static int hwpoison_user_mappings(struct
 			 * to it. Similarly, page lock is shifted.
 			 */
 			if (hpage != p) {
-				put_page(hpage);
-				get_page(p);
+				if (!(flags & MF_COUNT_INCREASED)) {
+					put_page(hpage);
+					get_page(p);
+				}
 				lock_page(p);
 				unlock_page(hpage);
 				*hpagep = p;
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
mm-hwpoison-release-page-on-pagehwpoison-in-__do_fault.patch
mm-hugetlb-unify-region-structure-handling.patch
mm-hugetlb-improve-cleanup-resv_map-parameters.patch
mm-hugetlb-fix-race-in-region-tracking.patch
mm-hugetlb-remove-resv_map_put.patch
mm-hugetlb-use-vma_resv_map-map-types.patch
mm-hugetlb-improve-page-fault-scalability.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
madvise-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-rename-__do_fault-do_fault.patch
mm-do_fault-extract-to-call-vm_ops-do_fault-to-separate-function.patch
mm-introduce-do_read_fault.patch
mm-introduce-do_cow_fault.patch
mm-introduce-do_shared_fault-and-drop-do_fault.patch
mm-consolidate-code-to-call-vm_ops-page_mkwrite.patch
mm-consolidate-code-to-setup-pte.patch

