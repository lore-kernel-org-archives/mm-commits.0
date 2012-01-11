From: akpm@linux-foundation.org
Subject: [merged] mm-page_alloc-generalize-order-handling-in-__free_pages_bootmem.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:28:03 -0800
Message-ID: <20120111212804.105F15C0064@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:36754 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934048Ab2AKV2H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:28:07 -0500
Received: by werf1 with SMTP id f1so53574wer.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:28:05 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, tj@kernel.org, u.kleine-koenig@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: generalize order handling in __free_pages=
_bootmem()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-generalize-order-handling-in-__free_pages_bootmem.pa=
tch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

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
@@ -730,32 +730,23 @@ static void __free_pages_ok(struct page=20
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

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
linux-next.patch
memcg-add-mem_cgroup_replace_page_cache-to-fix-lru-issue.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient.patch
memcg-fix-pgpgin-pgpgout-documentation.patch
mm-memcg-clean-up-fault-accounting-fix.patch
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
memcg-clear-pc-mem_cgorup-if-necessary-fix-2-fix.patch
memcg-clear-pc-mem_cgorup-if-necessary-comments.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix-3.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix-page-migration-to-reset_owne=
r.patch
memcg-simplify-lru-handling-by-new-rule.patch
memcg-simplify-lru-handling-by-new-rule-fix.patch
memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing=
-try_charge.patch
memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing=
-try_charge-fix.patch
memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing=
-try_charge-fix-null-mem_cgroup_try_charge.patch
memcg-cleanup-for_each_node_state.patch
page_alloc-break-early-in-check_for_regular_memory.patch
page_cgroup-drop-multi-config_memory_hotplug.patch
vmscan-trace-add-file-info-to-trace_mm_vmscan_lru_isolate.patch
memcg-fix-split_huge_page_refcounts.patch
memcg-fix-mem_cgroup_print_bad_page.patch
mm-rearrange-putback_inactive_pages.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
