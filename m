From: akpm@linux-foundation.org
Subject: + cpuid-driver-simplify-smp_call_function_single-call-sequence.patch added to -mm tree
Date: Mon, 23 Jul 2007 16:36:26 -0700
Message-ID: <200707232336.l6NNaQkI017828@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58610 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759124AbXGWXgi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 19:36:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com, ak@suse.de, hpa@zytor.com


The patch titled
     cpuid driver: implify smp_call_function_single() call sequence
has been added to the -mm tree.  Its filename is
     cpuid-driver-simplify-smp_call_function_single-call-sequence.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cpuid driver: implify smp_call_function_single() call sequence
From: Avi Kivity <avi@qumranet.com>

smp_call_function_single() now knows how to call the function on the
current cpu.

Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpuid.c |   22 +++-------------------
 1 files changed, 3 insertions(+), 19 deletions(-)

diff -puN arch/i386/kernel/cpuid.c~cpuid-driver-simplify-smp_call_function_single-call-sequence arch/i386/kernel/cpuid.c
--- a/arch/i386/kernel/cpuid.c~cpuid-driver-simplify-smp_call_function_single-call-sequence
+++ a/arch/i386/kernel/cpuid.c
@@ -45,8 +45,6 @@
 
 static struct class *cpuid_class;
 
-#ifdef CONFIG_SMP
-
 struct cpuid_command {
 	u32 reg;
 	u32 *data;
@@ -64,25 +62,11 @@ static inline void do_cpuid(int cpu, u32
 {
 	struct cpuid_command cmd;
 
-	preempt_disable();
-	if (cpu == smp_processor_id()) {
-		cpuid(reg, &data[0], &data[1], &data[2], &data[3]);
-	} else {
-		cmd.reg = reg;
-		cmd.data = data;
+	cmd.reg = reg;
+	cmd.data = data;
 
-		smp_call_function_single(cpu, cpuid_smp_cpuid, &cmd, 1, 1);
-	}
-	preempt_enable();
+	smp_call_function_single(cpu, cpuid_smp_cpuid, &cmd, 1, 1);
 }
-#else				/* ! CONFIG_SMP */
-
-static inline void do_cpuid(int cpu, u32 reg, u32 * data)
-{
-	cpuid(reg, &data[0], &data[1], &data[2], &data[3]);
-}
-
-#endif				/* ! CONFIG_SMP */
 
 static loff_t cpuid_seek(struct file *file, loff_t offset, int orig)
 {
_

Patches currently in -mm which might be from avi@qumranet.com are

ia64-allow-smp_call_function_single-to-current-cpu.patch
git-kvm.patch
cpuid-driver-simplify-smp_call_function_single-call-sequence.patch
msr-driver-simplify-smp_call_function_single-call-sequence.patch
time-simplify-smp_call_function_single-call-sequence.patch
