From: akpm@linux-foundation.org
Subject: - message-fusion-remove-redundant-memset.patch removed from -mm tree
Date: Sun, 16 Sep 2007 02:27:40 -0700
Message-ID: <200709160927.l8G9ReDE009277@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48264 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751970AbXIPJiY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 05:38:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, Eric.Moore@lsil.com, mm-commits@vger.kernel.org


The patch titled
     message/fusion: remove redundant memset
has been removed from the -mm tree.  Its filename was
     message-fusion-remove-redundant-memset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: message/fusion: remove redundant memset
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

alloc_fcdev() calls alloc_netdev() which uses kzalloc to alloc all the
memory together with dev->priv region hence no zeroing of structs inside
struct mpt_lan_priv needed.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptlan.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/message/fusion/mptlan.c~message-fusion-remove-redundant-memset drivers/message/fusion/mptlan.c
--- a/drivers/message/fusion/mptlan.c~message-fusion-remove-redundant-memset
+++ a/drivers/message/fusion/mptlan.c
@@ -1345,10 +1345,11 @@ mpt_lan_post_receive_buckets_work(struct
 static struct net_device *
 mpt_register_lan_device (MPT_ADAPTER *mpt_dev, int pnum)
 {
-	struct net_device *dev = alloc_fcdev(sizeof(struct mpt_lan_priv));
-	struct mpt_lan_priv *priv = NULL;
+	struct net_device *dev;
+	struct mpt_lan_priv *priv;
 	u8 HWaddr[FC_ALEN], *a;
 
+	dev = alloc_fcdev(sizeof(struct mpt_lan_priv));
 	if (!dev)
 		return NULL;
 
@@ -1360,7 +1361,6 @@ mpt_register_lan_device (MPT_ADAPTER *mp
 	priv->mpt_dev = mpt_dev;
 	priv->pnum = pnum;
 
-	memset(&priv->post_buckets_task, 0, sizeof(priv->post_buckets_task));
 	INIT_DELAYED_WORK(&priv->post_buckets_task,
 			  mpt_lan_post_receive_buckets_work);
 	priv->post_buckets_active = 0;
@@ -1385,8 +1385,6 @@ mpt_register_lan_device (MPT_ADAPTER *mp
 	spin_lock_init(&priv->txfidx_lock);
 	spin_lock_init(&priv->rxfidx_lock);
 
-	memset(&priv->stats, 0, sizeof(priv->stats));
-
 	/*  Grab pre-fetched LANPage1 stuff. :-) */
 	a = (u8 *) &mpt_dev->lan_cnfg_page1.HardwareAddressLow;
 
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

git-alsa.patch
arm-unbalanced-parenthesis-fix.patch
fs-cifs-connectc-kmalloc-memset-conversion-to-kzalloc.patch
git-powerpc.patch
git-dvb.patch
git-mmc.patch
git-mtd.patch
git-net.patch
skge-remove-broken-and-unused-phy_m_pc_mdi_xmode-macro.patch
move-a-few-definitions-to-au1000_xxs1500c-fix.patch
git-scsi-misc.patch
include-asm-frv-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
include-asm-m32r-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
drivers-char-consolemapc-kmalloc-memset-conversion-to-kzalloc.patch
doc-firmware_sample_firmware_classc-kmalloc-memset-conversion-to-kzalloc.patch
fs-autofs4-inodec-kmalloc-memset-conversion-to-kzalloc.patch
drivers-char-ip2-ip2mainc-kmalloc-memset-conversion-to-kzalloc.patch
add-a-rounddown_pow_of_two-routine-to-log2hpatch-fix.patch
fs-jbd2-journalc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-file-cryptcompressc-kmalloc-memset-conversion-to-kzalloc.patch
reiser4-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-init_superc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-inode_ops_renamec-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc.patch
