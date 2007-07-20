From: akpm@linux-foundation.org
Subject: + powerpc-allow-smp_call_function_single-to-current-cpu.patch added to -mm tree
Date: Fri, 20 Jul 2007 12:09:01 -0700
Message-ID: <200707201909.l6KJ91G7011592@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53079 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934010AbXGTTJL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 15:09:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com, benh@kernel.crashing.org, paulus@samba.org


The patch titled
     powerpc: allow smp_call_function_single() to current cpu
has been added to the -mm tree.  Its filename is
     powerpc-allow-smp_call_function_single-to-current-cpu.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: powerpc: allow smp_call_function_single() to current cpu
From: Avi Kivity <avi@qumranet.com>

This removes the requirement for callers to get_cpu() to check in simple
cases.  i386 and x86_64 already received a similar treatment.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/smp.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletion(-)

diff -puN arch/powerpc/kernel/smp.c~powerpc-allow-smp_call_function_single-to-current-cpu arch/powerpc/kernel/smp.c
--- a/arch/powerpc/kernel/smp.c~powerpc-allow-smp_call_function_single-to-current-cpu
+++ a/arch/powerpc/kernel/smp.c
@@ -284,7 +284,7 @@ int smp_call_function_single(int cpu, vo
 			int wait)
 {
 	cpumask_t map = CPU_MASK_NONE;
-	int ret = -EBUSY;
+	int ret = 0;
 
 	if (!cpu_online(cpu))
 		return -EINVAL;
@@ -292,6 +292,11 @@ int smp_call_function_single(int cpu, vo
 	cpu_set(cpu, map);
 	if (cpu != get_cpu())
 		ret = smp_call_function_map(func,info,nonatomic,wait,map);
+	else {
+		local_irq_disable();
+		func(info);
+		local_irq_enable();
+	}
 	put_cpu();
 	return ret;
 }
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
powerpc-allow-smp_call_function_single-to-current-cpu.patch
ia64-allow-smp_call_function_single-to-current-cpu.patch
git-kvm.patch
