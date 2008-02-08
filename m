From: akpm@linux-foundation.org
Subject: + megaraid-outb_p-extermination.patch added to -mm tree
Date: Fri, 08 Feb 2008 13:36:39 -0800
Message-ID: <200802082136.m18LadFD014539@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60904 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752058AbYBHVjO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:39:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, James.Bottomley@HansenPartnership.com, alan@redhat.com


The patch titled
     megaraid: outb_p extermination
has been added to the -mm tree.  Its filename is
     megaraid-outb_p-extermination.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: megaraid: outb_p extermination
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

After conversations with the maintainers the _p isn't needed so kill it. 
That removes the last non ISA _p user from the SCSI layer to my knowledge.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/megaraid.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/scsi/megaraid.c~megaraid-outb_p-extermination drivers/scsi/megaraid.c
--- a/drivers/scsi/megaraid.c~megaraid-outb_p-extermination
+++ a/drivers/scsi/megaraid.c
@@ -151,19 +151,19 @@ mega_setup_mailbox(adapter_t *adapter)
 	 */
 	if( adapter->flag & BOARD_IOMAP ) {
 
-		outb_p(adapter->mbox_dma & 0xFF,
+		outb(adapter->mbox_dma & 0xFF,
 				adapter->host->io_port + MBOX_PORT0);
 
-		outb_p((adapter->mbox_dma >> 8) & 0xFF,
+		outb((adapter->mbox_dma >> 8) & 0xFF,
 				adapter->host->io_port + MBOX_PORT1);
 
-		outb_p((adapter->mbox_dma >> 16) & 0xFF,
+		outb((adapter->mbox_dma >> 16) & 0xFF,
 				adapter->host->io_port + MBOX_PORT2);
 
-		outb_p((adapter->mbox_dma >> 24) & 0xFF,
+		outb((adapter->mbox_dma >> 24) & 0xFF,
 				adapter->host->io_port + MBOX_PORT3);
 
-		outb_p(ENABLE_MBOX_BYTE,
+		outb(ENABLE_MBOX_BYTE,
 				adapter->host->io_port + ENABLE_MBOX_REGION);
 
 		irq_ack(adapter);
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
libata-isolate-and-rework-cable-logic.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
hci_ldisc-fix-null-pointer-deref.patch
parisc-new-termios-definitions.patch
git-sh.patch
megaraid-outb_p-extermination.patch
git-watchdog.patch
tty-bkl-pushdown.patch
