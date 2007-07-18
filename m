From: akpm@linux-foundation.org
Subject: + cell-saving-spus-information-for-kexec-crash.patch added to -mm tree
Date: Wed, 18 Jul 2007 12:52:12 -0700
Message-ID: <200707181952.l6IJqCxC025940@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38585 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755702AbXGRTwo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 15:52:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adetsch@br.ibm.com, arnd.bergmann@de.ibm.com, luciojhc@br.ibm.com


The patch titled
     cell: saving spus information for kexec crash
has been added to the -mm tree.  Its filename is
     cell-saving-spus-information-for-kexec-crash.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cell: saving spus information for kexec crash
From: Andre Detsch <adetsch@br.ibm.com>

This patch adds support for investigating spus information after a kernel
crash event, through kdump vmcore file.  Implementation is based on xmon code,
but the new functionality was kept independent from xmon.

Signed-off-by: Lucio Jose Herculano Correia <luciojhc@br.ibm.com>
Signed-off-by: Andre Detsch <adetsch@br.ibm.com>
Signed-off-by: Arnd Bergmann <arnd.bergmann@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/crash.c            |   67 +++++++++++++++++++++++
 arch/powerpc/platforms/cell/spu_base.c |    3 +
 include/asm-powerpc/spu.h              |    4 +
 3 files changed, 74 insertions(+)

diff -puN arch/powerpc/kernel/crash.c~cell-saving-spus-information-for-kexec-crash arch/powerpc/kernel/crash.c
--- a/arch/powerpc/kernel/crash.c~cell-saving-spus-information-for-kexec-crash
+++ a/arch/powerpc/kernel/crash.c
@@ -219,6 +219,70 @@ void crash_kexec_secondary(struct pt_reg
 	cpus_in_sr = CPU_MASK_NONE;
 }
 #endif
+#ifdef CONFIG_SPU_BASE
+
+#include <asm/spu.h>
+#include <asm/spu_priv1.h>
+
+struct crash_spu_info {
+	struct spu *spu;
+	u32 saved_spu_runcntl_RW;
+	u32 saved_spu_status_R;
+	u32 saved_spu_npc_RW;
+	u64 saved_mfc_sr1_RW;
+	u64 saved_mfc_dar;
+	u64 saved_mfc_dsisr;
+};
+
+#define CRASH_NUM_SPUS	16	/* Enough for current hardware */
+static struct crash_spu_info crash_spu_info[CRASH_NUM_SPUS];
+
+static void crash_kexec_stop_spus(void)
+{
+	struct spu *spu;
+	int i;
+	u64 tmp;
+
+	for (i = 0; i < CRASH_NUM_SPUS; i++) {
+		if (!crash_spu_info[i].spu)
+			continue;
+
+		spu = crash_spu_info[i].spu;
+
+		crash_spu_info[i].saved_spu_runcntl_RW =
+			in_be32(&spu->problem->spu_runcntl_RW);
+		crash_spu_info[i].saved_spu_status_R =
+			in_be32(&spu->problem->spu_status_R);
+		crash_spu_info[i].saved_spu_npc_RW =
+			in_be32(&spu->problem->spu_npc_RW);
+
+		crash_spu_info[i].saved_mfc_dar    = spu_mfc_dar_get(spu);
+		crash_spu_info[i].saved_mfc_dsisr  = spu_mfc_dsisr_get(spu);
+		tmp = spu_mfc_sr1_get(spu);
+		crash_spu_info[i].saved_mfc_sr1_RW = tmp;
+
+		tmp &= ~MFC_STATE1_MASTER_RUN_CONTROL_MASK;
+		spu_mfc_sr1_set(spu, tmp);
+
+		__delay(200);
+	}
+}
+
+void crash_register_spus(struct list_head *list)
+{
+	struct spu *spu;
+
+	list_for_each_entry(spu, list, full_list) {
+		if (spu->number >= CRASH_NUM_SPUS) {
+			WARN_ON(1);
+			continue;
+		}
+
+		crash_spu_info[spu->number].spu = spu;
+	}
+}
+
+#endif /* CONFIG_SPU_BASE */
 
 void default_machine_crash_shutdown(struct pt_regs *regs)
 {
@@ -254,6 +318,9 @@ void default_machine_crash_shutdown(stru
 	crash_save_cpu(regs, crashing_cpu);
 	crash_kexec_prepare_cpus(crashing_cpu);
 	cpu_set(crashing_cpu, cpus_in_crash);
+#ifdef CONFIG_SPU_BASE
+	crash_kexec_stop_spus();
+#endif
 	if (ppc_md.kexec_cpu_down)
 		ppc_md.kexec_cpu_down(1, 0);
 }
diff -puN arch/powerpc/platforms/cell/spu_base.c~cell-saving-spus-information-for-kexec-crash arch/powerpc/platforms/cell/spu_base.c
--- a/arch/powerpc/platforms/cell/spu_base.c~cell-saving-spus-information-for-kexec-crash
+++ a/arch/powerpc/platforms/cell/spu_base.c
@@ -676,6 +676,9 @@ static int __init init_spu_base(void)
 	}
 
 	xmon_register_spus(&spu_full_list);
+#ifdef CONFIG_KEXEC
+	crash_register_spus(&spu_full_list);
+#endif
 
 	spu_add_sysdev_attr(&attr_stat);
 
diff -puN include/asm-powerpc/spu.h~cell-saving-spus-information-for-kexec-crash include/asm-powerpc/spu.h
--- a/include/asm-powerpc/spu.h~cell-saving-spus-information-for-kexec-crash
+++ a/include/asm-powerpc/spu.h
@@ -188,6 +188,10 @@ int spu_irq_class_0_bottom(struct spu *s
 int spu_irq_class_1_bottom(struct spu *spu);
 void spu_irq_setaffinity(struct spu *spu, int cpu);
 
+#ifdef CONFIG_KEXEC
+void crash_register_spus(struct list_head *list);
+#endif
+
 extern void spu_invalidate_slbs(struct spu *spu);
 extern void spu_associate_mm(struct spu *spu, struct mm_struct *mm);
 
_

Patches currently in -mm which might be from adetsch@br.ibm.com are

cell-saving-spus-information-for-kexec-crash.patch
