From: akpm@linux-foundation.org
Subject: [merged] gpiolib-fix-poll2-support-reconfigure-on-sysfs-polarity-change.patch removed from -mm tree
Date: Mon, 11 Jan 2010 12:18:50 -0800
Message-ID: <201001112018.o0BKIoDi025515@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39130 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754054Ab0AKUdY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jan 2010 15:33:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ext-jani.1.nikula@nokia.com, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     gpiolib: fix poll(2) support reconfigure on sysfs polarity change
has been removed from the -mm tree.  Its filename was
     gpiolib-fix-poll2-support-reconfigure-on-sysfs-polarity-change.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
