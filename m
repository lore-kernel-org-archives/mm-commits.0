From: akpm@linux-foundation.org
Subject: + mm-bootmem-try-harder-to-free-pages-in-bulk.patch added to -mm tree
Date: Tue, 13 Dec 2011 14:05:37 -0800
Message-ID: <201112132205.pBDM5b0K004037@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:60864 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab1LMWFl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Dec 2011 17:05:41 -0500
Received: by eekc1 with SMTP id c1so6199eek.1
        for <mm-commits@vger.kernel.org>; Tue, 13 Dec 2011 14:05:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, u.kleine-koenig@pengutronix.de


The patch titled
     Subject: mm: bootmem: try harder to free pages in bulk
has been added to the -mm tree.  Its filename is
     mm-bootmem-try-harder-to-free-pages-in-bulk.patch

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
Subject: Subject: mm: bootmem: try harder to free pages in bulk

Patches currently in -mm which might be from hannes@cmpxchg.org are

linux-next.patch
memcg-add-mem_cgroup_replace_page_cache-to-fix-lru-issue.patch
mm-page-writebackc-make-determine_dirtyable_memory-static-again.patch
vmscan-promote-shared-file-mapped-pages.patch
vmscan-activate-executable-pages-after-first-usage.patch
mm-do-not-stall-in-synchronous-compaction-for-thp-allocations.patch
mm-do-not-stall-in-synchronous-compaction-for-thp-allocations-v3.patch
vmscan-add-task-name-to-warn_scan_unevictable-messages.patch
mm-page_alloc-remove-order-assumption-from-__free_pages_bootmem.patch
mm-page_alloc-generalize-order-handling-in-__free_pages_bootmem.patch
mm-bootmem-drop-superfluous-range-check-when-freeing-pages-in-bulk.patc=
h
mm-bootmem-try-harder-to-free-pages-in-bulk.patch
cgroups-add-res_counter_write_u64-api.patch
cgroups-new-resource-counter-inheritance-api.patch
cgroups-add-previous-cgroup-in-can_attach_task-attach_task-callbacks.pa=
tch
cgroups-new-cancel_attach_task-subsystem-callback.patch
cgroups-ability-to-stop-res-charge-propagation-on-bounded-ancestor.patc=
h
cgroups-add-res-counter-common-ancestor-searching.patch
res_counter-allow-charge-failure-pointer-to-be-null.patch
cgroups-pull-up-res-counter-charge-failure-interpretation-to-caller.pat=
ch
cgroups-allow-subsystems-to-cancel-a-fork.patch
cgroups-add-a-task-counter-subsystem.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient.patch
memcg-fix-pgpgin-pgpgout-documentation.patch
mm-page_cgroup-check-page_cgroup-arrays-in-lookup_page_cgroup-only-when=
-necessary.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
