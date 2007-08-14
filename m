From: akpm@linux-foundation.org
Subject: - clean-up-duplicate-includes-in-drivers-net.patch removed from -mm tree
Date: Tue, 14 Aug 2007 12:12:08 -0700
Message-ID: <200708141912.l7EJC8SU016377@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55350 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934771AbXHNTMy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:12:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     Clean up duplicate includes in drivers/net/
has been removed from the -mm tree.  Its filename was
     clean-up-duplicate-includes-in-drivers-net.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Clean up duplicate includes in drivers/net/
From: Jesper Juhl <jesper.juhl@gmail.com>

This patch cleans up duplicate includes in
	 drivers/net/

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Acked-by: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/atl1/atl1_main.c           |    1 -
 drivers/net/bfin_mac.c                 |    5 -----
 drivers/net/bonding/bond_sysfs.c       |    1 -
 drivers/net/fs_enet/fs_enet-main.c     |    2 --
 drivers/net/gianfar.h                  |    1 -
 drivers/net/gianfar_ethtool.c          |    1 -
 drivers/net/irda/kingsun-sir.c         |    1 -
 drivers/net/irda/mcs7780.c             |    1 -
 drivers/net/mipsnet.c                  |    1 -
 drivers/net/netxen/netxen_nic_main.c   |    1 -
 drivers/net/qla3xxx.c                  |    1 -
 drivers/net/tsi108_eth.c               |    1 -
 drivers/net/wireless/ipw2200.h         |    1 -
 drivers/net/wireless/zd1211rw/zd_def.h |    1 -
 14 files changed, 19 deletions(-)

diff -puN drivers/net/atl1/atl1_main.c~clean-up-duplicate-includes-in-drivers-net drivers/net/atl1/atl1_main.c
--- a/drivers/net/atl1/atl1_main.c~clean-up-duplicate-includes-in-drivers-net
+++ a/drivers/net/atl1/atl1_main.c
@@ -76,7 +76,6 @@
 #include <linux/compiler.h>
 #include <linux/delay.h>
 #include <linux/mii.h>
-#include <linux/interrupt.h>
 #include <net/checksum.h>
 
 #include <asm/atomic.h>
diff -puN drivers/net/bfin_mac.c~clean-up-duplicate-includes-in-drivers-net drivers/net/bfin_mac.c
--- a/drivers/net/bfin_mac.c~clean-up-duplicate-includes-in-drivers-net
+++ a/drivers/net/bfin_mac.c
@@ -47,15 +47,10 @@
 #include <linux/spinlock.h>
 #include <linux/ethtool.h>
 #include <linux/mii.h>
-
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
-
 #include <linux/platform_device.h>
-#include <linux/netdevice.h>
-#include <linux/etherdevice.h>
-#include <linux/skbuff.h>
 
 #include <asm/dma.h>
 #include <linux/dma-mapping.h>
diff -puN drivers/net/bonding/bond_sysfs.c~clean-up-duplicate-includes-in-drivers-net drivers/net/bonding/bond_sysfs.c
--- a/drivers/net/bonding/bond_sysfs.c~clean-up-duplicate-includes-in-drivers-net
+++ a/drivers/net/bonding/bond_sysfs.c
@@ -31,7 +31,6 @@
 #include <linux/inetdevice.h>
 #include <linux/in.h>
 #include <linux/sysfs.h>
-#include <linux/string.h>
 #include <linux/ctype.h>
 #include <linux/inet.h>
 #include <linux/rtnetlink.h>
diff -puN drivers/net/fs_enet/fs_enet-main.c~clean-up-duplicate-includes-in-drivers-net drivers/net/fs_enet/fs_enet-main.c
--- a/drivers/net/fs_enet/fs_enet-main.c~clean-up-duplicate-includes-in-drivers-net
+++ a/drivers/net/fs_enet/fs_enet-main.c
@@ -39,8 +39,6 @@
 
 #include <linux/vmalloc.h>
 #include <asm/pgtable.h>
-
-#include <asm/pgtable.h>
 #include <asm/irq.h>
 #include <asm/uaccess.h>
 
diff -puN drivers/net/gianfar.h~clean-up-duplicate-includes-in-drivers-net drivers/net/gianfar.h
--- a/drivers/net/gianfar.h~clean-up-duplicate-includes-in-drivers-net
+++ a/drivers/net/gianfar.h
@@ -45,7 +45,6 @@
 #include <linux/crc32.h>
 #include <linux/workqueue.h>
 #include <linux/ethtool.h>
-#include <linux/netdevice.h>
 #include <linux/fsl_devices.h>
 #include "gianfar_mii.h"
 
diff -puN drivers/net/gianfar_ethtool.c~clean-up-duplicate-includes-in-drivers-net drivers/net/gianfar_ethtool.c
--- a/drivers/net/gianfar_ethtool.c~clean-up-duplicate-includes-in-drivers-net
+++ a/drivers/net/gianfar_ethtool.c
@@ -34,7 +34,6 @@
 #include <linux/module.h>
 #include <linux/crc32.h>
 #include <asm/types.h>
-#include <asm/uaccess.h>
 #include <linux/ethtool.h>
 #include <linux/mii.h>
 #include <linux/phy.h>
diff -puN drivers/net/irda/kingsun-sir.c~clean-up-duplicate-includes-in-drivers-net drivers/net/irda/kingsun-sir.c
--- a/drivers/net/irda/kingsun-sir.c~clean-up-duplicate-includes-in-drivers-net
+++ a/drivers/net/irda/kingsun-sir.c
@@ -66,7 +66,6 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/slab.h>
-#include <linux/module.h>
 #include <linux/kref.h>
 #include <linux/usb.h>
 #include <linux/device.h>
