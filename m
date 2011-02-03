From: akpm@linux-foundation.org
Subject: + kernel-cpuc-fix-many-errors-related-to-style.patch added to -mm tree
Date: Thu, 03 Feb 2011 12:40:37 -0800
Message-ID: <201102032040.p13KebI7023443@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36617 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752032Ab1BCUlK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Feb 2011 15:41:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dkingston02@gmail.com


The patch titled
     kernel/cpu.c: fix many errors related to style.
has been added to the -mm tree.  Its filename is
     kernel-cpuc-fix-many-errors-related-to-style.patch

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
Subject: kernel/cpu.c: fix many errors related to style.
From: Michael Rodriguez <dkingston02@gmail.com>

Change the printk() calls to have the KERN_INFO/KERN_ERROR stuff, and
fixes other coding style errors.  Not _all_ of them are gone, though.

Signed-off-by: Michael Rodriguez <dkingston02@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpu.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN kernel/cpu.c~kernel-cpuc-fix-many-errors-related-to-style kernel/cpu.c
--- a/kernel/cpu.c~kernel-cpuc-fix-many-errors-related-to-style
+++ a/kernel/cpu.c
@@ -160,7 +160,6 @@ static void cpu_notify_nofail(unsigned l
 {
 	BUG_ON(cpu_notify(val, v));
 }
-
 EXPORT_SYMBOL(register_cpu_notifier);
 
 void __ref unregister_cpu_notifier(struct notifier_block *nb)
@@ -201,11 +200,11 @@ static int __ref take_cpu_down(void *_pa
 
 	/* Ensure this CPU doesn't handle any more interrupts. */
 	err = __cpu_disable();
+
 	if (err < 0)
 		return err;
 
 	cpu_notify(CPU_DYING | param->mod, param->hcpu);
-
 	return 0;
 }
 
@@ -227,7 +226,9 @@ static int __ref _cpu_down(unsigned int 
 		return -EINVAL;
 
 	cpu_hotplug_begin();
+
 	err = __cpu_notify(CPU_DOWN_PREPARE | mod, hcpu, -1, &nr_calls);
+
 	if (err) {
 		nr_calls--;
 		__cpu_notify(CPU_DOWN_FAILED | mod, hcpu, nr_calls, NULL);
@@ -304,7 +305,7 @@ static int __cpuinit _cpu_up(unsigned in
 	ret = __cpu_notify(CPU_UP_PREPARE | mod, hcpu, -1, &nr_calls);
 	if (ret) {
 		nr_calls--;
-		printk("%s: attempt to bring up CPU %u failed\n",
+		printk(KERN_WARNING "%s: attempt to bring up CPU %u failed\n",
 				__func__, cpu);
 		goto out_notify;
 	}
@@ -450,14 +451,14 @@ void __ref enable_nonboot_cpus(void)
 	if (cpumask_empty(frozen_cpus))
 		goto out;
 
-	printk("Enabling non-boot CPUs ...\n");
+	printk(KERN_INFO "Enabling non-boot CPUs ...\n");
 
 	arch_enable_nonboot_cpus_begin();
 
 	for_each_cpu(cpu, frozen_cpus) {
 		error = _cpu_up(cpu, 1);
 		if (!error) {
-			printk("CPU%d is up\n", cpu);
+			printk(KERN_INFO "CPU%d is up\n", cpu);
 			continue;
 		}
 		printk(KERN_WARNING "Error taking CPU%d up: %d\n", cpu, error);
@@ -509,7 +510,7 @@ void __cpuinit notify_cpu_starting(unsig
  */
 
 /* cpu_bit_bitmap[0] is empty - so we can back into it */
-#define MASK_DECLARE_1(x)	[x+1][0] = 1UL << (x)
+#define MASK_DECLARE_1(x)	[x+1][0] = (1UL << (x))
 #define MASK_DECLARE_2(x)	MASK_DECLARE_1(x), MASK_DECLARE_1(x+1)
 #define MASK_DECLARE_4(x)	MASK_DECLARE_2(x), MASK_DECLARE_2(x+2)
 #define MASK_DECLARE_8(x)	MASK_DECLARE_4(x), MASK_DECLARE_4(x+4)
_

Patches currently in -mm which might be from dkingston02@gmail.com are

kernel-cpuc-fix-many-errors-related-to-style.patch
kernel-cpuc-fix-many-errors-related-to-style-fix.patch

