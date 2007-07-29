From: akpm@linux-foundation.org
Subject: + uncached-allocator-handle-memoryless-nodes.patch added to -mm tree
Date: Sun, 29 Jul 2007 00:16:06 -0700
Message-ID: <200707290716.l6T7G6RM013242@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40097 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760018AbXG2HQO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 03:16:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lee.schermerhorn@hp.com, bob.picco@hp.com, clameter@sgi.com, jes@sgi.com


The patch titled
     Uncached allocator: Handle memoryless nodes
has been added to the -mm tree.  Its filename is
     uncached-allocator-handle-memoryless-nodes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Uncached allocator: Handle memoryless nodes
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

The checks for node_online in the uncached allocator are made to make sure
that memory is available on these nodes.  Thus switch all the checks to use
the node_memory and for_each_memory_node functions.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Jes Sorensen <jes@sgi.com>
Acked-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Bob Picco <bob.picco@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/uncached.c |    4 ++--
 drivers/char/mspec.c        |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/ia64/kernel/uncached.c~uncached-allocator-handle-memoryless-nodes arch/ia64/kernel/uncached.c
--- a/arch/ia64/kernel/uncached.c~uncached-allocator-handle-memoryless-nodes
+++ a/arch/ia64/kernel/uncached.c
@@ -196,7 +196,7 @@ unsigned long uncached_alloc_page(int st
 	nid = starting_nid;
 
 	do {
-		if (!node_online(nid))
+		if (!node_state(nid, N_MEMORY))
 			continue;
 		uc_pool = &uncached_pools[nid];
 		if (uc_pool->pool == NULL)
@@ -268,7 +268,7 @@ static int __init uncached_init(void)
 {
 	int nid;
 
-	for_each_online_node(nid) {
+	for_each_node_state(nid, N_ONLINE) {
 		uncached_pools[nid].pool = gen_pool_create(PAGE_SHIFT, nid);
 		mutex_init(&uncached_pools[nid].add_chunk_mutex);
 	}
diff -puN drivers/char/mspec.c~uncached-allocator-handle-memoryless-nodes drivers/char/mspec.c
--- a/drivers/char/mspec.c~uncached-allocator-handle-memoryless-nodes
+++ a/drivers/char/mspec.c
@@ -344,7 +344,7 @@ mspec_init(void)
 		is_sn2 = 1;
 		if (is_shub2()) {
 			ret = -ENOMEM;
-			for_each_online_node(nid) {
+			for_each_node_state(nid, N_ONLINE) {
 				int actual_nid;
 				int nasid;
 				unsigned long phys;
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

numa-generic-management-of-nodemasks-for-various-purposes.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory.patch
memoryless-nodes-fix-interleave-behavior.patch
oom-use-the-n_memory-map-instead-of-constructing-one-on-the-fly.patch
memoryless-nodes-no-need-for-kswapd.patch
memoryless-node-slab-support.patch
memoryless-nodes-slub-support.patch
uncached-allocator-handle-memoryless-nodes.patch
memoryless-node-allow-profiling-data-to-fall-back-to-other-nodes.patch
memoryless-nodes-update-memory-policy-and-page-migration.patch
add-n_cpu-node-state.patch
memoryless-nodes-fix-gfp_thisnode-behavior.patch
memoryless-nodes-use-node_memory_map-for-cpusets.patch
memoryless-nodes-drop-one-memoryless-node-boot-warning.patch
