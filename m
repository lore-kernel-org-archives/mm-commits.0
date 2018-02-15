From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-initialize-pages-on-demand-during-boot-fix2.patch removed from -mm tree
Date: Wed, 14 Feb 2018 16:16:24 -0800
Message-ID: <5a84d158.T39CFqXimjeuAyIh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43872 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032191AbeBOAQk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Feb 2018 19:16:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pasha.tatashin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-initialize-pages-on-demand-during-boot-fix2
has been removed from the -mm tree.  Its filename was
     mm-initialize-pages-on-demand-during-boot-fix2.patch

This patch was dropped because it was folded into mm-initialize-pages-on-demand-during-boot.patch

------------------------------------------------------
From: Pavel Tatashin <pasha.tatashin@oracle.com>
Subject: mm-initialize-pages-on-demand-during-boot-fix2

fix min() type mismatch warning

Link: http://lkml.kernel.org/r/20180212164543.26592-1-pasha.tatashin@oracle.com
Signed-off-by: Pavel Tatashin <pasha.tatashin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-initialize-pages-on-demand-during-boot-fix2 mm/page_alloc.c
--- a/mm/page_alloc.c~mm-initialize-pages-on-demand-during-boot-fix2
+++ a/mm/page_alloc.c
@@ -6341,8 +6341,8 @@ void __paginginit free_area_init_node(in
 	 * We start only with one section of pages, more pages are added as
 	 * needed until the rest of deferred pages are initialized.
 	 */
-	pgdat->static_init_pgcnt = min(PAGES_PER_SECTION,
-				       pgdat->node_spanned_pages);
+	pgdat->static_init_pgcnt = min_t(unsigned long, PAGES_PER_SECTION,
+					 pgdat->node_spanned_pages);
 	pgdat->first_deferred_pfn = ULONG_MAX;
 #endif
 	free_area_init_core(pgdat);
_

Patches currently in -mm which might be from pasha.tatashin@oracle.com are

mm-initialize-pages-on-demand-during-boot.patch
mm-memory_hotplug-enforce-block-size-aligned-range-check.patch
x86-mm-memory_hotplug-determine-block-size-based-on-the-end-of-boot-memory.patch
mm-uninitialized-struct-page-poisoning-sanity-checking.patch
mm-memory_hotplug-optimize-memory-hotplug.patch
sparc64-ng4-memset-32-bits-overflow.patch

