From: akpm@linux-foundation.org
Subject: + wdt285-fix-sparse-warnings.patch added to -mm tree
Date: Fri, 19 Sep 2008 15:39:14 -0700
Message-ID: <200809192239.m8JMdEA0010090@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58660 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751503AbYISWj7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Sep 2008 18:39:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben-linux@fluff.org, wim@iguana.be


The patch titled
     wdt285: fix sparse warnings
has been added to the -mm tree.  Its filename is
     wdt285-fix-sparse-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: wdt285: fix sparse warnings
From: Ben Dooks <ben-linux@fluff.org>

The wdt285.c watchdog driver is producing a number of sparse errors due to
missing __user attributes to calls to put_user and copy_to_user, as well
as in the prototype of watchdog_write.

wdt285.c:144:21: warning: incorrect type in argument 1 (different address spaces)
wdt285.c:144:21:    expected void [noderef] <asn:1>*to
wdt285.c:144:21:    got void *<noident>
wdt285.c:150:9: warning: incorrect type in initializer (different address spaces)
wdt285.c:150:9:    expected int const [noderef] <asn:1>*register __p
wdt285.c:150:9:    got int *<noident>
wdt285.c:159:9: warning: incorrect type in initializer (different address spaces)
wdt285.c:159:9:    expected int const [noderef] <asn:1>*register __p
wdt285.c:159:9:    got int *<noident>
wdt285.c:174:9: warning: incorrect type in initializer (different address spaces)
wdt285.c:174:9:    expected int const [noderef] <asn:1>*register __p
wdt285.c:174:9:    got int *<noident>
wdt285.c:183:12: warning: incorrect type in initializer (incompatible argument 2 (different address spaces))
wdt285.c:183:12:    expected int ( *write )( ... )
wdt285.c:183:12:    got int ( static [toplevel] *<noident> )( ... )

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/wdt285.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN drivers/watchdog/wdt285.c~wdt285-fix-sparse-warnings drivers/watchdog/wdt285.c
--- a/drivers/watchdog/wdt285.c~wdt285-fix-sparse-warnings
+++ a/drivers/watchdog/wdt285.c
@@ -115,8 +115,8 @@ static int watchdog_release(struct inode
 	return 0;
 }
 
-static ssize_t watchdog_write(struct file *file, const char *data,
-						size_t len, loff_t *ppos)
+static ssize_t watchdog_write(struct file *file, const char __user *data,
+			      size_t len, loff_t *ppos)
 {
 	/*
 	 *	Refresh the timer.
@@ -133,21 +133,22 @@ static const struct watchdog_info ident 
 };
 
 static long watchdog_ioctl(struct file *file, unsigned int cmd,
-							unsigned long arg)
+			   unsigned long arg)
 {
 	unsigned int new_margin;
+	int __user *int_arg = (int __user *)arg;
 	int ret = -ENOTTY;
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
 		ret = 0;
-		if (copy_to_user((void *)arg, &ident, sizeof(ident)))
+		if (copy_to_user((void __user *)arg, &ident, sizeof(ident)))
 			ret = -EFAULT;
 		break;
 
 	case WDIOC_GETSTATUS:
 	case WDIOC_GETBOOTSTATUS:
-		ret = put_user(0, (int *)arg);
+		ret = put_user(0, int_arg);
 		break;
 
 	case WDIOC_KEEPALIVE:
@@ -156,7 +157,7 @@ static long watchdog_ioctl(struct file *
 		break;
 
 	case WDIOC_SETTIMEOUT:
-		ret = get_user(new_margin, (int *)arg);
+		ret = get_user(new_margin, int_arg);
 		if (ret)
 			break;
 
@@ -171,7 +172,7 @@ static long watchdog_ioctl(struct file *
 		watchdog_ping();
 		/* Fall */
 	case WDIOC_GETTIMEOUT:
-		ret = put_user(soft_margin, (int *)arg);
+		ret = put_user(soft_margin, int_arg);
 		break;
 	}
 	return ret;
_

Patches currently in -mm which might be from ben-linux@fluff.org are

origin.patch
linux-next.patch
wdt285-fix-sparse-warnings.patch
spi_s3c24xx-pin-configuration-updates.patch
resource-add-resource_type-and-ioresource_type_bits.patch

