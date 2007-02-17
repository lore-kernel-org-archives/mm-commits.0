From: akpm@linux-foundation.org
Subject: - simplify-the-registration-of-clocksources.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:13:44 -0800
Message-ID: <200702170713.l1H7Di51021475@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51439 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946445AbXBQHWN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:22:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, johnstul@us.ibm.com, mingo@elte.hu, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Simplify the registration of clocksources
has been removed from the -mm tree.  Its filename was
     simplify-the-registration-of-clocksources.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Simplify the registration of clocksources
From: Thomas Gleixner <tglx@linutronix.de>

Enqueue clocksources in rating order to make selection of the clocksource
easier.  Also check the match with an user override at enqueue time.

Preparatory patch for the generic clocksource verification.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/tsc.c      |    3 
 include/linux/clocksource.h |    6 -
 kernel/time/clocksource.c   |  118 ++++++++++++++++------------------
 3 files changed, 61 insertions(+), 66 deletions(-)

diff -puN arch/i386/kernel/tsc.c~simplify-the-registration-of-clocksources arch/i386/kernel/tsc.c
--- a/arch/i386/kernel/tsc.c~simplify-the-registration-of-clocksources
+++ a/arch/i386/kernel/tsc.c
@@ -323,8 +323,7 @@ static int tsc_update_callback(void)
 
 	/* check to see if we should switch to the safe clocksource: */
 	if (clocksource_tsc.rating != 0 && check_tsc_unstable()) {
-		clocksource_tsc.rating = 0;
-		clocksource_reselect();
+		clocksource_change_rating(&clocksource_tsc, 0);
 		change = 1;
 	}
 
diff -puN include/linux/clocksource.h~simplify-the-registration-of-clocksources include/linux/clocksource.h
--- a/include/linux/clocksource.h~simplify-the-registration-of-clocksources
+++ a/include/linux/clocksource.h
@@ -178,8 +178,8 @@ static inline void clocksource_calculate
 
 
 /* used to install a new clocksource */
-int clocksource_register(struct clocksource*);
-void clocksource_reselect(void);
-struct clocksource* clocksource_get_next(void);
+extern int clocksource_register(struct clocksource*);
+extern struct clocksource* clocksource_get_next(void);
+extern void clocksource_change_rating(struct clocksource *cs, int rating);
 
 #endif /* _LINUX_CLOCKSOURCE_H */
diff -puN kernel/time/clocksource.c~simplify-the-registration-of-clocksources kernel/time/clocksource.c
--- a/kernel/time/clocksource.c~simplify-the-registration-of-clocksources
+++ a/kernel/time/clocksource.c
@@ -48,6 +48,7 @@ extern struct clocksource clocksource_ji
  */
 static struct clocksource *curr_clocksource = &clocksource_jiffies;
 static struct clocksource *next_clocksource;
+static struct clocksource *clocksource_override;
 static LIST_HEAD(clocksource_list);
 static DEFINE_SPINLOCK(clocksource_lock);
 static char override_name[32];
