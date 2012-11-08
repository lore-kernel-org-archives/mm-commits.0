From: akpm@linux-foundation.org
Subject: + memory-hotplug-fix-nr_free_pages-mismatch-fix.patch added to -mm tree
Date: Thu, 08 Nov 2012 12:20:45 -0800
Message-ID: <20121108202046.08191200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:55782 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222Ab2KHUUs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Nov 2012 15:20:48 -0500
Received: by mail-ee0-f74.google.com with SMTP id b57so208723eek.1
        for <mm-commits@vger.kernel.org>; Thu, 08 Nov 2012 12:20:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wency@cn.fujitsu.com, wujianguo106@gmail.com


The patch titled
     Subject: memory-hotplug: fix NR_FREE_PAGES mismatch's fix
has been added to the -mm tree.  Its filename is
     memory-hotplug-fix-nr_free_pages-mismatch-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wen Congyang <wency@cn.fujitsu.com>
Subject: memory-hotplug: fix NR_FREE_PAGES mismatch's fix

When a page is freed and put into pcp list, get_freepage_migratetype()
doesn't return MIGRATE_ISOLATE even if this pageblock is isolated.
So we should use get_freepage_migratetype() instead of mt to check
whether it is isolated.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Reported-by: Jianguo Wu <wujianguo106@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~memory-hotplug-fix-nr_free_pages-mismatch-fix mm/page_alloc.c
--- a/mm/page_alloc.c~memory-hotplug-fix-nr_free_pages-mismatch-fix
+++ a/mm/page_alloc.c
@@ -666,7 +666,7 @@ static void free_pcppages_bulk(struct zo
 			/* MIGRATE_MOVABLE list may include MIGRATE_RESERVEs */
 			__free_one_page(page, zone, 0, mt);
 			trace_mm_page_pcpu_drain(page, 0, mt);
-			if (likely(mt != MIGRATE_ISOLATE)) {
+			if (likely(get_pageblock_migratetype(page) != MIGRATE_ISOLATE)) {
 				__mod_zone_page_state(zone, NR_FREE_PAGES, 1);
 				if (is_migrate_cma(mt))
 					__mod_zone_page_state(zone, NR_FREE_CMA_PAGES, 1);
_

Patches currently in -mm which might be from wency@cn.fujitsu.com are

linux-next.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
x86-numa-dont-check-if-node-is-numa_no_node.patch
x86-make-mem=-option-to-work-for-efi-platform.patch
memory-hotplug-suppress-device-memoryx-does-not-have-a-release-function-warning.patch
memory-hotplug-skip-hwpoisoned-page-when-offlining-pages.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
memory-hotplug-auto-offline-page_cgroup-when-onlining-memory-block-failed.patch
memory-hotplug-fix-nr_free_pages-mismatch.patch
memory-hotplug-fix-nr_free_pages-mismatch-fix.patch
numa-convert-static-memory-to-dynamically-allocated-memory-for-per-node-device.patch
memory-hotplug-suppress-device-nodex-does-not-have-a-release-function-warning.patch
memory-hotplug-mm-sparsec-clear-the-memory-to-store-struct-page.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix-2.patch
memory_hotplug-fix-possible-incorrect-node_states.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
mm-memory_hotplugc-update-start_pfn-in-zone-and-pg_data-when-spanned_pages-==-0.patch
documentation-kernel-parameterstxt-update-mem=-options-spec-according-to-its-implementation.patch

