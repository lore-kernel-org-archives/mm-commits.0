From: akpm@linux-foundation.org
Subject: - pm_trace-displays-the-wrong-time-from-the-rtc.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:41:07 -0700
Message-ID: <200710190341.l9J3f7V6012773@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52925 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934536AbXJSD4D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:56:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, davej@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pm_trace displays the wrong time from the RTC
has been removed from the -mm tree.  Its filename was
     pm_trace-displays-the-wrong-time-from-the-rtc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pm_trace displays the wrong time from the RTC
From: "Rafael J. Wysocki" <rjw@sisk.pl>

The way in which read_magic_time() displays the date read from the RTC is
apparently confusing to the users (cf. 
https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=250238).  Make it
print dates in the standard way.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Dave Jones <davej@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/power/trace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
git-acpi.patch
revert-x86_64-mm-cpa-einval.patch
shrink_slab-handle-bad-shrinkers.patch
