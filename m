From: akpm@linux-foundation.org
Subject: [merged] mm-bootmem-drop-superfluous-range-check-when-freeing-pages-in-bulk.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:28:06 -0800
Message-ID: <20120111212806.EF7231E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:51433 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934060Ab2AKV2H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:28:07 -0500
Received: by mail-gy0-f202.google.com with SMTP id r15so137004ghr.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:28:07 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, tj@kernel.org, u.kleine-koenig@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: bootmem: drop superfluous range check when freeing pa=
ges in bulk
has been removed from the -mm tree.  Its filename was
     mm-bootmem-drop-superfluous-range-check-when-freeing-pages-in-bulk=
=2Epatch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

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
