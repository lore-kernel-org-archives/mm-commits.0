From: akpm@linux-foundation.org
Subject: - kernel-time-clocksourcec-use-list_for_each_entry-instead-of-list_for_each.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:51:12 -0700
Message-ID: <200710192251.l9JMpCqh024164@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35602 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966792AbXJSXGb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:06:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias.kaehlcke@gmail.com, johnstul@us.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     kernel/time/clocksource.c: Use list_for_each_entry instead of list_for_each
has been removed from the -mm tree.  Its filename was
     kernel-time-clocksourcec-use-list_for_each_entry-instead-of-list_for_each.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kernel/time/clocksource.c: Use list_for_each_entry instead of list_for_each
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

kernel/time/clocksource.c: Convert list_for_each to
list_for_each_entry in clocksource_resume(),
sysfs_override_clocksource() and show_available_clocksources()

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/clocksource.c |   22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff -puN kernel/time/clocksource.c~kernel-time-clocksourcec-use-list_for_each_entry-instead-of-list_for_each kernel/time/clocksource.c
--- a/kernel/time/clocksource.c~kernel-time-clocksourcec-use-list_for_each_entry-instead-of-list_for_each
+++ a/kernel/time/clocksource.c
@@ -207,15 +207,12 @@ static inline void clocksource_resume_wa
  */
 void clocksource_resume(void)
 {
-	struct list_head *tmp;
+	struct clocksource *cs;
 	unsigned long flags;
 
 	spin_lock_irqsave(&clocksource_lock, flags);
 
-	list_for_each(tmp, &clocksource_list) {
-		struct clocksource *cs;
-
-		cs = list_entry(tmp, struct clocksource, list);
+	list_for_each_entry(cs, &clocksource_list, list) {
 		if (cs->resume)
 			cs->resume();
 	}
@@ -369,7 +366,6 @@ static ssize_t sysfs_override_clocksourc
 					  const char *buf, size_t count)
 {
 	struct clocksource *ovr = NULL;
-	struct list_head *tmp;
 	size_t ret = count;
 	int len;
 
@@ -389,12 +385,11 @@ static ssize_t sysfs_override_clocksourc
 
 	len = strlen(override_name);
 	if (len) {
+		struct clocksource *cs;
+
 		ovr = clocksource_override;
 		/* try to select it: */
-		list_for_each(tmp, &clocksource_list) {
-			struct clocksource *cs;
-
-			cs = list_entry(tmp, struct clocksource, list);
+		list_for_each_entry(cs, &clocksource_list, list) {
 			if (strlen(cs->name) == len &&
 			    !strcmp(cs->name, override_name))
 				ovr = cs;
@@ -422,14 +417,11 @@ static ssize_t sysfs_override_clocksourc
 static ssize_t
 sysfs_show_available_clocksources(struct sys_device *dev, char *buf)
 {
-	struct list_head *tmp;
+	struct clocksource *src;
 	char *curr = buf;
 
 	spin_lock_irq(&clocksource_lock);
-	list_for_each(tmp, &clocksource_list) {
-		struct clocksource *src;
-
-		src = list_entry(tmp, struct clocksource, list);
+	list_for_each_entry(src, &clocksource_list, list) {
 		curr += sprintf(curr, "%s ", src->name);
 	}
 	spin_unlock_irq(&clocksource_lock);
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

origin.patch
generic-ac97-mixer-modem-oss-use-list_for_each_entry.patch
ftdi-elan-driver-convert-ftdi-u132_lock-to-mutex.patch
