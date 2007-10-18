From: akpm@linux-foundation.org
Subject: - mxser-fix-compiler-warning-when-building-withoug-config_pci-fix.patch removed from -mm tree
Date: Thu, 18 Oct 2007 01:50:16 -0700
Message-ID: <200710180850.l9I8oGuD002910@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53704 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932607AbXJRIuU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 04:50:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mxser: Fix warning: 'CheckIsMoxaMust' defined but not used
has been removed from the -mm tree.  Its filename was
     mxser-fix-compiler-warning-when-building-withoug-config_pci-fix.patch

This patch was dropped because it was folded into mxser-fix-compiler-warning-when-building-withoug-config_pci.patch

------------------------------------------------------
Subject: mxser: Fix warning: 'CheckIsMoxaMust' defined but not used
From: Jesper Juhl <jesper.juhl@gmail.com>

drivers/char/mxser.c:427: warning: 'CheckIsMoxaMust' defined but not used
when building Moxa driver without CONFIG_PCI.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/char/mxser.c~mxser-fix-compiler-warning-when-building-withoug-config_pci-fix drivers/char/mxser.c
--- a/drivers/char/mxser.c~mxser-fix-compiler-warning-when-building-withoug-config_pci-fix
+++ a/drivers/char/mxser.c
@@ -421,7 +421,7 @@ static void mxser_wait_until_sent(struct
 static void mxser_startrx(struct tty_struct *tty);
 static void mxser_stoprx(struct tty_struct *tty);
 
-
+#ifdef CONFIG_PCI
 static int CheckIsMoxaMust(int io)
 {
 	u8 oldmcr, hwid;
@@ -444,6 +444,7 @@ static int CheckIsMoxaMust(int io)
 	}
 	return MOXA_OTHER_UART;
 }
+#endif
 
 /* above is modified by Victor Yu. 08-15-2002 */
 
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci-fix.patch
cyclades-avoid-label-defined-but-not-used-warning.patch
