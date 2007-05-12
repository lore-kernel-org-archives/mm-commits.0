From: akpm@linux-foundation.org
Subject: - x86_64-acpi-define-and-use-local_distance-and.patch removed from -mm tree
Date: Fri, 11 May 2007 22:16:21 -0700
Message-ID: <200705120516.l4C5GLEV001815@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60578 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756602AbXELFRn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:17:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, ak@suse.de, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     x86_64 acpi: define and use LOCAL_DISTANCE and REMOTE_DISTANCE
has been removed from the -mm tree.  Its filename was
     x86_64-acpi-define-and-use-local_distance-and.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64 acpi: define and use LOCAL_DISTANCE and REMOTE_DISTANCE
From: David Rientjes <rientjes@google.com>

Export {LOCAL,REMOTE}_DISTANCE to x86_64 ACPI code.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/mm/srat.c    |    6 +++---
 include/linux/topology.h |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/x86_64/mm/srat.c~x86_64-acpi-define-and-use-local_distance-and arch/x86_64/mm/srat.c
--- a/arch/x86_64/mm/srat.c~x86_64-acpi-define-and-use-local_distance-and
+++ a/arch/x86_64/mm/srat.c
@@ -106,9 +106,9 @@ static __init int slit_valid(struct acpi
 		for (j = 0; j < d; j++)  {
 			u8 val = slit->entry[d*i + j];
 			if (i == j) {
-				if (val != 10)
+				if (val != LOCAL_DISTANCE)
 					return 0;
-			} else if (val <= 10)
+			} else if (val <= LOCAL_DISTANCE)
 				return 0;
 		}
 	}
@@ -464,7 +464,7 @@ int __node_distance(int a, int b)
 	int index;
 
 	if (!acpi_slit)
-		return a == b ? 10 : 20;
+		return a == b ? LOCAL_DISTANCE : REMOTE_DISTANCE;
 	index = acpi_slit->locality_count * node_to_pxm(a);
 	return acpi_slit->entry[index + node_to_pxm(b)];
 }
diff -puN include/linux/topology.h~x86_64-acpi-define-and-use-local_distance-and include/linux/topology.h
--- a/include/linux/topology.h~x86_64-acpi-define-and-use-local_distance-and
+++ a/include/linux/topology.h
@@ -50,10 +50,10 @@
 	for_each_online_node(node)						\
 		if (nr_cpus_node(node))
 
-#ifndef node_distance
 /* Conform to ACPI 2.0 SLIT distance definitions */
 #define LOCAL_DISTANCE		10
 #define REMOTE_DISTANCE		20
+#ifndef node_distance
 #define node_distance(from,to)	((from) == (to) ? LOCAL_DISTANCE : REMOTE_DISTANCE)
 #endif
 #ifndef RECLAIM_DISTANCE
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
frv-gdb-use-__maybe_unused.patch
git-alsa.patch
powerpc-ps3-use-__maybe_unused.patch
mips-excite-use-__maybe_unused.patch
mips-tlbex-use-__maybe_unused.patch
scsi-fix-ambiguous-gdthtable-definition.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
x86_64-fix-e820_hole_size-based-on-address-ranges.patch
x86_64-acpi-disable-srat-when-numa-emulation-succeeds.patch
x86_64-slit-fake-pxm-to-node-mapping-for-fake-numa-2.patch
x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources-update.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
