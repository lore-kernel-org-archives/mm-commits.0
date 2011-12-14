From: akpm@linux-foundation.org
Subject: [obsolete] mm-page_alloc-remove-order-assumption-from-__free_pages_bootmem.patch removed from -mm tree
Date: Wed, 14 Dec 2011 12:44:57 -0800
Message-ID: <20111214204457.77CA31E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:47008 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519Ab1LNUo6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2011 15:44:58 -0500
Received: by yenm5 with SMTP id m5so138681yen.1
        for <mm-commits@vger.kernel.org>; Wed, 14 Dec 2011 12:44:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, u.kleine-koenig@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: remove order assumption from __free_pages=
_bootmem()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-remove-order-assumption-from-__free_pages_bootmem.pa=
tch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
=46rom: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: remove order assumption from __free_pages_boot=
mem()

Even though bootmem passes an order with the page to be freed,
__free_pages_bootmem() assumes that 1 << order is always BITS_PER_LONG
if non-zero.  While this happens to be true, it's not really robust.
Remove that assumption and use 1 << order instead.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-remove-order-assumption-from-__=
free_pages_bootmem mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-remove-order-assumption-from-__free=
_pages_bootmem
+++ a/mm/page_alloc.c
@@ -755,12 +755,14 @@ void __meminit __free_pages_bootmem(stru
 		__free_page(page);
 	} else {
 		int loop;
+		unsigned int nr_pages =3D 1 << order;
+		unsigned int loop;
=20
 		prefetchw(page);
-		for (loop =3D 0; loop < (1 << order); loop++) {
+		for (loop =3D 0; loop < nr_pages; loop++) {
 			struct page *p =3D &page[loop];
=20
-			if (loop + 1 < (1 << order))
+			if (loop + 1 < nr_pages)
 				prefetchw(p + 1);
 			__ClearPageReserved(p);
 			set_page_count(p, 0);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

linux-next.patch
memcg-add-mem_cgroup_replace_page_cache-to-fix-lru-issue.patch
memcg-keep-root-group-unchanged-if-creation-fails.patch
mm-page-writebackc-make-determine_dirtyable_memory-static-again.patch
vmscan-promote-shared-file-mapped-pages.patch
vmscan-activate-executable-pages-after-first-usage.patch
mm-do-not-stall-in-synchronous-compaction-for-thp-allocations.patch
mm-do-not-stall-in-synchronous-compaction-for-thp-allocations-v3.patch
vmscan-add-task-name-to-warn_scan_unevictable-messages.patch
mm-page_alloc-generalize-order-handling-in-__free_pages_bootmem.patch
mm-bootmem-drop-superfluous-range-check-when-freeing-pages-in-bulk.patc=
h
mm-bootmem-try-harder-to-free-pages-in-bulk.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient.patch
memcg-fix-pgpgin-pgpgout-documentation.patch
mm-page_cgroup-check-page_cgroup-arrays-in-lookup_page_cgroup-only-when=
-necessary.patch
page_cgroup-add-helper-function-to-get-swap_cgroup-cleanup.patch
memcg-clean-up-soft_limit_tree-if-allocation-fails.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
