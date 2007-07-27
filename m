From: akpm@linux-foundation.org
Subject: + x86_64-remove-never-used-apic_mapped.patch added to -mm tree
Date: Thu, 26 Jul 2007 23:37:35 -0700
Message-ID: <200707270637.l6R6bZE2009773@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33553 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753846AbXG0Ghw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Jul 2007 02:37:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yhlu.kernel@gmail.com, ak@suse.de, clameter@sgi.com, lenb@kernel.org


The patch titled
     x86_64: remove never used apic_mapped
has been added to the -mm tree.  Its filename is
     x86_64-remove-never-used-apic_mapped.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

x86_64-get-mp_bus_to_node-as-early-v2.patch
x86_64-use-bus-conf-in-nb-conf-fun1-to-get-bus-range-on-node.patch
try-parent-numa_node-at-first-before-using-default-v2.patch
net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
x86_64-store-core-id-bits-in-cpuinfo_x8.patch
x86_64-use-core-id-bits-for-apicid_to_node-initialization.patch
x86_64-remove-never-used-apic_mapped.patch
x86_64-get-boot_cpu_id-as-early-for-k8_scan_nodes.patch
