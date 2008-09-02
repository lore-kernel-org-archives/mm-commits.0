From: akpm@linux-foundation.org
Subject: + sparc64-avoid-invoking-irq-handlers-on-offline-cpus.patch added to -mm tree
Date: Tue, 02 Sep 2008 16:57:57 -0700
Message-ID: <200809022357.m82NvvLA019430@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35220 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751570AbYICAIf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Sep 2008 20:08:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com


The patch titled
     sparc64: avoid invoking irq handlers on offline CPUs
has been added to the -mm tree.  Its filename is
     sparc64-avoid-invoking-irq-handlers-on-offline-cpus.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sparc64: avoid invoking irq handlers on offline CPUs
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Make sparc64 refrain from clearing a given to-be-offlined CPU's bit in the
cpu_online_mask until it has processed pending irqs.  This change prevents
other CPUs from being blindsided by an apparently offline CPU nevertheless
changing globally visible state.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc64/kernel/smp.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/sparc64/kernel/smp.c~sparc64-avoid-invoking-irq-handlers-on-offline-cpus arch/sparc64/kernel/smp.c
--- a/arch/sparc64/kernel/smp.c~sparc64-avoid-invoking-irq-handlers-on-offline-cpus
+++ a/arch/sparc64/kernel/smp.c
@@ -1305,10 +1305,6 @@ int __cpu_disable(void)
 	c->core_id = 0;
 	c->proc_id = -1;
 
-	spin_lock(&call_lock);
-	cpu_clear(cpu, cpu_online_map);
-	spin_unlock(&call_lock);
-
 	smp_wmb();
 
 	/* Make sure no interrupts point to this cpu.  */
@@ -1318,6 +1314,10 @@ int __cpu_disable(void)
 	mdelay(1);
 	local_irq_disable();
 
+	spin_lock(&call_lock);
+	cpu_clear(cpu, cpu_online_map);
+	spin_unlock(&call_lock);
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from paulmck@linux.vnet.ibm.com are

linux-next.patch
ia64-avoid-invoking-irq-handlers-on-offline-cpus.patch
rcu-spinlocks-take-an-unsigned-long-flags.patch
rcu-fix-sparse-shadowed-variable-warning.patch
sparc64-avoid-invoking-irq-handlers-on-offline-cpus.patch
modules-remove-stop_machine-during-module-load.patch
modules-remove-stop_machine-during-module-load-checkpatch-fixes.patch

