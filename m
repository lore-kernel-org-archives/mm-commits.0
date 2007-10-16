From: akpm@linux-foundation.org
Subject: - convert-cpu_sibling_map-to-a-per_cpu-data-array-ia64-fix.patch removed from -mm tree
Date: Mon, 15 Oct 2007 20:52:14 -0700
Message-ID: <200710160352.l9G3qEVO007408@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60850 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758229AbXJPDwS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 23:52:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: travis@sgi.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ia64: convert cpu_sibling_map to a per_cpu data array FIX
has been removed from the -mm tree.  Its filename was
     convert-cpu_sibling_map-to-a-per_cpu-data-array-ia64-fix.patch

This patch was dropped because it was folded into convert-cpu_sibling_map-to-a-per_cpu-data-array-ia64.patch

------------------------------------------------------
Subject: ia64: convert cpu_sibling_map to a per_cpu data array FIX
From: Mike Travis <travis@sgi.com>

There are two versions of per_cpu_init() for ia64.  This patch corrects the
problem that one of the versions did not insert the boot cpu into the cpu
sibling and core maps.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN arch/ia64/kernel/setup.c~convert-cpu_sibling_map-to-a-per_cpu-data-array-ia64-fix arch/ia64/kernel/setup.c
--- a/arch/ia64/kernel/setup.c~convert-cpu_sibling_map-to-a-per_cpu-data-array-ia64-fix
+++ a/arch/ia64/kernel/setup.c
@@ -869,6 +869,14 @@ cpu_init (void)
 	void *cpu_data;
 
 	cpu_data = per_cpu_init();
+	/*
+	 * insert boot cpu into sibling and core mapes
+	 * (must be done after per_cpu area is setup)
+	 */
+	if (smp_processor_id() == 0) {
+		cpu_set(0, per_cpu(cpu_sibling_map, 0));
+		cpu_set(0, cpu_core_map[0]);
+	}
 
 	/*
 	 * We set ar.k3 so that assembly code in MCA handler can compute
diff -puN arch/ia64/mm/contig.c~convert-cpu_sibling_map-to-a-per_cpu-data-array-ia64-fix arch/ia64/mm/contig.c
--- a/arch/ia64/mm/contig.c~convert-cpu_sibling_map-to-a-per_cpu-data-array-ia64-fix
+++ a/arch/ia64/mm/contig.c
@@ -212,12 +212,6 @@ per_cpu_init (void)
 			cpu_data += PERCPU_PAGE_SIZE;
 			per_cpu(local_per_cpu_offset, cpu) = __per_cpu_offset[cpu];
 		}
-		/*
-		 * cpu_sibling_map is now a per_cpu variable - it needs to
-		 * be accessed after per_cpu_init() sets up the per_cpu area.
-		 */
-		cpu_set(0, per_cpu(cpu_sibling_map, 0));
-		cpu_set(0, cpu_core_map[0]);
 	}
 	return __per_cpu_start + __per_cpu_offset[smp_processor_id()];
 }
_

Patches currently in -mm which might be from travis@sgi.com are

x86-convert-cpu_core_map-to-be-a-per-cpu-variable.patch
convert-cpu_sibling_map-to-be-a-per-cpu-variable.patch
convert-cpu_sibling_map-to-a-per_cpu-data-array-ia64.patch
convert-cpu_sibling_map-to-a-per_cpu-data-array-ia64-fix.patch
convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64.patch
convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64-fix.patch
convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64-fix-2.patch
convert-cpu_sibling_map-to-a-per_cpu-data-array-sparc64.patch
x86-convert-cpuinfo_x86-array-to-a-per_cpu-array.patch
x86-convert-cpuinfo_x86-array-to-a-per_cpu-array-fix.patch
