From: akpm@linux-foundation.org
Subject: - megaraid-outb_p-extermination.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:22:43 -0800
Message-ID: <200802232022.m1NKMhiu013447@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:54795 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763319AbYBWU31 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:29:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, James.Bottomley@HansenPartnership.com, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     megaraid: outb_p extermination
has been removed from the -mm tree.  Its filename was
     megaraid-outb_p-extermination.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
pata_amd-fix-sparse-warning.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
git-scsi-rc-fixes.patch
crisv10-prepare-for-bkl-push-down.patch
fix-tty-speed-handling-on-8250.patch
uart_get_baud_rate-stop-mangling-termios.patch
do_task_stat-dont-take-rcu_read_lock.patch
amiserial-prepare-for-locking-relaxation-in-caller.patch
cyclades-prepare-for-relaxed-locking-in-callers.patch
epca-lock_kernel-push-down.patch
esp-lock_kernel-push-down.patch
isicom-prepare-for-lock_kernel-push-down.patch
isicom-istallion-prepare-for-lock_kernel-pushdown.patch
mxser-prepare-for-bkl-pushdown.patch
nozomi-prepare-for-bkl-pushdown.patch
riscom8-prepare-for-bkl-pushdown.patch
rocket-prepare-for-bkl-pushdown.patch
serial167-prepare-to-push-bkl-down-into-drivers.patch
specialix-prepare-for-bkl-pushdown.patch
stallion-prepare-for-bkl-push-down.patch
sx-prepare-for-bkl-pushdown.patch
synclink-series-prepare-for-bkl-pushdown.patch
viocons-bkl-locking.patch
vt_ioctl-prepare-for-bkl-push-down.patch
isdn_tty-prepare-for-bkl-push-down.patch
68360serial-note-that-there-isnt-any-info-mcr-locking.patch
serial_core-prepare-for-bkl-push-down.patch
tty-bkl-pushdown.patch
tty-bkl-pushdown-fix1.patch
redo-locking-of-tty-pgrp.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch
