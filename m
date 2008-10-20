From: akpm@linux-foundation.org
Subject: - gpio-modify-sysfs-gpio-export-so-that-value-displays-as-0-or-1.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:35:35 -0700
Message-ID: <200810202035.m9KKZZAC011181@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50728 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752588AbYJTUgV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:36:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfalco@harris.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     gpio: modify sysfs gpio export so that "value" displays as 0 or 1
has been removed from the -mm tree.  Its filename was
     gpio-modify-sysfs-gpio-export-so-that-value-displays-as-0-or-1.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
linux-next.patch

