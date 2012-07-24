From: akpm@linux-foundation.org
Subject: + mips-zero-out-pg_data_t-when-its-allocated.patch added to -mm tree
Date: Tue, 24 Jul 2012 14:52:29 -0700
Message-ID: <20120724215230.52B0D1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:58213 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab2GXVwb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jul 2012 17:52:31 -0400
Received: by ghbz15 with SMTP id z15so10002ghb.1
        for <mm-commits@vger.kernel.org>; Tue, 24 Jul 2012 14:52:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan@kernel.org, ralf@linux-mips.org, tj@kernel.org


The patch titled
     Subject: mips: zero out pg_data_t when it's allocated
has been added to the -mm tree.  Its filename is
     mips-zero-out-pg_data_t-when-its-allocated.patch

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
Subject: mips: zero out pg_data_t when it's allocated

This patch is preparation for the next patch which removes the zeroing of
the pg_data_t in core MM.  All archs except MIPS already do this.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Tejun Heo <tj@kernel.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/sgi-ip27/ip27-memory.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/mips/sgi-ip27/ip27-memory.c~mips-zero-out-pg_data_t-when-its-allocated arch/mips/sgi-ip27/ip27-memory.c
--- a/arch/mips/sgi-ip27/ip27-memory.c~mips-zero-out-pg_data_t-when-its-allocated
+++ a/arch/mips/sgi-ip27/ip27-memory.c
@@ -401,6 +401,7 @@ static void __init node_mem_init(cnodeid
 	 * Allocate the node data structures on the node first.
 	 */
 	__node_data[node] = __va(slot_freepfn << PAGE_SHIFT);
+	memset(__node_data[node], 0, PAGE_SIZE);
 
 	NODE_DATA(node)->bdata = &bootmem_node_data[node];
 	NODE_DATA(node)->node_start_pfn = start_pfn;
_
Subject: Subject: mips: zero out pg_data_t when it's allocated

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

