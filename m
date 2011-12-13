From: akpm@linux-foundation.org
Subject: + mm-bootmem-drop-superfluous-range-check-when-freeing-pages-in-bulk.patch added to -mm tree
Date: Tue, 13 Dec 2011 14:05:34 -0800
Message-ID: <201112132205.pBDM5Y8C015302@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:61210 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab1LMWFh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Dec 2011 17:05:37 -0500
Received: by yenm5 with SMTP id m5so19545yen.1
        for <mm-commits@vger.kernel.org>; Tue, 13 Dec 2011 14:05:35 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, u.kleine-koenig@pengutronix.de


The patch titled
     Subject: mm: bootmem: drop superfluous range check when freeing pa=
ges in bulk
has been added to the -mm tree.  Its filename is
     mm-bootmem-drop-superfluous-range-check-when-freeing-pages-in-bulk=
=2Epatch

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
Subject: mm: bootmem: drop superfluous range check when freeing pages i=
n bulk

The area node_bootmem_map represents is aligned to BITS_PER_LONG, and a=
ll
bits in any aligned word of that map valid.  When the represented area
extends beyond the end of the node, the non-existant pages will be mark=
ed
as reserved.

As a result, when freeing a page block, doing an explicit range check f=
or
whether that block is within the node's range is redundant as the bitma=
p
is consulted anyway to see whether all pages in the block are unreserve=
d.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/bootmem.c~mm-bootmem-drop-superfluous-range-check-when-fre=
eing-pages-in-bulk mm/bootmem.c
--- a/mm/bootmem.c~mm-bootmem-drop-superfluous-range-check-when-freeing=
-pages-in-bulk
+++ a/mm/bootmem.c
@@ -197,7 +197,7 @@ static unsigned long __init free_all_boo
 		idx =3D start - bdata->node_min_pfn;
 		vec =3D ~map[idx / BITS_PER_LONG];
=20
-		if (aligned && vec =3D=3D ~0UL && start + BITS_PER_LONG <=3D end) {
+		if (aligned && vec =3D=3D ~0UL) {
 			int order =3D ilog2(BITS_PER_LONG);
=20
 			__free_pages_bootmem(pfn_to_page(start), order);
_
Subject: Subject: mm: bootmem: drop superfluous range check when freein=
g pages in bulk

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
