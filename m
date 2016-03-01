From: akpm@linux-foundation.org
Subject: + mm-slb-print-gfp_flags-as-strings-in-slab_out_of_memory.patch
 added to -mm tree
Date: Tue, 01 Mar 2016 13:34:51 -0800
Message-ID: <56d60afb.FhAhgjOTAn3Unt1E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40552 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbcCAVew (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Mar 2016 16:34:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, sl[au]b: print gfp_flags as strings in slab_out_of_memory()
has been added to the -mm tree.  Its filename is
     mm-slb-print-gfp_flags-as-strings-in-slab_out_of_memory.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slb-print-gfp_flags-as-strings-in-slab_out_of_memory.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slb-print-gfp_flags-as-strings-in-slab_out_of_memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, sl[au]b: print gfp_flags as strings in slab_out_of_memory()

We can now print gfp_flags more human-readable. Make use of this in
slab_out_of_memory() for SLUB and SLAB. Also convert the SLAB variant it to
pr_warn() along the way.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   10 ++++------
 mm/slub.c |    4 ++--
 2 files changed, 6 insertions(+), 8 deletions(-)

diff -puN mm/slab.c~mm-slb-print-gfp_flags-as-strings-in-slab_out_of_memory mm/slab.c
--- a/mm/slab.c~mm-slb-print-gfp_flags-as-strings-in-slab_out_of_memory
+++ a/mm/slab.c
@@ -1350,10 +1350,9 @@ slab_out_of_memory(struct kmem_cache *ca
 	if ((gfpflags & __GFP_NOWARN) || !__ratelimit(&slab_oom_rs))
 		return;
 
-	printk(KERN_WARNING
-		"SLAB: Unable to allocate memory on node %d (gfp=0x%x)\n",
-		nodeid, gfpflags);
-	printk(KERN_WARNING "  cache: %s, object size: %d, order: %d\n",
+	pr_warn("SLAB: Unable to allocate memory on node %d, gfp=%#x(%pGg)\n",
+		nodeid, gfpflags, &gfpflags);
+	pr_warn("  cache: %s, object size: %d, order: %d\n",
 		cachep->name, cachep->size, cachep->gfporder);
 
 	for_each_kmem_cache_node(cachep, node, n) {
@@ -1377,8 +1376,7 @@ slab_out_of_memory(struct kmem_cache *ca
 
 		num_slabs += active_slabs;
 		num_objs = num_slabs * cachep->num;
-		printk(KERN_WARNING
-			"  node %d: slabs: %ld/%ld, objs: %ld/%ld, free: %ld\n",
+		pr_warn("  node %d: slabs: %ld/%ld, objs: %ld/%ld, free: %ld\n",
 			node, active_slabs, num_slabs, active_objs, num_objs,
 			free_objects);
 	}
diff -puN mm/slub.c~mm-slb-print-gfp_flags-as-strings-in-slab_out_of_memory mm/slub.c
--- a/mm/slub.c~mm-slb-print-gfp_flags-as-strings-in-slab_out_of_memory
+++ a/mm/slub.c
@@ -2236,8 +2236,8 @@ slab_out_of_memory(struct kmem_cache *s,
 	if ((gfpflags & __GFP_NOWARN) || !__ratelimit(&slub_oom_rs))
 		return;
 
-	pr_warn("SLUB: Unable to allocate memory on node %d (gfp=0x%x)\n",
-		nid, gfpflags);
+	pr_warn("SLUB: Unable to allocate memory on node %d, gfp=%#x(%pGg)\n",
+		nid, gfpflags, &gfpflags);
 	pr_warn("  cache: %s, object size: %d, buffer size: %d, default order: %d, min order: %d\n",
 		s->name, s->object_size, s->size, oo_order(s->oo),
 		oo_order(s->min));
_

Patches currently in -mm which might be from vbabka@suse.cz are

tracepoints-move-trace_print_flags-definitions-to-tracepoint-defsh.patch
mm-tracing-make-show_gfp_flags-up-to-date.patch
tools-perf-make-gfp_compact_table-up-to-date.patch
mm-tracing-unify-mm-flags-handling-in-tracepoints-and-printk.patch
mm-printk-introduce-new-format-string-for-flags.patch
mm-printk-introduce-new-format-string-for-flags-fix.patch
mm-debug-replace-dump_flags-with-the-new-printk-formats.patch
mm-page_alloc-print-symbolic-gfp_flags-on-allocation-failure.patch
mm-oom-print-symbolic-gfp_flags-in-oom-warning.patch
mm-page_owner-print-migratetype-of-page-and-pageblock-symbolic-flags.patch
mm-page_owner-convert-page_owner_inited-to-static-key.patch
mm-page_owner-copy-page-owner-info-during-migration.patch
mm-page_owner-track-and-print-last-migrate-reason.patch
mm-page_owner-dump-page-owner-info-from-dump_page.patch
mm-debug-move-bad-flags-printing-to-bad_page.patch
mm-slb-print-gfp_flags-as-strings-in-slab_out_of_memory.patch
mm-kswapd-remove-bogus-check-of-balance_classzone_idx.patch
mm-compaction-introduce-kcompactd.patch
mm-memory-hotplug-small-cleanup-in-online_pages.patch
mm-kswapd-replace-kswapd-compaction-with-waking-up-kcompactd.patch
mm-compaction-adapt-isolation_suitable-flushing-to-kcompactd.patch
mm-tracing-refresh-__def_vmaflag_names-fix.patch
mm-use-radix_tree_iter_retry-fix.patch

