From: akpm@linux-foundation.org
Subject: + serial-samsungc-mark-s3c24xx_serial_remove-as-__devexit.patch added to -mm tree
Date: Thu, 11 Jun 2009 15:20:02 -0700
Message-ID: <200906112220.n5BMK2oD032348@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54800 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755966AbZFKWVC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Jun 2009 18:21:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jacmet@sunsite.dk, alan@lxorguk.ukuu.org.uk, ben-linux@fluff.org


The patch titled
     serial: samsung.c: mark s3c24xx_serial_remove as __devexit
has been added to the -mm tree.  Its filename is
     serial-samsungc-mark-s3c24xx_serial_remove-as-__devexit.patch

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
Subject: serial: samsung.c: mark s3c24xx_serial_remove as __devexit
From: Peter Korsgaard <jacmet@sunsite.dk>

Mark the remove function as __devexit so it gets eliminated in
CONFIG_HOTPLUG=n builds.  Saves ~100 bytes.

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
Acked-by: Ben Dooks <ben-linux@fluff.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/s3c2400.c |    2 +-
 drivers/serial/s3c2410.c |    2 +-
 drivers/serial/s3c2412.c |    2 +-
 drivers/serial/s3c2440.c |    2 +-
 drivers/serial/s3c24a0.c |    2 +-
 drivers/serial/s3c6400.c |    2 +-
 drivers/serial/samsung.c |    2 +-
 drivers/serial/samsung.h |    2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/serial/s3c2400.c~serial-samsungc-mark-s3c24xx_serial_remove-as-__devexit drivers/serial/s3c2400.c
