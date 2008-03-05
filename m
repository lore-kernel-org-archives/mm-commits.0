From: akpm@linux-foundation.org
Subject: + rcu-move-preempt_rcu-config-option-back-under-preempt.patch added to -mm tree
Date: Wed, 05 Mar 2008 15:41:34 -0800
Message-ID: <200803052341.m25NfYBq027663@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46125 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756750AbYCEXrb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 18:47:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, dipankar@in.ibm.com, josh@freedesktop.org, mingo@elte.hu, rostedt@goodmis.org, sam@ravnborg.org, tglx@linutronix.de, zippel@linux-m68k.org


The patch titled
     rcu: move PREEMPT_RCU config option back under PREEMPT
has been added to the -mm tree.  Its filename is
     rcu-move-preempt_rcu-config-option-back-under-preempt.patch

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
Subject: rcu: move PREEMPT_RCU config option back under PREEMPT
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The original preemptible-RCU patch put the choice between classic and
preemptible RCU into kernel/Kconfig.preempt, which resulted in build failures
on machines not supporting CONFIG_PREEMPT.  This choice was therefore moved to
init/Kconfig, which worked, but placed the choice between classic and
preemptible RCU at the top level, a very obtuse choice indeed.

This patch changes from the Kconfig "choice" mechanism to a pair of booleans,
only one of which (CONFIG_PREEMPT_RCU) is user-visible, and is located in
kernel/Kconfig.preempt, where one would expect it to be.  The other
(CONFIG_CLASSIC_RCU) is in init/Kconfig so that it is available to all
architectures, hopefully avoiding build breakage.  Thanks to Roman Zippel for
suggesting this approach.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Cc: Josh Triplett <josh@freedesktop.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig           |   34 +++-------------------------------
 kernel/Kconfig.preempt |   15 +++++++++++++++
 2 files changed, 18 insertions(+), 31 deletions(-)

diff -puN init/Kconfig~rcu-move-preempt_rcu-config-option-back-under-preempt init/Kconfig
--- a/init/Kconfig~rcu-move-preempt_rcu-config-option-back-under-preempt
+++ a/init/Kconfig
@@ -865,38 +865,10 @@ source "block/Kconfig"
 config PREEMPT_NOTIFIERS
 	bool
 
-choice
-	prompt "RCU implementation type:"
-	default CLASSIC_RCU
-	help
-	  This allows you to choose either the classic RCU implementation
-	  that is designed for best read-side performance on non-realtime
-	  systems, or the preemptible RCU implementation for best latency
-	  on realtime systems.  Note that some kernel preemption modes
-	  will restrict your choice.
-
-	  Select the default if you are unsure.
-
 config CLASSIC_RCU
-	bool "Classic RCU"
+	def_bool !PREEMPT_RCU
 	help
 	  This option selects the classic RCU implementation that is
 	  designed for best read-side performance on non-realtime
-	  systems.
-
-	  Say Y if you are unsure.
-
-config PREEMPT_RCU
-	bool "Preemptible RCU"
-	depends on PREEMPT
-	help
-	  This option reduces the latency of the kernel by making certain
-	  RCU sections preemptible. Normally RCU code is non-preemptible, if
-	  this option is selected then read-only RCU sections become
-	  preemptible. This helps latency, but may expose bugs due to
-	  now-naive assumptions about each RCU read-side critical section
-	  remaining on a given CPU through its execution.
-
-	  Say N if you are unsure.
-
-endchoice
+	  systems.  Classic RCU is the default.  Note that the
+	  PREEMPT_RCU symbol is used to select/deselect this option.
diff -puN kernel/Kconfig.preempt~rcu-move-preempt_rcu-config-option-back-under-preempt kernel/Kconfig.preempt
--- a/kernel/Kconfig.preempt~rcu-move-preempt_rcu-config-option-back-under-preempt
+++ a/kernel/Kconfig.preempt
@@ -52,8 +52,23 @@ config PREEMPT
 
 endchoice
 
+config PREEMPT_RCU
+	bool "Preemptible RCU"
+	depends on PREEMPT
+	default n
+	help
+	  This option reduces the latency of the kernel by making certain
+	  RCU sections preemptible. Normally RCU code is non-preemptible, if
+	  this option is selected then read-only RCU sections become
+	  preemptible. This helps latency, but may expose bugs due to
+	  now-naive assumptions about each RCU read-side critical section
+	  remaining on a given CPU through its execution.
+
+	  Say N if you are unsure.
+
 config RCU_TRACE
 	bool "Enable tracing for RCU - currently stats in debugfs"
+	depends on PREEMPT_RCU
 	select DEBUG_FS
 	default y
 	help
_

Patches currently in -mm which might be from paulmck@linux.vnet.ibm.com are

kthread-call-wake_up_process-without-the-lock-being-held.patch
rcu-move-preempt_rcu-config-option-back-under-preempt.patch
add-rcu_assign_index-if-ever-needed.patch
add-rcu_assign_index-if-ever-needed-fix.patch
rcu-split-listh-and-move-rcu-protected-lists-into-rculisth.patch
lock_task_sighand-add-rcu-lock-unlock.patch
k_getrusage-dont-take-rcu_read_lock.patch
do_task_stat-dont-take-rcu_read_lock.patch

