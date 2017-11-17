From: akpm@linux-foundation.org
Subject: [patch 88/94] drivers/pcmcia/sa1111_badge4.c: avoid unused
 function warning
Date: Fri, 17 Nov 2017 15:31:26 -0800
Message-ID: <20171117233126.QCYAXlLDw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56202 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966977AbdKQXb1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:31:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, mm-commits@vger.kernel.org, rmk@armlinux.org.uk, torvalds@linux-foundation.org

From: Arnd Bergmann <arnd@arndb.de>
Subject: drivers/pcmcia/sa1111_badge4.c: avoid unused function warning

pcmv_setup() is only used when the badge4 driver is built-in, but not when
it is a loadable module:

drivers/pcmcia/sa1111_badge4.c:153:122: error: 'pcmv_setup' defined but not used [-Werror=unused-function]

This adds an #ifdef to avoid the definition of the unused function in the
modular case.

Link: http://lkml.kernel.org/r/20170911201133.3421636-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <rmk@armlinux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/sa1111_badge4.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/pcmcia/sa1111_badge4.c~pcmcia-badge4-avoid-unused-function-warning drivers/pcmcia/sa1111_badge4.c
--- a/drivers/pcmcia/sa1111_badge4.c~pcmcia-badge4-avoid-unused-function-warning
+++ a/drivers/pcmcia/sa1111_badge4.c
@@ -144,6 +144,7 @@ int pcmcia_badge4_init(struct sa1111_dev
 				 sa11xx_drv_pcmcia_add_one);
 }
 
+#ifndef MODULE
 static int __init pcmv_setup(char *s)
 {
 	int v[4];
@@ -158,3 +159,4 @@ static int __init pcmv_setup(char *s)
 }
 
 __setup("pcmv=", pcmv_setup);
+#endif
_
