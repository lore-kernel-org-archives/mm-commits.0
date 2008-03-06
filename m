From: akpm@linux-foundation.org
Subject: - drivers-usb-serial-io_tic-remove-unneeded-null-tty-check.patch removed from -mm tree
Date: Thu, 06 Mar 2008 14:22:26 -0800
Message-ID: <200803062222.m26MMQjk020809@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60414 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757201AbYCFWgq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 17:36:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ray-lk@madrabbit.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     drivers/usb/serial/io_ti.c: remove unneeded null tty check
has been removed from the -mm tree.  Its filename was
     drivers-usb-serial-io_tic-remove-unneeded-null-tty-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/usb/serial/io_ti.c: remove unneeded null tty check
From: Ray Lee <ray-lk@madrabbit.org>

The Coverity checker (and Adrian Bunk) spotted an inconsistent NULL check of
port->tty (it's blindly dereferenced later without the check).

Alan Cox confirmed the check can go.

Signed-off-by: Ray Lee <ray-lk@madrabbit.org>
Cc: Greg KH <gregkh@suse.de>
Cc: Adrian Bunk <bunk@kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/io_ti.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/usb/serial/io_ti.c~drivers-usb-serial-io_tic-remove-unneeded-null-tty-check drivers/usb/serial/io_ti.c
--- a/drivers/usb/serial/io_ti.c~drivers-usb-serial-io_tic-remove-unneeded-null-tty-check
+++ a/drivers/usb/serial/io_ti.c
@@ -1942,8 +1942,7 @@ static int edge_open (struct usb_serial_
 	if (edge_port == NULL)
 		return -ENODEV;
 
-	if (port->tty)
-		port->tty->low_latency = low_latency;
+	port->tty->low_latency = low_latency;
 
 	port_number = port->number - port->serial->minor;
 	switch (port_number) {
_

Patches currently in -mm which might be from ray-lk@madrabbit.org are

mempolicy-add-bitmap_onto-and-bitmap_fold-operations.patch

