From: akpm@linux-foundation.org
Subject: - clocksource-fix-permissions-for-available_clocksource.patch removed from -mm tree
Date: Mon, 05 May 2008 12:17:17 -0700
Message-ID: <200805051917.m45JHH9E000464@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40625 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751475AbYEETSs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2008 15:18:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, johnstul@us.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     clocksource: fix permissions for available_clocksource
has been removed from the -mm tree.  Its filename was
     clocksource-fix-permissions-for-available_clocksource.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
linux-next.patch

