From: akpm@linux-foundation.org
Subject: + kernel-time-clocksourcec-use-list_for_each_entry-instead-of-list_for_each.patch added to -mm tree
Date: Mon, 23 Jul 2007 14:32:58 -0700
Message-ID: <200707232132.l6NLWwiQ012931@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38848 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759108AbXGWVdj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 17:33:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.kaehlcke@gmail.com, johnstul@us.ibm.com, tglx@linutronix.de


The patch titled
     kernel/time/clocksource.c: Use list_for_each_entry instead of list_for_each
has been added to the -mm tree.  Its filename is
     kernel-time-clocksourcec-use-list_for_each_entry-instead-of-list_for_each.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kernel/time/clocksource.c: Use list_for_each_entry instead of list_for_each
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

kernel/time/clocksource.c: Convert list_for_each to
list_for_each_entry in clocksource_resume(),
sysfs_override_clocksource() and show_available_clocksources()

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/clocksource.c |   22 +++++++---------------
 1 files changed, 7 insertions(+), 15 deletions(-)

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

kcopyd-use-mutex-instead-of-semaphore.patch
git-mtd.patch
videopix-frame-grabber-fix-unreleased-lock-in-vfc_debug.patch
fs-file_tablec-use-list_for_each_entry-instead-of-list_for_each.patch
fs-eventpollc-use-list_for_each_entry-instead-of-list_for_each.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
fs-locksc-use-list_for_each_entry-instead-of-list_for_each.patch
kernel-exitc-use-list_for_each_entry_safe-instead-of-list_for_each_safe.patch
kernel-time-clocksourcec-use-list_for_each_entry-instead-of-list_for_each.patch
mm-oom_killc-use-list_for_each_entry-instead-of-list_for_each.patch
kernel-userc-use-list_for_each_entry-instead-of-list_for_each.patch
