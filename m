From: akpm@linux-foundation.org
Subject: [merged] kernel-cpuc-delete-deprecated-definition-in-cpu_up.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:05:32 -0800
Message-ID: <201003091905.o29J5W80031127@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51535 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752118Ab0CITGb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:06:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gong.chen@linux.intel.com, mingo@elte.hu, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     kernel/cpu.c: delete deprecated definition in cpu_up()
has been removed from the -mm tree.  Its filename was
     kernel-cpuc-delete-deprecated-definition-in-cpu_up.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/cpu.c: delete deprecated definition in cpu_up()
From: Chen Gong <gong.chen@linux.intel.com>

Additional_cpus is only supported for IA64 now.  X86_64 should not be
included.

Signed-off-by: Chen Gong <gong.chen@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/cpu.c~kernel-cpuc-delete-deprecated-definition-in-cpu_up kernel/cpu.c
--- a/kernel/cpu.c~kernel-cpuc-delete-deprecated-definition-in-cpu_up
+++ a/kernel/cpu.c
@@ -338,7 +338,7 @@ int __cpuinit cpu_up(unsigned int cpu)
 	if (!cpu_possible(cpu)) {
 		printk(KERN_ERR "can't online cpu %d because it is not "
 			"configured as may-hotadd at boot time\n", cpu);
-#if defined(CONFIG_IA64) || defined(CONFIG_X86_64)
+#if defined(CONFIG_IA64)
 		printk(KERN_ERR "please check additional_cpus= boot "
 				"parameter\n");
 #endif
_

Patches currently in -mm which might be from gong.chen@linux.intel.com are


