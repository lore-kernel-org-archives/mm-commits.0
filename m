From: akpm@osdl.org
Subject: - clocksource-add-block-notifier.patch removed from -mm tree
Date: Fri, 08 Dec 2006 03:05:40 -0800
Message-ID: <200612081105.kB8B5eRc018660@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49595 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425398AbWLHLMT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 06:12:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     clocksource: add block notifier
has been removed from the -mm tree.  Its filename was
     clocksource-add-block-notifier.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: clocksource: add block notifier
From: Daniel Walker <dwalker@mvista.com>

Adds a call back interface for register/rating change events.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/clocksource.h |    8 ++++++++
 kernel/time/clocksource.c   |   19 ++++++++++++++++++-
 kernel/timer.c              |   12 ++++++++++++
 3 files changed, 38 insertions(+), 1 deletion(-)

diff -puN include/linux/clocksource.h~clocksource-add-block-notifier include/linux/clocksource.h
--- a/include/linux/clocksource.h~clocksource-add-block-notifier
+++ a/include/linux/clocksource.h
@@ -14,6 +14,7 @@
 #include <linux/list.h>
 #include <linux/plist.h>
 #include <linux/sysdev.h>
+#include <linux/notifier.h>
 #include <asm/div64.h>
 #include <asm/io.h>
 
@@ -26,6 +27,12 @@ typedef u64 cycle_t;
  */
 extern struct clocksource clocksource_jiffies;
 
+/*
+ * Block notifier flags.
+ */
+#define CLOCKSOURCE_NOTIFY_REGISTER	1
+#define CLOCKSOURCE_NOTIFY_RATING	2
+
 /**
  * struct clocksource - hardware abstraction for a free running counter
  *	Provides mostly state-free accessors to the underlying hardware.
@@ -205,6 +212,7 @@ static inline void clocksource_calculate
 
 
 /* used to install a new clocksource */
+extern int clocksource_notifier_register(struct notifier_block*);
 extern int clocksource_sysfs_register(struct sysdev_attribute*);
 extern void clocksource_sysfs_unregister(struct sysdev_attribute*);
 extern int clocksource_register(struct clocksource*);
diff -puN kernel/time/clocksource.c~clocksource-add-block-notifier kernel/time/clocksource.c
--- a/kernel/time/clocksource.c~clocksource-add-block-notifier
+++ a/kernel/time/clocksource.c
@@ -39,6 +39,18 @@
 static __read_mostly
 struct list_head clocksource_list = LIST_HEAD_INIT(clocksource_list);
 static DEFINE_SPINLOCK(clocksource_lock);
+static ATOMIC_NOTIFIER_HEAD(clocksource_list_notifier);
+
+/**
+ * clocksource_notifier_register - Registers a list change notifier
+ * @nb:		pointer to a notifier block
+ *
+ * Returns zero always.
+ */
+int clocksource_notifier_register(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_register(&clocksource_list_notifier, nb);
+}
 
 /**
  * __is_registered - Returns a clocksource if it's registered
@@ -139,6 +151,9 @@ int clocksource_register(struct clocksou
  		__sorted_list_add(c);
 	}
 	spin_unlock_irqrestore(&clocksource_lock, flags);
+
+	atomic_notifier_call_chain(&clocksource_list_notifier,
+ 				   CLOCKSOURCE_NOTIFY_REGISTER, c);
 	return ret;
 }
 EXPORT_SYMBOL(clocksource_register);
@@ -165,7 +180,9 @@ void clocksource_rating_change(struct cl
 	list_del_init(&c->list);
 	__sorted_list_add(c);
 
-	/* XXX: Add block notifier to signal new rating */
+	atomic_notifier_call_chain(&clocksource_list_notifier,
+				   CLOCKSOURCE_NOTIFY_RATING, c);
+
 	spin_unlock_irqrestore(&clocksource_lock, flags);
 }
 EXPORT_SYMBOL(clocksource_rating_change);
diff -puN kernel/timer.c~clocksource-add-block-notifier kernel/timer.c
--- a/kernel/timer.c~clocksource-add-block-notifier
+++ a/kernel/timer.c
@@ -891,6 +891,17 @@ static int __init boot_override_clocksou
 }
 __setup("timeofday_clocksource=", boot_override_clocksource);
 
+static int
+clocksource_callback(struct notifier_block *nb, unsigned long op, void *c)
+{
+	atomic_inc(&clock_check);
+	return 0;
+}
+
+static struct notifier_block clocksource_nb = {
+	.notifier_call = clocksource_callback,
+};
+
 #else
 #define change_clocksource(x)	do { } while(0)
 #endif
@@ -1019,6 +1030,7 @@ static int __init timekeeping_init_devic
 
 #ifdef CONFIG_GENERIC_TIME
 	clocksource_sysfs_register(&attr_timeofday_clocksource);
+	clocksource_notifier_register(&clocksource_nb);
 
 	/*
 	 * All the clocks should be registered at this point,
_

Patches currently in -mm which might be from dwalker@mvista.com are

clocksource-add-usage-of-config_sysfs.patch
clocksource-small-cleanup-2.patch
clocksource-small-cleanup-2-fix.patch
clocksource-small-acpi_pm-cleanup.patch
profile-likely-unlikely-macros.patch
profile_likely-export-do_check_likely.patch

