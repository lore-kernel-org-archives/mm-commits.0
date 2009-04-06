From: akpm@linux-foundation.org
Subject: [merged] floppy-provide-a-pnp-device-table-in-the-module.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:32:45 -0700
Message-ID: <200904061932.n36JWjCv010860@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35882 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754507AbZDFThC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:37:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: scott@canonical.com, bjorn.helgaas@hp.com, kay.sievers@vrfy.org, phdm@macqel.be, tim.gardner@canonical.com, mm-commits@vger.kernel.org


The patch titled
     floppy: provide a PNP device table in the module.
has been removed from the -mm tree.  Its filename was
     floppy-provide-a-pnp-device-table-in-the-module.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: floppy: provide a PNP device table in the module.
From: Scott James Remnant <scott@canonical.com>

The missing device table means that the floppy module is not auto-loaded,
even when the appropriate PNP device (0700) is found.

We don't actually use the table in the module, since the device doesn't
have a struct pnp_driver, but it's sufficient to cause an alias in the
module that udev/modprobe will use.

Signed-off-by: Scott James Remnant <scott@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Philippe De Muyter <phdm@macqel.be>
Acked-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN drivers/block/floppy.c~floppy-provide-a-pnp-device-table-in-the-module drivers/block/floppy.c
--- a/drivers/block/floppy.c~floppy-provide-a-pnp-device-table-in-the-module
+++ a/drivers/block/floppy.c
@@ -177,6 +177,7 @@ static int print_unex = 1;
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
+#include <linux/mod_devicetable.h>
 #include <linux/buffer_head.h>	/* for invalidate_buffers() */
 #include <linux/mutex.h>
 
@@ -4597,6 +4598,13 @@ MODULE_AUTHOR("Alain L. Knaff");
 MODULE_SUPPORTED_DEVICE("fd");
 MODULE_LICENSE("GPL");
 
+/* This doesn't actually get used other than for module information */
+static const struct pnp_device_id floppy_pnpids[] = {
+	{ "PNP0700", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(pnp, floppy_pnpids);
+
 #else
 
 __setup("floppy=", floppy_setup);
_

Patches currently in -mm which might be from scott@canonical.com are

origin.patch
linux-next.patch

