From: akpm@linux-foundation.org
Subject: [patch 116/126] drivers/pps: use surrounding "if PPS" to
 remove numerous dependency checks
Date: Fri, 08 Sep 2017 16:17:22 -0700
Message-ID: <20170908231722.ffUlnGhLe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53746 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757292AbdIHXRX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 19:17:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, giometti@enneenne.com, mm-commits@vger.kernel.org, rpjday@crashcourse.ca, torvalds@linux-foundation.org

From: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: drivers/pps: use surrounding "if PPS" to remove numerous dependency checks

Adding high-level "if PPS" makes lower-level dependency tests superfluous.

Link: http://lkml.kernel.org/r/alpine.LFD.2.20.1708261050500.8156@localhost.localdomain
Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Acked-by: Rodolfo Giometti <giometti@enneenne.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/Kconfig            |    7 +++++--
 drivers/pps/clients/Kconfig    |    7 ++-----
 drivers/pps/generators/Kconfig |    3 +--
 3 files changed, 8 insertions(+), 9 deletions(-)

diff -puN drivers/pps/Kconfig~pps-use-surrounding-if-pps-to-remove-numerous-dependency-checks drivers/pps/Kconfig
--- a/drivers/pps/Kconfig~pps-use-surrounding-if-pps-to-remove-numerous-dependency-checks
+++ a/drivers/pps/Kconfig
@@ -19,9 +19,10 @@ menuconfig PPS
 	  To compile this driver as a module, choose M here: the module
 	  will be called pps_core.ko.
 
+if PPS
+
 config PPS_DEBUG
 	bool "PPS debugging messages"
-	depends on PPS
 	help
 	  Say Y here if you want the PPS support to produce a bunch of debug
 	  messages to the system log.  Select this if you are having a
@@ -29,7 +30,7 @@ config PPS_DEBUG
 
 config NTP_PPS
 	bool "PPS kernel consumer support"
-	depends on PPS && !NO_HZ_COMMON
+	depends on !NO_HZ_COMMON
 	help
 	  This option adds support for direct in-kernel time
 	  synchronization using an external PPS signal.
@@ -39,3 +40,5 @@ config NTP_PPS
 source drivers/pps/clients/Kconfig
 
 source drivers/pps/generators/Kconfig
+
+endif # PPS
diff -puN drivers/pps/clients/Kconfig~pps-use-surrounding-if-pps-to-remove-numerous-dependency-checks drivers/pps/clients/Kconfig
--- a/drivers/pps/clients/Kconfig~pps-use-surrounding-if-pps-to-remove-numerous-dependency-checks
+++ a/drivers/pps/clients/Kconfig
@@ -3,11 +3,9 @@
 #
 
 comment "PPS clients support"
-	depends on PPS
 
 config PPS_CLIENT_KTIMER
 	tristate "Kernel timer client (Testing client, use for debug)"
-	depends on PPS
 	help
 	  If you say yes here you get support for a PPS debugging client
 	  which uses a kernel timer to generate the PPS signal.
@@ -17,21 +15,20 @@ config PPS_CLIENT_KTIMER
 
 config PPS_CLIENT_LDISC
 	tristate "PPS line discipline"
-	depends on PPS && TTY
+	depends on TTY
 	help
 	  If you say yes here you get support for a PPS source connected
 	  with the CD (Carrier Detect) pin of your serial port.
 
 config PPS_CLIENT_PARPORT
 	tristate "Parallel port PPS client"
-	depends on PPS && PARPORT
+	depends on PARPORT
 	help
 	  If you say yes here you get support for a PPS source connected
 	  with the interrupt pin of your parallel port.
 
 config PPS_CLIENT_GPIO
 	tristate "PPS client using GPIO"
-	depends on PPS
 	help
 	  If you say yes here you get support for a PPS source using
 	  GPIO. To be useful you must also register a platform device
diff -puN drivers/pps/generators/Kconfig~pps-use-surrounding-if-pps-to-remove-numerous-dependency-checks drivers/pps/generators/Kconfig
--- a/drivers/pps/generators/Kconfig~pps-use-surrounding-if-pps-to-remove-numerous-dependency-checks
+++ a/drivers/pps/generators/Kconfig
@@ -3,11 +3,10 @@
 #
 
 comment "PPS generators support"
-	depends on PPS
 
 config PPS_GENERATOR_PARPORT
 	tristate "Parallel port PPS signal generator"
-	depends on PPS && PARPORT && BROKEN
+	depends on PARPORT && BROKEN
 	help
 	  If you say yes here you get support for a PPS signal generator which
 	  utilizes STROBE pin of a parallel port to send PPS signals. It uses
_
