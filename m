From: akpm@linux-foundation.org
Subject: [merged] kernel-cpuc-fix-many-errors-related-to-style.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:38:59 -0700
Message-ID: <201103232042.p2NKgZxY028781@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57921 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751361Ab1CWUx3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:53:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dkingston02@gmail.com, mm-commits@vger.kernel.org


The patch titled
     kernel/cpu.c: fix many errors related to style.
has been removed from the -mm tree.  Its filename was
     kernel-cpuc-fix-many-errors-related-to-style.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/cpu.c: fix many errors related to style.
From: Michael Rodriguez <dkingston02@gmail.com>

Change the printk() calls to have the KERN_INFO/KERN_ERROR stuff, and
fixes other coding style errors.  Not _all_ of them are gone, though.

[akpm@linux-foundation.org: revert the bits I disagree with]
Signed-off-by: Michael Rodriguez <dkingston02@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpu.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

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
@@ -205,7 +204,6 @@ static int __ref take_cpu_down(void *_pa
 		return err;
 
 	cpu_notify(CPU_DYING | param->mod, param->hcpu);
-
 	return 0;
 }
 
@@ -227,6 +225,7 @@ static int __ref _cpu_down(unsigned int 
 		return -EINVAL;
 
 	cpu_hotplug_begin();
+
 	err = __cpu_notify(CPU_DOWN_PREPARE | mod, hcpu, -1, &nr_calls);
 	if (err) {
 		nr_calls--;
@@ -304,7 +303,7 @@ static int __cpuinit _cpu_up(unsigned in
 	ret = __cpu_notify(CPU_UP_PREPARE | mod, hcpu, -1, &nr_calls);
 	if (ret) {
 		nr_calls--;
-		printk("%s: attempt to bring up CPU %u failed\n",
+		printk(KERN_WARNING "%s: attempt to bring up CPU %u failed\n",
 				__func__, cpu);
 		goto out_notify;
 	}
@@ -450,14 +449,14 @@ void __ref enable_nonboot_cpus(void)
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
@@ -509,7 +508,7 @@ void __cpuinit notify_cpu_starting(unsig
  */
 
 /* cpu_bit_bitmap[0] is empty - so we can back into it */
-#define MASK_DECLARE_1(x)	[x+1][0] = 1UL << (x)
+#define MASK_DECLARE_1(x)	[x+1][0] = (1UL << (x))
 #define MASK_DECLARE_2(x)	MASK_DECLARE_1(x), MASK_DECLARE_1(x+1)
 #define MASK_DECLARE_4(x)	MASK_DECLARE_2(x), MASK_DECLARE_2(x+2)
 #define MASK_DECLARE_8(x)	MASK_DECLARE_4(x), MASK_DECLARE_4(x+4)
_

Patches currently in -mm which might be from dkingston02@gmail.com are

origin.patch

