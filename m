From: akpm@osdl.org
Subject: - clocksource-add-some-new-api-calls.patch removed from -mm tree
Date: Fri, 08 Dec 2006 03:05:35 -0800
Message-ID: <200612081105.kB8B5Z7n018654@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50625 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425407AbWLHLYy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 06:24:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     clocksource: add some new API calls
has been removed from the -mm tree.  Its filename was
     clocksource-add-some-new-api-calls.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: clocksource: add some new API calls
From: Daniel Walker <dwalker@mvista.com>

originally used plist but removed it in this patch, and used a sorted list
which is just as fast with a lot less memory overhead.

Introduces some new API calls,

- clocksource_get_clock()
	Allows a clock lookup by name.
- clocksource_rating_change()
	Used by a clocksource to signal a rating change. Replaces
	reselect_clocksource()

I also moved the the clock source list to a plist, which removes some lookup
overhead in the average case.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/tsc.c      |    2 
 include/linux/clocksource.h |   44 ++++++-
 kernel/time/clocksource.c   |  213 +++++++++++++++++++++-------------
 3 files changed, 179 insertions(+), 80 deletions(-)

diff -puN arch/i386/kernel/tsc.c~clocksource-add-some-new-api-calls arch/i386/kernel/tsc.c
--- a/arch/i386/kernel/tsc.c~clocksource-add-some-new-api-calls
+++ a/arch/i386/kernel/tsc.c
@@ -351,7 +351,7 @@ static int tsc_update_callback(void)
 	/* check to see if we should switch to the safe clocksource: */
 	if (clocksource_tsc.rating != 50 && check_tsc_unstable()) {
 		clocksource_tsc.rating = 50;
-		clocksource_reselect();
+		clocksource_rating_change(&clocksource_tsc);
 		change = 1;
 	}
 
diff -puN include/linux/clocksource.h~clocksource-add-some-new-api-calls include/linux/clocksource.h
--- a/include/linux/clocksource.h~clocksource-add-some-new-api-calls
+++ a/include/linux/clocksource.h
@@ -12,12 +12,20 @@
 #include <linux/timex.h>
 #include <linux/time.h>
 #include <linux/list.h>
+#include <linux/plist.h>
+#include <linux/sysdev.h>
 #include <asm/div64.h>
 #include <asm/io.h>
 
 /* clocksource cycle base type */
 typedef u64 cycle_t;
 
+/*
+ * This is the only generic clock, it should be used
+ * for early initialization.
+ */
+extern struct clocksource clocksource_jiffies;
+
 /**
  * struct clocksource - hardware abstraction for a free running counter
  *	Provides mostly state-free accessors to the underlying hardware.
@@ -148,6 +156,25 @@ static inline s64 cyc2ns(struct clocksou
 }
 
 /**
+ * ns2cyc - converts nanoseconds to clocksource cycles
+ * @cs:		Pointer to clocksource
+ * @ns:		Nanoseconds
+ *
+ * Uses the clocksource to convert nanoseconds back to cycles.
+ *
+ * XXX - This could use some mult_lxl_ll() asm optimization
+ */
+static inline cycle_t ns2cyc(struct clocksource *cs, s64 ns)
+{
+	u64 ret = ns;
+
+	ret <<= cs->shift;
+	do_div(ret, cs->mult);
+
+	return ret;
+}
+
+/**
  * clocksource_calculate_interval - Calculates a clocksource interval struct
  *
  * @c:		Pointer to clocksource.
@@ -178,8 +205,19 @@ static inline void clocksource_calculate
 
 
 /* used to install a new clocksource */
-int clocksource_register(struct clocksource*);
-void clocksource_reselect(void);
-struct clocksource* clocksource_get_next(void);
+extern struct clocksource *clocksource_get_next(void);
+extern int clocksource_register(struct clocksource*);
+extern void clocksource_rating_change(struct clocksource*);
+extern struct clocksource * clocksource_get_clock(char*);
 
+/**
+ * clocksource_get_best_clock - Finds highest rated clocksource
+ *
+ * Returns the highest rated clocksource. If none are register the
+ * jiffies clock is returned.
+ */
+static inline struct clocksource * clocksource_get_best_clock(void)
+{
+	return clocksource_get_clock(NULL);
+}
 #endif /* _LINUX_CLOCKSOURCE_H */
diff -puN kernel/time/clocksource.c~clocksource-add-some-new-api-calls kernel/time/clocksource.c
--- a/kernel/time/clocksource.c~clocksource-add-some-new-api-calls
+++ a/kernel/time/clocksource.c
@@ -31,8 +31,6 @@
 
 /* XXX - Would like a better way for initializing curr_clocksource */
 extern struct clocksource clocksource_jiffies;
