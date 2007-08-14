From: akpm@linux-foundation.org
Subject: - msr-driver-simplify-smp_call_function_single-call-sequence.patch removed from -mm tree
Date: Tue, 14 Aug 2007 12:14:15 -0700
Message-ID: <200708141914.l7EJEFdK016599@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48367 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932395AbXHNTUt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:20:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, ak@suse.de, hpa@zytor.com, mm-commits@vger.kernel.org


The patch titled
     msr driver: simplify smp_call_function_single() call sequence
has been removed from the -mm tree.  Its filename was
     msr-driver-simplify-smp_call_function_single-call-sequence.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-kvm.patch
time-simplify-smp_call_function_single-call-sequence.patch
