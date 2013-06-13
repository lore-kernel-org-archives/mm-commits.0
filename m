From: akpm@linux-foundation.org
Subject: + mm-remove-zone_type-argument-of-build_zonelists_node.patch
 added to -mm tree
Date: Thu, 13 Jun 2013 14:25:56 -0700
Message-ID: <51ba38e4.GXcVSVOupGSpFHaD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37922 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758816Ab3FMVZ5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jun 2013 17:25:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, zhangyanfei@cn.fujitsu.com

Subject: + mm-remove-zone_type-argument-of-build_zonelists_node.patch added to -mm tree
To: zhangyanfei@cn.fujitsu.com,rientjes@google.com
From: akpm@linux-foundation.org
Date: Thu, 13 Jun 2013 14:25:56 -0700


The patch titled
     Subject: mm/page_alloc.c: remove zone_type argument of build_zonelists_node
has been added to the -mm tree.  Its filename is
     mm-remove-zone_type-argument-of-build_zonelists_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: mm/page_alloc.c: remove zone_type argument of build_zonelists_node

The callers of build_zonelists_node always pass MAX_NR_ZONES -1 as the
zone_type argument, so we can directly use the value in
build_zonelists_node and remove zone_type argument.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff -puN mm/page_alloc.c~mm-remove-zone_type-argument-of-build_zonelists_node mm/page_alloc.c
--- a/mm/page_alloc.c~mm-remove-zone_type-argument-of-build_zonelists_node
+++ a/mm/page_alloc.c
@@ -3153,12 +3153,10 @@ static void zoneref_set_zone(struct zone
  * Add all populated zones of a node to the zonelist.
  */
 static int build_zonelists_node(pg_data_t *pgdat, struct zonelist *zonelist,
-				int nr_zones, enum zone_type zone_type)
+				int nr_zones)
 {
 	struct zone *zone;
-
-	BUG_ON(zone_type >= MAX_NR_ZONES);
-	zone_type++;
+	enum zone_type zone_type = MAX_NR_ZONES;
 
 	do {
 		zone_type--;
@@ -3168,8 +3166,8 @@ static int build_zonelists_node(pg_data_
 				&zonelist->_zonerefs[nr_zones++]);
 			check_highest_zone(zone_type);
 		}
-
 	} while (zone_type);
+
 	return nr_zones;
 }
 
@@ -3363,8 +3361,7 @@ static void build_zonelists_in_node_orde
 	zonelist = &pgdat->node_zonelists[0];
 	for (j = 0; zonelist->_zonerefs[j].zone != NULL; j++)
 		;
-	j = build_zonelists_node(NODE_DATA(node), zonelist, j,
-							MAX_NR_ZONES - 1);
+	j = build_zonelists_node(NODE_DATA(node), zonelist, j);
 	zonelist->_zonerefs[j].zone = NULL;
 	zonelist->_zonerefs[j].zone_idx = 0;
 }
@@ -3378,7 +3375,7 @@ static void build_thisnode_zonelists(pg_
 	struct zonelist *zonelist;
 
 	zonelist = &pgdat->node_zonelists[1];
-	j = build_zonelists_node(pgdat, zonelist, 0, MAX_NR_ZONES - 1);
+	j = build_zonelists_node(pgdat, zonelist, 0);
 	zonelist->_zonerefs[j].zone = NULL;
 	zonelist->_zonerefs[j].zone_idx = 0;
 }
@@ -3586,7 +3583,7 @@ static void build_zonelists(pg_data_t *p
 	local_node = pgdat->node_id;
 
 	zonelist = &pgdat->node_zonelists[0];
-	j = build_zonelists_node(pgdat, zonelist, 0, MAX_NR_ZONES - 1);
+	j = build_zonelists_node(pgdat, zonelist, 0);
 
 	/*
 	 * Now we build the zonelist so that it contains the zones
@@ -3599,14 +3596,12 @@ static void build_zonelists(pg_data_t *p
 	for (node = local_node + 1; node < MAX_NUMNODES; node++) {
 		if (!node_online(node))
 			continue;
-		j = build_zonelists_node(NODE_DATA(node), zonelist, j,
-							MAX_NR_ZONES - 1);
+		j = build_zonelists_node(NODE_DATA(node), zonelist, j);
 	}
 	for (node = 0; node < local_node; node++) {
 		if (!node_online(node))
 			continue;
-		j = build_zonelists_node(NODE_DATA(node), zonelist, j,
-							MAX_NR_ZONES - 1);
+		j = build_zonelists_node(NODE_DATA(node), zonelist, j);
 	}
 
 	zonelist->_zonerefs[j].zone = NULL;
_

Patches currently in -mm which might be from zhangyanfei@cn.fujitsu.com are

linux-next.patch
vmcore-clean-up-read_vmcore.patch
vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment.patch
vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment-fix.patch
vmcore-treat-memory-chunks-referenced-by-pt_load-program-header-entries-in-page-size-boundary-in-vmcore_list.patch
vmalloc-make-find_vm_area-check-in-range.patch
vmalloc-introduce-remap_vmalloc_range_partial.patch
vmalloc-introduce-remap_vmalloc_range_partial-fix.patch
vmcore-allocate-elf-note-segment-in-the-2nd-kernel-vmalloc-memory.patch
vmcore-allocate-elf-note-segment-in-the-2nd-kernel-vmalloc-memory-fix.patch
vmcore-allow-user-process-to-remap-elf-note-segment-buffer.patch
vmcore-allow-user-process-to-remap-elf-note-segment-buffer-fix.patch
vmcore-calculate-vmcore-file-size-from-buffer-size-and-total-size-of-vmcore-objects.patch
vmcore-support-mmap-on-proc-vmcore.patch
vmcore-support-mmap-on-proc-vmcore-fix.patch
vmcore-support-mmap-on-proc-vmcore-fix-2.patch
mm-ia64-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-vmalloc-only-call-setup_vmalloc_vm-only-in-__get_vm_area_node.patch
mm-vmalloc-call-setup_vmalloc_vm-instead-of-insert_vmalloc_vm.patch
mm-vmalloc-remove-insert_vmalloc_vm.patch
mm-vmalloc-use-clamp-to-simplify-code.patch
mm-remove-duplicated-call-of-get_pfn_range_for_nid.patch
mm-vmallocc-unbreak-__vunmap.patch
mm-vmallocc-remove-dead-code-in-vb_alloc.patch
mm-vmallocc-remove-unused-purge_fragmented_blocks_thiscpu.patch
mm-vmallocc-remove-alloc_map-from-vmap_block.patch
mm-vmallocc-emit-the-failure-message-before-return.patch
mm-vmallocc-rename-vm_unlist-to-vm_uninitialized.patch
mm-vmallocc-check-vm_uninitialized-flag-in-s_show-instead-of-show_numa_info.patch
include-linux-gfph-fix-the-comment-for-gfp_zone_table.patch
mm-remove-zone_type-argument-of-build_zonelists_node.patch
dev-oldmem-remove-the-interface.patch
dev-oldmem-remove-the-interface-fix.patch
documentation-kdump-kdumptxt-remove-dev-oldmem-description.patch
mips-remove-savemaxmem-parameter-setup.patch
powerpc-remove-savemaxmem-parameter-setup.patch
ia64-remove-setting-for-saved_max_pfn.patch
s390-remove-setting-for-saved_max_pfn.patch

