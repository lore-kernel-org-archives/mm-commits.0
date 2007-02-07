From: akpm@linux-foundation.org
Subject: + atm-use-array_size-macro-when-appropriate.patch added to -mm tree
Date: Tue, 06 Feb 2007 16:05:33 -0800
Message-ID: <200702070005.l1705YrW001166@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56137 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030255AbXBGAHQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Feb 2007 19:07:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: darwish.07@gmail.com, chas@cmf.nrl.navy.mil, davem@davemloft.net, jeff@garzik.org


The patch titled
     atm: Use ARRAY_SIZE macro when appropriate
has been added to the -mm tree.  Its filename is
     atm-use-array_size-macro-when-appropriate.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: atm: Use ARRAY_SIZE macro when appropriate
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

Use ARRAY_SIZE macro already defined in kernel.h for ATM
drivers.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: chas williams <chas@cmf.nrl.navy.mil>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/atm/he.c         |    2 +-
 drivers/atm/idt77252.c   |    8 ++++----
 drivers/atm/nicstarmac.c |    4 +++-
 3 files changed, 8 insertions(+), 6 deletions(-)

diff -puN drivers/atm/he.c~atm-use-array_size-macro-when-appropriate drivers/atm/he.c
--- a/drivers/atm/he.c~atm-use-array_size-macro-when-appropriate
+++ a/drivers/atm/he.c
@@ -3017,7 +3017,7 @@ read_prom_byte(struct he_dev *he_dev, in
 	he_writel(he_dev, val, HOST_CNTL);
        
 	/* Send READ instruction */
-	for (i = 0; i < sizeof(readtab)/sizeof(readtab[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(readtab); i++) {
 		he_writel(he_dev, val | readtab[i], HOST_CNTL);
 		udelay(EEPROM_DELAY);
 	}
diff -puN drivers/atm/idt77252.c~atm-use-array_size-macro-when-appropriate drivers/atm/idt77252.c
--- a/drivers/atm/idt77252.c~atm-use-array_size-macro-when-appropriate
+++ a/drivers/atm/idt77252.c
@@ -388,7 +388,7 @@ idt77252_eeprom_read_status(struct idt77
 
 	gp = idt77252_read_gp(card) & ~(SAR_GP_EESCLK|SAR_GP_EECS|SAR_GP_EEDO);
 
-	for (i = 0; i < sizeof(rdsrtab)/sizeof(rdsrtab[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(rdsrtab); i++) {
 		idt77252_write_gp(card, gp | rdsrtab[i]);
 		udelay(5);
 	}
@@ -422,7 +422,7 @@ idt77252_eeprom_read_byte(struct idt7725
 
 	gp = idt77252_read_gp(card) & ~(SAR_GP_EESCLK|SAR_GP_EECS|SAR_GP_EEDO);
 
-	for (i = 0; i < sizeof(rdtab)/sizeof(rdtab[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(rdtab); i++) {
 		idt77252_write_gp(card, gp | rdtab[i]);
 		udelay(5);
 	}
@@ -469,14 +469,14 @@ idt77252_eeprom_write_byte(struct idt772
 
 	gp = idt77252_read_gp(card) & ~(SAR_GP_EESCLK|SAR_GP_EECS|SAR_GP_EEDO);
 
-	for (i = 0; i < sizeof(wrentab)/sizeof(wrentab[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(wrentab); i++) {
 		idt77252_write_gp(card, gp | wrentab[i]);
 		udelay(5);
 	}
 	idt77252_write_gp(card, gp | SAR_GP_EECS);
 	udelay(5);
 
-	for (i = 0; i < sizeof(wrtab)/sizeof(wrtab[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(wrtab); i++) {
 		idt77252_write_gp(card, gp | wrtab[i]);
 		udelay(5);
 	}
diff -puN drivers/atm/nicstarmac.c~atm-use-array_size-macro-when-appropriate drivers/atm/nicstarmac.c
--- a/drivers/atm/nicstarmac.c~atm-use-array_size-macro-when-appropriate
+++ a/drivers/atm/nicstarmac.c
@@ -7,6 +7,8 @@
  * Read this ForeRunner's MAC address from eprom/eeprom
  */
 
+#include <linux/kernel.h>
+
 typedef void __iomem *virt_addr_t;
 
 #define CYCLE_DELAY 5
@@ -176,7 +178,7 @@ read_eprom_byte(virt_addr_t base, u_int8
    val = NICSTAR_REG_READ( base, NICSTAR_REG_GENERAL_PURPOSE ) & 0xFFFFFFF0;
 
    /* Send READ instruction */
-   for (i=0; i<sizeof readtab/sizeof readtab[0]; i++)
+   for (i=0; i<ARRAY_SIZE(readtab); i++)
    {
 	NICSTAR_REG_WRITE( base, NICSTAR_REG_GENERAL_PURPOSE,
 		(val | readtab[i]) );
_

Patches currently in -mm which might be from darwish.07@gmail.com are

arch-arm-use-array_size-macro-when-appropriate.patch
arch-avr32-use-array_size-macro-when-appropriate.patch
arch-powerpc-user-array_size-macro-when-appropriate.patch
arch-ppc-user-array_size-macro-when-appropriate.patch
git-dvb.patch
git-netdev-all.patch
s390-kmalloc-kzalloc-casting-cleanups.patch
dac960-kmalloc-kzalloc-casting-cleanups.patch
arch-arm26-use-array_size-macro-when-appropriate.patch
arch-m68knommu-user-array_size-macro-when-appropriate.patch
arch-m68k-user-array_size-macro-when-appropriate.patch
arch-cris-user-array_size-macro-when-appropriate.patch
arch-v850-user-array_size-macro-when-appropriate.patch
w1-use-array_size-macro-when-appropriate.patch
isdn-capi-use-array_size-when-appropriate.patch
dvb-use-array_size-macro-when-appropriate.patch
isdn-eicon-use-array_size-macro-when-appropriate.patch
oss-use-array_size-macro-when-appropriate.patch
oss-use-array_size-macro-when-appropriate-2.patch
atm-use-array_size-macro-when-appropriate.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
s390-drivers-use-array_size-macro-when-appropriate.patch
rcutorture-use-array_size-macro-when-appropriate.patch
intel-agp-use-array_size-macro-when-appropriate.patch
reiserfs-use-array_size-macro-when-appropriate.patch
toshiba-acpi-use-array_size-macro-when-appropriate.patch
drm-use-array_size-macro-when-appropriate.patch
