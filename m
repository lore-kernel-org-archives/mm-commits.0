From: akpm@linux-foundation.org
Subject: + gpiolib-fix-poll2-support-reconfigure-on-sysfs-polarity-change.patch added to -mm tree
Date: Tue, 22 Dec 2009 14:23:58 -0800
Message-ID: <200912222223.nBMMNwEG027902@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55746 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755064AbZLVWYd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Dec 2009 17:24:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ext-jani.1.nikula@nokia.com, david-b@pacbell.net


The patch titled
     gpiolib: fix poll(2) support reconfigure on sysfs polarity change
has been added to the -mm tree.  Its filename is
     gpiolib-fix-poll2-support-reconfigure-on-sysfs-polarity-change.patch

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
Subject: gpiolib: fix poll(2) support reconfigure on sysfs polarity change
From: Jani Nikula <ext-jani.1.nikula@nokia.com>

Previously enabled poll(2) support on one edge was never reconfigured when
sysfs polarity change was triggered from kernel, because 'struct device
*dev' shadowed an earlier definition.

Found by sparse, which I should've run much earlier.

Signed-off-by: Jani Nikula <ext-jani.1.nikula@nokia.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/gpiolib.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/gpio/gpiolib.c~gpiolib-fix-poll2-support-reconfigure-on-sysfs-polarity-change drivers/gpio/gpiolib.c
--- a/drivers/gpio/gpiolib.c~gpiolib-fix-poll2-support-reconfigure-on-sysfs-polarity-change
+++ a/drivers/gpio/gpiolib.c
@@ -858,8 +858,6 @@ int gpio_sysfs_set_active_low(unsigned g
 	desc = &gpio_desc[gpio];
 
 	if (test_bit(FLAG_EXPORT, &desc->flags)) {
-		struct device *dev;
