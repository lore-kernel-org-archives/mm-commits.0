From: akpm@linux-foundation.org
Subject: - x86_64-remove-sync_arb_ids.patch removed from -mm tree
Date: Tue, 14 Aug 2007 12:14:50 -0700
Message-ID: <200708141914.l7EJEoAD016654@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52346 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933061AbXHNTVC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:21:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Yinghai.Lu@sun.com, ak@suse.de, ebiederm@xmission.com, yinghai.lu@sun.com, mm-commits@vger.kernel.org


The patch titled
     x86_64: remove sync_Arb_IDs
has been removed from the -mm tree.  Its filename was
     x86_64-remove-sync_arb_ids.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: remove sync_Arb_IDs
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

i386 code said
       /*
        * Unsupported on P4 - see Intel Dev. Manual Vol. 3, Ch. 8.6.1 And not
        * needed on AMD.
        */
So we don't need sync_Arb_IDs for x86_64...

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/apic.c    |   17 -----------------
 arch/x86_64/kernel/io_apic.c |    1 -
 2 files changed, 18 deletions(-)

diff -puN arch/x86_64/kernel/apic.c~x86_64-remove-sync_arb_ids arch/x86_64/kernel/apic.c
--- a/arch/x86_64/kernel/apic.c~x86_64-remove-sync_arb_ids
+++ a/arch/x86_64/kernel/apic.c
@@ -282,23 +282,6 @@ int __init verify_local_APIC(void)
 	return 1;
 }
 
-void __init sync_Arb_IDs(void)
-{
-	/* Unsupported on P4 - see Intel Dev. Manual Vol. 3, Ch. 8.6.1 */
-	unsigned int ver = GET_APIC_VERSION(apic_read(APIC_LVR));
-	if (ver >= 0x14)	/* P4 or higher */
-		return;
-
-	/*
-	 * Wait for idle.
-	 */
-	apic_wait_icr_idle();
-
-	apic_printk(APIC_DEBUG, "Synchronizing Arb IDs.\n");
-	apic_write(APIC_ICR, APIC_DEST_ALLINC | APIC_INT_LEVELTRIG
-				| APIC_DM_INIT);
-}
-
 /*
  * An initial setup of the virtual wire mode.
  */
diff -puN arch/x86_64/kernel/io_apic.c~x86_64-remove-sync_arb_ids arch/x86_64/kernel/io_apic.c
--- a/arch/x86_64/kernel/io_apic.c~x86_64-remove-sync_arb_ids
+++ a/arch/x86_64/kernel/io_apic.c
@@ -1783,7 +1783,6 @@ void __init setup_IO_APIC(void)
 
 	apic_printk(APIC_VERBOSE, "ENABLING IO-APIC IRQs\n");
 
-	sync_Arb_IDs();
 	setup_IO_APIC_irqs();
 	init_IO_APIC_traps();
 	check_timer();
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

x86_64-get-mp_bus_to_node-as-early-v3.patch
x86_64-use-bus-conf-in-nb-conf-fun1-to-get-bus-range-on-node.patch
try-parent-numa_node-at-first-before-using-default.patch
net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
