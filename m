From: akpm@osdl.org
Subject: + pnp-export-pnp_bus_type.patch added to -mm tree
Date: Thu, 28 Dec 2006 15:03:31 -0800
Message-ID: <200612282303.kBSN3V68015564@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:40080 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965046AbWL1XDw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Dec 2006 18:03:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, ambx1@neo.rr.com, dbrownell@users.sourceforge.net


The patch titled
     PNP: export pnp_bus_type
has been added to the -mm tree.  Its filename is
     pnp-export-pnp_bus_type.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PNP: export pnp_bus_type
From: David Brownell <david-b@pacbell.net>

The PNP framework doesn't export "pnp_bus_type", which is an unfortunate
exception to the policy followed by pretty much every other bus.  I noticed
this when I had to find a device in order to provide its platform_data.

Note that per advice from Arjan, the "export" scope has been been minimized to
avoid the hundred-plus bytes needed to support access from modules.  In this
case, the symbol is only needed by statically linked kernel code that lives
outside the drivers/pnp directory.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Adam Belay <ambx1@neo.rr.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/pnp/base.h  |    1 -
 include/linux/pnp.h |    2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/pnp/base.h~pnp-export-pnp_bus_type drivers/pnp/base.h
--- a/drivers/pnp/base.h~pnp-export-pnp_bus_type
+++ a/drivers/pnp/base.h
@@ -1,4 +1,3 @@
-extern struct bus_type pnp_bus_type;
 extern spinlock_t pnp_lock;
 void *pnp_alloc(long size);
 int pnp_interface_attach_device(struct pnp_dev *dev);
diff -puN include/linux/pnp.h~pnp-export-pnp_bus_type include/linux/pnp.h
--- a/include/linux/pnp.h~pnp-export-pnp_bus_type
+++ a/include/linux/pnp.h
@@ -352,6 +352,8 @@ struct pnp_protocol {
 	(dev) = protocol_to_pnp_dev((dev)->protocol_list.next))
 
 
+extern struct bus_type pnp_bus_type;
+
 #if defined(CONFIG_PNP)
 
 /* device management */
_

Patches currently in -mm which might be from david-b@pacbell.net are

spi-define-null-tx_buf-to-mean-shift-out-zeroes.patch
m25p80-build-fixes-with-mtd-debug.patch
spi-mtd-mtd_dataflash-oops-prevention.patch
spi-kconfig-fix.patch
spi-controller-driver-for-omap-microwire.patch
pnp-export-pnp_bus_type.patch
gpio-core.patch
omap-gpio-wrappers.patch
at91-gpio-wrappers.patch

