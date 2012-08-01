From: akpm@linux-foundation.org
Subject: [merged] mm-warn-if-pg_data_t-isnt-initialized-with-zero.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:19:01 -0700
Message-ID: <20120801201902.4A24620004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:63387 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754963Ab2HAUTE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:19:04 -0400
Received: by lagr15 with SMTP id r15so343932lag.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:19:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, ralf@linux-mips.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: warn if pg_data_t isn't initialized with zero
has been removed from the -mm tree.  Its filename was
     mm-warn-if-pg_data_t-isnt-initialized-with-zero.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: warn if pg_data_t isn't initialized with zero

Warn if memory-hotplug/boot code doesn't initialize pg_data_t with zero
when it is allocated.  Arch code and memory hotplug already initiailize
pg_data_t.  So this warning should never happen.  I select fields randomly
near the beginning, middle and end of pg_data_t for checking.

This patch isn't for performance but for removing initialization code
which is necessary to add whenever we adds new field to pg_data_t or zone.

Firstly, Andrew suggested clearing out of pg_data_t in MM core part but
Tejun doesn't like it because in the future, some archs can initialize
some fields in arch code and pass them into general MM part so blindly
clearing it out in mm core part would be very annoying.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/page_alloc.c~mm-warn-if-pg_data_t-isnt-initialized-with-zero mm/page_alloc.c
--- a/mm/page_alloc.c~mm-warn-if-pg_data_t-isnt-initialized-with-zero
+++ a/mm/page_alloc.c
@@ -4515,6 +4515,9 @@ void __paginginit free_area_init_node(in
 {
 	pg_data_t *pgdat = NODE_DATA(nid);
 
+	/* pg_data_t should be reset to zero when it's allocated */
+	WARN_ON(pgdat->nr_zones || pgdat->node_start_pfn || pgdat->classzone_idx);
+
 	pgdat->node_id = nid;
 	pgdat->node_start_pfn = node_start_pfn;
 	calculate_node_totalpages(pgdat, zones_size, zholes_size);
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
mm-remove-__gfp_no_kswapd.patch
remove-__gfp_no_kswapd-fixes-fix.patch

