From: akpm@linux-foundation.org
Subject: + gpio-pca953x-bugfix-mark-as-can_sleep.patch added to -mm tree
Date: Sun, 09 Mar 2008 15:52:42 -0700
Message-ID: <200803092252.m29MqgA8021437@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49576 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752237AbYCIWxr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 9 Mar 2008 18:53:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arnaud.patard@rtp-net.org, dbrownell@users.sourceforge.net, khali@linux-fr.org


The patch titled
     gpio/pca953x bugfix: mark as can_sleep
has been added to the -mm tree.  Its filename is
     gpio-pca953x-bugfix-mark-as-can_sleep.patch

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
Subject: gpio/pca953x bugfix: mark as can_sleep
From: Arnaud Patard <arnaud.patard@rtp-net.org>

The pca953x driver is an I2C driver so gpio_chip->can_sleep should be set. 
This lets upper layers know they should use the gpio_*_cansleep() calls to
access values, and may not access them from nonsleeping contexts.

Signed-off-by: Arnaud Patard <arnaud.patard@rtp-net.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/pca953x.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/gpio/pca953x.c~gpio-pca953x-bugfix-mark-as-can_sleep drivers/gpio/pca953x.c
--- a/drivers/gpio/pca953x.c~gpio-pca953x-bugfix-mark-as-can_sleep
+++ a/drivers/gpio/pca953x.c
@@ -184,6 +184,7 @@ static void pca953x_setup_gpio(struct pc
 	gc->direction_output = pca953x_gpio_direction_output;
 	gc->get = pca953x_gpio_get_value;
 	gc->set = pca953x_gpio_set_value;
+	gc->can_sleep = 1;
 
 	gc->base = chip->gpio_start;
 	gc->ngpio = gpios;
_

Patches currently in -mm which might be from arnaud.patard@rtp-net.org are

gpio-pca953x-bugfix-mark-as-can_sleep.patch

