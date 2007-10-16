From: akpm@linux-foundation.org
Subject: - m32r-serial-remove-m32r_sio_share_irqs.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:36:37 -0700
Message-ID: <200710162036.l9GKabIp015197@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54160 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966046AbXJPVdx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:33:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: takata@linux-m32r.org, rpjday@mindspring.com, mm-commits@vger.kernel.org


The patch titled
     m32r: serial: remove M32R_SIO_SHARE_IRQS
has been removed from the -mm tree.  Its filename was
     m32r-serial-remove-m32r_sio_share_irqs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: m32r: serial: remove M32R_SIO_SHARE_IRQS
From: Hirokazu Takata <takata@linux-m32r.org>

Remove an unused symbol M32R_SIO_SHARE_IRQS from drivers/serial/m32r_sio.h.

Signed-off-by: Hirokazu Takata <takata@linux-m32r.org>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/m32r_sio.c |    2 +-
 drivers/serial/m32r_sio.h |    6 ------
 2 files changed, 1 insertion(+), 7 deletions(-)

diff -puN drivers/serial/m32r_sio.c~m32r-serial-remove-m32r_sio_share_irqs drivers/serial/m32r_sio.c
--- a/drivers/serial/m32r_sio.c~m32r-serial-remove-m32r_sio_share_irqs
+++ a/drivers/serial/m32r_sio.c
@@ -539,7 +539,7 @@ static void serial_do_unlink(struct irq_
 static int serial_link_irq_chain(struct uart_sio_port *up)
 {
 	struct irq_info *i = irq_lists + up->port.irq;
-	int ret, irq_flags = up->port.flags & UPF_SHARE_IRQ ? IRQF_SHARED : 0;
+	int ret, irq_flags = 0;
 
 	spin_lock_irq(&i->lock);
 
diff -puN drivers/serial/m32r_sio.h~m32r-serial-remove-m32r_sio_share_irqs drivers/serial/m32r_sio.h
--- a/drivers/serial/m32r_sio.h~m32r-serial-remove-m32r_sio_share_irqs
+++ a/drivers/serial/m32r_sio.h
@@ -46,9 +46,3 @@ struct old_serial_port {
 #define PROBE_ANY	(~0)
 
 #define HIGH_BITS_OFFSET ((sizeof(long)-sizeof(int))*8)
-
-#ifdef CONFIG_SERIAL_SIO_SHARE_IRQ
-#define M32R_SIO_SHARE_IRQS 1
-#else
-#define M32R_SIO_SHARE_IRQS 0
-#endif
_

Patches currently in -mm which might be from takata@linux-m32r.org are

origin.patch
git-m32r.patch
bitops-introduce-lock-ops.patch
