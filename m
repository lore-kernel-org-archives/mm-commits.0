From: akpm@linux-foundation.org
Subject: - time-fix-sysfs_show_availablecurrent_clocksources-buffer-overflow-problem.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:22:25 -0800
Message-ID: <200802070022.m170M6oZ006395@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46402 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932807AbYBGAp6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:45:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: miaox@cn.fujitsu.com, johnstul@us.ibm.com, tglx@linutronix.de, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     time: fix sysfs_show_{available,current}_clocksources() buffer overflow problem
has been removed from the -mm tree.  Its filename was
     time-fix-sysfs_show_availablecurrent_clocksources-buffer-overflow-problem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: time: fix sysfs_show_{available,current}_clocksources() buffer overflow problem
From: Miao Xie <miaox@cn.fujitsu.com>

I found that there is a buffer overflow problem in the following code.

Version:	2.6.24-rc2,
File:		kernel/time/clocksource.c:417-432
--------------------------------------------------------------------
static ssize_t
sysfs_show_available_clocksources(struct sys_device *dev, char *buf)
{
	struct clocksource *src;
	char *curr = buf;

	spin_lock_irq(&clocksource_lock);
	list_for_each_entry(src, &clocksource_list, list) {
		curr += sprintf(curr, "%s ", src->name);
	}
	spin_unlock_irq(&clocksource_lock);

	curr += sprintf(curr, "\n");

	return curr - buf;
}
-----------------------------------------------------------------------

sysfs_show_current_clocksources() also has the same problem though in practice
the size of current clocksource's name won't exceed PAGE_SIZE.

I fix the bug by using snprintf according to the specification of the kernel
(Version:2.6.24-rc2,File:Documentation/filesystems/sysfs.txt)

Fix sysfs_show_available_clocksources() and sysfs_show_current_clocksources()
buffer overflow problem with snprintf().

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/clocksource.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff -puN kernel/time/clocksource.c~time-fix-sysfs_show_availablecurrent_clocksources-buffer-overflow-problem kernel/time/clocksource.c
--- a/kernel/time/clocksource.c~time-fix-sysfs_show_availablecurrent_clocksources-buffer-overflow-problem
+++ a/kernel/time/clocksource.c
@@ -363,15 +363,13 @@ void clocksource_unregister(struct clock
 static ssize_t
 sysfs_show_current_clocksources(struct sys_device *dev, char *buf)
 {
-	char *curr = buf;
+	ssize_t count = 0;
 
 	spin_lock_irq(&clocksource_lock);
-	curr += sprintf(curr, "%s ", curr_clocksource->name);
+	count = snprintf(buf, PAGE_SIZE, "%s\n", curr_clocksource->name);
 	spin_unlock_irq(&clocksource_lock);
 
-	curr += sprintf(curr, "\n");
-
-	return curr - buf;
+	return count;
 }
 
 /**
@@ -439,17 +437,20 @@ static ssize_t
 sysfs_show_available_clocksources(struct sys_device *dev, char *buf)
 {
 	struct clocksource *src;
-	char *curr = buf;
+	ssize_t count = 0;
 
 	spin_lock_irq(&clocksource_lock);
 	list_for_each_entry(src, &clocksource_list, list) {
-		curr += sprintf(curr, "%s ", src->name);
+		count += snprintf(buf + count,
+				  max((ssize_t)PAGE_SIZE - count, (ssize_t)0),
+				  "%s ", src->name);
 	}
 	spin_unlock_irq(&clocksource_lock);
 
-	curr += sprintf(curr, "\n");
+	count += snprintf(buf + count,
+			  max((ssize_t)PAGE_SIZE - count, (ssize_t)0), "\n");
 
-	return curr - buf;
+	return count;
 }
 
 /*
_

Patches currently in -mm which might be from miaox@cn.fujitsu.com are

origin.patch
