From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 045/127] mm/memory_hotplug: set node_start_pfn of
 hotadded pgdat to 0
Date: Thu, 04 Jun 2020 16:48:35 -0700
Message-ID: <20200604234835.COzbnKlZr%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgFDXsh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:48:37 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, anshuman.khandual@arm.com, bhe@redhat.com, david@redhat.com, linux-mm@kvack.org, mhocko@kernel.org, mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de, pankaj.gupta.linux@gmail.com, rppt@linux.ibm.com, torvalds@linux-foundation.org

From: David Hildenbrand <david@redhat.com>
Subject: mm/memory_hotplug: set node_start_pfn of hotadded pgdat to 0

Patch series "mm/memory_hotplug: handle memblocks only with
CONFIG_ARCH_KEEP_MEMBLOCK", v1.

A hotadded node/pgdat will span no pages at all, until memory is moved to
the zone/node via move_pfn_range_to_zone() -> resize_pgdat_range - e.g.,
when onlining memory blocks.  We don't have to initialize the
node_start_pfn to the memory we are adding.


This patch (of 2):

Especially, there is an inconsistency:
- Hotplugging memory to a memory-less node with cpus: node_start_pf ==  0
- Offlining and removing last memory from a node: node_start_pfn == 0
- Hotplugging memory to a memory-less node without cpus: node_start_pfn != 0

As soon as memory is onlined, node_start_pfn is overwritten with the
actual start.  E.g., when adding two DIMMs but only onlining one of both,
only that DIMM (with online memory blocks) is spanned by the node.

Currently, the validity of node_start_pfn really is linked to
node_spanned_pages != 0.  With node_spanned_pages == 0 (e.g., before
onlining memory), it has no meaning.

So let's stop setting node_start_pfn, just to be overwritten via
move_pfn_range_to_zone().  This avoids confusion when looking at the code,
wondering which magic will be performed with the node_start_pfn in this
function, when hotadding a pgdat.

Link: http://lkml.kernel.org/r/20200422155353.25381-1-david@redhat.com
Link: http://lkml.kernel.org/r/20200422155353.25381-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-set-node_start_pfn-of-hotadded-pgdat-to-0
+++ a/mm/memory_hotplug.c
@@ -862,10 +862,9 @@ static void reset_node_present_pages(pg_
 }
 
 /* we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG */
-static pg_data_t __ref *hotadd_new_pgdat(int nid, u64 start)
+static pg_data_t __ref *hotadd_new_pgdat(int nid)
 {
 	struct pglist_data *pgdat;
-	unsigned long start_pfn = PFN_DOWN(start);
 
 	pgdat = NODE_DATA(nid);
 	if (!pgdat) {
@@ -895,9 +894,8 @@ static pg_data_t __ref *hotadd_new_pgdat
 	}
 
 	/* we can use NODE_DATA(nid) from here */
-
 	pgdat->node_id = nid;
-	pgdat->node_start_pfn = start_pfn;
+	pgdat->node_start_pfn = 0;
 
 	/* init node's zones as empty zones, we don't have any present pages.*/
 	free_area_init_core_hotplug(nid);
@@ -932,7 +930,6 @@ static void rollback_node_hotadd(int nid
 /**
  * try_online_node - online a node if offlined
  * @nid: the node ID
- * @start: start addr of the node
  * @set_node_online: Whether we want to online the node
  * called by cpu_up() to online a node without onlined memory.
  *
@@ -941,7 +938,7 @@ static void rollback_node_hotadd(int nid
  * 0 -> the node is already online
  * -ENOMEM -> the node could not be allocated
  */
-static int __try_online_node(int nid, u64 start, bool set_node_online)
+static int __try_online_node(int nid, bool set_node_online)
 {
 	pg_data_t *pgdat;
 	int ret = 1;
@@ -949,7 +946,7 @@ static int __try_online_node(int nid, u6
 	if (node_online(nid))
 		return 0;
 
-	pgdat = hotadd_new_pgdat(nid, start);
+	pgdat = hotadd_new_pgdat(nid);
 	if (!pgdat) {
 		pr_err("Cannot online node %d due to NULL pgdat\n", nid);
 		ret = -ENOMEM;
@@ -973,7 +970,7 @@ int try_online_node(int nid)
 	int ret;
 
 	mem_hotplug_begin();
-	ret =  __try_online_node(nid, 0, true);
+	ret =  __try_online_node(nid, true);
 	mem_hotplug_done();
 	return ret;
 }
@@ -1032,7 +1029,7 @@ int __ref add_memory_resource(int nid, s
 	 */
 	memblock_add_node(start, size, nid);
 
-	ret = __try_online_node(nid, start, false);
+	ret = __try_online_node(nid, false);
 	if (ret < 0)
 		goto error;
 	new_node = ret;
_
