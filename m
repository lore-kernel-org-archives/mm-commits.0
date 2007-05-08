From: akpm@linux-foundation.org
Subject: + sn-validate-smp_affinity-mask-on-intr-redirect.patch added to -mm tree
Date: Tue, 08 May 2007 12:20:52 -0700
Message-ID: <200705081920.l48JKr0A031503@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44452 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031535AbXEHTVD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 15:21:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jpk@sgi.com, tony.luck@intel.com


The patch titled
     SN: validate smp_affinity mask on intr redirect
has been added to the -mm tree.  Its filename is
     sn-validate-smp_affinity-mask-on-intr-redirect.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SN: validate smp_affinity mask on intr redirect
From: John Keller <jpk@sgi.com>

On SN, only allow one bit to be set in the smp_affinty mask when
redirecting an interrupt.  Currently setting multiple bits is allowed, but
only the first bit is used in determining the CPU to redirect to.  This has
caused confusion among some customers.

Signed-off-by: John Keller <jpk@sgi.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/irq.c |   11 +++++++++++
 include/asm-ia64/irq.h |    2 ++
 kernel/irq/proc.c      |    7 +++++++
 3 files changed, 20 insertions(+)

diff -puN arch/ia64/kernel/irq.c~sn-validate-smp_affinity-mask-on-intr-redirect arch/ia64/kernel/irq.c
--- a/arch/ia64/kernel/irq.c~sn-validate-smp_affinity-mask-on-intr-redirect
+++ a/arch/ia64/kernel/irq.c
@@ -104,6 +104,17 @@ void set_irq_affinity_info (unsigned int
 		irq_redir[irq] = (char) (redir & 0xff);
 	}
 }
+
+bool is_affinity_mask_valid(cpumask_t cpumask)
+{
+	if (ia64_platform_is("sn2")) {
+		/* Only allow one CPU to be specified in the smp_affinity mask */
+		if (cpus_weight(cpumask) != 1)
+			return false;
+	}
+	return true;
+}
+
 #endif /* CONFIG_SMP */
 
 #ifdef CONFIG_HOTPLUG_CPU
diff -puN include/asm-ia64/irq.h~sn-validate-smp_affinity-mask-on-intr-redirect include/asm-ia64/irq.h
--- a/include/asm-ia64/irq.h~sn-validate-smp_affinity-mask-on-intr-redirect
+++ a/include/asm-ia64/irq.h
@@ -30,4 +30,6 @@ extern void disable_irq_nosync (unsigned
 extern void enable_irq (unsigned int);
 extern void set_irq_affinity_info (unsigned int irq, int dest, int redir);
 
+#define is_affinity_mask_valid is_affinity_mask_valid
+
 #endif /* _ASM_IA64_IRQ_H */
diff -puN kernel/irq/proc.c~sn-validate-smp_affinity-mask-on-intr-redirect kernel/irq/proc.c
--- a/kernel/irq/proc.c~sn-validate-smp_affinity-mask-on-intr-redirect
+++ a/kernel/irq/proc.c
@@ -27,6 +27,10 @@ static int irq_affinity_read_proc(char *
 	return len;
 }
 
+#ifndef is_affinity_mask_valid
+#define is_affinity_mask_valid() 1
+#endif
+
 int no_irq_affinity;
 static int irq_affinity_write_proc(struct file *file, const char __user *buffer,
 				   unsigned long count, void *data)
@@ -42,6 +46,9 @@ static int irq_affinity_write_proc(struc
 	if (err)
 		return err;
 
+	if (!is_affinity_mask_valid(new_value))
+		return -EINVAL;
+
 	/*
 	 * Do not allow disabling IRQs completely - it's a too easy
 	 * way to make the system unusable accidentally :-) At least
_

Patches currently in -mm which might be from jpk@sgi.com are

sn-validate-smp_affinity-mask-on-intr-redirect.patch
sn-validate-smp_affinity-mask-on-intr-redirect-fix.patch
