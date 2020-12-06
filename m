Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF0C8C433FE
	for <mm-commits@archiver.kernel.org>; Sun,  6 Dec 2020 00:54:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78F1723104
	for <mm-commits@archiver.kernel.org>; Sun,  6 Dec 2020 00:54:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725966AbgLFAyg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 5 Dec 2020 19:54:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:43616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725922AbgLFAyf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 5 Dec 2020 19:54:35 -0500
Date:   Sat, 05 Dec 2020 16:53:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607216034;
        bh=qJQzdSBPA1HyNk/vOgX3/yo9As0Kg9CAcC2cMx1tMlU=;
        h=From:To:Subject:From;
        b=cPUOFjrJ8+TmqodXQUuCfBuR91bF6Lsw9+cZnuTlWlYDl7koooi88EpBzuQUXcmW5
         3BI3yS6M+McA8HszQ5HVNufpSeZ598F1h6qK8+MGXhP32ZTzoh4rO8hrOoxi+TbIkc
         s4BafeHKJvoSJqyW3eV9O2uU48UsIFk2f2bHnqkc=
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, bhe@redhat.com, cai@lca.pw, david@redhat.com,
        lstoakes@gmail.com, mgorman@suse.de, mhocko@kernel.org,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        sfr@canb.auug.org.au, vbabka@suse.cz
Subject:  [alternative-merged]
 =?US-ASCII?Q?mm-refactor-initialization-of-stuct-page-for-holes-in-mem?=
 =?US-ASCII?Q?ory-layout-fix.patch?= removed from -mm tree
Message-ID: <20201206005352.7EaUXZ6Qj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fixup for "mm: refactor initialization of stuct page for holes"
has been removed from the -mm tree.  Its filename was
     mm-refactor-initialization-of-stuct-page-for-holes-in-memory-layout-fix.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: fixup for "mm: refactor initialization of stuct page for holes"

Fix boot-time panic.  The change to initialization of "unavailable" memory
missed pfn 0.

Link: https://lkml.kernel.org/r/00000000000056f29e05b58d448f@google.com
Link: https://lkml.kernel.org/r/20201203122354.GI751215@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reported-by: syzbot+86800a8349c0f3f9466e@syzkaller.appspotmail.com
Tested-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qian Cai <cai@lca.pw>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/page_alloc.c~mm-refactor-initialization-of-stuct-page-for-holes-in-memory-layout-fix
+++ a/mm/page_alloc.c
@@ -6227,7 +6227,8 @@ void __init __weak memmap_init(unsigned
 			       unsigned long zone,
 			       unsigned long range_start_pfn)
 {
-	unsigned long start_pfn, end_pfn, next_pfn = 0;
+	static unsigned long hole_start_pfn;
+	unsigned long start_pfn, end_pfn;
 	unsigned long range_end_pfn = range_start_pfn + size;
 	u64 pgcnt = 0;
 	int i;
@@ -6235,7 +6236,6 @@ void __init __weak memmap_init(unsigned
 	for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, NULL) {
 		start_pfn = clamp(start_pfn, range_start_pfn, range_end_pfn);
 		end_pfn = clamp(end_pfn, range_start_pfn, range_end_pfn);
-		next_pfn = clamp(next_pfn, range_start_pfn, range_end_pfn);
 
 		if (end_pfn > start_pfn) {
 			size = end_pfn - start_pfn;
@@ -6243,10 +6243,10 @@ void __init __weak memmap_init(unsigned
 					 MEMINIT_EARLY, NULL, MIGRATE_MOVABLE);
 		}
 
-		if (next_pfn < start_pfn)
-			pgcnt += init_unavailable_range(next_pfn, start_pfn,
-							zone, nid);
-		next_pfn = end_pfn;
+		if (hole_start_pfn < start_pfn)
+			pgcnt += init_unavailable_range(hole_start_pfn,
+							start_pfn, zone, nid);
+		hole_start_pfn = end_pfn;
 	}
 
 	/*
@@ -6256,8 +6256,8 @@ void __init __weak memmap_init(unsigned
 	 * considered initialized. Make sure that memmap has a well defined
 	 * state.
 	 */
-	if (next_pfn < range_end_pfn)
-		pgcnt += init_unavailable_range(next_pfn, range_end_pfn,
+	if (hole_start_pfn < range_end_pfn)
+		pgcnt += init_unavailable_range(hole_start_pfn, range_end_pfn,
 						zone, nid);
 
 	if (pgcnt)
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-refactor-initialization-of-stuct-page-for-holes-in-memory-layout.patch
alpha-switch-from-discontigmem-to-sparsemem.patch
ia64-remove-custom-__early_pfn_to_nid.patch
ia64-remove-ifdef-config_zone_dma32-statements.patch
ia64-discontig-paging_init-remove-local-max_pfn-calculation.patch
ia64-split-virtual-map-initialization-out-of-paging_init.patch
ia64-forbid-using-virtual_mem_map-with-flatmem.patch
ia64-make-sparsemem-default-and-disable-discontigmem.patch
arm-remove-config_arch_has_holes_memorymodel.patch
arm-arm64-move-free_unused_memmap-to-generic-mm.patch
arc-use-flatmem-with-freeing-of-unused-memory-map-instead-of-discontigmem.patch
m68k-mm-make-node-data-and-node-setup-depend-on-config_discontigmem.patch
m68k-mm-enable-use-of-generic-memory_modelh-for-discontigmem.patch
m68k-deprecate-discontigmem.patch
mm-introduce-debug_pagealloc_mapunmap_pages-helpers.patch
pm-hibernate-make-direct-map-manipulations-more-explicit.patch
arch-mm-restore-dependency-of-__kernel_map_pages-on-debug_pagealloc.patch
arch-mm-make-kernel_page_present-always-available.patch
mm-add-definition-of-pmd_page_order.patch
mmap-make-mlock_future_check-global.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages.patch
set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch
secretmem-use-pmd-size-pages-to-amortize-direct-map-fragmentation.patch
secretmem-add-memcg-accounting.patch
pm-hibernate-disable-when-there-are-active-secretmem-users.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant.patch
secretmem-test-add-basic-selftest-for-memfd_secret2.patch

