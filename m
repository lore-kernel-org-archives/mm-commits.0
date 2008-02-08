From: akpm@linux-foundation.org
Subject: - char-mxser_new-ioaddresses-are-ulong.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:09:34 -0800
Message-ID: <200802080809.m1889F4o014810@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39527 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755042AbYBHIS5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:18:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: mxser_new, ioaddresses are ulong
has been removed from the -mm tree.  Its filename was
     char-mxser_new-ioaddresses-are-ulong.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: mxser_new, ioaddresses are ulong
From: Jiri Slaby <jirislaby@gmail.com>

To not pass ulong address as int parameter, switch it to ulong.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser_new.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/mxser_new.c~char-mxser_new-ioaddresses-are-ulong drivers/char/mxser_new.c
--- a/drivers/char/mxser_new.c~char-mxser_new-ioaddresses-are-ulong
+++ a/drivers/char/mxser_new.c
@@ -320,7 +320,7 @@ static struct mxser_mon_ext mon_data_ext
 static int mxser_set_baud_method[MXSER_PORTS + 1];
 
 #ifdef CONFIG_PCI
-static int __devinit CheckIsMoxaMust(int io)
+static int __devinit CheckIsMoxaMust(unsigned long io)
 {
 	u8 oldmcr, hwid;
 	int i;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-drm.patch
drm-i915-fix-oops-after-killing-x.patch
git-watchdog.patch
moxa-first-pass-at-termios-reporting.patch
char-applicom-use-pci_resource_start.patch
char-applicom-use-pci_match_id.patch
char-applicom-use-pci_match_id-fix.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