-static int is_registered_source(struct clocksource *c);
-static struct clocksource *select_clocksource(void);
 
 /*[Clocksource internal variables]---------
  * curr_clocksource:
@@ -40,7 +38,7 @@ static struct clocksource *select_clocks
  * next_clocksource:
  *	pending next selected clocksource.
  * clocksource_list:
- *	linked list with the registered clocksources
+ *	priority list with the registered clocksources
  * clocksource_lock:
  *	protects manipulations to curr_clocksource and next_clocksource
  *	and the clocksource_list
@@ -49,7 +47,7 @@ static struct clocksource *select_clocks
  */
 static struct clocksource *curr_clocksource = &clocksource_jiffies;
 static struct clocksource *next_clocksource;
-static LIST_HEAD(clocksource_list);
+static struct list_head clocksource_list = LIST_HEAD_INIT(clocksource_list);
 static DEFINE_SPINLOCK(clocksource_lock);
 static char override_name[32];
 
@@ -72,10 +70,122 @@ struct clocksource *clocksource_get_next
 }
 
 /**
+ * __is_registered - Returns a clocksource if it's registered
+ * @name:		name of the clocksource to return
+ *
+ * Private function. Must hold clocksource_lock when called.
+ *
+ * Returns the clocksource if registered, zero otherwise.
+ * If no clocksources are registered the jiffies clock is
+ * returned.
+ */
+static struct clocksource * __is_registered(char * name)
+{
+	struct list_head *tmp;
+
+	list_for_each(tmp, &clocksource_list) {
+		struct clocksource *src;
+
+		src = list_entry(tmp, struct clocksource, list);
+		if (!strcmp(src->name, name))
+			return src;
+	}
+
+	return 0;
+}
+
+/**
+ * __get_clock - Finds a specific clocksource
+ * @name:		name of the clocksource to return
+ *
+ * Private function. Must hold clocksource_lock when called.
+ *
+ * Returns the clocksource if registered, zero otherwise.
+ * If the @name is null the highest rated clock is returned.
+ */
+static inline struct clocksource * __get_clock(char * name)
+{
+
+	if (unlikely(list_empty(&clocksource_list)))
+		return &clocksource_jiffies;
+
+	if (!name)
+		return list_entry(clocksource_list.next,
+				  struct clocksource, list);
+
+	return __is_registered(name);
+}
+
+/**
+ * clocksource_get_clock - Finds a specific clocksource
+ * @name:		name of the clocksource to return
+ *
+ * Returns the clocksource if registered, zero otherwise.
+ */
+struct clocksource * clocksource_get_clock(char * name)
+{
+	struct clocksource * ret;
+	unsigned long flags;
+
+	spin_lock_irqsave(&clocksource_lock, flags);
+	ret = __get_clock(name);
+	spin_unlock_irqrestore(&clocksource_lock, flags);
+	return ret;
+}
+
+
+/**
+ * select_clocksource - Finds the best registered clocksource.
+ *
+ * Private function. Must hold clocksource_lock when called.
+ *
+ * Looks through the list of registered clocksources, returning
+ * the one with the highest rating value. If there is a clocksource
+ * name that matches the override string, it returns that clocksource.
+ */
+static struct clocksource *select_clocksource(void)
+{
+	if (!*override_name)
+		return list_entry(clocksource_list.next,
+				  struct clocksource, list);
+
+	return __get_clock(override_name);
+}
+/*
+ * __sorted_list_add - Sorted clocksource add
+ * @c:			clocksource to add
+ *
+ * Adds a clocksource to the clocksource_list in sorted order.
+ */
+static void __sorted_list_add(struct clocksource *c)
+{
+	struct list_head *tmp;
+
+	list_for_each(tmp, &clocksource_list) {
+		struct clocksource *src;
+
+		src = list_entry(tmp, struct clocksource, list);
+
+		if (c->rating > src->rating) {
+			list_add_tail(&c->list, &src->list);
+			return;
+		}
+	}
+
+	/*
+	 * If it's bigger/smaller than all the other entries put it
+	 * at the end.
+	 */
+	list_add_tail(&c->list, &clocksource_list);
+}
+
+/**
  * clocksource_register - Used to install new clocksources
  * @t:		clocksource to be registered
  *
- * Returns -EBUSY if registration fails, zero otherwise.
+ * Returns -EBUSY clock is already registered,
+ * Returns -EINVAL if clocksource is invalid,
+ * Return zero otherwise.
  */
 int clocksource_register(struct clocksource *c)
 {
@@ -83,14 +193,13 @@ int clocksource_register(struct clocksou
 	unsigned long flags;
 
 	spin_lock_irqsave(&clocksource_lock, flags);
-	/* check if clocksource is already registered */
-	if (is_registered_source(c)) {
-		printk("register_clocksource: Cannot register %s. "
+	if (unlikely(!list_empty(&c->list) && __is_registered(c->name))) {
+		printk("register_clocksource: Cannot register %s clocksource. "
 		       "Already registered!", c->name);
 		ret = -EBUSY;
 	} else {
-		/* register it */
- 		list_add(&c->list, &clocksource_list);
+		INIT_LIST_HEAD(&c->list);
+ 		__sorted_list_add(c);
 		/* scan the registered clocksources, and pick the best one */
 		next_clocksource = select_clocksource();
 	}
@@ -100,21 +209,31 @@ int clocksource_register(struct clocksou
 EXPORT_SYMBOL(clocksource_register);
 
 /**
- * clocksource_reselect - Rescan list for next clocksource
+ * clocksource_rating_change - Allows dynamic rating changes for register
+ *                           clocksources.
  *
- * A quick helper function to be used if a clocksource changes its
- * rating. Forces the clocksource list to be re-scanned for the best
- * clocksource.
+ * Signals that a clocksource is dynamically changing it's rating.
+ * This could happen if a clocksource becomes more/less stable.
  */
-void clocksource_reselect(void)
+void clocksource_rating_change(struct clocksource *c)
 {
 	unsigned long flags;
 
+	if (unlikely(list_empty(&c->list)))
+		return;
+
 	spin_lock_irqsave(&clocksource_lock, flags);
+
+	/*
+	 * Re-register the clocksource with it's new rating.
+	 */
+	list_del_init(&c->list);
+	__sorted_list_add(c);
+
 	next_clocksource = select_clocksource();
 	spin_unlock_irqrestore(&clocksource_lock, flags);
 }
-EXPORT_SYMBOL(clocksource_reselect);
+EXPORT_SYMBOL(clocksource_rating_change);
 
 /**
  * sysfs_show_current_clocksources - sysfs interface for current clocksource
@@ -179,7 +298,8 @@ static ssize_t sysfs_override_clocksourc
  * @dev:	unused
  * @buf:	char buffer to be filled with clocksource list
  *
- * Provides sysfs interface for listing registered clocksources
+ * Provides sysfs interface for listing registered clocksources.
+ * Output in priority sorted order.
  */
 static ssize_t
 sysfs_show_available_clocksources(struct sys_device *dev, char *buf)
@@ -277,62 +397,3 @@ static int __init boot_override_clock(ch
 }
 
 __setup("clock=", boot_override_clock);
-
-/**
- * select_clocksource - Finds the best registered clocksource.
- *
- * Private function. Must hold clocksource_lock when called.
- *
- * Looks through the list of registered clocksources, returning
- * the one with the highest rating value. If there is a clocksource
- * name that matches the override string, it returns that clocksource.
- */
-static struct clocksource *select_clocksource(void)
-{
-	struct clocksource *best = NULL;
-	struct list_head *tmp;
-
-	list_for_each(tmp, &clocksource_list) {
-		struct clocksource *src;
-
-		src = list_entry(tmp, struct clocksource, list);
-		if (!best)
-			best = src;
-
-		/* check for override: */
-		if (strlen(src->name) == strlen(override_name) &&
-		    !strcmp(src->name, override_name)) {
-			best = src;
-			break;
-		}
-		/* pick the highest rating: */
-		if (src->rating > best->rating)
-		 	best = src;
-	}
-
-	return best;
-}
-
-/**
- * is_registered_source - Checks if clocksource is registered
- * @c:		pointer to a clocksource
- *
- * Private helper function. Must hold clocksource_lock when called.
- *
- * Returns one if the clocksource is already registered, zero otherwise.
- */
-static int is_registered_source(struct clocksource *c)
-{
-	int len = strlen(c->name);
-	struct list_head *tmp;
-
-	list_for_each(tmp, &clocksource_list) {
-		struct clocksource *src;
-
-		src = list_entry(tmp, struct clocksource, list);
-		if (strlen(src->name) == len &&	!strcmp(src->name, c->name))
-			return 1;
-	}
-
-	return 0;
-}
_

Patches currently in -mm which might be from dwalker@mvista.com are

clocksource-add-usage-of-config_sysfs.patch
clocksource-small-cleanup-2.patch
clocksource-small-cleanup-2-fix.patch
clocksource-small-acpi_pm-cleanup.patch
profile-likely-unlikely-macros.patch
profile_likely-export-do_check_likely.patch

