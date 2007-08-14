From: akpm@linux-foundation.org
Subject: - x86_64-remove-never-used-apic_mapped.patch removed from -mm tree
Date: Tue, 14 Aug 2007 12:14:21 -0700
Message-ID: <200708141914.l7EJELtJ016608@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42495 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933681AbXHNTVJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:21:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yhlu.kernel@gmail.com, ak@suse.de, clameter@sgi.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     x86_64: remove never used apic_mapped
has been removed from the -mm tree.  Its filename was
     x86_64-remove-never-used-apic_mapped.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: remove never used apic_mapped
From: "Yinghai Lu" <yhlu.kernel@gmail.com>

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/apic.c |    5 ++---
 include/asm-x86_64/apic.h |    1 -
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN arch/x86_64/kernel/apic.c~x86_64-remove-never-used-apic_mapped arch/x86_64/kernel/apic.c
--- a/arch/x86_64/kernel/apic.c~x86_64-remove-never-used-apic_mapped
+++ a/arch/x86_64/kernel/apic.c
@@ -39,7 +39,6 @@
 #include <asm/hpet.h>
 #include <asm/apic.h>
 
-int apic_mapped;
 int apic_verbosity;
 int apic_runs_main_timer;
 int apic_calibrate_pmtmr __initdata;
@@ -706,8 +705,8 @@ void __init init_apic_mappings(void)
 		apic_phys = mp_lapic_addr;
 
 	set_fixmap_nocache(FIX_APIC_BASE, apic_phys);
-	apic_mapped = 1;
-	apic_printk(APIC_VERBOSE,"mapped APIC to %16lx (%16lx)\n", APIC_BASE, apic_phys);
+	apic_printk(APIC_VERBOSE, "mapped APIC to %16lx (%16lx)\n",
+				APIC_BASE, apic_phys);
 
 	/* Put local APIC into the resource map. */
 	lapic_resource.start = apic_phys;
diff -puN include/asm-x86_64/apic.h~x86_64-remove-never-used-apic_mapped include/asm-x86_64/apic.h
--- a/include/asm-x86_64/apic.h~x86_64-remove-never-used-apic_mapped
+++ a/include/asm-x86_64/apic.h
@@ -19,7 +19,6 @@
 extern int apic_verbosity;
 extern int apic_runs_main_timer;
 extern int ioapic_force;
-extern int apic_mapped;
 
 /*
  * Define the default level of output to be very little
_

Patches currently in -mm which might be from yhlu.kernel@gmail.com are

x86_64-get-boot_cpu_id-as-early-for-k8_scan_nodes.patch
