From: akpm@linux-foundation.org
Subject: - x86-msr-add-support-for-safe-variants.patch removed from -mm tree
Date: Tue, 08 May 2007 20:04:00 -0700
Message-ID: <200705090304.l49340Zr011003@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56951 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1033435AbXEIDEd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:04:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: r.marek@assembler.cz, adobriyan@openvz.org, ak@suse.de, davej@redhat.com, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     x86: MSR: add support for safe variants
has been removed from the -mm tree.  Its filename was
     x86-msr-add-support-for-safe-variants.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86: MSR: add support for safe variants
From: Rudolf Marek <r.marek@assembler.cz>

Add safe (exception handled) variants of rdmsr_on_cpu and wrmsr_on_cpu. 
You should use these when the target MSR may not actually exist, as doing
so could trigger an exception which the regular functions do not handle. 
The safe variants are slower, though.

The upcoming coretemp hardware monitoring driver will need this.

Signed-off-by: Rudolf Marek <r.marek@assembler.cz>
Cc: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Dave Jones <davej@redhat.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/lib/msr-on-cpu.c |   73 ++++++++++++++++++++++++++++++++---
 include/asm-i386/msr.h     |   12 +++++
 include/asm-x86_64/msr.h   |   11 +++++
 3 files changed, 89 insertions(+), 7 deletions(-)

diff -puN arch/i386/lib/msr-on-cpu.c~x86-msr-add-support-for-safe-variants arch/i386/lib/msr-on-cpu.c
--- a/arch/i386/lib/msr-on-cpu.c~x86-msr-add-support-for-safe-variants
+++ a/arch/i386/lib/msr-on-cpu.c
@@ -6,6 +6,7 @@
 struct msr_info {
 	u32 msr_no;
 	u32 l, h;
+	int err;
 };
 
 static void __rdmsr_on_cpu(void *info)
@@ -15,20 +16,38 @@ static void __rdmsr_on_cpu(void *info)
 	rdmsr(rv->msr_no, rv->l, rv->h);
 }
 
-void rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
+static void __rdmsr_safe_on_cpu(void *info)
 {
+	struct msr_info *rv = info;
+
+	rv->err = rdmsr_safe(rv->msr_no, &rv->l, &rv->h);
+}
+
+static int _rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h, int safe)
+{
+	int err = 0;
 	preempt_disable();
 	if (smp_processor_id() == cpu)
-		rdmsr(msr_no, *l, *h);
+		if (safe)
+			err = rdmsr_safe(msr_no, l, h);
+		else
+			rdmsr(msr_no, *l, *h);
 	else {
 		struct msr_info rv;
 
 		rv.msr_no = msr_no;
-		smp_call_function_single(cpu, __rdmsr_on_cpu, &rv, 0, 1);
+		if (safe) {
+			smp_call_function_single(cpu, __rdmsr_safe_on_cpu,
+						 &rv, 0, 1);
+			err = rv.err;
+		} else {
+			smp_call_function_single(cpu, __rdmsr_on_cpu, &rv, 0, 1);
+		}
 		*l = rv.l;
 		*h = rv.h;
 	}
 	preempt_enable();
+	return err;
 }
 
 static void __wrmsr_on_cpu(void *info)
@@ -38,21 +57,63 @@ static void __wrmsr_on_cpu(void *info)
 	wrmsr(rv->msr_no, rv->l, rv->h);
 }
 
