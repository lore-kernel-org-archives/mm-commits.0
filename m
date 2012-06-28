From: akpm@linux-foundation.org
Subject: [merged] drivers-char-ipmi-ipmi_watchdogc-remove-local-ioctl-defines-replaced-by-generic-ones.patch removed from -mm tree
Date: Thu, 28 Jun 2012 11:40:14 -0700
Message-ID: <20120628184016.54B73A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:52077 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197Ab2F1SkT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jun 2012 14:40:19 -0400
Received: by eeit10 with SMTP id t10so144467eei.1
        for <mm-commits@vger.kernel.org>; Thu, 28 Jun 2012 11:40:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oskar@scara.com, minyard@acm.org, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/char/ipmi/ipmi_watchdog.c: remove local ioctl defines replaced by generic ones
has been removed from the -mm tree.  Its filename was
     drivers-char-ipmi-ipmi_watchdogc-remove-local-ioctl-defines-replaced-by-generic-ones.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: "Oskar Schirmer" <oskar@scara.com>
Subject: drivers/char/ipmi/ipmi_watchdog.c: remove local ioctl defines replaced by generic ones

This watchdog driver had ioctl defines introduced locally for pre timeout
handling, marked to be removed as soon as a generic replacement would
become available.

The latter has actually occurred in 2006, at e05b59fe.

Remove the local duplicates for pre timeout handling.

Signed-off-by: Oskar Schirmer <oskar@scara.com>
Cc: Corey Minyard <minyard@acm.org>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_watchdog.c |   13 -------------
 1 file changed, 13 deletions(-)

diff -puN drivers/char/ipmi/ipmi_watchdog.c~drivers-char-ipmi-ipmi_watchdogc-remove-local-ioctl-defines-replaced-by-generic-ones drivers/char/ipmi/ipmi_watchdog.c
--- a/drivers/char/ipmi/ipmi_watchdog.c~drivers-char-ipmi-ipmi_watchdogc-remove-local-ioctl-defines-replaced-by-generic-ones
+++ a/drivers/char/ipmi/ipmi_watchdog.c
@@ -141,17 +141,6 @@
 
 #define IPMI_WDOG_TIMER_NOT_INIT_RESP	0x80
 
-/* These are here until the real ones get into the watchdog.h interface. */
-#ifndef WDIOC_GETTIMEOUT
-#define	WDIOC_GETTIMEOUT        _IOW(WATCHDOG_IOCTL_BASE, 20, int)
-#endif
-#ifndef WDIOC_SET_PRETIMEOUT
-#define	WDIOC_SET_PRETIMEOUT     _IOW(WATCHDOG_IOCTL_BASE, 21, int)
-#endif
-#ifndef WDIOC_GET_PRETIMEOUT
-#define	WDIOC_GET_PRETIMEOUT     _IOW(WATCHDOG_IOCTL_BASE, 22, int)
-#endif
-
 static DEFINE_MUTEX(ipmi_watchdog_mutex);
 static bool nowayout = WATCHDOG_NOWAYOUT;
 
@@ -732,7 +721,6 @@ static int ipmi_ioctl(struct file *file,
 			return -EFAULT;
 		return 0;
 
-	case WDIOC_SET_PRETIMEOUT:
 	case WDIOC_SETPRETIMEOUT:
 		i = copy_from_user(&val, argp, sizeof(int));
 		if (i)
@@ -740,7 +728,6 @@ static int ipmi_ioctl(struct file *file,
 		pretimeout = val;
 		return ipmi_set_timeout(IPMI_SET_TIMEOUT_HB_IF_NECESSARY);
 
-	case WDIOC_GET_PRETIMEOUT:
 	case WDIOC_GETPRETIMEOUT:
 		i = copy_to_user(argp, &pretimeout, sizeof(pretimeout));
 		if (i)
_

Patches currently in -mm which might be from oskar@scara.com are

linux-next.patch

