From: akpm@linux-foundation.org
Subject: + drivers-char-ipmi-ipmi_watchdogc-remove-local-ioctl-defines-replaced-by-generic-ones.patch added to -mm tree
Date: Fri, 08 Jun 2012 13:13:22 -0700
Message-ID: <20120608201322.5C795A02F8@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:46026 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983Ab2FHUNX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2012 16:13:23 -0400
Received: by ggeh3 with SMTP id h3so206203gge.1
        for <mm-commits@vger.kernel.org>; Fri, 08 Jun 2012 13:13:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oskar@scara.com, minyard@acm.org, wim@iguana.be


The patch titled
     Subject: drivers/char/ipmi/ipmi_watchdog.c: remove local ioctl defines replaced by generic ones
has been added to the -mm tree.  Its filename is
     drivers-char-ipmi-ipmi_watchdogc-remove-local-ioctl-defines-replaced-by-generic-ones.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: drivers/char/ipmi/ipmi_watchdog.c: remove local ioctl defines replaced by generic ones

Patches currently in -mm which might be from oskar@scara.com are

drivers-char-ipmi-ipmi_watchdogc-remove-local-ioctl-defines-replaced-by-generic-ones.patch