-void wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
+static void __wrmsr_safe_on_cpu(void *info)
 {
+	struct msr_info *rv = info;
+
+	rv->err = wrmsr_safe(rv->msr_no, rv->l, rv->h);
+}
+
+static int _wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h, int safe)
+{
+	int err = 0;
 	preempt_disable();
 	if (smp_processor_id() == cpu)
-		wrmsr(msr_no, l, h);
+		if (safe)
+			err = wrmsr_safe(msr_no, l, h);
+		else
+			wrmsr(msr_no, l, h);
 	else {
 		struct msr_info rv;
 
 		rv.msr_no = msr_no;
 		rv.l = l;
 		rv.h = h;
-		smp_call_function_single(cpu, __wrmsr_on_cpu, &rv, 0, 1);
+		if (safe) {
+			smp_call_function_single(cpu, __wrmsr_safe_on_cpu,
+						 &rv, 0, 1);
+			err = rv.err;
+		} else {
+			smp_call_function_single(cpu, __wrmsr_on_cpu, &rv, 0, 1);
+		}
 	}
 	preempt_enable();
+	return err;
+}
+
+void wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
+{
+	_wrmsr_on_cpu(cpu, msr_no, l, h, 0);
+}
+
+void rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
+{
+	_rdmsr_on_cpu(cpu, msr_no, l, h, 0);
+}
+
+/* These "safe" variants are slower and should be used when the target MSR
+   may not actually exist. */
+int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
+{
+	return _wrmsr_on_cpu(cpu, msr_no, l, h, 1);
+}
+
+int rdmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
+{
+	return _rdmsr_on_cpu(cpu, msr_no, l, h, 1);
 }
 
 EXPORT_SYMBOL(rdmsr_on_cpu);
 EXPORT_SYMBOL(wrmsr_on_cpu);
+EXPORT_SYMBOL(rdmsr_safe_on_cpu);
+EXPORT_SYMBOL(wrmsr_safe_on_cpu);
diff -puN include/asm-i386/msr.h~x86-msr-add-support-for-safe-variants include/asm-i386/msr.h
--- a/include/asm-i386/msr.h~x86-msr-add-support-for-safe-variants
+++ a/include/asm-i386/msr.h
@@ -77,7 +77,7 @@ static inline unsigned long long native_
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
 #else
-
+#include <linux/errno.h>
 /*
  * Access to machine-specific registers (available on 586 and better only)
  * Note: the rd* operations modify the parameters directly (without using
@@ -148,6 +148,8 @@ static inline void wrmsrl (unsigned long
 #ifdef CONFIG_SMP
 void rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
 void wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
+int rdmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
+int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
 #else  /*  CONFIG_SMP  */
 static inline void rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
 {
@@ -157,6 +159,14 @@ static inline void wrmsr_on_cpu(unsigned
 {
 	wrmsr(msr_no, l, h);
 }
+static inline int rdmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
+{
+	return rdmsr_safe(msr_no, l, h);
+}
+static inline int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
+{
+	return wrmsr_safe(msr_no, l, h);
+}
 #endif  /*  CONFIG_SMP  */
 #endif
 #endif
diff -puN include/asm-x86_64/msr.h~x86-msr-add-support-for-safe-variants include/asm-x86_64/msr.h
--- a/include/asm-x86_64/msr.h~x86-msr-add-support-for-safe-variants
+++ a/include/asm-x86_64/msr.h
@@ -4,6 +4,7 @@
 #include <asm/msr-index.h>
 
 #ifndef __ASSEMBLY__
+#include <linux/errno.h>
 /*
  * Access to machine-specific registers (available on 586 and better only)
  * Note: the rd* operations modify the parameters directly (without using
@@ -162,6 +163,8 @@ static inline unsigned int cpuid_edx(uns
 #ifdef CONFIG_SMP
 void rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
 void wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
+int rdmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
+int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
 #else  /*  CONFIG_SMP  */
 static inline void rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
 {
@@ -171,6 +174,14 @@ static inline void wrmsr_on_cpu(unsigned
 {
 	wrmsr(msr_no, l, h);
 }
+static inline int rdmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
+{
+	return rdmsr_safe(msr_no, l, h);
+}
+static inline int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
+{
+	return wrmsr_safe(msr_no, l, h);
+}
 #endif  /* CONFIG_SMP */
 #endif /* __ASSEMBLY__ */
 #endif	/* X86_64_MSR_H */
_

Patches currently in -mm which might be from r.marek@assembler.cz are

origin.patch
