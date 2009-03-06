From: akpm@linux-foundation.org
Subject: + floppy-provide-a-pnp-device-table-in-the-module.patch added to -mm tree
Date: Fri, 06 Mar 2009 15:49:41 -0800
Message-ID: <200903062349.n26NnfPE013597@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37747 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754078AbZCFXuW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Mar 2009 18:50:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: scott@canonical.com, bjorn.helgaas@hp.com, kay.sievers@vrfy.org, phdm@macqel.be, tim.gardner@canonical.com


The patch titled
     floppy: provide a PNP device table in the module.
has been added to the -mm tree.  Its filename is
     floppy-provide-a-pnp-device-table-in-the-module.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

floppy-provide-a-pnp-device-table-in-the-module.patch

