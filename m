From: akpm@linux-foundation.org
Subject: + mm-page_alloc-generalize-order-handling-in-__free_pages_bootmem.patch added to -mm tree
Date: Fri, 16 Dec 2011 16:03:24 -0800
Message-ID: <20111217000325.4555010004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:43393 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab1LQAD0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2011 19:03:26 -0500
Received: by yhjj51 with SMTP id j51so588674yhj.1
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2011 16:03:25 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, tj@kernel.org, u.kleine-koenig@pengutronix.de


The patch titled
     Subject: mm: page_alloc: generalize order handling in __free_pages=
_bootmem()
has been added to the -mm tree.  Its filename is
     mm-page_alloc-generalize-order-handling-in-__free_pages_bootmem.pa=
tch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   35 +++++++++++++----------------------
 1 file changed, 13 insertions(+), 22 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-generalize-order-handling-in-__=
free_pages_bootmem mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-generalize-order-handling-in-__free=
_pages_bootmem
+++ a/mm/page_alloc.c
@@ -743,32 +743,23 @@ static void __free_pages_ok(struct page=20
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
+	unsigned int nr_pages =3D 1 << order;
+	unsigned int loop;
=20
-		prefetchw(page);
-		for (loop =3D 0; loop < (1 << order); loop++) {
-			struct page *p =3D &page[loop];
-
-			if (loop + 1 < (1 << order))
-				prefetchw(p + 1);
-			__ClearPageReserved(p);
-			set_page_count(p, 0);
-		}
-
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
+
+	set_page_refcounted(page);
+	__free_pages(page, order);
 }
=20
=20
_
Subject: Subject: mm: page_alloc: generalize order handling in __free_p=
ages_bootmem()

Patches currently in -mm which might be from hannes@cmpxchg.org are

linux-next.patch
memcg-add-mem_cgroup_replace_page_cache-to-fix-lru-issue.patch
memcg-keep-root-group-unchanged-if-creation-fails.patch
mm-page-writebackc-make-determine_dirtyable_memory-static-again.patch
vmscan-promote-shared-file-mapped-pages.patch
vmscan-activate-executable-pages-after-first-usage.patch
vmscan-add-task-name-to-warn_scan_unevictable-messages.patch
mm-page_alloc-generalize-order-handling-in-__free_pages_bootmem.patch
mm-bootmem-drop-superfluous-range-check-when-freeing-pages-in-bulk.patc=
h
mm-bootmem-try-harder-to-free-pages-in-bulk.patch
mm-do-not-stall-in-synchronous-compaction-for-thp-allocations.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient.patch
memcg-fix-pgpgin-pgpgout-documentation.patch
mm-page_cgroup-check-page_cgroup-arrays-in-lookup_page_cgroup-only-when=
-necessary.patch
page_cgroup-add-helper-function-to-get-swap_cgroup-cleanup.patch
memcg-clean-up-soft_limit_tree-if-allocation-fails.patch
oom-memcg-fix-exclusion-of-memcg-threads-after-they-have-detached-their=
-mm.patch
memcg-simplify-page-cache-charging.patch
memcg-simplify-corner-case-handling-of-lru.patch
memcg-clear-pc-mem_cgorup-if-necessary.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix-2.patch
memcg-simplify-lru-handling-by-new-rule.patch
vmscan-trace-add-file-info-to-trace_mm_vmscan_lru_isolate.patch
revert-mm-do-not-stall-in-synchronous-compaction-for-thp-allocations.pa=
tch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
