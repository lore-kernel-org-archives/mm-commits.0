From: akpm@linux-foundation.org
Subject: + drivers-char-pcmcia-cm40x0_csc-fix-release-function-call.patch added to -mm tree
Date: Fri, 03 Aug 2007 18:15:24 -0700
Message-ID: <200708040115.l741FODB004013@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34391 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759211AbXHDBPs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Aug 2007 21:15:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: daniel.ritz-ml@swissonline.ch, daniel.ritz@gmx.ch, laforge@gnumonks.org, mcconnau@biochem.wustl.edu, protasnb@gmail.com


The patch titled
     drivers/char/pcmcia/cm40x0_cs.c: fix release function call
has been added to the -mm tree.  Its filename is
     drivers-char-pcmcia-cm40x0_csc-fix-release-function-call.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/char/pcmcia/cm40x0_cs.c: fix release function call
From: Daniel Ritz <daniel.ritz-ml@swissonline.ch>

cm4000_cs.c and cm4040_cs.c call the internal release function with
an argument of wrong type. this fixes bug #8485

Signed-off-by: Daniel Ritz <daniel.ritz@gmx.ch>
Cc: Bill McConnaughey <mcconnau@biochem.wustl.edu>
Cc: Natalie Protasevich <protasnb@gmail.com>
Cc: Harald Welte <laforge@gnumonks.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/pcmcia/cm4000_cs.c |    5 ++---
 drivers/char/pcmcia/cm4040_cs.c |    2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/char/pcmcia/cm4000_cs.c~drivers-char-pcmcia-cm40x0_csc-fix-release-function-call drivers/char/pcmcia/cm4000_cs.c
--- a/drivers/char/pcmcia/cm4000_cs.c~drivers-char-pcmcia-cm40x0_csc-fix-release-function-call
+++ a/drivers/char/pcmcia/cm4000_cs.c
@@ -1629,7 +1629,7 @@ static int cmm_open(struct inode *inode,
 {
 	struct cm4000_dev *dev;
 	struct pcmcia_device *link;
-	int rc, minor = iminor(inode);
+	int minor = iminor(inode);
 
 	if (minor >= CM4000_MAX_DEV)
 		return -ENODEV;
@@ -1668,7 +1668,6 @@ static int cmm_open(struct inode *inode,
 	start_monitor(dev);
 
 	link->open = 1;		/* only one open per device */
-	rc = 0;
 
 	DEBUGP(2, dev, "<- cmm_open\n");
 	return nonseekable_open(inode, filp);
@@ -1824,7 +1823,7 @@ static int cm4000_resume(struct pcmcia_d
 
 static void cm4000_release(struct pcmcia_device *link)
 {
-	cmm_cm4000_release(link->priv);	/* delay release until device closed */
+	cmm_cm4000_release(link);	/* delay release until device closed */
 	pcmcia_disable_device(link);
 }
 
diff -puN drivers/char/pcmcia/cm4040_cs.c~drivers-char-pcmcia-cm40x0_csc-fix-release-function-call drivers/char/pcmcia/cm4040_cs.c
--- a/drivers/char/pcmcia/cm4040_cs.c~drivers-char-pcmcia-cm40x0_csc-fix-release-function-call
+++ a/drivers/char/pcmcia/cm4040_cs.c
@@ -599,7 +599,7 @@ cs_release:
 
 static void reader_release(struct pcmcia_device *link)
 {
-	cm4040_reader_release(link->priv);
+	cm4040_reader_release(link);
 	pcmcia_disable_device(link);
 }
 
_

Patches currently in -mm which might be from daniel.ritz-ml@swissonline.ch are

origin.patch
serial-fix-8250-early-console-setup.patch
drivers-char-pcmcia-cm40x0_csc-fix-release-function-call.patch
