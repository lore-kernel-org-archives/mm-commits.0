From: akpm@linux-foundation.org
Subject: + mm-bootmem-drop-superfluous-range-check-when-freeing-pages-in-bulk.patch added to -mm tree
Date: Fri, 16 Dec 2011 16:03:27 -0800
Message-ID: <20111217000328.95C145C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:58800 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752591Ab1LQADb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Dec 2011 19:03:31 -0500
Received: by lagu2 with SMTP id u2so116966lag.1
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2011 16:03:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, tj@kernel.org, u.kleine-koenig@pengutronix.de


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
Cc: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: Tejun Heo <tj@kernel.org>
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
