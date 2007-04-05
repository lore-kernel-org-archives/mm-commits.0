From: akpm@linux-foundation.org
Subject: - clocksource-refactor-duplicate-registration-checking.patch removed from -mm tree
Date: Thu, 05 Apr 2007 12:29:10 -0700
Message-ID: <200704051929.l35JTANQ024073@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49194 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209AbXDETfm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 5 Apr 2007 15:35:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, ak@suse.de, grundler@parisc-linux.org, heiko.carstens@de.ibm.com, hskinnemoen@atmel.com, johnstul@us.ibm.com, kyle@mcmartin.ca, mingo@elte.hu, ralf@linux-mips.org, rmk@arm.linux.org.uk, tglx@linutronix.de, willy@debian.org, mm-commits@vger.kernel.org


The patch titled
     clocksource: refactor duplicate registration checking
has been removed from the -mm tree.  Its filename was
     clocksource-refactor-duplicate-registration-checking.patch

This patch was dropped because of general bunfight

------------------------------------------------------
Subject: clocksource: refactor duplicate registration checking
From: Daniel Walker <dwalker@mvista.com>

Refactors the duplicate registration checking. This makes it based on the
clocksource structure list state. I was able to drop some if statements
making the registration code path slightly smaller and faster, and remove
some looping which was endemic of the first version of this check.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Matthew Wilcox <willy@debian.org>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/clocksource.h |    2 +-
 kernel/time/clocksource.c   |   30 ++++++++++++++++++------------
 kernel/time/jiffies.c       |    1 +
 3 files changed, 20 insertions(+), 13 deletions(-)

diff -puN include/linux/clocksource.h~clocksource-refactor-duplicate-registration-checking include/linux/clocksource.h
--- a/include/linux/clocksource.h~clocksource-refactor-duplicate-registration-checking
+++ a/include/linux/clocksource.h
@@ -26,7 +26,7 @@ struct clocksource;
  *	Provides mostly state-free accessors to the underlying hardware.
  *
  * @name:		ptr to clocksource name
- * @list:		list head for registration
+ * @list:		list head for registration, must be initialized.
  * @rating:		rating value for selection (higher is better)
  *			To avoid rating inflation the following
  *			list should give you a guide as to how
diff -puN kernel/time/clocksource.c~clocksource-refactor-duplicate-registration-checking kernel/time/clocksource.c
--- a/kernel/time/clocksource.c~clocksource-refactor-duplicate-registration-checking
+++ a/kernel/time/clocksource.c
@@ -232,7 +232,7 @@ static struct clocksource *select_clocks
 /*
  * Enqueue the clocksource sorted by rating
  */
-static int clocksource_enqueue(struct clocksource *c)
+static void clocksource_enqueue(struct clocksource *c)
 {
 	struct list_head *tmp, *entry = &clocksource_list;
 
@@ -240,8 +240,7 @@ static int clocksource_enqueue(struct cl
 		struct clocksource *cs;
 
 		cs = list_entry(tmp, struct clocksource, list);
-		if (cs == c)
-			return -EBUSY;
+
 		/* Keep track of the place, where to insert */
 		if (cs->rating >= c->rating)
 			entry = tmp;
@@ -252,28 +251,35 @@ static int clocksource_enqueue(struct cl
 	    !strcmp(c->name, override_name))
 		clocksource_override = c;
 
-	return 0;
 }
 
 /**
  * clocksource_register - Used to install new clocksources
  * @t:		clocksource to be registered
  *
- * Returns -EBUSY if registration fails, zero otherwise.
+ * Always returns zero.
  */
 int clocksource_register(struct clocksource *c)
 {
 	unsigned long flags;
-	int ret;
+
+	/*
+	 * This BUGON indicates that either the clocksource has been
+	 * registered already, or the list element hasn't been properly
+	 * initialized.
+	 */
+	BUG_ON(!list_empty(&c->list));
 
 	spin_lock_irqsave(&clocksource_lock, flags);
-	ret = clocksource_enqueue(c);
-	if (!ret)
-		next_clocksource = select_clocksource();
+
+	clocksource_enqueue(c);
+	next_clocksource = select_clocksource();
+
 	spin_unlock_irqrestore(&clocksource_lock, flags);
-	if (!ret)
-		clocksource_check_watchdog(c);
-	return ret;
+
+	clocksource_check_watchdog(c);
+
+	return 0;
 }
 EXPORT_SYMBOL(clocksource_register);
 
diff -puN kernel/time/jiffies.c~clocksource-refactor-duplicate-registration-checking kernel/time/jiffies.c
--- a/kernel/time/jiffies.c~clocksource-refactor-duplicate-registration-checking
+++ a/kernel/time/jiffies.c
@@ -62,6 +62,7 @@ struct clocksource clocksource_jiffies =
 	.mask		= 0xffffffff, /*32bits*/
 	.mult		= NSEC_PER_JIFFY << JIFFIES_SHIFT, /* details above */
 	.shift		= JIFFIES_SHIFT,
+	.list		= LIST_HEAD_INIT(clocksource_jiffies.list),
 };
 
 static int __init init_jiffies_clocksource(void)
_

Patches currently in -mm which might be from dwalker@mvista.com are

clocksource-refactor-duplicate-registration-checking.patch
slim-make-and-config-stuff.patch
profile-likely-unlikely-macros.patch
