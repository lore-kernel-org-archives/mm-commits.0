From: akpm@linux-foundation.org
Subject: + x86_64-set-the-irq_chip-name-for-lapic.patch added to -mm tree
Date: Mon, 25 Jun 2007 15:39:36 -0700
Message-ID: <200706252239.l5PMdaSV012747@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34395 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751851AbXFYWkF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 18:40:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: suresh.b.siddha@intel.com, ak@suse.de, akpm@linux-foundation.org, rjw@sisk.pl


The patch titled
     x86_64: set the irq_chip name for lapic
has been added to the -mm tree.  Its filename is
     x86_64-set-the-irq_chip-name-for-lapic.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: set the irq_chip name for lapic
From: Suresh Siddha <suresh.b.siddha@intel.com>

/proc/interrupts:

            CPU0       CPU1
   0:    6343294          0    <NULL>-edge      timer

Set the irq_chip name for lapic.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/io_apic.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN arch/x86_64/kernel/io_apic.c~x86_64-set-the-irq_chip-name-for-lapic arch/x86_64/kernel/io_apic.c
--- a/arch/x86_64/kernel/io_apic.c~x86_64-set-the-irq_chip-name-for-lapic
+++ a/arch/x86_64/kernel/io_apic.c
@@ -1546,6 +1546,7 @@ static void ack_lapic_irq (unsigned int 
 static void end_lapic_irq (unsigned int i) { /* nothing */ }
 
 static struct hw_interrupt_type lapic_irq_type __read_mostly = {
+	.name = "local-APIC",
 	.typename = "local-APIC-edge",
 	.startup = NULL, /* startup_irq() not used for IRQ0 */
 	.shutdown = NULL, /* shutdown_irq() not used for IRQ0 */
_

Patches currently in -mm which might be from suresh.b.siddha@intel.com are

x86_64-set-the-irq_chip-name-for-lapic.patch
x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3.patch
