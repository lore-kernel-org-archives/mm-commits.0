From: akpm@linux-foundation.org
Subject: + pm_trace-displays-the-wrong-time-from-the-rtc.patch added to -mm tree
Date: Wed, 01 Aug 2007 14:19:43 -0700
Message-ID: <200708012119.l71LJhFP017981@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53519 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752289AbXHAVUb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2007 17:20:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl


The patch titled
     pm_trace displays the wrong time from the RTC
has been added to the -mm tree.  Its filename is
     pm_trace-displays-the-wrong-time-from-the-rtc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pm_trace displays the wrong time from the RTC
From: "Rafael J. Wysocki" <rjw@sisk.pl>

The way in which read_magic_time() displays the date read from the RTC is
apparently confusing to the users (cf. 
https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=250238).  Make it
print dates in the standard way.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/power/trace.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/base/power/trace.c~pm_trace-displays-the-wrong-time-from-the-rtc drivers/base/power/trace.c
--- a/drivers/base/power/trace.c~pm_trace-displays-the-wrong-time-from-the-rtc
+++ a/drivers/base/power/trace.c
@@ -114,7 +114,7 @@ static unsigned int read_magic_time(void
 	get_rtc_time(&time);
 	printk("Time: %2d:%02d:%02d  Date: %02d/%02d/%02d\n",
 		time.tm_hour, time.tm_min, time.tm_sec,
-		time.tm_mon, time.tm_mday, time.tm_year);
+		time.tm_mon + 1, time.tm_mday, time.tm_year % 100);
 	val = time.tm_year;				/* 100 years */
 	if (val > 100)
 		val -= 100;
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
pm-move-definition-of-struct-pm_ops-to-suspendh.patch
pm-rename-struct-pm_ops-and-related-things.patch
pm-rework-struct-platform_suspend_ops.patch
pm-make-suspend_ops-static.patch
pm-rework-struct-hibernation_ops.patch
pm-rename-hibernation_ops-to-platform_hibernation_ops.patch
freezer-document-relationship-with-memory-shrinking.patch
freezer-do-not-sync-filesystems-from-freeze_processes.patch
freezer-prevent-new-tasks-from-inheriting-tif_freeze-set.patch
freezer-introduce-freezer-firendly-waiting-macros.patch
freezer-do-not-send-signals-to-kernel-threads.patch
unexport-pm_power_off_prepare.patch
pm_trace-displays-the-wrong-time-from-the-rtc.patch
shrink_slab-handle-bad-shrinkers.patch
