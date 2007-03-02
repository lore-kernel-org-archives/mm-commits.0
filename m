From: akpm@linux-foundation.org
Subject: + dz-remove-struct-pt_regs-references.patch added to -mm tree
Date: Thu, 01 Mar 2007 16:39:05 -0800
Message-ID: <200703020039.l220d5LS027672@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59907 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422658AbXCBAmW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 19:42:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: macro@linux-mips.org


The patch titled
     dz: remove struct pt_regs references
has been added to the -mm tree.  Its filename is
     dz-remove-struct-pt_regs-references.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dz: remove struct pt_regs references
From: "Maciej W. Rozycki" <macro@linux-mips.org>

Remove remaining references to saved registers now that
uart_handle_sysrq_char() does not want them.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/dz.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/serial/dz.c~dz-remove-struct-pt_regs-references drivers/serial/dz.c
--- a/drivers/serial/dz.c~dz-remove-struct-pt_regs-references
+++ a/drivers/serial/dz.c
@@ -170,8 +170,7 @@ static void dz_enable_ms(struct uart_por
  * This routine deals with inputs from any lines.
  * ------------------------------------------------------------
  */
-static inline void dz_receive_chars(struct dz_port *dport_in,
-				    struct pt_regs *regs)
+static inline void dz_receive_chars(struct dz_port *dport_in)
 {
 	struct dz_port *dport;
 	struct tty_struct *tty = NULL;
@@ -226,7 +225,7 @@ static inline void dz_receive_chars(stru
 			break;
 		}
 
-		if (uart_handle_sysrq_char(&dport->port, ch, regs))
+		if (uart_handle_sysrq_char(&dport->port, ch))
 			continue;
 
 		if ((status & dport->port.ignore_status_mask) == 0) {
@@ -332,7 +331,7 @@ static irqreturn_t dz_interrupt(int irq,
 	status = dz_in(dport, DZ_CSR);
 
 	if ((status & (DZ_RDONE | DZ_RIE)) == (DZ_RDONE | DZ_RIE))
-		dz_receive_chars(dport, regs);
+		dz_receive_chars(dport);
 
 	if ((status & (DZ_TRDY | DZ_TIE)) == (DZ_TRDY | DZ_TIE))
 		dz_transmit_chars(dport);
_

Patches currently in -mm which might be from macro@linux-mips.org are

aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
tgafb-turbochannel-support.patch
dz-remove-struct-pt_regs-references.patch
