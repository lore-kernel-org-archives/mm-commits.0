From: akpm@linux-foundation.org
Subject: + mm-hwpoison-fix-miss-catch-transparent-huge-page.patch added to -mm tree
Date: Thu, 26 Sep 2013 11:54:43 -0700
Message-ID: <524482f3.2GIYrhg1xfBp0dIl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60167 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555Ab3IZSyp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Sep 2013 14:54:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, ak@linux.intel.com, liwanp@linux.vnet.ibm.com

Subject: + mm-hwpoison-fix-miss-catch-transparent-huge-page.patch added to -mm tree
To: liwanp@linux.vnet.ibm.com,ak@linux.intel.com,n-horiguchi@ah.jp.nec.com
From: akpm@linux-foundation.org
Date: Thu, 26 Sep 2013 11:54:43 -0700


The patch titled
     Subject: mm/hwpoison: fix test for a transparent huge page
has been added to the -mm tree.  Its filename is
     mm-hwpoison-fix-miss-catch-transparent-huge-page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-fix-miss-catch-transparent-huge-page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-fix-miss-catch-transparent-huge-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/hwpoison: fix test for a transparent huge page

PageTransHuge() can't guarantee the page is a transparent huge page since
it returns true for both transparent huge and hugetlbfs pages.  This patch
fixes it by checking the page is also !hugetlbfs page.

Before patch:

[  121.571128] Injecting memory failure at pfn 23a200
[  121.571141] MCE 0x23a200: huge page recovery: Delayed
[  140.355100] MCE: Memory failure is now running on 0x23a200

After patch:

[   94.290793] Injecting memory failure at pfn 23a000
[   94.290800] MCE 0x23a000: huge page recovery: Delayed
[  105.722303] MCE: Software-unpoisoned page 0x23a000

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory-failure.c~mm-hwpoison-fix-miss-catch-transparent-huge-page mm/memory-failure.c
--- a/mm/memory-failure.c~mm-hwpoison-fix-miss-catch-transparent-huge-page
+++ a/mm/memory-failure.c
@@ -1349,7 +1349,7 @@ int unpoison_memory(unsigned long pfn)
 	 * worked by memory_failure() and the page lock is not held yet.
 	 * In such case, we yield to memory_failure() and make unpoison fail.
 	 */
-	if (PageTransHuge(page)) {
+	if (!PageHuge(page) && PageTransHuge(page)) {
 		pr_info("MCE: Memory failure is now running on %#lx\n", pfn);
 			return 0;
 	}
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

revert-mm-memory-hotplug-fix-lowmem-count-overflow-when-offline-pages.patch
mm-compactionc-periodically-schedule-when-freeing-pages.patch
mm-hwpoison-fix-traverse-hugetlbfs-page-to-avoid-printk-flood.patch
mm-hwpoison-fix-miss-catch-transparent-huge-page.patch
mm-hwpoison-fix-false-report-2nd-try-page-recovery.patch
mm-hwpoison-fix-the-lack-of-one-reference-count-against-poisoned-page.patch
ksm-remove-redundant-__gfp_zero-from-kcalloc.patch
mm-huge_memoryc-fix-stale-comments-of-transparent_hugepage_flags.patch
mm-memory-failurec-move-set_migratetype_isolate-outside-get_any_page.patch
mm-vmalloc-dont-set-area-caller-twice.patch
mm-vmalloc-fix-show-vmap_area-information-race-with-vmap_area-tear-down.patch
mm-vmalloc-revert-mm-vmallocc-check-vm_uninitialized-flag-in-s_show-instead-of-show_numa_info.patch
revert-mm-vmallocc-emit-the-failure-message-before-return.patch
memblock-factor-out-of-top-down-allocation.patch
memblock-introduce-bottom-up-allocation-mode.patch
x86-mm-factor-out-of-top-down-direct-mapping-setup.patch
x86-mem-hotplug-support-initialize-page-tables-in-bottom-up.patch
x86-acpi-crash-kdump-do-reserve_crashkernel-after-srat-is-parsed.patch
mem-hotplug-introduce-movablenode-boot-option.patch
mm-thp-cleanup-mv-alloc_hugepage-to-better-place.patch
mm-thp-khugepaged-add-policy-for-finding-target-node.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

