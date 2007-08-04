From: akpm@linux-foundation.org
Subject: - uncached-allocator-handle-memoryless-nodes.patch removed from -mm tree
Date: Fri, 03 Aug 2007 22:15:21 -0700
Message-ID: <200708040515.l745FLeK011729@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43049 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752632AbXHDFP3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 4 Aug 2007 01:15:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lee.schermerhorn@hp.com, bob.picco@hp.com, clameter@sgi.com, jes@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Uncached allocator: Handle memoryless nodes
has been removed from the -mm tree.  Its filename was
     uncached-allocator-handle-memoryless-nodes.patch

This patch was dropped because an updated version will be merged

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
@@ -345,7 +345,7 @@ mspec_init(void)
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

fix-missing-numa_zonelist_order-sysctl.patch
document-linux-memory-policy-v3.patch
uncached-allocator-handle-memoryless-nodes.patch
memoryless-node-allow-profiling-data-to-fall-back-to-other-nodes.patch
memoryless-nodes-update-memory-policy-and-page-migration.patch
add-n_cpu-node-state.patch
memoryless-nodes-fix-gfp_thisnode-behavior.patch
memoryless-nodes-use-node_memory_map-for-cpusets.patch
memoryless-nodes-drop-one-memoryless-node-boot-warning.patch
