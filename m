From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-page_alloc-generalize-order-handling-in-__free_pages_bootmem.patch removed from -mm tree
Date: Wed, 14 Dec 2011 13:47:10 -0800
Message-ID: <20111214214711.40618200217@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:45126 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372Ab1LNVrN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2011 16:47:13 -0500
Received: by eekc1 with SMTP id c1so42937eek.1
        for <mm-commits@vger.kernel.org>; Wed, 14 Dec 2011 13:47:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, u.kleine-koenig@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: generalize order handling in __free_pages=
_bootmem()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-generalize-order-handling-in-__free_pages_bootmem.pa=
tch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
=46rom: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: generalize order handling in __free_pages_boot=
mem()

__free_pages_bootmem() used to special-case higher-order frees to save
individual page checking with free_pages_bulk().

Nowadays, both zero order and non-zero order frees use free_pages(), wh=
ich
checks each individual page anyway, and so there is little point in mak=
ing
the distinction anymore.  The higher-order loop will work just fine for
zero order pages.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   38 +++++++++++++-------------------------
 1 file changed, 13 insertions(+), 25 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-generalize-order-handling-in-__=
free_pages_bootmem mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-generalize-order-handling-in-__free=
_pages_bootmem
+++ a/mm/page_alloc.c
@@ -743,36 +743,24 @@ static void __free_pages_ok(struct page=20
 	local_irq_restore(flags);
 }
=20
-/*
- * permit the bootmem allocator to evade page validation on high-order=
 frees
- */
 void __meminit __free_pages_bootmem(struct page *page, unsigned int or=
der)
 {
-	if (order =3D=3D 0) {
-		__ClearPageReserved(page);
-		set_page_count(page, 0);
-		set_page_refcounted(page);
-		__free_page(page);
-	} else {
-		int loop;
-		unsigned int nr_pages =3D 1 << order;
-		unsigned int loop;
-
-		prefetchw(page);
-		for (loop =3D 0; loop < nr_pages; loop++) {
-			struct page *p =3D &page[loop];
-
-			if (loop + 1 < nr_pages)
-				prefetchw(p + 1);
-			__ClearPageReserved(p);
-			set_page_count(p, 0);
-		}
+	unsigned int nr_pages =3D 1 << order;
+	unsigned int loop;
=20
-		set_page_refcounted(page);
-		__free_pages(page, order);
+	prefetchw(page);
+	for (loop =3D 0; loop < nr_pages; loop++) {
+		struct page *p =3D &page[loop];
+
+		if (loop + 1 < nr_pages)
+			prefetchw(p + 1);
+		__ClearPageReserved(p);
+		set_page_count(p, 0);
 	}
-}
=20
+	set_page_refcounted(page);
+	__free_pages(page, order);
+}
=20
 /*
  * The order of subdivision here is critical for the IO subsystem.
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
