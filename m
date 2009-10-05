From: akpm@linux-foundation.org
Subject: [merged] serial167-fix-read-buffer-overflow.patch removed from -mm tree
Date: Mon, 05 Oct 2009 11:39:23 -0700
Message-ID: <200910051839.n95IdNQt019015@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56617 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754727AbZJESkI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2009 14:40:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, alan@lxorguk.ukuu.org.uk, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     serial167: fix read buffer overflow
has been removed from the -mm tree.  Its filename was
     serial167-fix-read-buffer-overflow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial167: fix read buffer overflow
From: Roel Kluin <roel.kluin@gmail.com>

Check whether index is within bounds before grabbing the element.

Also, since NR_PORTS is defined ARRAY_SIZE(cy_port), cy_port[NR_PORTS] is
out of bounds as well.

[akpm@linux-foundation.org: cleanup, remove (long) casts]
Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/serial167.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/char/serial167.c~serial167-fix-read-buffer-overflow drivers/char/serial167.c
--- a/drivers/char/serial167.c~serial167-fix-read-buffer-overflow
+++ a/drivers/char/serial167.c
@@ -220,8 +220,7 @@ static inline int serial_paranoia_check(
 		return 1;
 	}
 
-	if ((long)info < (long)(&cy_port[0])
-	    || (long)(&cy_port[NR_PORTS]) < (long)info) {
+	if (info < &cy_port[0] || info >= &cy_port[NR_PORTS]) {
 		printk("Warning: cyclades_port out of range for (%s) in %s\n",
 				name, routine);
 		return 1;
@@ -520,15 +519,13 @@ static irqreturn_t cd2401_tx_interrupt(i
 		panic("TxInt on debug port!!!");
 	}
 #endif
-
-	info = &cy_port[channel];
-
 	/* validate the port number (as configured and open) */
 	if ((channel < 0) || (NR_PORTS <= channel)) {
 		base_addr[CyIER] &= ~(CyTxMpty | CyTxRdy);
 		base_addr[CyTEOIR] = CyNOTRANS;
 		return IRQ_HANDLED;
 	}
+	info = &cy_port[channel];
 	info->last_active = jiffies;
 	if (info->tty == 0) {
 		base_addr[CyIER] &= ~(CyTxMpty | CyTxRdy);
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
hfc_usb-fix-read-buffer-overflow.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
zfcp-test-kmalloc-failure-in-scsi_get_vpd_page.patch
st-fix-test-of-value-range-in-st_set_options.patch
drivers-staging-octeon-ethernet-rgmiic-dont-ignore-request_irq-return-code.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
random-kmalloc-failure-ignored-in-init_std_data.patch

