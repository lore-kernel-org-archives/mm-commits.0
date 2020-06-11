From: akpm@linux-foundation.org
Subject: [merged] mm-add-comments-on-pglist_data-zones.patch
 removed from -mm tree
Date: Thu, 11 Jun 2020 15:23:05 -0700
Message-ID: <20200611222305.GuIExpKAK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726260AbgFKWXF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Jun 2020 18:23:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ben.widawsky@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add comments on pglist_data zones
has been removed from the -mm tree.  Its filename was
     mm-add-comments-on-pglist_data-zones.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ben Widawsky <ben.widawsky@intel.com>
Subject: mm: add comments on pglist_data zones

While making other modifications it was easy to confuse the two struct
members node_zones and node_zonelists.  For those already familiar with
the code, this might seem to be a silly patch, but it's quite helpful to
disambiguate the similar-sounding fields

While here, add a small comment on why nr_zones isn't simply MAX_NR_ZONES

Link: http://lkml.kernel.org/r/20200520205443.2757414-1-ben.widawsky@intel.com
Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/include/linux/mmzone.h~mm-add-comments-on-pglist_data-zones
+++ a/include/linux/mmzone.h
@@ -660,9 +660,21 @@ struct deferred_split {
  * per-zone basis.
  */
 typedef struct pglist_data {
+	/*
+	 * node_zones contains just the zones for THIS node. Not all of the
+	 * zones may be populated, but it is the full list. It is referenced by
+	 * this node's node_zonelists as well as other node's node_zonelists.
+	 */
 	struct zone node_zones[MAX_NR_ZONES];
+
+	/*
+	 * node_zonelists contains references to all zones in all nodes.
+	 * Generally the first zones will be references to this node's
+	 * node_zones.
+	 */
 	struct zonelist node_zonelists[MAX_ZONELISTS];
-	int nr_zones;
+
+	int nr_zones; /* number of populated zones in this node */
 #ifdef CONFIG_FLAT_NODE_MEM_MAP	/* means !SPARSEMEM */
 	struct page *node_mem_map;
 #ifdef CONFIG_PAGE_EXTENSION
_

Patches currently in -mm which might be from ben.widawsky@intel.com are
