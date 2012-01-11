From: akpm@linux-foundation.org
Subject: [merged] mm-bootmem-try-harder-to-free-pages-in-bulk.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:28:08 -0800
Message-ID: <20120111212808.E0C0310004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:41159 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934011Ab2AKV2J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:28:09 -0500
Received: by yhpp56 with SMTP id p56so153861yhp.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:28:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, tj@kernel.org, u.kleine-koenig@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: bootmem: try harder to free pages in bulk
has been removed from the -mm tree.  Its filename was
     mm-bootmem-try-harder-to-free-pages-in-bulk.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
=46rom: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: bootmem: try harder to free pages in bulk

The loop that frees pages to the page allocator while bootstrapping tri=
es
to free higher-order blocks only when the starting address is aligned t=
o
that block size.  Otherwise it will free all pages on that node
one-by-one.

Change it to free individual pages up to the first aligned block and th=
en
try higher-order frees from there.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff -puN mm/bootmem.c~mm-bootmem-try-harder-to-free-pages-in-bulk mm/b=
ootmem.c
--- a/mm/bootmem.c~mm-bootmem-try-harder-to-free-pages-in-bulk
+++ a/mm/bootmem.c
@@ -171,7 +171,6 @@ void __init free_bootmem_late(unsigned l
=20
 static unsigned long __init free_all_bootmem_core(bootmem_data_t *bdat=
a)
 {
-	int aligned;
 	struct page *page;
 	unsigned long start, end, pages, count =3D 0;
=20
@@ -181,14 +180,8 @@ static unsigned long __init free_all_boo
 	start =3D bdata->node_min_pfn;
 	end =3D bdata->node_low_pfn;
=20
-	/*
-	 * If the start is aligned to the machines wordsize, we might
-	 * be able to free pages in bulks of that order.
-	 */
-	aligned =3D !(start & (BITS_PER_LONG - 1));
-
-	bdebug("nid=3D%td start=3D%lx end=3D%lx aligned=3D%d\n",
-		bdata - bootmem_node_data, start, end, aligned);
+	bdebug("nid=3D%td start=3D%lx end=3D%lx\n",
+		bdata - bootmem_node_data, start, end);
=20
 	while (start < end) {
 		unsigned long *map, idx, vec;
@@ -196,12 +189,17 @@ static unsigned long __init free_all_boo
 		map =3D bdata->node_bootmem_map;
 		idx =3D start - bdata->node_min_pfn;
 		vec =3D ~map[idx / BITS_PER_LONG];
-
-		if (aligned && vec =3D=3D ~0UL) {
+		/*
+		 * If we have a properly aligned and fully unreserved
+		 * BITS_PER_LONG block of pages in front of us, free
+		 * it in one go.
+		 */
+		if (IS_ALIGNED(start, BITS_PER_LONG) && vec =3D=3D ~0UL) {
 			int order =3D ilog2(BITS_PER_LONG);
=20
 			__free_pages_bootmem(pfn_to_page(start), order);
 			count +=3D BITS_PER_LONG;
+			start +=3D BITS_PER_LONG;
 		} else {
 			unsigned long off =3D 0;
=20
@@ -214,8 +212,8 @@ static unsigned long __init free_all_boo
 				vec >>=3D 1;
 				off++;
 			}
+			start =3D ALIGN(start + 1, BITS_PER_LONG);
 		}
-		start +=3D BITS_PER_LONG;
 	}
=20
 	page =3D virt_to_page(bdata->node_bootmem_map);
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
