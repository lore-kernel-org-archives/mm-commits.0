From: akpm@linux-foundation.org
Subject: - acpi-fix-potential-call-to-a-freed-memory-section.patch removed from -mm tree
Date: Fri, 18 May 2007 00:06:04 -0700
Message-ID: <200705180706.l4I763du010142@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37774 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754907AbXERHmp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 May 2007 03:42:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adurbin@google.com, lenb@kernel.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     acpi: fix potential call to a freed memory section.
has been removed from the -mm tree.  Its filename was
     acpi-fix-potential-call-to-a-freed-memory-section.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: acpi: fix potential call to a freed memory section.
From: Aaron Durbin <adurbin@google.com>

Strip __cpuinit[data] from Node <-> PXM routines and supporting data
structures.  Also make pxm_to_node_map and node_to_pxm_map local to the
numa acpi module.

This fixes a bug triggered by the following conditions:
- boot on a machine with a SLIT table defined
- kernel is configured w/ CONFIG_HOTPLUG_CPU=n
- cat /sys/devices/system/node/node*/distance
This will cause an oops by calling into a freed memory section.

In particular, on x86_64, __node_distance calls node_to_pxm().

Signed-off-by: Aaron Durbin <adurbin@google.com>
Cc: Len Brown <lenb@kernel.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/numa.c      |    8 ++++----
 include/acpi/acpi_numa.h |    7 ++-----
 2 files changed, 6 insertions(+), 9 deletions(-)

diff -puN drivers/acpi/numa.c~acpi-fix-potential-call-to-a-freed-memory-section drivers/acpi/numa.c
--- a/drivers/acpi/numa.c~acpi-fix-potential-call-to-a-freed-memory-section
+++ a/drivers/acpi/numa.c
@@ -40,19 +40,19 @@ static nodemask_t nodes_found_map = NODE
 #define NID_INVAL	-1
 
 /* maps to convert between proximity domain and logical node ID */
-int __cpuinitdata pxm_to_node_map[MAX_PXM_DOMAINS]
+static int pxm_to_node_map[MAX_PXM_DOMAINS]
 				= { [0 ... MAX_PXM_DOMAINS - 1] = NID_INVAL };
-int __cpuinitdata node_to_pxm_map[MAX_NUMNODES]
+static int node_to_pxm_map[MAX_NUMNODES]
 				= { [0 ... MAX_NUMNODES - 1] = PXM_INVAL };
 
-int __cpuinit pxm_to_node(int pxm)
+int pxm_to_node(int pxm)
 {
 	if (pxm < 0)
 		return NID_INVAL;
 	return pxm_to_node_map[pxm];
 }
 
-int __cpuinit node_to_pxm(int node)
+int node_to_pxm(int node)
 {
 	if (node < 0)
 		return PXM_INVAL;
diff -puN include/acpi/acpi_numa.h~acpi-fix-potential-call-to-a-freed-memory-section include/acpi/acpi_numa.h
--- a/include/acpi/acpi_numa.h~acpi-fix-potential-call-to-a-freed-memory-section
+++ a/include/acpi/acpi_numa.h
@@ -11,11 +11,8 @@
 #define MAX_PXM_DOMAINS (256)	/* Old pxm spec is defined 8 bit */
 #endif
 
-extern int __cpuinitdata pxm_to_node_map[MAX_PXM_DOMAINS];
-extern int __cpuinitdata node_to_pxm_map[MAX_NUMNODES];
-
-extern int __cpuinit pxm_to_node(int);
-extern int __cpuinit node_to_pxm(int);
+extern int pxm_to_node(int);
+extern int node_to_pxm(int);
 extern int __cpuinit acpi_map_pxm_to_node(int);
 extern void __cpuinit acpi_unmap_pxm_to_node(int);
 
_

Patches currently in -mm which might be from adurbin@google.com are

origin.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources-fix.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources-update.patch
