From: akpm@google.com
Subject: + drivers-watchdog-w83627hf_wdtc-implement-wdioc_gettimeleft-ioctl-support.patch added to -mm tree
Date: Thu, 06 Oct 2011 16:14:17 -0700
Message-ID: <201110062314.p96NEH3a021358@wpaz24.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:17049 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab1JFXOY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Oct 2011 19:14:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: glee@swspec.com, P@draigbrady.com, wim@iguana.be


The patch titled
     Subject: drivers/watchdog/w83627hf_wdt.c: implement WDIOC_GETTIMELEFT ioctl support
has been added to the -mm tree.  Its filename is
     drivers-watchdog-w83627hf_wdtc-implement-wdioc_gettimeleft-ioctl-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Greg Lee <glee@swspec.com>
Subject: drivers/watchdog/w83627hf_wdt.c: implement WDIOC_GETTIMELEFT ioctl support

Implement the WDIOC_GETTIMELEFT ioctl, allowing you to check how much time
is left on the watchdog counter before a reset occurs.  A few additional
naming clean-ups requested by Padraig Brady as well.

Signed-off-by: Greg Lee <glee [at] swspec.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Padraig Brady <P@draigbrady.com>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 drivers/watchdog/w83627hf_wdt.c |   33 ++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

diff -puN drivers/watchdog/w83627hf_wdt.c~drivers-watchdog-w83627hf_wdtc-implement-wdioc_gettimeleft-ioctl-support drivers/watchdog/w83627hf_wdt.c
--- a/drivers/watchdog/w83627hf_wdt.c~drivers-watchdog-w83627hf_wdtc-implement-wdioc_gettimeleft-ioctl-support
+++ a/drivers/watchdog/w83627hf_wdt.c
@@ -142,7 +142,7 @@ static void w83627hf_init(void)
 	w83627hf_unselect_wd_register();
 }
 
-static void wdt_ctrl(int timeout)
+static void wdt_set_time(int timeout)
 {
 	spin_lock(&io_lock);
 
@@ -158,13 +158,13 @@ static void wdt_ctrl(int timeout)
 
 static int wdt_ping(void)
 {
-	wdt_ctrl(timeout);
+	wdt_set_time(timeout);
 	return 0;
 }
 
 static int wdt_disable(void)
 {
-	wdt_ctrl(0);
+	wdt_set_time(0);
 	return 0;
 }
 
@@ -176,6 +176,24 @@ static int wdt_set_heartbeat(int t)
 	return 0;
 }
 
+static int wdt_get_time(void)
+{
+	int timeleft;
+
+	spin_lock(&io_lock);
+
+	w83627hf_select_wd_register();
+
+	outb_p(0xF6, WDT_EFER);    /* Select CRF6 */
+	timeleft = inb_p(WDT_EFDR); /* Read Timeout counter to CRF6 */
+
+	w83627hf_unselect_wd_register();
+
+	spin_unlock(&io_lock);
+
+	return timeleft;
+}
+
 static ssize_t wdt_write(struct file *file, const char __user *buf,
 						size_t count, loff_t *ppos)
 {
@@ -202,7 +220,7 @@ static long wdt_ioctl(struct file *file,
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	int new_timeout;
+	int timeval;
 	static const struct watchdog_info ident = {
 		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT |
 							WDIOF_MAGICCLOSE,
@@ -238,14 +256,17 @@ static long wdt_ioctl(struct file *file,
 		wdt_ping();
 		break;
 	case WDIOC_SETTIMEOUT:
-		if (get_user(new_timeout, p))
+		if (get_user(timeval, p))
 			return -EFAULT;
-		if (wdt_set_heartbeat(new_timeout))
+		if (wdt_set_heartbeat(timeval))
 			return -EINVAL;
 		wdt_ping();
 		/* Fall */
 	case WDIOC_GETTIMEOUT:
 		return put_user(timeout, p);
+	case WDIOC_GETTIMELEFT:
+		timeval = wdt_get_time();
+		return put_user(timeval, p);
 	default:
 		return -ENOTTY;
 	}
_
Subject: Subject: drivers/watchdog/w83627hf_wdt.c: implement WDIOC_GETTIMELEFT ioctl support

Patches currently in -mm which might be from glee@swspec.com are

drivers-watchdog-w83627hf_wdtc-implement-wdioc_gettimeleft-ioctl-support.patch

