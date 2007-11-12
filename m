From: akpm@linux-foundation.org
Subject: + time-fix-sysfs_show_availablecurrent_clocksources-buffer-overflow-problem.patch added to -mm tree
Date: Mon, 12 Nov 2007 13:20:11 -0800
Message-ID: <200711122120.lACLKBAQ009532@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48064 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752779AbXKLVZx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 16:25:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: miaox@cn.fujitsu.com, johnstul@us.ibm.com, tglx@linutronix.de, xiyou.wangcong@gmail.com


The patch titled
     time: fix sysfs_show_{available,current}_clocksources() buffer overflow problem
has been added to the -mm tree.  Its filename is
     time-fix-sysfs_show_availablecurrent_clocksources-buffer-overflow-problem.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -342,15 +342,13 @@ void clocksource_change_rating(struct cl
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
@@ -418,17 +416,20 @@ static ssize_t
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

sysfs-fix-off-by-one-error-in-fill_read_buffer.patch
time-fix-sysfs_show_availablecurrent_clocksources-buffer-overflow-problem.patch
