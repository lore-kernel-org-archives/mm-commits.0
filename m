From: akpm@linux-foundation.org
Subject: - slab-dont-allocate-empty-shared-caches.patch removed from -mm tree
Date: Mon, 07 May 2007 17:02:40 -0700
Message-ID: <200705080002.l4802eRr008862@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43187 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967333AbXEHADb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:03:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dada1@cosmosbay.com, clameter@engr.sgi.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     SLAB: don't allocate empty shared caches
has been removed from the -mm tree.  Its filename was
     slab-dont-allocate-empty-shared-caches.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SLAB: don't allocate empty shared caches
From: Eric Dumazet <dada1@cosmosbay.com>

We can avoid allocating empty shared caches and avoid unecessary check of
cache->limit.  We save some memory.  We avoid bringing into CPU cache
unecessary cache lines.

All accesses to l3->shared are already checking NULL pointers so this patch is
safe.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff -puN mm/slab.c~slab-dont-allocate-empty-shared-caches mm/slab.c
--- a/mm/slab.c~slab-dont-allocate-empty-shared-caches
+++ a/mm/slab.c
@@ -1223,19 +1223,20 @@ static int __cpuinit cpuup_callback(stru
 		 */
 		list_for_each_entry(cachep, &cache_chain, next) {
 			struct array_cache *nc;
-			struct array_cache *shared;
+			struct array_cache *shared = NULL;
 			struct array_cache **alien = NULL;
 
 			nc = alloc_arraycache(node, cachep->limit,
 						cachep->batchcount);
 			if (!nc)
 				goto bad;
-			shared = alloc_arraycache(node,
+			if (cachep->shared) {
+				shared = alloc_arraycache(node,
 					cachep->shared * cachep->batchcount,
 					0xbaadf00d);
-			if (!shared)
-				goto bad;
-
+				if (!shared)
+					goto bad;
+			}
 			if (use_alien_caches) {
                                 alien = alloc_alien_cache(node, cachep->limit);
                                 if (!alien)
@@ -1317,8 +1318,8 @@ static int __cpuinit cpuup_callback(stru
 
 			shared = l3->shared;
 			if (shared) {
-				free_block(cachep, l3->shared->entry,
-					   l3->shared->avail, node);
+				free_block(cachep, shared->entry,
+					   shared->avail, node);
 				l3->shared = NULL;
 			}
 
@@ -3870,12 +3871,15 @@ static int alloc_kmemlist(struct kmem_ca
                                 goto fail;
                 }
 
-		new_shared = alloc_arraycache(node,
+		new_shared = NULL;
+		if (cachep->shared) {
+			new_shared = alloc_arraycache(node,
 				cachep->shared*cachep->batchcount,
 					0xbaadf00d);
-		if (!new_shared) {
-			free_alien_cache(new_alien);
-			goto fail;
+			if (!new_shared) {
+				free_alien_cache(new_alien);
+				goto fail;
+			}
 		}
 
 		l3 = cachep->nodelists[node];
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

origin.patch
optimize-timespec_trunc.patch
procfs-reorder-struct-pid_dentry-to-save-space-on-64bit-archs-and-constify-them.patch
vfs-delay-the-dentry-name-generation-on-sockets-and.patch
getrusage-fill-ru_inblock-and-ru_oublock-fields-if-possible.patch
time-smp-friendly-alignment-of-struct-clocksource.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
splice-and-readahead-interaction.patch
make-static-counters-in-new_inode-and-iunique-be-32-bits.patch
speedup-divides-by-cpu_power-in-scheduler.patch
futex-new-private-futexes.patch
lguest-the-host-code-vs-futex-new-private-futexes.patch
