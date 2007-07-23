From: akpm@linux-foundation.org
Subject: + msr-driver-simplify-smp_call_function_single-call-sequence.patch added to -mm tree
Date: Mon, 23 Jul 2007 16:36:28 -0700
Message-ID: <200707232336.l6NNaS1U017831@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44079 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759259AbXGWXgi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 19:36:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com, ak@suse.de, hpa@zytor.com


The patch titled
     msr driver: simplify smp_call_function_single() call sequence
has been added to the -mm tree.  Its filename is
     msr-driver-simplify-smp_call_function_single-call-sequence.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: msr driver: simplify smp_call_function_single() call sequence
From: Avi Kivity <avi@qumranet.com>

smp_call_function_single() now knows how to call the function on the
current cpu.

Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/lib/msr-on-cpu.c |   62 ++++++++++++-----------------------
 1 files changed, 22 insertions(+), 40 deletions(-)

diff -puN arch/i386/lib/msr-on-cpu.c~msr-driver-simplify-smp_call_function_single-call-sequence arch/i386/lib/msr-on-cpu.c
--- a/arch/i386/lib/msr-on-cpu.c~msr-driver-simplify-smp_call_function_single-call-sequence
+++ a/arch/i386/lib/msr-on-cpu.c
@@ -26,27 +26,18 @@ static void __rdmsr_safe_on_cpu(void *in
 static int _rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h, int safe)
 {
 	int err = 0;
-	preempt_disable();
-	if (smp_processor_id() == cpu)
-		if (safe)
-			err = rdmsr_safe(msr_no, l, h);
-		else
-			rdmsr(msr_no, *l, *h);
-	else {
-		struct msr_info rv;
-
-		rv.msr_no = msr_no;
-		if (safe) {
-			smp_call_function_single(cpu, __rdmsr_safe_on_cpu,
-						 &rv, 0, 1);
-			err = rv.err;
-		} else {
-			smp_call_function_single(cpu, __rdmsr_on_cpu, &rv, 0, 1);
-		}
-		*l = rv.l;
-		*h = rv.h;
+	struct msr_info rv;
+
+	rv.msr_no = msr_no;
+	if (safe) {
+		smp_call_function_single(cpu, __rdmsr_safe_on_cpu, &rv, 0, 1);
+		err = rv.err;
+	} else {
+		smp_call_function_single(cpu, __rdmsr_on_cpu, &rv, 0, 1);
 	}
-	preempt_enable();
+	*l = rv.l;
+	*h = rv.h;
+
 	return err;
 }
 
@@ -67,27 +58,18 @@ static void __wrmsr_safe_on_cpu(void *in
 static int _wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h, int safe)
 {
 	int err = 0;
-	preempt_disable();
-	if (smp_processor_id() == cpu)
-		if (safe)
-			err = wrmsr_safe(msr_no, l, h);
-		else
-			wrmsr(msr_no, l, h);
-	else {
-		struct msr_info rv;
-
-		rv.msr_no = msr_no;
-		rv.l = l;
-		rv.h = h;
-		if (safe) {
-			smp_call_function_single(cpu, __wrmsr_safe_on_cpu,
-						 &rv, 0, 1);
-			err = rv.err;
-		} else {
-			smp_call_function_single(cpu, __wrmsr_on_cpu, &rv, 0, 1);
-		}
+	struct msr_info rv;
+
+	rv.msr_no = msr_no;
+	rv.l = l;
+	rv.h = h;
+	if (safe) {
+		smp_call_function_single(cpu, __wrmsr_safe_on_cpu, &rv, 0, 1);
+		err = rv.err;
+	} else {
+		smp_call_function_single(cpu, __wrmsr_on_cpu, &rv, 0, 1);
 	}
-	preempt_enable();
+
 	return err;
 }
 
_

Patches currently in -mm which might be from avi@qumranet.com are

ia64-allow-smp_call_function_single-to-current-cpu.patch
git-kvm.patch
cpuid-driver-simplify-smp_call_function_single-call-sequence.patch
msr-driver-simplify-smp_call_function_single-call-sequence.patch
time-simplify-smp_call_function_single-call-sequence.patch
