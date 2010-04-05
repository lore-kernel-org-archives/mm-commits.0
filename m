From: akpm@linux-foundation.org
Subject: + cpuhotplug-do-not-need-cpu_hotplug_begin-when-config_hotplug_cpu=n.patch added to -mm tree
Date: Mon, 05 Apr 2010 14:41:29 -0700
Message-ID: <201004052141.o35LfTfs010678@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45885 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756407Ab0DEVmb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Apr 2010 17:42:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: laijs@cn.fujitsu.com, ego@in.ibm.com, mingo@elte.hu


The patch titled
     cpuhotplug: do not need cpu_hotplug_begin() when CONFIG_HOTPLUG_CPU=n
has been added to the -mm tree.  Its filename is
     cpuhotplug-do-not-need-cpu_hotplug_begin-when-config_hotplug_cpu=n.patch

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
Subject: cpuhotplug: do not need cpu_hotplug_begin() when CONFIG_HOTPLUG_CPU=n
From: Lai Jiangshan <laijs@cn.fujitsu.com>

Since when CONFIG_HOTPLUG_CPU=n, get_online_cpus() do nothing, so we don't
need cpu_hotplug_begin() either.

This patch moves cpu_hotplug_begin()/cpu_hotplug_done() into the code
block of CONFIG_HOTPLUG_CPU=y.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpu.c |   40 ++++++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 18 deletions(-)

diff -puN kernel/cpu.c~cpuhotplug-do-not-need-cpu_hotplug_begin-when-config_hotplug_cpu=n kernel/cpu.c
--- a/kernel/cpu.c~cpuhotplug-do-not-need-cpu_hotplug_begin-when-config_hotplug_cpu=n
+++ a/kernel/cpu.c
@@ -20,6 +20,20 @@
 /* Serializes the updates to cpu_online_mask, cpu_present_mask */
 static DEFINE_MUTEX(cpu_add_remove_lock);
 
+/*
+ * The following two API's must be used when attempting
+ * to serialize the updates to cpu_online_mask, cpu_present_mask.
+ */
+void cpu_maps_update_begin(void)
+{
+	mutex_lock(&cpu_add_remove_lock);
+}
+
+void cpu_maps_update_done(void)
+{
+	mutex_unlock(&cpu_add_remove_lock);
+}
+
 static __cpuinitdata RAW_NOTIFIER_HEAD(cpu_chain);
 
 /* If set, cpu_up and cpu_down will return -EBUSY and do nothing.
@@ -27,6 +41,8 @@ static __cpuinitdata RAW_NOTIFIER_HEAD(c
  */
 static int cpu_hotplug_disabled;
 
+#ifdef CONFIG_HOTPLUG_CPU
+
 static struct {
 	struct task_struct *active_writer;
 	struct mutex lock; /* Synchronizes accesses to refcount, */
@@ -41,8 +57,6 @@ static struct {
 	.refcount = 0,
 };
 
-#ifdef CONFIG_HOTPLUG_CPU
-
 void get_online_cpus(void)
 {
 	might_sleep();
@@ -67,22 +81,6 @@ void put_online_cpus(void)
 }
 EXPORT_SYMBOL_GPL(put_online_cpus);
 
-#endif	/* CONFIG_HOTPLUG_CPU */
-
-/*
- * The following two API's must be used when attempting
- * to serialize the updates to cpu_online_mask, cpu_present_mask.
- */
-void cpu_maps_update_begin(void)
-{
-	mutex_lock(&cpu_add_remove_lock);
-}
-
-void cpu_maps_update_done(void)
-{
-	mutex_unlock(&cpu_add_remove_lock);
-}
