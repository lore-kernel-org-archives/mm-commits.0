From: akpm@linux-foundation.org
Subject: + x86-apic-ack-all-pending-irqs-when-crashed-on-kexec-v5.patch added to -mm tree
Date: Thu, 18 Mar 2010 13:57:06 -0700
Message-ID: <201003182057.o2IKv6PK015217@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35067 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751346Ab0CRU6L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Mar 2010 16:58:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kerstin.jonsson@ericsson.com, avi@redhat.com, ebiederm@xmission.com, hpa@zytor.com, jbohac@novell.com, mingo@elte.hu, tglx@linutronix.de, trenn@suse.de, yinghai@kernel.org


The patch titled
     x86 apic: ack all pending irqs when crashed/on kexec
has been added to the -mm tree.  Its filename is
     x86-apic-ack-all-pending-irqs-when-crashed-on-kexec-v5.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86 apic: ack all pending irqs when crashed/on kexec
From: Kerstin Jonsson <kerstin.jonsson@ericsson.com>

When the SMP kernel decides to crash_kexec() the local APICs may have
pending interrupts in their vector tables.

The setup routine for the local APIC has a deficient mechanism for
clearing these interrupts, it only handles interrupts that has already
been dispatched to the local core for servicing (the ISR register) safely,
it doesn't consider lower prioritized queued interrupts stored in the IRR
register.

If you have more than one pending interrupt within the same 32 bit word in
the LAPIC vector table registers you may find yourself entering the IO
APIC setup with pending interrupts left in the LAPIC.  This is a situation
for wich the IO APIC setup is not prepared.  Depending of what/which
interrupt vector/vectors are stuck in the APIC tables your system may show
various degrees of malfunctioning.  That was the reason why the
check_timer() failed in our system, the timer interrupts was blocked by
pending interrupts from the old kernel when routed trough the IO APIC.

Additional comment from Jiri Bohac:
==============
If this should go into stable release,
I'd add some kind of limit on the number of iterations, just to be safe from
hard to debug lock-ups:

+if (loops++  > MAX_LOOPS) {
+        printk("LAPIC pending clean-up")
+        break;
+}
 while (queued);

with MAX_LOOPS something like 1E9 this would leave plenty of time for the
pending IRQs to be cleared and would and still cause at most a second of delay
if the loop were to lock-up for whatever reason.

[trenn@suse.de:

V2: Use tsc if avail to bail out after 1 sec due to possible virtual
    apic_read calls which may take rather long (suggested by: Avi Kivity
    <avi@redhat.com>) If no tsc is available bail out quickly after
    cpu_khz, if we broke out too early and still have irqs pending (which
    should never happen?) we still get a WARN_ON...

V3: - Fixed indentation -> checkpatch clean
    - max_loops must be signed

V4: - Fix typo, mixed up tsc and ntsc in first rdtscll() call

V5: Adjust WARN_ON() condition to also catch error in cpu_has_tsc case]

Cc: <jbohac@novell.com>
Cc: "Yinghai Lu" <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Kerstin Jonsson" <kerstin.jonsson@ericsson.com>
Cc: "Avi Kivity" <avi@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Thomas Renninger <trenn@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/apic/apic.c |   41 +++++++++++++++++++++++++++-------
 1 file changed, 33 insertions(+), 8 deletions(-)

diff -puN arch/x86/kernel/apic/apic.c~x86-apic-ack-all-pending-irqs-when-crashed-on-kexec-v5 arch/x86/kernel/apic/apic.c
--- a/arch/x86/kernel/apic/apic.c~x86-apic-ack-all-pending-irqs-when-crashed-on-kexec-v5
+++ a/arch/x86/kernel/apic/apic.c
@@ -51,6 +51,7 @@
 #include <asm/smp.h>
 #include <asm/mce.h>
 #include <asm/kvm_para.h>
+#include <asm/tsc.h>
 
 unsigned int num_processors;
 
@@ -1151,8 +1152,13 @@ static void __cpuinit lapic_setup_esr(vo
  */
 void __cpuinit setup_local_APIC(void)
 {
-	unsigned int value;
-	int i, j;
+	unsigned int value, queued;
+	int i, j, acked = 0;
+	unsigned long long tsc = 0, ntsc;
+	long long max_loops = cpu_khz;
+
+	if (cpu_has_tsc)
+		rdtscll(tsc);
 
 	if (disable_apic) {
 		arch_disable_smp_support();
@@ -1204,13 +1210,32 @@ void __cpuinit setup_local_APIC(void)
 	 * the interrupt. Hence a vector might get locked. It was noticed
 	 * for timer irq (vector 0x31). Issue an extra EOI to clear ISR.
 	 */
-	for (i = APIC_ISR_NR - 1; i >= 0; i--) {
-		value = apic_read(APIC_ISR + i*0x10);
-		for (j = 31; j >= 0; j--) {
-			if (value & (1<<j))
-				ack_APIC_irq();
+	do {
+		queued = 0;
+		for (i = APIC_ISR_NR - 1; i >= 0; i--)
+			queued |= apic_read(APIC_IRR + i*0x10);
+
+		for (i = APIC_ISR_NR - 1; i >= 0; i--) {
+			value = apic_read(APIC_ISR + i*0x10);
+			for (j = 31; j >= 0; j--) {
+				if (value & (1<<j)) {
+					ack_APIC_irq();
+					acked++;
+				}
+			}
 		}
-	}
+		if (acked > 256) {
+			printk(KERN_ERR "LAPIC pending interrupts after %d EOI\n",
+			       acked);
+			break;
+		}
+		if (cpu_has_tsc) {
+			rdtscll(ntsc);
+			max_loops = (cpu_khz << 10) - (ntsc - tsc);
+		} else
+			max_loops--;
+	} while (queued && max_loops > 0);
+	WARN_ON(max_loops <= 0);
 
 	/*
 	 * Now that we are all set up, enable the APIC
_

Patches currently in -mm which might be from kerstin.jonsson@ericsson.com are

x86-apic-ack-all-pending-irqs-when-crashed-on-kexec-v5.patch

