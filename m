From: akpm@linux-foundation.org
Subject: - x86_64-remove-x86_cpu_to_log_apicid.patch removed from -mm tree
Date: Tue, 14 Aug 2007 12:14:58 -0700
Message-ID: <200708141914.l7EJEwoE016669@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42462 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765162AbXHNTUh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:20:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: travis@sgi.com, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     x86_64: remove x86_cpu_to_log_apicid
has been removed from the -mm tree.  Its filename was
     x86_64-remove-x86_cpu_to_log_apicid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: remove x86_cpu_to_log_apicid
From: Mike Travis <travis@sgi.com>

Remove the x86_cpu_to_log_apicid array.  It is set in
arch/x86_64/kernel/genapic_flat.c:flat_init_apic_ldr() and
arch/x86_64/kernel/smpboot.c:do_boot_cpu() but it is never
referenced.

Signed-off-by: Mike Travis <travis@sgi.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/genapic.c      |    2 --
 arch/x86_64/kernel/genapic_flat.c |    1 -
 arch/x86_64/kernel/smpboot.c      |    1 -
 include/asm-x86_64/smp.h          |    1 -
 4 files changed, 5 deletions(-)

diff -puN arch/x86_64/kernel/genapic.c~x86_64-remove-x86_cpu_to_log_apicid arch/x86_64/kernel/genapic.c
--- a/arch/x86_64/kernel/genapic.c~x86_64-remove-x86_cpu_to_log_apicid
+++ a/arch/x86_64/kernel/genapic.c
@@ -29,8 +29,6 @@ u8 x86_cpu_to_apicid[NR_CPUS] __read_mos
 					= { [0 ... NR_CPUS-1] = BAD_APICID };
 EXPORT_SYMBOL(x86_cpu_to_apicid);
 
-u8 x86_cpu_to_log_apicid[NR_CPUS]	= { [0 ... NR_CPUS-1] = BAD_APICID };
-
 struct genapic __read_mostly *genapic = &apic_flat;
 
 /*
diff -puN arch/x86_64/kernel/genapic_flat.c~x86_64-remove-x86_cpu_to_log_apicid arch/x86_64/kernel/genapic_flat.c
--- a/arch/x86_64/kernel/genapic_flat.c~x86_64-remove-x86_cpu_to_log_apicid
+++ a/arch/x86_64/kernel/genapic_flat.c
@@ -52,7 +52,6 @@ static void flat_init_apic_ldr(void)
 
 	num = smp_processor_id();
 	id = 1UL << num;
-	x86_cpu_to_log_apicid[num] = id;
 	apic_write(APIC_DFR, APIC_DFR_FLAT);
 	val = apic_read(APIC_LDR) & ~APIC_LDR_MASK;
 	val |= SET_APIC_LOGICAL_ID(id);
diff -puN arch/x86_64/kernel/smpboot.c~x86_64-remove-x86_cpu_to_log_apicid arch/x86_64/kernel/smpboot.c
--- a/arch/x86_64/kernel/smpboot.c~x86_64-remove-x86_cpu_to_log_apicid
+++ a/arch/x86_64/kernel/smpboot.c
@@ -702,7 +702,6 @@ do_rest:
 		cpu_clear(cpu, cpu_present_map);
 		cpu_clear(cpu, cpu_possible_map);
 		x86_cpu_to_apicid[cpu] = BAD_APICID;
-		x86_cpu_to_log_apicid[cpu] = BAD_APICID;
 		return -EIO;
 	}
 
diff -puN include/asm-x86_64/smp.h~x86_64-remove-x86_cpu_to_log_apicid include/asm-x86_64/smp.h
--- a/include/asm-x86_64/smp.h~x86_64-remove-x86_cpu_to_log_apicid
+++ a/include/asm-x86_64/smp.h
@@ -78,7 +78,6 @@ static inline int hard_smp_processor_id(
  * the real APIC ID <-> CPU # mapping.
  */
 extern u8 x86_cpu_to_apicid[NR_CPUS];	/* physical ID */
-extern u8 x86_cpu_to_log_apicid[NR_CPUS];
 extern u8 bios_cpu_apicid[];
 
 static inline int cpu_present_to_apicid(int mps_cpu)
_

Patches currently in -mm which might be from travis@sgi.com are
