From: akpm@linux-foundation.org
Subject: - fdomainc-get-rid-of-unused-stuff.patch removed from -mm tree
Date: Tue, 29 May 2007 11:55:27 -0700
Message-ID: <200705291855.l4TItRdo008583@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:37624 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765150AbXE2Szz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:55:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: parag.warudkar@gmail.com, James.Bottomley@steeleye.com, mm-commits@vger.kernel.org


The patch titled
     fdomain.c: get rid of unused stuff
has been removed from the -mm tree.  Its filename was
     fdomainc-get-rid-of-unused-stuff.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fdomain.c: get rid of unused stuff
From: Parag Warudkar <parag.warudkar@gmail.com>

fdomain.c uses the below stuff only if PCMCIA is not defined.  This causes
unused variables to be defined when PCMCIA is not defined.  Wrap variables
and functions around #ifndef PCMCIA appropriately to avoid this.

4 less compiler warnings.

Signed-off-by: Parag Warudkar <parag.warudkar@gmail.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/fdomain.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/fdomain.c~fdomainc-get-rid-of-unused-stuff drivers/scsi/fdomain.c
--- a/drivers/scsi/fdomain.c~fdomainc-get-rid-of-unused-stuff
+++ a/drivers/scsi/fdomain.c
@@ -410,6 +410,7 @@ static irqreturn_t       do_fdomain_16x0
 static char * fdomain = NULL;
 module_param(fdomain, charp, 0);
 
+#ifndef PCMCIA
 static unsigned long addresses[] = {
    0xc8000,
    0xca000,
@@ -502,6 +503,7 @@ static struct signature {
 };
 
 #define SIGNATURE_COUNT ARRAY_SIZE(signatures)
+#endif /* ifndef PCMCIA */
 
 static void print_banner( struct Scsi_Host *shpnt )
 {
@@ -646,7 +648,7 @@ static int fdomain_test_loopback( void )
    Sometimes it is possible to use the computer's BIOS setup screen to
    configure a PCI system so that one of these IRQs will be used by the
    Future Domain card. */
-
+#ifndef PCMCIA
 static int fdomain_get_irq( int base )
 {
    int options = inb(base + Configuration1);
@@ -664,6 +666,7 @@ static int fdomain_get_irq( int base )
    	return 0;
    return ints[(options & 0x0e) >> 1];
 }
+#endif
 
 static int fdomain_isa_detect( int *irq, int *iobase )
 {
_

Patches currently in -mm which might be from parag.warudkar@gmail.com are
