From: akpm@linux-foundation.org
Subject: - slab-partially-revert-list3-changes.patch removed from -mm tree
Date: Mon, 28 Jan 2008 17:47:50 -0800
Message-ID: <200801290147.m0T1lo6U027307@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35023 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754180AbYA2Bs7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 20:48:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, clameter@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, nacc@us.ibm.com, paulus@samba.org, penberg@cs.helsinki.fi


The patch titled
     slab: partially revert list3 changes
has been removed from the -mm tree.  Its filename was
     slab-partially-revert-list3-changes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: slab: partially revert list3 changes
From: Mel Gorman <mel@csn.ul.ie>

Partial revert the changes made by 04231b3002ac53f8a64a7bd142fde3fa4b6808c6
to the kmem_list3 management. On a machine with a memoryless node, this
BUG_ON was triggering

static void *____cache_alloc_node(struct kmem_cache *cachep, gfp_t
flags,
                                int nodeid)
{
        struct list_head *entry;
        struct slab *slabp;
        struct kmem_list3 *l3;
        void *obj;
        int x;

        l3 = cachep->nodelists[nodeid];
        BUG_ON(!l3);

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Acked-by: Christoph Lameter <clameter@sgi.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/slab.c~slab-partially-revert-list3-changes mm/slab.c
--- a/mm/slab.c~slab-partially-revert-list3-changes
+++ a/mm/slab.c
@@ -1590,7 +1590,7 @@ void __init kmem_cache_init(void)
 		/* Replace the static kmem_list3 structures for the boot cpu */
 		init_list(&cache_cache, &initkmem_list3[CACHE_CACHE], node);
 
-		for_each_node_state(nid, N_NORMAL_MEMORY) {
+		for_each_online_node(nid) {
 			init_list(malloc_sizes[INDEX_AC].cs_cachep,
 				  &initkmem_list3[SIZE_AC + nid], nid);
 
@@ -1968,7 +1968,7 @@ static void __init set_up_list3s(struct 
 {
 	int node;
 
-	for_each_node_state(node, N_NORMAL_MEMORY) {
+	for_each_online_node(node) {
 		cachep->nodelists[node] = &initkmem_list3[index + node];
 		cachep->nodelists[node]->next_reap = jiffies +
 		    REAPTIMEOUT_LIST3 +
@@ -3815,7 +3815,7 @@ static int alloc_kmemlist(struct kmem_ca
 	struct array_cache *new_shared;
 	struct array_cache **new_alien = NULL;
 
-	for_each_node_state(node, N_NORMAL_MEMORY) {
+	for_each_online_node(node) {
 
                 if (use_alien_caches) {
                         new_alien = alloc_alien_cache(node, cachep->limit);
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
git-x86.patch
memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability.patch
page-allocator-clean-up-pcp-draining-functions.patch
page-allocator-get-rid-of-the-list-of-cold-pages.patch
page-allocator-get-rid-of-the-list-of-cold-pages-fix.patch
memcgroup-tidy-up-mem_cgroup_charge_common.patch
memcgroup-fix-hang-with-shmem-tmpfs.patch
page-owner-tracking-leak-detector.patch
add-debugging-aid-for-memory-initialisation-problems.patch
