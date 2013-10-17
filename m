From: akpm@linux-foundation.org
Subject: [merged]
 mm-hwpoison-fix-the-lack-of-one-reference-count-against-poisoned-page.patch removed from -mm tree
Date: Thu, 17 Oct 2013 11:12:45 -0700
Message-ID: <5260289d.AjzN4QbzBCnVzcDX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44259 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758657Ab3JQSMq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Oct 2013 14:12:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, ak@linux.intel.com, liwanp@linux.vnet.ibm.com

Subject: [merged] mm-hwpoison-fix-the-lack-of-one-reference-count-against-poisoned-page.patch removed from -mm tree
To: liwanp@linux.vnet.ibm.com,ak@linux.intel.com,n-horiguchi@ah.jp.nec.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 17 Oct 2013 11:12:45 -0700


The patch titled
     Subject: mm/hwpoison: fix the lack of one reference count against poisoned page
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-fix-the-lack-of-one-reference-count-against-poisoned-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/hwpoison: fix the lack of one reference count against poisoned page

The lack of one reference count against poisoned page for hwpoison_inject
w/o hwpoison_filter enabled result in hwpoison detect -1 users still
referenced the page, however, the number should be 0 except the poison
handler held one after successfully unmap.  This patch fix it by hold one
referenced count against poisoned page for hwpoison_inject w/ and w/o
hwpoison_filter enabled.

Before patch:

[   71.902112] Injecting memory failure at pfn 224706
[   71.902137] MCE 0x224706: dirty LRU page recovery: Failed
[   71.902138] MCE 0x224706: dirty LRU page still referenced by -1 users

After patch:

[   94.710860] Injecting memory failure at pfn 215b68
[   94.710885] MCE 0x215b68: dirty LRU page recovery: Recovered

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hwpoison-inject.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/hwpoison-inject.c~mm-hwpoison-fix-the-lack-of-one-reference-count-against-poisoned-page mm/hwpoison-inject.c
--- a/mm/hwpoison-inject.c~mm-hwpoison-fix-the-lack-of-one-reference-count-against-poisoned-page
+++ a/mm/hwpoison-inject.c
@@ -20,8 +20,6 @@ static int hwpoison_inject(void *data, u
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (!hwpoison_filter_enable)
-		goto inject;
 	if (!pfn_valid(pfn))
 		return -ENXIO;
 
@@ -33,6 +31,9 @@ static int hwpoison_inject(void *data, u
 	if (!get_page_unless_zero(hpage))
 		return 0;
 
+	if (!hwpoison_filter_enable)
+		goto inject;
+
 	if (!PageLRU(p) && !PageHuge(p))
 		shake_page(p, 0);
 	/*
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

origin.patch
ksm-remove-redundant-__gfp_zero-from-kcalloc.patch
mm-huge_memoryc-fix-stale-comments-of-transparent_hugepage_flags.patch
mm-nobootmemc-have-__free_pages_memory-free-in-larger-chunks.patch
mm-memory-failurec-move-set_migratetype_isolate-outside-get_any_page.patch
mm-vmalloc-dont-set-area-caller-twice.patch
mm-vmalloc-fix-show-vmap_area-information-race-with-vmap_area-tear-down.patch
mm-vmalloc-revert-mm-vmallocc-check-vm_uninitialized-flag-in-s_show-instead-of-show_numa_info.patch
revert-mm-vmallocc-emit-the-failure-message-before-return.patch
mm-thp-cleanup-mv-alloc_hugepage-to-better-place.patch
mm-thp-khugepaged-add-policy-for-finding-target-node.patch
mm-sparsemem-fix-a-bug-in-free_map_bootmem-when-config_sparsemem_vmemmap.patch
memblock-factor-out-of-top-down-allocation.patch
memblock-introduce-bottom-up-allocation-mode.patch
x86-acpi-crash-kdump-do-reserve_crashkernel-after-srat-is-parsed.patch
mem-hotplug-introduce-movable_node-boot-option.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

