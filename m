From: akpm@linux-foundation.org
Subject: + mm-compaction-fix-return-value-of-capture_free_page.patch added to -mm tree
Date: Mon, 26 Nov 2012 15:22:44 -0800
Message-ID: <20121126232245.89B9920004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:54098 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412Ab2KZXWr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Nov 2012 18:22:47 -0500
Received: by mail-ee0-f74.google.com with SMTP id t10so817534eei.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Nov 2012 15:22:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, dave@linux.vnet.ibm.com


The patch titled
     Subject: mm: compaction: fix return value of capture_free_page()
has been added to the -mm tree.  Its filename is
     mm-compaction-fix-return-value-of-capture_free_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: compaction: fix return value of capture_free_page()

Commit ef6c5be6 ("fix incorrect NR_FREE_PAGES accounting (appears like
memory leak)") fixes a NR_FREE_PAGE accounting leak but missed the return
value which was also missed by this reviewer until today.  That return
value is used by compaction when adding pages to a list of isolated free
pages and without this follow-up fix, there is a risk of free list
corruption.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-compaction-fix-return-value-of-capture_free_page mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-fix-return-value-of-capture_free_page
+++ a/mm/page_alloc.c
@@ -1422,7 +1422,7 @@ int capture_free_page(struct page *page,
 		}
 	}
 
-	return 1UL << order;
+	return 1UL << alloc_order;
 }
 
 /*
_

Patches currently in -mm which might be from mgorman@suse.de are

revert-mm-remove-__gfp_no_kswapd.patch
mm-vmscan-check-for-fatal-signals-iff-the-process-was-throttled.patch
linux-next.patch
memory_hotplug-fix-possible-incorrect-node_states.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
mm-add-comment-on-storage-key-dirty-bit-semantics.patch
mm-refactor-reinsert-of-swap_info-in-sys_swapoff.patch
mm-do-not-call-frontswap_init-during-swapoff.patch
mm-memmap_init_zone-performance-improvement.patch
mm-allocate-kernel-pages-to-the-right-memcg.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory.patch
memory_hotplug-handle-empty-zone-when-online_movable-online_kernel.patch
memory_hotplug-ensure-every-online-node-has-normal-memory.patch
mm-compaction-fix-compiler-warning.patch
mm-add-a-reminder-comment-for-__gfp_bits_shift.patch
numa-add-config_movable_node-for-movable-dedicated-node.patch
numa-add-config_movable_node-for-movable-dedicated-node-fix.patch
memory_hotplug-allow-online-offline-memory-to-result-movable-node.patch
mm-introduce-new-field-managed_pages-to-struct-zone.patch
mm-compaction-fix-return-value-of-capture_free_page.patch

