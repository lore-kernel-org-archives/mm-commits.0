From: akpm@linux-foundation.org
Subject: [merged] agnx-make-input-parameters-const.patch removed from -mm tree
Date: Tue, 21 Apr 2009 11:08:24 -0700
Message-ID: <200904211808.n3LI8Ovn010135@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35284 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752011AbZDUSKx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Apr 2009 14:10:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     agnx: make input parameters const
has been removed from the -mm tree.  Its filename was
     agnx-make-input-parameters-const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: agnx: make input parameters const
From: Geert Uytterhoeven <geert@linux-m68k.org>

| drivers/staging/agnx/pci.c:317: warning: passing argument 2 of 'agnx_set_bssid' discards qualifiers from pointer target
| drivers/staging/agnx/pci.c:319: warning: passing argument 2 of 'hash_write' discards qualifiers from pointer target type

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/agnx/phy.c |    4 ++--
 drivers/staging/agnx/phy.h |    2 +-
 drivers/staging/agnx/sta.c |    2 +-
 drivers/staging/agnx/sta.h |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/staging/agnx/phy.c~agnx-make-input-parameters-const drivers/staging/agnx/phy.c
--- a/drivers/staging/agnx/phy.c~agnx-make-input-parameters-const
+++ a/drivers/staging/agnx/phy.c
@@ -118,7 +118,7 @@ static void mac_address_set(struct agnx_
 	iowrite32(reg, ctl + AGNX_RXM_MACLO);
 }
 
-static void receiver_bssid_set(struct agnx_priv *priv, u8 *bssid)
+static void receiver_bssid_set(struct agnx_priv *priv, const u8 *bssid)
 {
 	void __iomem *ctl = priv->ctl;
 	u32 reg;
@@ -954,7 +954,7 @@ int agnx_set_ssid(struct agnx_priv *priv
 	return 0;
 }
 
-void agnx_set_bssid(struct agnx_priv *priv, u8 *bssid)
+void agnx_set_bssid(struct agnx_priv *priv, const u8 *bssid)
 {
 	receiver_bssid_set(priv, bssid);
 }
diff -puN drivers/staging/agnx/phy.h~agnx-make-input-parameters-const drivers/staging/agnx/phy.h
--- a/drivers/staging/agnx/phy.h~agnx-make-input-parameters-const
+++ a/drivers/staging/agnx/phy.h
@@ -401,7 +401,7 @@ u8 read_from_eeprom(struct agnx_priv *pr
 void agnx_hw_init(struct agnx_priv *priv);
 int agnx_hw_reset(struct agnx_priv *priv);
 int agnx_set_ssid(struct agnx_priv *priv, u8 *ssid, size_t ssid_len);
-void agnx_set_bssid(struct agnx_priv *priv, u8 *bssid);
+void agnx_set_bssid(struct agnx_priv *priv, const u8 *bssid);
 void enable_power_saving(struct agnx_priv *priv);
 void disable_power_saving(struct agnx_priv *priv);
 void calibrate_antenna_period(unsigned long data);
diff -puN drivers/staging/agnx/sta.c~agnx-make-input-parameters-const drivers/staging/agnx/sta.c
--- a/drivers/staging/agnx/sta.c~agnx-make-input-parameters-const
+++ a/drivers/staging/agnx/sta.c
@@ -22,7 +22,7 @@ void hash_read(struct agnx_priv *priv, u
 	printk(PFX "RX hash cmd are : %.8x%.8x\n", reghi, reglo);
 }
 
-void hash_write(struct agnx_priv *priv, u8 *mac_addr, u8 sta_id)
+void hash_write(struct agnx_priv *priv, const u8 *mac_addr, u8 sta_id)
 {
 	void __iomem *ctl = priv->ctl;
 	u32 reghi, reglo;
diff -puN drivers/staging/agnx/sta.h~agnx-make-input-parameters-const drivers/staging/agnx/sta.h
--- a/drivers/staging/agnx/sta.h~agnx-make-input-parameters-const
+++ a/drivers/staging/agnx/sta.h
@@ -201,7 +201,7 @@ struct agnx_beacon_hdr {
 	/* 802.11(abg) beacon */
 } __attribute__((__packed__));
 
-void hash_write(struct agnx_priv *priv, u8 *mac_addr, u8 sta_id);
+void hash_write(struct agnx_priv *priv, const u8 *mac_addr, u8 sta_id);
 void hash_dump(struct agnx_priv *priv, u8 sta_id);
 void hash_read(struct agnx_priv *priv, u32 reghi, u32 reglo, u8 sta_id);
 void hash_delete(struct agnx_priv *priv, u32 reghi, u32 reglo, u8 sta_id);
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
drivers-input-serio-hp_sdcc-fix-crash-when-removing-hp_sdc-module.patch
linux-next.patch
time-create-arch_gettimeoffset-infrastructure-for-use-in-the-generic-timekeeping-core.patch
scsi-a4000-correct-driver-unregistration-in-case-of-failure.patch
m68k-count-can-reach-51-not-50.patch
kmap_types-make-most-arches-use-generic-header-file.patch
flat-fix-data-sections-alignment.patch

