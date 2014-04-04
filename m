From: akpm@linux-foundation.org
Subject: [merged] fs-cachefiles-use-add_to_page_cache_lru.patch removed
 from -mm tree
Date: Fri, 04 Apr 2014 12:31:17 -0700
Message-ID: <533f0885.0Phj8nR9bT3m6L2/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42920 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242AbaDDTbS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:31:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, vbabka@suse.cz, tj@kernel.org, semenzato@google.com, rmallon@gmail.com, riel@redhat.com, peterz@infradead.org, ozgun@citusdata.com, minchan@kernel.org, mgorman@suse.de, metin@citusdata.com, kosaki.motohiro@jp.fujitsu.com, klamm@yandex-team.ru, jack@suse.cz, hughd@google.com, hch@infradead.org, gthelen@google.com, dhowells@redhat.com, david@fromorbit.com, bob.liu@oracle.com, aarcange@redhat.com, hannes@cmpxchg.org

Subject: [merged] fs-cachefiles-use-add_to_page_cache_lru.patch removed from -mm tree
To: hannes@cmpxchg.org,aarcange@redhat.com,bob.liu@oracle.com,david@fromorbit.com,dhowells@redhat.com,gthelen@google.com,hch@infradead.org,hughd@google.com,jack@suse.cz,klamm@yandex-team.ru,kosaki.motohiro@jp.fujitsu.com,metin@citusdata.com,mgorman@suse.de,minchan@kernel.org,ozgun@citusdata.com,peterz@infradead.org,riel@redhat.com,rmallon@gmail.com,semenzato@google.com,tj@kernel.org,vbabka@suse.cz,walken@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:31:17 -0700


The patch titled
     Subject: fs: cachefiles: use add_to_page_cache_lru()
has been removed from the -mm tree.  Its filename was
     fs-cachefiles-use-add_to_page_cache_lru.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: fs: cachefiles: use add_to_page_cache_lru()

This code used to have its own lru cache pagevec up until a0b8cab3
("mm: remove lru parameter from __pagevec_lru_add and remove parts of
pagevec API").  Now it's just add_to_page_cache() followed by
lru_cache_add(), might as well use add_to_page_cache_lru() directly.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Bob Liu <bob.liu@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Luigi Semenzato <semenzato@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Metin Doslu <metin@citusdata.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Ozgun Erdogan <ozgun@citusdata.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin <klamm@yandex-team.ru>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cachefiles/rdwr.c |   33 +++++++++++++--------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

diff -puN fs/cachefiles/rdwr.c~fs-cachefiles-use-add_to_page_cache_lru fs/cachefiles/rdwr.c
--- a/fs/cachefiles/rdwr.c~fs-cachefiles-use-add_to_page_cache_lru
+++ a/fs/cachefiles/rdwr.c
@@ -265,24 +265,22 @@ static int cachefiles_read_backing_file_
 				goto nomem_monitor;
 		}
 
-		ret = add_to_page_cache(newpage, bmapping,
-					netpage->index, cachefiles_gfp);
+		ret = add_to_page_cache_lru(newpage, bmapping,
+					    netpage->index, cachefiles_gfp);
 		if (ret == 0)
 			goto installed_new_backing_page;
 		if (ret != -EEXIST)
 			goto nomem_page;
 	}
 
-	/* we've installed a new backing page, so now we need to add it
-	 * to the LRU list and start it reading */
+	/* we've installed a new backing page, so now we need to start
+	 * it reading */
 installed_new_backing_page:
 	_debug("- new %p", newpage);
 
 	backpage = newpage;
 	newpage = NULL;
 
-	lru_cache_add_file(backpage);
-
 read_backing_page:
 	ret = bmapping->a_ops->readpage(NULL, backpage);
 	if (ret < 0)
@@ -510,24 +508,23 @@ static int cachefiles_read_backing_file(
 					goto nomem;
 			}
 
-			ret = add_to_page_cache(newpage, bmapping,
-						netpage->index, cachefiles_gfp);
+			ret = add_to_page_cache_lru(newpage, bmapping,
+						    netpage->index,
+						    cachefiles_gfp);
 			if (ret == 0)
 				goto installed_new_backing_page;
 			if (ret != -EEXIST)
 				goto nomem;
 		}
 
