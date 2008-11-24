From: akpm@linux-foundation.org
Subject: - net-hp-plus-fix-link-errors.patch removed from -mm tree
Date: Mon, 24 Nov 2008 11:29:52 -0800
Message-ID: <200811241929.mAOJTqXT027937@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45784 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752675AbYKXTap (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Nov 2008 14:30:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, alan@lxorguk.ukuu.org.uk, davem@davemloft.net, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     net/hp-plus: fix link errors
has been removed from the -mm tree.  Its filename was
     net-hp-plus-fix-link-errors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: net/hp-plus: fix link errors
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix hp-plus driver link errors.

Builds as loadable module and kernel image driver.

All drivers that use 8390.o or 8390p.o that will build on i386 with
MCA/PCI/EISA/ISA were built successfully both =m and =y.

drivers/built-in.o: In function `hpp_open':
hp-plus.c:(.text+0xac06c): undefined reference to `eip_interrupt'
hp-plus.c:(.text+0xac0d7): undefined reference to `eip_open'
drivers/built-in.o: In function `hpp_close':
hp-plus.c:(.text+0xac1bb): undefined reference to `eip_close'
drivers/built-in.o: In function `hpp_probe1':
hp-plus.c:(.init.text+0xa98a): undefined reference to `NS8390p_init'
drivers/built-in.o: In function `hp_plus_probe':
(.init.text+0xa9fe): undefined reference to `__alloc_eip_netdev'

(akpm: needed in 2.6.28)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/Makefile~net-hp-plus-fix-link-errors drivers/net/Makefile
--- a/drivers/net/Makefile~net-hp-plus-fix-link-errors
+++ a/drivers/net/Makefile
@@ -113,7 +113,7 @@ obj-$(CONFIG_EL2) += 3c503.o 8390p.o
 obj-$(CONFIG_NE2000) += ne.o 8390p.o
 obj-$(CONFIG_NE2_MCA) += ne2.o 8390p.o
 obj-$(CONFIG_HPLAN) += hp.o 8390p.o
-obj-$(CONFIG_HPLAN_PLUS) += hp-plus.o 8390.o
+obj-$(CONFIG_HPLAN_PLUS) += hp-plus.o 8390p.o
 obj-$(CONFIG_ULTRA) += smc-ultra.o 8390.o
 obj-$(CONFIG_ULTRAMCA) += smc-mca.o 8390.o
 obj-$(CONFIG_ULTRA32) += smc-ultra32.o 8390.o
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
kgdb-fix-kernel-doc-error.patch
arm-fix-kernel-doc-syntax.patch
audit-remove-excess-kernel-doc.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
scripts-extract-ikconfig-remove-bashisms.patch
drivers-ata-pata_radisysc-cleanup-kernel-doc.patch
drivers-ata-libata-corec-cleanup-kernel-doc.patch
drivers-ata-pata_oldpiixc-cleanup-kernel-doc.patch
drivers-ata-pata_pdc2027xc-cleanup-kernel-doc.patch
drivers-ata-pata_legacyc-cleanup-kernel-doc.patch
drivers-ata-pata_sisc-cleanup-kernel-doc.patch
drivers-ata-pata_c-the-rest-remove-redundant-comments.patch
mtd-remove-excess-kernel-doc-notation.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
gdth-fix-section-mismatch-warnings.patch
esp-fix-section-mismatch-warning.patch
fusion-remove-excess-kernel-doc-notation.patch
block-remove-excess-kernel-doc.patch
fs-ncpfs-getoptc-cleanup-keneldoc.patch
max3100-spi-uart-driver-select-serial_core.patch
max3100-spi-uart-driver-select-serial_core-fix.patch
i2o-remove-extraneous-kernel-doc.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
fs-ecryptfs-inodec-cleanup-kerneldoc.patch
kmod-fix-varargs-kernel-doc.patch
docs-document-how-to-write-varargs-in-kernel-doc.patch
rapidio-remove-excess-kernel-doc-notation.patch
documentation-update-header-file-paths.patch
documentation-update-s390-header-file-paths.patch
profile-likely-unlikely-macros.patch

