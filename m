From: akpm@linux-foundation.org
Subject: + gpio-modify-sysfs-gpio-export-so-that-value-displays-as-0-or-1.patch added to -mm tree
Date: Thu, 16 Oct 2008 12:59:43 -0700
Message-ID: <200810161959.m9GJxhcm011236@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53477 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753753AbYJPUAJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 16:00:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfalco@harris.com, dbrownell@users.sourceforge.net


The patch titled
     gpio: modify sysfs gpio export so that "value" displays as 0 or 1
has been added to the -mm tree.  Its filename is
     gpio-modify-sysfs-gpio-export-so-that-value-displays-as-0-or-1.patch

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
Subject: gpio: modify sysfs gpio export so that "value" displays as 0 or 1
From: "Steven A. Falco" <sfalco@harris.com>

gpiolib can export GPIOs to userspace via sysfs.  This patch modifies the
gpio_value_show() so that any non-zero value is explicitly printed as "1",
rather than whatever numerical value the lower-level driver returns.

Signed-off-by: Steve Falco <sfalco@harris.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/gpiolib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/gpio/gpiolib.c~gpio-modify-sysfs-gpio-export-so-that-value-displays-as-0-or-1 drivers/gpio/gpiolib.c
--- a/drivers/gpio/gpiolib.c~gpio-modify-sysfs-gpio-export-so-that-value-displays-as-0-or-1
+++ a/drivers/gpio/gpiolib.c
@@ -248,7 +248,7 @@ static ssize_t gpio_value_show(struct de
 	if (!test_bit(FLAG_EXPORT, &desc->flags))
 		status = -EIO;
 	else
-		status = sprintf(buf, "%d\n", gpio_get_value_cansleep(gpio));
+		status = sprintf(buf, "%d\n", !!gpio_get_value_cansleep(gpio));
 
 	mutex_unlock(&sysfs_lock);
 	return status;
_

Patches currently in -mm which might be from sfalco@harris.com are

origin.patch
rtc-rtc-m41t80c-add-support-for-the-st-m41t65-rtc.patch
gpio-modify-sysfs-gpio-export-so-that-value-displays-as-0-or-1.patch

