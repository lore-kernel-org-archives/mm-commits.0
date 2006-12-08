From: akpm@osdl.org
Subject: - clocksource-move-old-api-calls.patch removed from -mm tree
Date: Fri, 08 Dec 2006 03:05:33 -0800
Message-ID: <200612081105.kB8B5XQN018651@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49555 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425399AbWLHLLh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 06:11:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     clocksource: move old API calls
has been removed from the -mm tree.  Its filename was
     clocksource-move-old-api-calls.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: clocksource: move old API calls
From: Daniel Walker <dwalker@mvista.com>

I added this to make the next few patches cleaner.  The mixing of code removal
and code addition can make a patchset harder to read.

There's nothing new here from the first patchset, it just moves some code out
of the way.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/time/clocksource.c |  120 ++++++++++++++++++------------------
 1 file changed, 61 insertions(+), 59 deletions(-)

diff -puN kernel/time/clocksource.c~clocksource-move-old-api-calls kernel/time/clocksource.c
--- a/kernel/time/clocksource.c~clocksource-move-old-api-calls
+++ a/kernel/time/clocksource.c
@@ -31,6 +31,8 @@
 
 /* XXX - Would like a better way for initializing curr_clocksource */
 extern struct clocksource clocksource_jiffies;
+static int is_registered_source(struct clocksource *c);
+static struct clocksource *select_clocksource(void);
 
 /*[Clocksource internal variables]---------
  * curr_clocksource:
@@ -70,65 +72,6 @@ struct clocksource *clocksource_get_next
 }
 
 /**
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
-
-/**
  * clocksource_register - Used to install new clocksources
  * @t:		clocksource to be registered
  *
@@ -334,3 +277,62 @@ static int __init boot_override_clock(ch
 }
 
 __setup("clock=", boot_override_clock);
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
+	struct clocksource *best = NULL;
+	struct list_head *tmp;
+
+	list_for_each(tmp, &clocksource_list) {
+		struct clocksource *src;
+
+		src = list_entry(tmp, struct clocksource, list);
+		if (!best)
+			best = src;
+
+		/* check for override: */
+		if (strlen(src->name) == strlen(override_name) &&
+		    !strcmp(src->name, override_name)) {
+			best = src;
+			break;
+		}
+		/* pick the highest rating: */
+		if (src->rating > best->rating)
+		 	best = src;
+	}
+
+	return best;
+}
+
+/**
+ * is_registered_source - Checks if clocksource is registered
+ * @c:		pointer to a clocksource
+ *
+ * Private helper function. Must hold clocksource_lock when called.
+ *
+ * Returns one if the clocksource is already registered, zero otherwise.
+ */
+static int is_registered_source(struct clocksource *c)
+{
+	int len = strlen(c->name);
+	struct list_head *tmp;
+
+	list_for_each(tmp, &clocksource_list) {
+		struct clocksource *src;
+
+		src = list_entry(tmp, struct clocksource, list);
+		if (strlen(src->name) == len &&	!strcmp(src->name, c->name))
+			return 1;
+	}
+
+	return 0;
+}
_

Patches currently in -mm which might be from dwalker@mvista.com are

clocksource-add-usage-of-config_sysfs.patch
clocksource-small-cleanup-2.patch
clocksource-small-cleanup-2-fix.patch
clocksource-small-acpi_pm-cleanup.patch
profile-likely-unlikely-macros.patch
profile_likely-export-do_check_likely.patch

