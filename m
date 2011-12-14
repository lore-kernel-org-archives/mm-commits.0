From: akpm@linux-foundation.org
Subject: [obsolete] mm-bootmem-drop-superfluous-range-check-when-freeing-pages-in-bulk.patch removed from -mm tree
Date: Wed, 14 Dec 2011 12:45:42 -0800
Message-ID: <20111214204543.E96F45C007A@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:54234 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab1LNUpq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2011 15:45:46 -0500
Received: by eaad1 with SMTP id d1so38824eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 14 Dec 2011 12:45:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, u.kleine-koenig@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: bootmem: drop superfluous range check when freeing pa=
ges in bulk
has been removed from the -mm tree.  Its filename was
     mm-bootmem-drop-superfluous-range-check-when-freeing-pages-in-bulk=
=2Epatch

This patch was dropped because it is obsolete

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
