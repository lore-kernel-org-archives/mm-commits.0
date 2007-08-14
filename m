From: akpm@linux-foundation.org
Subject: - cpuid-driver-simplify-smp_call_function_single-call-sequence.patch removed from -mm tree
Date: Tue, 14 Aug 2007 12:14:13 -0700
Message-ID: <200708141914.l7EJEDEF016596@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49039 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932375AbXHNTUs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:20:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, ak@suse.de, hpa@zytor.com, mm-commits@vger.kernel.org


The patch titled
     cpuid driver: implify smp_call_function_single() call sequence
has been removed from the -mm tree.  Its filename was
     cpuid-driver-simplify-smp_call_function_single-call-sequence.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-kvm.patch
time-simplify-smp_call_function_single-call-sequence.patch
