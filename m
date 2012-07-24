From: akpm@linux-foundation.org
Subject: + mm-warn-if-pg_data_t-isnt-initialized-with-zero.patch added to -mm tree
Date: Tue, 24 Jul 2012 14:52:33 -0700
Message-ID: <20120724215233.7D86F1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:64405 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab2GXVwe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jul 2012 17:52:34 -0400
Received: by yenl3 with SMTP id l3so9711yen.1
        for <mm-commits@vger.kernel.org>; Tue, 24 Jul 2012 14:52:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan@kernel.org, ralf@linux-mips.org, tj@kernel.org


The patch titled
     Subject: mm: warn if pg_data_t isn't initialized with zero
has been added to the -mm tree.  Its filename is
     mm-warn-if-pg_data_t-isnt-initialized-with-zero.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -4514,6 +4514,9 @@ void __paginginit free_area_init_node(in
 {
 	pg_data_t *pgdat = NODE_DATA(nid);
 
+	/* pg_data_t should be reset to zero when it's allocated */
+	WARN_ON(pgdat->nr_zones || pgdat->node_start_pfn || pgdat->classzone_idx);
+
 	pgdat->node_id = nid;
 	pgdat->node_start_pfn = node_start_pfn;
 	calculate_node_totalpages(pgdat, zones_size, zholes_size);
_
Subject: Subject: mm: warn if pg_data_t isn't initialized with zero

Patches currently in -mm which might be from minchan@kernel.org are

linux-next.patch
swap-allow-swap-readahead-to-be-merged.patch
documentation-update-how-page-cluster-affects-swap-i-o.patch
mm-compaction-cleanup-on-compaction_deferred.patch
mm-clear-pages_scanned-only-if-draining-a-pcp-adds-pages-to-the-buddy-allocator-again.patch
mm-do-not-use-page_count-without-a-page-pin.patch
mm-clean-up-__count_immobile_pages.patch
mm-have-order-0-compaction-start-off-where-it-left-v3.patch
vmscan-remove-obsolete-shrink_control-comment.patch
mm-hotplug-correctly-setup-fallback-zonelists-when-creating-new-pgdat.patch
mm-hotplug-correctly-add-new-zone-to-all-other-nodes-zone-lists.patch
mm-hotplug-free-zone-pageset-when-a-zone-becomes-empty.patch
mm-hotplug-mark-memory-hotplug-code-in-page_allocc-as-__meminit.patch
mm-factor-out-memory-isolate-functions.patch
mm-bug-fix-free-page-check-in-zone_watermark_ok.patch
memory-hotplug-fix-kswapd-looping-forever-problem.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix-fix.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
memcg-further-prevent-oom-with-too-many-dirty-pages.patch
mips-zero-out-pg_data_t-when-its-allocated.patch
mm-warn-if-pg_data_t-isnt-initialized-with-zero.patch
mm-remove-redundant-initialization.patch