--- a/drivers/serial/s3c2400.c~serial-samsungc-mark-s3c24xx_serial_remove-as-__devexit
+++ a/drivers/serial/s3c2400.c
@@ -78,7 +78,7 @@ static int s3c2400_serial_probe(struct p
 
 static struct platform_driver s3c2400_serial_drv = {
 	.probe		= s3c2400_serial_probe,
-	.remove		= s3c24xx_serial_remove,
+	.remove		= __devexit_p(s3c24xx_serial_remove),
 	.driver		= {
 		.name	= "s3c2400-uart",
 		.owner	= THIS_MODULE,
diff -puN drivers/serial/s3c2410.c~serial-samsungc-mark-s3c24xx_serial_remove-as-__devexit drivers/serial/s3c2410.c
--- a/drivers/serial/s3c2410.c~serial-samsungc-mark-s3c24xx_serial_remove-as-__devexit
+++ a/drivers/serial/s3c2410.c
@@ -90,7 +90,7 @@ static int s3c2410_serial_probe(struct p
 
 static struct platform_driver s3c2410_serial_drv = {
 	.probe		= s3c2410_serial_probe,
-	.remove		= s3c24xx_serial_remove,
+	.remove		= __devexit_p(s3c24xx_serial_remove),
 	.driver		= {
 		.name	= "s3c2410-uart",
 		.owner	= THIS_MODULE,
diff -puN drivers/serial/s3c2412.c~serial-samsungc-mark-s3c24xx_serial_remove-as-__devexit drivers/serial/s3c2412.c
--- a/drivers/serial/s3c2412.c~serial-samsungc-mark-s3c24xx_serial_remove-as-__devexit
+++ a/drivers/serial/s3c2412.c
@@ -123,7 +123,7 @@ static int s3c2412_serial_probe(struct p
 
 static struct platform_driver s3c2412_serial_drv = {
 	.probe		= s3c2412_serial_probe,
-	.remove		= s3c24xx_serial_remove,
+	.remove		= __devexit_p(s3c24xx_serial_remove),
 	.driver		= {
 		.name	= "s3c2412-uart",
 		.owner	= THIS_MODULE,
diff -puN drivers/serial/s3c2440.c~serial-samsungc-mark-s3c24xx_serial_remove-as-__devexit drivers/serial/s3c2440.c
--- a/drivers/serial/s3c2440.c~serial-samsungc-mark-s3c24xx_serial_remove-as-__devexit
+++ a/drivers/serial/s3c2440.c
@@ -153,7 +153,7 @@ static int s3c2440_serial_probe(struct p
 
 static struct platform_driver s3c2440_serial_drv = {
 	.probe		= s3c2440_serial_probe,
-	.remove		= s3c24xx_serial_remove,
+	.remove		= __devexit_p(s3c24xx_serial_remove),
 	.driver		= {
 		.name	= "s3c2440-uart",
 		.owner	= THIS_MODULE,
diff -puN drivers/serial/s3c24a0.c~serial-samsungc-mark-s3c24xx_serial_remove-as-__devexit drivers/serial/s3c24a0.c
--- a/drivers/serial/s3c24a0.c~serial-samsungc-mark-s3c24xx_serial_remove-as-__devexit
+++ a/drivers/serial/s3c24a0.c
@@ -94,7 +94,7 @@ static int s3c24a0_serial_probe(struct p
 
 static struct platform_driver s3c24a0_serial_drv = {
 	.probe		= s3c24a0_serial_probe,
-	.remove		= s3c24xx_serial_remove,
+	.remove		= __devexit_p(s3c24xx_serial_remove),
 	.driver		= {
 		.name	= "s3c24a0-uart",
 		.owner	= THIS_MODULE,
diff -puN drivers/serial/s3c6400.c~serial-samsungc-mark-s3c24xx_serial_remove-as-__devexit drivers/serial/s3c6400.c
--- a/drivers/serial/s3c6400.c~serial-samsungc-mark-s3c24xx_serial_remove-as-__devexit
+++ a/drivers/serial/s3c6400.c
@@ -124,7 +124,7 @@ static int s3c6400_serial_probe(struct p
 
 static struct platform_driver s3c6400_serial_drv = {
 	.probe		= s3c6400_serial_probe,
-	.remove		= s3c24xx_serial_remove,
+	.remove		= __devexit_p(s3c24xx_serial_remove),
 	.driver		= {
 		.name	= "s3c6400-uart",
 		.owner	= THIS_MODULE,
diff -puN drivers/serial/samsung.c~serial-samsungc-mark-s3c24xx_serial_remove-as-__devexit drivers/serial/samsung.c
--- a/drivers/serial/samsung.c~serial-samsungc-mark-s3c24xx_serial_remove-as-__devexit
+++ a/drivers/serial/samsung.c
@@ -1174,7 +1174,7 @@ int s3c24xx_serial_probe(struct platform
 
 EXPORT_SYMBOL_GPL(s3c24xx_serial_probe);
 
-int s3c24xx_serial_remove(struct platform_device *dev)
+int __devexit s3c24xx_serial_remove(struct platform_device *dev)
 {
 	struct uart_port *port = s3c24xx_dev_to_port(&dev->dev);
 
diff -puN drivers/serial/samsung.h~serial-samsungc-mark-s3c24xx_serial_remove-as-__devexit drivers/serial/samsung.h
--- a/drivers/serial/samsung.h~serial-samsungc-mark-s3c24xx_serial_remove-as-__devexit
+++ a/drivers/serial/samsung.h
@@ -72,7 +72,7 @@ struct s3c24xx_uart_port {
 extern int s3c24xx_serial_probe(struct platform_device *dev,
 				struct s3c24xx_uart_info *uart);
 
-extern int s3c24xx_serial_remove(struct platform_device *dev);
+extern int __devexit s3c24xx_serial_remove(struct platform_device *dev);
 
 extern int s3c24xx_serial_initconsole(struct platform_driver *drv,
 				      struct s3c24xx_uart_info *uart);
_

Patches currently in -mm which might be from jacmet@sunsite.dk are

linux-next.patch
serial-samsungc-mark-s3c24xx_serial_remove-as-__devexit.patch

