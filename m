From: akpm@linux-foundation.org
Subject: + clocksource-fix-permissions-for-available_clocksource.patch added to -mm tree
Date: Fri, 02 May 2008 05:45:00 -0700
Message-ID: <200805021245.m42Cj08Y026707@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39406 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759535AbYEBMqx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 08:46:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, johnstul@us.ibm.com, tglx@linutronix.de


The patch titled
     clocksource: fix permissions for available_clocksource
has been added to the -mm tree.  Its filename is
     clocksource-fix-permissions-for-available_clocksource.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: clocksource: fix permissions for available_clocksource
From: Heiko Carstens <heiko.carstens@de.ibm.com>

File permissions for
/sys/devices/system/clocksource/clocksource0/available_clocksource are 600
which allows write access.  But this is in fact a read only file.  So change
permissions to 400.

Cc: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/clocksource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/time/clocksource.c~clocksource-fix-permissions-for-available_clocksource kernel/time/clocksource.c
--- a/kernel/time/clocksource.c~clocksource-fix-permissions-for-available_clocksource
+++ a/kernel/time/clocksource.c
@@ -474,7 +474,7 @@ sysfs_show_available_clocksources(struct
 static SYSDEV_ATTR(current_clocksource, 0600, sysfs_show_current_clocksources,
 		   sysfs_override_clocksource);
 
-static SYSDEV_ATTR(available_clocksource, 0600,
+static SYSDEV_ATTR(available_clocksource, 0400,
 		   sysfs_show_available_clocksources, NULL);
 
 static struct sysdev_class clocksource_sysclass = {
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

origin.patch
git-kvm.patch
git-sched.patch
clocksource-fix-permissions-for-available_clocksource.patch

