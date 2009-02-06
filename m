From: akpm@linux-foundation.org
Subject: + cpu-hotplug-remove-unused-cpuhotplug_mutex_lock.patch added to -mm tree
Date: Fri, 06 Feb 2009 13:22:46 -0800
Message-ID: <200902062122.n16LMkHU023735@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36754 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756148AbZBFVXg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Feb 2009 16:23:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: laijs@cn.fujitsu.com, mingo@elte.hu, rusty@rustcorp.com.au


The patch titled
     cpu hotplug: remove unused cpuhotplug_mutex_lock()
has been added to the -mm tree.  Its filename is
     cpu-hotplug-remove-unused-cpuhotplug_mutex_lock.patch

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
Subject: cpu hotplug: remove unused cpuhotplug_mutex_lock()
From: Lai Jiangshan <laijs@cn.fujitsu.com>

cpuhotplug_mutex_lock() is not used, remove it.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpu.h |   16 ----------------
 1 file changed, 16 deletions(-)

diff -puN include/linux/cpu.h~cpu-hotplug-remove-unused-cpuhotplug_mutex_lock include/linux/cpu.h
--- a/include/linux/cpu.h~cpu-hotplug-remove-unused-cpuhotplug_mutex_lock
+++ a/include/linux/cpu.h
@@ -23,7 +23,6 @@
 #include <linux/node.h>
 #include <linux/compiler.h>
 #include <linux/cpumask.h>
-#include <linux/mutex.h>
 
 struct cpu {
 	int node_id;		/* The node which contains the CPU */
@@ -103,16 +102,6 @@ extern struct sysdev_class cpu_sysdev_cl
 #ifdef CONFIG_HOTPLUG_CPU
 /* Stop CPUs going up and down. */
 
-static inline void cpuhotplug_mutex_lock(struct mutex *cpu_hp_mutex)
-{
-	mutex_lock(cpu_hp_mutex);
-}
-
-static inline void cpuhotplug_mutex_unlock(struct mutex *cpu_hp_mutex)
-{
-	mutex_unlock(cpu_hp_mutex);
-}
-
 extern void get_online_cpus(void);
 extern void put_online_cpus(void);
 #define hotcpu_notifier(fn, pri) {				\
@@ -126,11 +115,6 @@ int cpu_down(unsigned int cpu);
 
 #else		/* CONFIG_HOTPLUG_CPU */
 
-static inline void cpuhotplug_mutex_lock(struct mutex *cpu_hp_mutex)
-{ }
-static inline void cpuhotplug_mutex_unlock(struct mutex *cpu_hp_mutex)
-{ }
