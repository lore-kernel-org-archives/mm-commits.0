From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 10/25] mm: add comments on pglist_data zones
Date: Wed, 10 Jun 2020 18:41:50 -0700
Message-ID: <20200611014150.9MNWkw05i%akpm@linux-foundation.org>
References: <20200610184053.3fa7368ab80e23bfd44de71f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726381AbgFKBlv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Jun 2020 21:41:51 -0400
In-Reply-To: <20200610184053.3fa7368ab80e23bfd44de71f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ben.widawsky@intel.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
