From: akpm@linux-foundation.org
Subject: + mm-page_alloc-remove-order-assumption-from-__free_pages_bootmem.patch added to -mm tree
Date: Tue, 13 Dec 2011 14:05:28 -0800
Message-ID: <201112132205.pBDM5T2D019218@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:40418 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752388Ab1LMWFd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Dec 2011 17:05:33 -0500
Received: by lagu2 with SMTP id u2so6283lag.1
        for <mm-commits@vger.kernel.org>; Tue, 13 Dec 2011 14:05:31 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, u.kleine-koenig@pengutronix.de


The patch titled
     Subject: mm: page_alloc: remove order assumption from __free_pages=
_bootmem()
has been added to the -mm tree.  Its filename is
     mm-page_alloc-remove-order-assumption-from-__free_pages_bootmem.pa=
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
Subject: Subject: mm: page_alloc: remove order assumption from __free_p=
ages_bootmem()

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
