From: akpm@linux-foundation.org
Subject: + gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links-update.patch added to -mm tree
Date: Wed, 01 Jul 2009 14:03:34 -0700
Message-ID: <200907012103.n61L3YnC014157@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35218 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751212AbZGAVEf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jul 2009 17:04:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ext-jani.1.nikula@nokia.com, david-b@pacbell.net, dsilvers@simtec.co.uk


The patch titled
     gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links-update
has been added to the -mm tree.  Its filename is
     gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links-update.patch

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
Subject: gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links-update
From: Jani Nikula <ext-jani.1.nikula@nokia.com>

Signed-off-by: Jani Nikula <ext-jani.1.nikula@nokia.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Daniel Silverstone <dsilvers@simtec.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/gpiolib.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN drivers/gpio/gpiolib.c~gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links-update drivers/gpio/gpiolib.c
--- a/drivers/gpio/gpiolib.c~gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links-update
+++ a/drivers/gpio/gpiolib.c
@@ -520,9 +520,6 @@ int gpio_export_link(struct device *dev,
 	struct gpio_desc	*desc;
 	int			status = -EINVAL;
 
-	BUG_ON(dev == NULL);
-	BUG_ON(name == NULL);
