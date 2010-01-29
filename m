From: akpm@linux-foundation.org
Subject: [merged] drivers-usb-serial-eliminate-useless-code.patch removed from -mm tree
Date: Fri, 29 Jan 2010 12:17:11 -0800
Message-ID: <201001292017.o0TKHBdY003289@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58022 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754802Ab0A2URr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Jan 2010 15:17:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, dignome@gmail.com, gregkh@suse.de, jhovold@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drivers/usb/serial: eliminate useless code
has been removed from the -mm tree.  Its filename was
     drivers-usb-serial-eliminate-useless-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/usb/serial: eliminate useless code
From: Julia Lawall <julia@diku.dk>

The variables priv and portdata are initialized twice to the same (side
effect-free) expressions.  Drop one initialization in each case.

A simplified version of the semantic match that finds this problem is:
(http://coccinelle.lip6.fr/)

// <smpl>
@forall@
idexpression *x;
identifier f!=ERR_PTR;
@@

x = f(...)
... when != x
(
x = f(...,<+...x...+>,...)
|
* x = f(...)
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Lonnie Mendez <dignome@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Acked-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/cypress_m8.c |    1 -
 drivers/usb/serial/sierra.c     |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/usb/serial/cypress_m8.c~drivers-usb-serial-eliminate-useless-code drivers/usb/serial/cypress_m8.c
--- a/drivers/usb/serial/cypress_m8.c~drivers-usb-serial-eliminate-useless-code
+++ a/drivers/usb/serial/cypress_m8.c
@@ -691,7 +691,6 @@ static void cypress_dtr_rts(struct usb_s
 {
 	struct cypress_private *priv = usb_get_serial_port_data(port);
 	/* drop dtr and rts */
-	priv = usb_get_serial_port_data(port);
 	spin_lock_irq(&priv->lock);
 	if (on == 0)
 		priv->line_control = 0;
diff -puN drivers/usb/serial/sierra.c~drivers-usb-serial-eliminate-useless-code drivers/usb/serial/sierra.c
--- a/drivers/usb/serial/sierra.c~drivers-usb-serial-eliminate-useless-code
+++ a/drivers/usb/serial/sierra.c
@@ -476,7 +476,7 @@ static void sierra_outdat_callback(struc
 static int sierra_write(struct tty_struct *tty, struct usb_serial_port *port,
 					const unsigned char *buf, int count)
 {
-	struct sierra_port_private *portdata = usb_get_serial_port_data(port);
+	struct sierra_port_private *portdata;
 	struct sierra_intf_private *intfdata;
 	struct usb_serial *serial = port->serial;
 	unsigned long flags;
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-scsi-sesc-eliminate-double-free.patch
kernel-credc-use-kmem_cache_free.patch
arch-arm-plat-pxa-dmac-correct-null-test.patch
drivers-gpu-drm-nouveau-nouveau_grctxc-correct-null-test.patch
drivers-media-video-move-dereference-after-null-test.patch
net-ipv4-correct-the-size-argument-to-kzalloc.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-bfa-bfad_imc-eliminate-useless-code.patch
drivers-staging-tm6000-tm6000-videoc-correct-null-test.patch
drivers-misc-iwmc3200top-mainc-eliminate-useless-code.patch
rtc-at91sam9-correct-size-given-to-memset.patch
drivers-edac-introduce-missing-kfree.patch
drivers-char-mmtimerc-eliminate-useless-code.patch

