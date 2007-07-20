From: akpm@linux-foundation.org
Subject: + ia64-allow-smp_call_function_single-to-current-cpu.patch added to -mm tree
Date: Fri, 20 Jul 2007 12:07:06 -0700
Message-ID: <200707201907.l6KJ76h5011538@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47908 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760577AbXGTTHT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 15:07:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com, tony.luck@intel.com


The patch titled
     ia64: allow smp_call_function_single() to current cpu
has been added to the -mm tree.  Its filename is
     ia64-allow-smp_call_function_single-to-current-cpu.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ia64: allow smp_call_function_single() to current cpu
From: Avi Kivity <avi@qumranet.com>

This removes the requirement for callers to get_cpu() to check in simple
cases.  i386 and x86_64 already received a similar treatment.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/smp.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff -puN arch/ia64/kernel/smp.c~ia64-allow-smp_call_function_single-to-current-cpu arch/ia64/kernel/smp.c
--- a/arch/ia64/kernel/smp.c~ia64-allow-smp_call_function_single-to-current-cpu
+++ a/arch/ia64/kernel/smp.c
@@ -346,7 +346,7 @@ smp_flush_tlb_mm (struct mm_struct *mm)
 }
 
 /*
- * Run a function on another CPU
+ * Run a function on a specific CPU
  *  <func>	The function to run. This must be fast and non-blocking.
  *  <info>	An arbitrary pointer to pass to the function.
  *  <nonatomic>	Currently unused.
@@ -366,9 +366,11 @@ smp_call_function_single (int cpuid, voi
 	int me = get_cpu(); /* prevent preemption and reschedule on another processor */
 
 	if (cpuid == me) {
-		printk(KERN_INFO "%s: trying to call self\n", __FUNCTION__);
+		local_irq_disable();
+		func(info);
+		local_irq_enable();
 		put_cpu();
-		return -EBUSY;
+		return 0;
 	}
 
 	data.func = func;
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
ia64-allow-smp_call_function_single-to-current-cpu.patch
git-kvm.patch
