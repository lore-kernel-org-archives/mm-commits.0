From: akpm@linux-foundation.org
Subject: - swsusp-change-code-order-in-diskc-fix.patch removed from -mm tree
Date: Sat, 10 Feb 2007 01:39:09 -0800
Message-ID: <200702100939.l1A9d9N6008339@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41149 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210AbXBJJjY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 Feb 2007 04:39:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexey.y.starikovskiy@linux.intel.com, greg@kroah.com, mochel@digitalimplant.org, nigel@suspend2.net, pavel@ucw.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     Fix swsusp-change-code-order-in-diskc.patch
has been removed from the -mm tree.  Its filename was
     swsusp-change-code-order-in-diskc-fix.patch

This patch was dropped because it was folded into swsusp-change-code-ordering-in-diskc.patch

------------------------------------------------------
Subject: Fix swsusp-change-code-order-in-diskc.patch
From: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>

Recent patch from Rafael changed the order of platform_prepare() and
swsusp_read(). platform_prepare() should happen before swsusp_read()
in order to get nice LED blinking during load of the image and time for
GPE activity to settle down.

LED blinking and time for GPE activity to stop.

Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <greg@kroah.com>
Cc: Nigel Cunningham <nigel@suspend2.net>
Cc: Patrick Mochel <mochel@digitalimplant.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/disk.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN kernel/power/disk.c~swsusp-change-code-order-in-diskc-fix kernel/power/disk.c
--- a/kernel/power/disk.c~swsusp-change-code-order-in-diskc-fix
+++ a/kernel/power/disk.c
@@ -240,21 +240,22 @@ static int software_resume(void)
 		goto Done;
 	}
 
-	pr_debug("PM: Reading swsusp image.\n");
-
-	error = swsusp_read();
+	error = platform_prepare();
 	if (error) {
 		swsusp_free();
 		goto Thaw;
 	}
 
-	pr_debug("PM: Preparing devices for restore.\n");
+	pr_debug("PM: Reading swsusp image.\n");
 
-	error = platform_prepare();
+	error = swsusp_read();
 	if (error) {
 		swsusp_free();
 		goto Thaw;
 	}
+
+	pr_debug("PM: Preparing devices for restore.\n");
+
 	suspend_console();
 	error = device_suspend(PMSG_PRETHAW);
 	if (error)
_

Patches currently in -mm which might be from alexey.y.starikovskiy@linux.intel.com are

origin.patch
swsusp-change-code-ordering-in-diskc.patch
swsusp-change-code-order-in-diskc-fix.patch
