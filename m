From: akpm@linux-foundation.org
Subject: [merged] notifiers-cpu-move-cpu-notifiers-into-cpuh.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:55:22 -0700
Message-ID: <201107260754.p6Q7sPiM003350@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37309 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752832Ab1GZHz2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:55:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amwang@redhat.com, davem@davemloft.net, greg@kroah.com, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     notifiers: cpu: move cpu notifiers into cpu.h
has been removed from the -mm tree.  Its filename was
     notifiers-cpu-move-cpu-notifiers-into-cpuh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: notifiers: cpu: move cpu notifiers into cpu.h
From: Amerigo Wang <amwang@redhat.com>

We presently define all kinds of notifiers in notifier.h.  This is not
necessary at all, since different subsystems use different notifiers, they
are almost non-related with each other.

This can also save much build time.  Suppose I add a new netdevice event,
really I don't have to recompile all the source, just network related. 
Without this patch, all the source will be recompiled.

I move the notify events near to their subsystem notifier registers, so
that they can be found more easily.


This patch:

It is not necessary to share the same notifier.h.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: David Miller <davem@davemloft.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpu.h      |   33 +++++++++++++++++++++++++++++++++
 include/linux/notifier.h |   34 ++--------------------------------
 net/rds/page.c           |    1 +
 3 files changed, 36 insertions(+), 32 deletions(-)

diff -puN include/linux/cpu.h~notifiers-cpu-move-cpu-notifiers-into-cpuh include/linux/cpu.h
--- a/include/linux/cpu.h~notifiers-cpu-move-cpu-notifiers-into-cpuh
+++ a/include/linux/cpu.h
@@ -70,6 +70,39 @@ enum {
 	CPU_PRI_WORKQUEUE	= 5,
 };
 
+#define CPU_ONLINE		0x0002 /* CPU (unsigned)v is up */
+#define CPU_UP_PREPARE		0x0003 /* CPU (unsigned)v coming up */
+#define CPU_UP_CANCELED		0x0004 /* CPU (unsigned)v NOT coming up */
+#define CPU_DOWN_PREPARE	0x0005 /* CPU (unsigned)v going down */
+#define CPU_DOWN_FAILED		0x0006 /* CPU (unsigned)v NOT going down */
+#define CPU_DEAD		0x0007 /* CPU (unsigned)v dead */
+#define CPU_DYING		0x0008 /* CPU (unsigned)v not running any task,
+					* not handling interrupts, soon dead.
+					* Called on the dying cpu, interrupts
+					* are already disabled. Must not
+					* sleep, must not fail */
+#define CPU_POST_DEAD		0x0009 /* CPU (unsigned)v dead, cpu_hotplug
+					* lock is dropped */
+#define CPU_STARTING		0x000A /* CPU (unsigned)v soon running.
+					* Called on the new cpu, just before
+					* enabling interrupts. Must not sleep,
+					* must not fail */
+
+/* Used for CPU hotplug events occurring while tasks are frozen due to a suspend
+ * operation in progress
+ */
+#define CPU_TASKS_FROZEN	0x0010
+
+#define CPU_ONLINE_FROZEN	(CPU_ONLINE | CPU_TASKS_FROZEN)
+#define CPU_UP_PREPARE_FROZEN	(CPU_UP_PREPARE | CPU_TASKS_FROZEN)
+#define CPU_UP_CANCELED_FROZEN	(CPU_UP_CANCELED | CPU_TASKS_FROZEN)
+#define CPU_DOWN_PREPARE_FROZEN	(CPU_DOWN_PREPARE | CPU_TASKS_FROZEN)
+#define CPU_DOWN_FAILED_FROZEN	(CPU_DOWN_FAILED | CPU_TASKS_FROZEN)
+#define CPU_DEAD_FROZEN		(CPU_DEAD | CPU_TASKS_FROZEN)
+#define CPU_DYING_FROZEN	(CPU_DYING | CPU_TASKS_FROZEN)
+#define CPU_STARTING_FROZEN	(CPU_STARTING | CPU_TASKS_FROZEN)
+
+
 #ifdef CONFIG_SMP
 /* Need to know about CPUs going up/down? */
 #if defined(CONFIG_HOTPLUG_CPU) || !defined(MODULE)
diff -puN include/linux/notifier.h~notifiers-cpu-move-cpu-notifiers-into-cpuh include/linux/notifier.h
--- a/include/linux/notifier.h~notifiers-cpu-move-cpu-notifiers-into-cpuh
+++ a/include/linux/notifier.h
@@ -185,6 +185,8 @@ static inline int notifier_to_errno(int 
  *	VC switch chains (for loadable kernel svgalib VC switch helpers) etc...
  */
  
+/* CPU notfiers are defined in include/linux/cpu.h. */
+
 /* netdevice notifier chain. Please remember to update the rtnetlink
  * notification exclusion list in rtnetlink_event() when adding new
  * types.
@@ -220,38 +222,6 @@ static inline int notifier_to_errno(int 
 
 #define NETLINK_URELEASE	0x0001	/* Unicast netlink socket released */
 
-#define CPU_ONLINE		0x0002 /* CPU (unsigned)v is up */
-#define CPU_UP_PREPARE		0x0003 /* CPU (unsigned)v coming up */
-#define CPU_UP_CANCELED		0x0004 /* CPU (unsigned)v NOT coming up */
-#define CPU_DOWN_PREPARE	0x0005 /* CPU (unsigned)v going down */
-#define CPU_DOWN_FAILED		0x0006 /* CPU (unsigned)v NOT going down */
-#define CPU_DEAD		0x0007 /* CPU (unsigned)v dead */
-#define CPU_DYING		0x0008 /* CPU (unsigned)v not running any task,
-					* not handling interrupts, soon dead.
-					* Called on the dying cpu, interrupts
-					* are already disabled. Must not
-					* sleep, must not fail */
-#define CPU_POST_DEAD		0x0009 /* CPU (unsigned)v dead, cpu_hotplug
-					* lock is dropped */
-#define CPU_STARTING		0x000A /* CPU (unsigned)v soon running.
-					* Called on the new cpu, just before
-					* enabling interrupts. Must not sleep,
-					* must not fail */
-
-/* Used for CPU hotplug events occurring while tasks are frozen due to a suspend
- * operation in progress
- */
-#define CPU_TASKS_FROZEN	0x0010
-
-#define CPU_ONLINE_FROZEN	(CPU_ONLINE | CPU_TASKS_FROZEN)
-#define CPU_UP_PREPARE_FROZEN	(CPU_UP_PREPARE | CPU_TASKS_FROZEN)
-#define CPU_UP_CANCELED_FROZEN	(CPU_UP_CANCELED | CPU_TASKS_FROZEN)
-#define CPU_DOWN_PREPARE_FROZEN	(CPU_DOWN_PREPARE | CPU_TASKS_FROZEN)
-#define CPU_DOWN_FAILED_FROZEN	(CPU_DOWN_FAILED | CPU_TASKS_FROZEN)
-#define CPU_DEAD_FROZEN		(CPU_DEAD | CPU_TASKS_FROZEN)
-#define CPU_DYING_FROZEN	(CPU_DYING | CPU_TASKS_FROZEN)
-#define CPU_STARTING_FROZEN	(CPU_STARTING | CPU_TASKS_FROZEN)
