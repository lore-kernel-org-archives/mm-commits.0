From: akpm@linux-foundation.org
Subject: + mm-hwpoison-fix-false-report-2nd-try-page-recovery.patch added
 to -mm tree
Date: Thu, 26 Sep 2013 11:54:44 -0700
Message-ID: <524482f4.HpI7EVSn8x/5CWwe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60171 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557Ab3IZSyp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Sep 2013 14:54:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, ak@linux.intel.com, liwanp@linux.vnet.ibm.com

Subject: + mm-hwpoison-fix-false-report-2nd-try-page-recovery.patch added to -mm tree
To: liwanp@linux.vnet.ibm.com,ak@linux.intel.com,n-horiguchi@ah.jp.nec.com
From: akpm@linux-foundation.org
Date: Thu, 26 Sep 2013 11:54:44 -0700


The patch titled
     Subject: mm/hwpoison: fix false report on 2nd attempt at page recovery
has been added to the -mm tree.  Its filename is
     mm-hwpoison-fix-false-report-2nd-try-page-recovery.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-fix-false-report-2nd-try-page-recovery.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-fix-false-report-2nd-try-page-recovery.patch

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
Subject: mm/hwpoison: fix false report on 2nd attempt at page recovery

If the page is poisoned by software injection w/ MF_COUNT_INCREASED flag,
there is a false report during the 2nd attempt at page recovery which is
not truthful.  This patch fixes it by reporting the first attempt to try
free buddy page recovery if MF_COUNT_INCREASED is set.

Before patch:

[  346.332041] Injecting memory failure at pfn 200010
[  346.332189] MCE 0x200010: free buddy, 2nd try page recovery: Delayed

After patch:

[  297.742600] Injecting memory failure at pfn 200010
[  297.742941] MCE 0x200010: free buddy page recovery: Delayed

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/memory-failure.c~mm-hwpoison-fix-false-report-2nd-try-page-recovery mm/memory-failure.c
--- a/mm/memory-failure.c~mm-hwpoison-fix-false-report-2nd-try-page-recovery
+++ a/mm/memory-failure.c
@@ -1114,8 +1114,10 @@ int memory_failure(unsigned long pfn, in
 			 * shake_page could have turned it free.
 			 */
 			if (is_free_buddy_page(p)) {
-				action_result(pfn, "free buddy, 2nd try",
-						DELAYED);
+				if (flags & MF_COUNT_INCREASED)
+					action_result(pfn, "free buddy", DELAYED);
+				else
+					action_result(pfn, "free buddy, 2nd try", DELAYED);
 				return 0;
 			}
 			action_result(pfn, "non LRU", IGNORED);
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