@@ -84,60 +85,46 @@ struct clocksource *clocksource_get_next
 }
 
 /**
- * select_clocksource - Finds the best registered clocksource.
+ * select_clocksource - Selects the best registered clocksource.
  *
  * Private function. Must hold clocksource_lock when called.
  *
- * Looks through the list of registered clocksources, returning
- * the one with the highest rating value. If there is a clocksource
- * name that matches the override string, it returns that clocksource.
+ * Select the clocksource with the best rating, or the clocksource,
+ * which is selected by userspace override.
  */
 static struct clocksource *select_clocksource(void)
 {
-	struct clocksource *best = NULL;
-	struct list_head *tmp;
-
-	list_for_each(tmp, &clocksource_list) {
-		struct clocksource *src;
+	if (list_empty(&clocksource_list))
+		return NULL;
 
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
+	if (clocksource_override)
+		return clocksource_override;
 
-	return best;
+	return list_entry(clocksource_list.next, struct clocksource, list);
 }
 
-/**
- * is_registered_source - Checks if clocksource is registered
- * @c:		pointer to a clocksource
- *
- * Private helper function. Must hold clocksource_lock when called.
- *
- * Returns one if the clocksource is already registered, zero otherwise.
+/*
+ * Enqueue the clocksource sorted by rating
  */
-static int is_registered_source(struct clocksource *c)
+static int clocksource_enqueue(struct clocksource *c)
 {
-	int len = strlen(c->name);
-	struct list_head *tmp;
+	struct list_head *tmp, *entry = &clocksource_list;
 
 	list_for_each(tmp, &clocksource_list) {
-		struct clocksource *src;
+		struct clocksource *cs;
 
-		src = list_entry(tmp, struct clocksource, list);
-		if (strlen(src->name) == len &&	!strcmp(src->name, c->name))
-			return 1;
+		cs = list_entry(tmp, struct clocksource, list);
+		if (cs == c)
+			return -EBUSY;
+		/* Keep track of the place, where to insert */
+		if (cs->rating >= c->rating)
+			entry = tmp;
 	}
+	list_add(&c->list, entry);
+
+	if (strlen(c->name) == strlen(override_name) &&
+	    !strcmp(c->name, override_name))
+		clocksource_override = c;
 
 	return 0;
 }
@@ -150,42 +137,32 @@ static int is_registered_source(struct c
  */
 int clocksource_register(struct clocksource *c)
 {
-	int ret = 0;
 	unsigned long flags;
+	int ret = 0;
 
 	spin_lock_irqsave(&clocksource_lock, flags);
-	/* check if clocksource is already registered */
-	if (is_registered_source(c)) {
-		printk("register_clocksource: Cannot register %s. "
-		       "Already registered!", c->name);
-		ret = -EBUSY;
-	} else {
-		/* register it */
- 		list_add(&c->list, &clocksource_list);
-		/* scan the registered clocksources, and pick the best one */
+	ret = clocksource_enqueue(c);
+	if (!ret)
 		next_clocksource = select_clocksource();
-	}
 	spin_unlock_irqrestore(&clocksource_lock, flags);
 	return ret;
 }
 EXPORT_SYMBOL(clocksource_register);
 
 /**
- * clocksource_reselect - Rescan list for next clocksource
+ * clocksource_change_rating - Change the rating of a registered clocksource
  *
- * A quick helper function to be used if a clocksource changes its
- * rating. Forces the clocksource list to be re-scanned for the best
- * clocksource.
  */
-void clocksource_reselect(void)
+void clocksource_change_rating(struct clocksource *cs, int rating)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&clocksource_lock, flags);
+	list_del(&cs->list);
+	clocksource_enqueue(cs);
 	next_clocksource = select_clocksource();
 	spin_unlock_irqrestore(&clocksource_lock, flags);
 }
-EXPORT_SYMBOL(clocksource_reselect);
 
 #ifdef CONFIG_SYSFS
 /**
@@ -221,7 +198,11 @@ sysfs_show_current_clocksources(struct s
 static ssize_t sysfs_override_clocksource(struct sys_device *dev,
 					  const char *buf, size_t count)
 {
+	struct clocksource *ovr = NULL;
+	struct list_head *tmp;
 	size_t ret = count;
+	int len;
+
 	/* strings from sysfs write are not 0 terminated! */
 	if (count >= sizeof(override_name))
 		return -EINVAL;
@@ -229,17 +210,32 @@ static ssize_t sysfs_override_clocksourc
 	/* strip of \n: */
 	if (buf[count-1] == '\n')
 		count--;
-	if (count < 1)
-		return -EINVAL;
 
 	spin_lock_irq(&clocksource_lock);
 
-	/* copy the name given: */
-	memcpy(override_name, buf, count);
+	if (count > 0)
+		memcpy(override_name, buf, count);
 	override_name[count] = 0;
 
-	/* try to select it: */
-	next_clocksource = select_clocksource();
+	len = strlen(override_name);
+	if (len) {
+		ovr = clocksource_override;
+		/* try to select it: */
+		list_for_each(tmp, &clocksource_list) {
+			struct clocksource *cs;
+
+			cs = list_entry(tmp, struct clocksource, list);
+			if (strlen(cs->name) == len &&
+			    !strcmp(cs->name, override_name))
+				ovr = cs;
+		}
+	}
+
+	/* Reselect, when the override name has changed */
+	if (ovr != clocksource_override) {
+		clocksource_override = ovr;
+		next_clocksource = select_clocksource();
+	}
 
 	spin_unlock_irq(&clocksource_lock);
 
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-acpi.patch
git-block.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-3.patch
