From: akpm@linux-foundation.org
Subject: [merged] serial-two-branches-the-same-in-timbuart_set_mctrl.patch removed from -mm tree
Date: Thu, 06 May 2010 12:09:15 -0400
Message-ID: <201005061910.o46JAjne008548@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35037 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755639Ab0EFTLE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 May 2010 15:11:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com, richard.rojfors@pelagicore.com, mm-commits@vger.kernel.org


The patch titled
     serial: two branches the same in timbuart_set_mctrl()
has been removed from the -mm tree.  Its filename was
     serial-two-branches-the-same-in-timbuart_set_mctrl.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: serial: two branches the same in timbuart_set_mctrl()
=46rom: Roel Kluin <roel.kluin@gmail.com>

CTS is a read only bit and we are to stop signal RTS if modem line
TIOCM_RTS is not set.

Thanks for suggestions by Richard R=F6jfors.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Richard R=F6jfors <richard.rojfors@pelagicore.com>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/timbuart.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/serial/timbuart.c~serial-two-branches-the-same-in-tim=
buart_set_mctrl drivers/serial/timbuart.c
--- a/drivers/serial/timbuart.c~serial-two-branches-the-same-in-timbuar=
t_set_mctrl
+++ a/drivers/serial/timbuart.c
@@ -220,7 +220,7 @@ static void timbuart_set_mctrl(struct ua
 	if (mctrl & TIOCM_RTS)
 		iowrite8(TIMBUART_CTRL_RTS, port->membase + TIMBUART_CTRL);
 	else
-		iowrite8(TIMBUART_CTRL_RTS, port->membase + TIMBUART_CTRL);
+		iowrite8(0, port->membase + TIMBUART_CTRL);
 }
=20
 static void timbuart_mctrl_check(struct uart_port *port, u32 isr, u32 =
*ier)
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
score-fix-dereference-of-null-pointer-in-local_flush_tlb_page.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.pat=
ch
ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch
dc395x-decrease-iteration-for-tag_number-of-max_command-in-start_scsi.p=
atch
lpfc-positive-error-return-into-negative.patch
scsi-bfa-correct-onstack-wait_queue_head-declaration.patch
bfa-wrong-fcport-h2i-message-tested-in-bfa_fcport_isr.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hvsi-messed-up-error-checking-getting-state-name.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