diff -puN drivers/net/irda/mcs7780.c~clean-up-duplicate-includes-in-drivers-net drivers/net/irda/mcs7780.c
--- a/drivers/net/irda/mcs7780.c~clean-up-duplicate-includes-in-drivers-net
+++ a/drivers/net/irda/mcs7780.c
@@ -50,7 +50,6 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/slab.h>
-#include <linux/module.h>
 #include <linux/kref.h>
 #include <linux/usb.h>
 #include <linux/device.h>
diff -puN drivers/net/mipsnet.c~clean-up-duplicate-includes-in-drivers-net drivers/net/mipsnet.c
--- a/drivers/net/mipsnet.c~clean-up-duplicate-includes-in-drivers-net
+++ a/drivers/net/mipsnet.c
@@ -11,7 +11,6 @@
 #include <linux/module.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
-#include <linux/netdevice.h>
 #include <linux/platform_device.h>
 #include <asm/io.h>
 #include <asm/mips-boards/simint.h>
diff -puN drivers/net/netxen/netxen_nic_main.c~clean-up-duplicate-includes-in-drivers-net drivers/net/netxen/netxen_nic_main.c
--- a/drivers/net/netxen/netxen_nic_main.c~clean-up-duplicate-includes-in-drivers-net
+++ a/drivers/net/netxen/netxen_nic_main.c
@@ -39,7 +39,6 @@
 #include "netxen_nic_phan_reg.h"
 
 #include <linux/dma-mapping.h>
-#include <linux/vmalloc.h>
 #include <net/ip.h>
 
 MODULE_DESCRIPTION("NetXen Multi port (1/10) Gigabit Network Driver");
diff -puN drivers/net/qla3xxx.c~clean-up-duplicate-includes-in-drivers-net drivers/net/qla3xxx.c
--- a/drivers/net/qla3xxx.c~clean-up-duplicate-includes-in-drivers-net
+++ a/drivers/net/qla3xxx.c
@@ -31,7 +31,6 @@
 #include <linux/skbuff.h>
 #include <linux/rtnetlink.h>
 #include <linux/if_vlan.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/mm.h>
 
diff -puN drivers/net/tsi108_eth.c~clean-up-duplicate-includes-in-drivers-net drivers/net/tsi108_eth.c
--- a/drivers/net/tsi108_eth.c~clean-up-duplicate-includes-in-drivers-net
+++ a/drivers/net/tsi108_eth.c
@@ -47,7 +47,6 @@
 #include <linux/rtnetlink.h>
 #include <linux/timer.h>
 #include <linux/platform_device.h>
-#include <linux/etherdevice.h>
 
 #include <asm/system.h>
 #include <asm/io.h>
diff -puN drivers/net/wireless/ipw2200.h~clean-up-duplicate-includes-in-drivers-net drivers/net/wireless/ipw2200.h
--- a/drivers/net/wireless/ipw2200.h~clean-up-duplicate-includes-in-drivers-net
+++ a/drivers/net/wireless/ipw2200.h
@@ -45,7 +45,6 @@
 
 #include <linux/firmware.h>
 #include <linux/wireless.h>
-#include <linux/dma-mapping.h>
 #include <linux/jiffies.h>
 #include <asm/io.h>
 
diff -puN drivers/net/wireless/zd1211rw/zd_def.h~clean-up-duplicate-includes-in-drivers-net drivers/net/wireless/zd1211rw/zd_def.h
--- a/drivers/net/wireless/zd1211rw/zd_def.h~clean-up-duplicate-includes-in-drivers-net
+++ a/drivers/net/wireless/zd1211rw/zd_def.h
@@ -21,7 +21,6 @@
 #include <linux/kernel.h>
 #include <linux/stringify.h>
 #include <linux/device.h>
-#include <linux/kernel.h>
 
 typedef u16 __nocast zd_addr_t;
 
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
git-alsa.patch
git-agpgart.patch
fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch
powerpc-clean-out-a-bunch-of-duplicate-includes.patch
mga_dma-return-err-not-just-zero-from-mga_do_cleanup_dma.patch
git-dvb.patch
git-gfs2-nmw.patch
clean-up-duplicate-includes-in-drivers-input.patch
scripts-ver_linux-correct-printing-of-binutils-version.patch
improve-scripts-gcc-versionsh-output-a-bit-when-called-without-args.patch
git-mtd.patch
git-ubi.patch
git-netdev-all.patch
git-backlight.patch
clean-up-duplicate-includes-in-include-linux-nfs_fsh.patch
clean-up-duplicate-includes-in-fs-ntfs.patch
sh64-arch-sh64-kernel-signalh-duplicate-include-removal.patch
clean-up-duplicate-includes-in-drivers-scsi.patch
mpt-fusion-fix-two-potential-mem-leaks.patch
fix-a-potential-null-pointer-deref-in-the-aic7xxx-ahc_print_register-function.patch
git-xfs.patch
fix-a-potential-null-pointer-deref-in-xfs-on-failed-mount.patch
clean-up-duplicate-includes-in-include-linux-memory_hotplugh.patch
clean-up-duplicate-includes-in-mm.patch
clean-up-duplicate-includes-in-drivers-char.patch
clean-up-duplicate-includes-in-drivers-w1.patch
clean-up-duplicate-includes-in-fs.patch
clean-up-duplicate-includes-in-fs-ecryptfs.patch
clean-up-duplicate-includes-in-kernel.patch
avoid-a-small-unlikely-memory-leak-in-proc_read_escd.patch
clean-up-duplicate-includes-in-drivers-spi.patch
fix-possible-null-deref-on-low-memory-condition-in-capidrvcsend_message.patch
isdn-guard-against-a-potential-null-pointer-dereference-in-old_capi_manufacturer.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
clean-up-duplicate-includes-in-documentation.patch
