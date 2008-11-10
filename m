From: akpm@linux-foundation.org
Subject: - sam9-watchdog-supported-on-all-sam9-and-cap9-processors.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:34:35 -0800
Message-ID: <200811102034.mAAKYZjS025126@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57771 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754164AbYKJUfP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:35:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avictor.za@gmail.com, linux@maxim.org.za, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     SAM9 watchdog: supported on all SAM9 and CAP9 processors
has been removed from the -mm tree.  Its filename was
     sam9-watchdog-supported-on-all-sam9-and-cap9-processors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: SAM9 watchdog: supported on all SAM9 and CAP9 processors
From: "Andrew Victor" <avictor.za@gmail.com>

The SAM9 watchdog driver is usable on the whole family of AT91SAM9 and
CAP9 processors.  Update the configuration to indicate this and allow the
driver to be selected.

Signed-off-by: Andrew Victor <linux@maxim.org.za>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/Kconfig |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/watchdog/Kconfig~sam9-watchdog-supported-on-all-sam9-and-cap9-processors drivers/watchdog/Kconfig
--- a/drivers/watchdog/Kconfig~sam9-watchdog-supported-on-all-sam9-and-cap9-processors
+++ a/drivers/watchdog/Kconfig
@@ -74,11 +74,11 @@ config AT91RM9200_WATCHDOG
 	  system when the timeout is reached.
 
 config AT91SAM9X_WATCHDOG
-	tristate "AT91SAM9X watchdog"
-	depends on WATCHDOG && (ARCH_AT91SAM9260 || ARCH_AT91SAM9261)
+	tristate "AT91SAM9X / AT91CAP9 watchdog"
+	depends on ARCH_AT91 && !ARCH_AT91RM9200
 	help
-	  Watchdog timer embedded into AT91SAM9X chips. This will reboot your
-	  system when the timeout is reached.
+	  Watchdog timer embedded into AT91SAM9X and AT91CAP9 chips. This will
+	  reboot your system when the timeout is reached.
 
 config 21285_WATCHDOG
 	tristate "DC21285 watchdog"
_

Patches currently in -mm which might be from avictor.za@gmail.com are