-		/* we've installed a new backing page, so now we need to add it
-		 * to the LRU list and start it reading */
+		/* we've installed a new backing page, so now we need
+		 * to start it reading */
 	installed_new_backing_page:
 		_debug("- new %p", newpage);
 
 		backpage = newpage;
 		newpage = NULL;
 
-		lru_cache_add_file(backpage);
-
 	reread_backing_page:
 		ret = bmapping->a_ops->readpage(NULL, backpage);
 		if (ret < 0)
@@ -538,8 +535,8 @@ static int cachefiles_read_backing_file(
 	monitor_backing_page:
 		_debug("- monitor add");
 
-		ret = add_to_page_cache(netpage, op->mapping, netpage->index,
-					cachefiles_gfp);
+		ret = add_to_page_cache_lru(netpage, op->mapping,
+					    netpage->index, cachefiles_gfp);
 		if (ret < 0) {
 			if (ret == -EEXIST) {
 				page_cache_release(netpage);
@@ -549,8 +546,6 @@ static int cachefiles_read_backing_file(
 			goto nomem;
 		}
 
-		lru_cache_add_file(netpage);
-
 		/* install a monitor */
 		page_cache_get(netpage);
 		monitor->netfs_page = netpage;
@@ -613,8 +608,8 @@ static int cachefiles_read_backing_file(
 	backing_page_already_uptodate:
 		_debug("- uptodate");
 
-		ret = add_to_page_cache(netpage, op->mapping, netpage->index,
-					cachefiles_gfp);
+		ret = add_to_page_cache_lru(netpage, op->mapping,
+					    netpage->index, cachefiles_gfp);
 		if (ret < 0) {
 			if (ret == -EEXIST) {
 				page_cache_release(netpage);
@@ -631,8 +626,6 @@ static int cachefiles_read_backing_file(
 
 		fscache_mark_page_cached(op, netpage);
 
-		lru_cache_add_file(netpage);
-
 		/* the netpage is unlocked and marked up to date here */
 		fscache_end_io(op, netpage, 0);
 		page_cache_release(netpage);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch
mm-thp-add-vm_init_def_mask-and-prctl_thp_disable.patch
exec-kill-the-unnecessary-mm-def_flags-setting-in-load_elf_binary.patch
fork-collapse-copy_flags-into-copy_process.patch
mm-mempolicy-rename-slab_node-for-clarity.patch
mm-mempolicy-remove-per-process-flag.patch
res_counter-remove-interface-for-locked-charging-and-uncharging.patch
mm-vmallocc-enhance-vm_map_ram-comment.patch
mm-vmallocc-enhance-vm_map_ram-comment-fix.patch
mm-memcg-remove-unnecessary-preemption-disabling.patch
mm-memcg-remove-mem_cgroup_move_account_page_stat.patch
mm-memcg-inline-mem_cgroup_charge_common.patch
mm-memcg-push-mm-handling-out-to-page-cache-charge-function.patch
memcg-remove-unnecessary-mm-check-from-try_get_mem_cgroup_from_mm.patch
memcg-get_mem_cgroup_from_mm.patch
memcg-get_mem_cgroup_from_mm-fix.patch
memcg-do-not-replicate-get_mem_cgroup_from_mm-in-__mem_cgroup_try_charge.patch
memcg-sanitize-__mem_cgroup_try_charge-call-protocol.patch
memcg-sanitize-__mem_cgroup_try_charge-call-protocol-fix.patch
memcg-rename-high-level-charging-functions.patch
mm-page_alloc-spill-to-remote-nodes-before-waking-kswapd.patch
linux-next.patch
memcg-slab-never-try-to-merge-memcg-caches.patch
memcg-slab-cleanup-memcg-cache-creation.patch
memcg-slab-separate-memcg-vs-root-cache-creation-paths.patch
memcg-slab-unregister-cache-from-memcg-before-starting-to-destroy-it.patch
memcg-slab-do-not-destroy-children-caches-if-parent-has-aliases.patch
slub-adjust-memcg-caches-when-creating-cache-alias.patch
slub-rework-sysfs-layout-for-memcg-caches.patch
debugging-keep-track-of-page-owners.patch

