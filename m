From: akpm@linux-foundation.org
Subject: [merged] rapidio-fix-sysfs-config-attribute-to-access-16mb-of-maint-space.patch removed from -mm tree
Date: Mon, 28 Feb 2011 13:11:04 -0800
Message-ID: <201102282111.p1SLB4Aj029386@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57684 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755186Ab1B1VMI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Feb 2011 16:12:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, galak@kernel.crashing.org, leoli@freescale.com, micha@neli.hopto.org, mporter@kernel.crashing.org, thomas.moll@sysgo.com, mm-commits@vger.kernel.org


The patch titled
     rapidio: fix sysfs config attribute to access 16MB of maint space
has been removed from the -mm tree.  Its filename was
     rapidio-fix-sysfs-config-attribute-to-access-16mb-of-maint-space.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rapidio: fix sysfs config attribute to access 16MB of maint space
From: Alexandre Bounine <alexandre.bounine@idt.com>

Fixes sysfs config attribute to allow access to entire 16MB maintenance
space of RapidIO devices.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Cc: Micha Nelissen <micha@neli.hopto.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-sysfs.c |   12 ++++++------
 include/linux/rio_regs.h    |    4 +++-
 2 files changed, 9 insertions(+), 7 deletions(-)

diff -puN drivers/rapidio/rio-sysfs.c~rapidio-fix-sysfs-config-attribute-to-access-16mb-of-maint-space drivers/rapidio/rio-sysfs.c
--- a/drivers/rapidio/rio-sysfs.c~rapidio-fix-sysfs-config-attribute-to-access-16mb-of-maint-space
+++ a/drivers/rapidio/rio-sysfs.c
@@ -77,9 +77,9 @@ rio_read_config(struct file *filp, struc
 
 	/* Several chips lock up trying to read undefined config space */
 	if (capable(CAP_SYS_ADMIN))
-		size = 0x200000;
+		size = RIO_MAINT_SPACE_SZ;
 
-	if (off > size)
+	if (off >= size)
 		return 0;
 	if (off + count > size) {
 		size -= off;
@@ -147,10 +147,10 @@ rio_write_config(struct file *filp, stru
 	loff_t init_off = off;
 	u8 *data = (u8 *) buf;
 
-	if (off > 0x200000)
+	if (off >= RIO_MAINT_SPACE_SZ)
 		return 0;
-	if (off + count > 0x200000) {
-		size = 0x200000 - off;
+	if (off + count > RIO_MAINT_SPACE_SZ) {
+		size = RIO_MAINT_SPACE_SZ - off;
 		count = size;
 	}
 
@@ -200,7 +200,7 @@ static struct bin_attribute rio_config_a
 		 .name = "config",
 		 .mode = S_IRUGO | S_IWUSR,
 		 },
-	.size = 0x200000,
+	.size = RIO_MAINT_SPACE_SZ,
 	.read = rio_read_config,
 	.write = rio_write_config,
 };
diff -puN include/linux/rio_regs.h~rapidio-fix-sysfs-config-attribute-to-access-16mb-of-maint-space include/linux/rio_regs.h
--- a/include/linux/rio_regs.h~rapidio-fix-sysfs-config-attribute-to-access-16mb-of-maint-space
+++ a/include/linux/rio_regs.h
@@ -14,10 +14,12 @@
 #define LINUX_RIO_REGS_H
 
 /*
- * In RapidIO, each device has a 2MB configuration space that is
+ * In RapidIO, each device has a 16MB configuration space that is
  * accessed via maintenance transactions.  Portions of configuration
  * space are standardized and/or reserved.
  */
+#define RIO_MAINT_SPACE_SZ	0x1000000 /* 16MB of RapidIO mainenance space */
+
 #define RIO_DEV_ID_CAR		0x00	/* [I] Device Identity CAR */
 #define RIO_DEV_INFO_CAR	0x04	/* [I] Device Information CAR */
 #define RIO_ASM_ID_CAR		0x08	/* [I] Assembly Identity CAR */
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

origin.patch
rapidio-add-new-sysfs-attributes.patch
rapidio-add-new-sysfs-attributes-v2.patch
rapidio-add-rapidio-documentation.patch
rapidio-add-rapidio-documentation-v2.patch

