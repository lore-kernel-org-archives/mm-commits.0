From: akpm@linux-foundation.org
Subject: [merged] acpi-remove-nid_inval.patch removed from -mm tree
Date: Thu, 17 Dec 2009 12:38:42 -0800
Message-ID: <200912172038.nBHKcgEU017498@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53611 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764096AbZLQUjh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Dec 2009 15:39:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, Lee.Schermerhorn@hp.com, cl@linux-foundation.org, gorcunov@openvz.org, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     acpi: remove NID_INVAL
has been removed from the -mm tree.  Its filename was
     acpi-remove-nid_inval.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: remove NID_INVAL
From: David Rientjes <rientjes@google.com>

NUMA_NO_NODE has been exported globally and thus it can replace NID_INVAL
in the acpi code.

Also removes the unused acpi_unmap_pxm_to_node() function.

[akpm@linux-foundation.org: coding-style fixes]
Cc: Len Brown <lenb@kernel.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/numa.c |   21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff -puN drivers/acpi/numa.c~acpi-remove-nid_inval drivers/acpi/numa.c
--- a/drivers/acpi/numa.c~acpi-remove-nid_inval
+++ a/drivers/acpi/numa.c
@@ -28,6 +28,7 @@
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/acpi.h>
+#include <linux/numa.h>
 #include <acpi/acpi_bus.h>
 
 #define PREFIX "ACPI: "
@@ -40,14 +41,14 @@ static nodemask_t nodes_found_map = NODE
 
 /* maps to convert between proximity domain and logical node ID */
 static int pxm_to_node_map[MAX_PXM_DOMAINS]
-				= { [0 ... MAX_PXM_DOMAINS - 1] = NID_INVAL };
+			= { [0 ... MAX_PXM_DOMAINS - 1] = NUMA_NO_NODE };
 static int node_to_pxm_map[MAX_NUMNODES]
-				= { [0 ... MAX_NUMNODES - 1] = PXM_INVAL };
+			= { [0 ... MAX_NUMNODES - 1] = PXM_INVAL };
 
 int pxm_to_node(int pxm)
 {
 	if (pxm < 0)
-		return NID_INVAL;
+		return NUMA_NO_NODE;
 	return pxm_to_node_map[pxm];
 }
 
@@ -68,9 +69,9 @@ int acpi_map_pxm_to_node(int pxm)
 {
 	int node = pxm_to_node_map[pxm];
 
-	if (node < 0){
+	if (node < 0) {
 		if (nodes_weight(nodes_found_map) >= MAX_NUMNODES)
-			return NID_INVAL;
+			return NUMA_NO_NODE;
 		node = first_unset_node(nodes_found_map);
 		__acpi_map_pxm_to_node(pxm, node);
 		node_set(node, nodes_found_map);
@@ -79,16 +80,6 @@ int acpi_map_pxm_to_node(int pxm)
 	return node;
 }
 
-#if 0
-void __cpuinit acpi_unmap_pxm_to_node(int node)
-{
-	int pxm = node_to_pxm_map[node];
-	pxm_to_node_map[pxm] = NID_INVAL;
-	node_to_pxm_map[node] = PXM_INVAL;
-	node_clear(node, nodes_found_map);
-}
-#endif  /*  0  */
