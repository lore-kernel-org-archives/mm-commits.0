From: akpm@linux-foundation.org
Subject: + pcmcia-badge4-avoid-unused-function-warning.patch added to -mm
 tree
Date: Thu, 28 Sep 2017 14:56:20 -0700
Message-ID: <59cd7004./Gwg54TL/9i+OTBy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54044 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750805AbdI1V4V (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Sep 2017 17:56:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, rmk@armlinux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/pcmcia/sa1111_badge4.c: avoid unused function warning
has been added to the -mm tree.  Its filename is
     pcmcia-badge4-avoid-unused-function-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pcmcia-badge4-avoid-unused-function-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pcmcia-badge4-avoid-unused-function-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from arnd@arndb.de are

mm-meminit-mark-init_reserved_page-as-__meminit.patch
iopoll-avoid-wint-in-bool-context-warning.patch
pcmcia-badge4-avoid-unused-function-warning.patch

