From: akpm@osdl.org
Subject: - hostap-replace-kmallocmemset-with-kzalloc.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:18:57 -0800
Message-ID: <200612072318.kB7NIvUH031071@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:54096 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163957AbWLGXTS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:19:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: burman.yan@gmail.com, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     hostap: replace kmalloc+memset with kzalloc
has been removed from the -mm tree.  Its filename was
     hostap-replace-kmallocmemset-with-kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: hostap: replace kmalloc+memset with kzalloc
From: Yan Burman <burman.yan@gmail.com>

Replace kmalloc+memset with kzalloc

Signed-off-by: Yan Burman <burman.yan@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/wireless/hostap/hostap_ap.c       |    4 +---
 drivers/net/wireless/hostap/hostap_cs.c       |    3 +--
 drivers/net/wireless/hostap/hostap_download.c |    4 +---
 drivers/net/wireless/hostap/hostap_hw.c       |   12 +++---------
 drivers/net/wireless/hostap/hostap_info.c     |    3 +--
 drivers/net/wireless/hostap/hostap_ioctl.c    |   12 +++---------
 drivers/net/wireless/hostap/hostap_pci.c      |    3 +--
 drivers/net/wireless/hostap/hostap_plx.c      |    3 +--
 8 files changed, 12 insertions(+), 32 deletions(-)

diff -puN drivers/net/wireless/hostap/hostap_ap.c~hostap-replace-kmallocmemset-with-kzalloc drivers/net/wireless/hostap/hostap_ap.c
--- a/drivers/net/wireless/hostap/hostap_ap.c~hostap-replace-kmallocmemset-with-kzalloc
+++ a/drivers/net/wireless/hostap/hostap_ap.c
@@ -1099,15 +1099,13 @@ static struct sta_info * ap_add_sta(stru
 {
 	struct sta_info *sta;
 
-	sta = (struct sta_info *)
-		kmalloc(sizeof(struct sta_info), GFP_ATOMIC);
+	sta = kzalloc(sizeof(struct sta_info), GFP_ATOMIC);
 	if (sta == NULL) {
 		PDEBUG(DEBUG_AP, "AP: kmalloc failed\n");
 		return NULL;
 	}
 
 	/* initialize STA info data */
-	memset(sta, 0, sizeof(struct sta_info));
 	sta->local = ap->local;
 	skb_queue_head_init(&sta->tx_buf);
 	memcpy(sta->addr, addr, ETH_ALEN);
diff -puN drivers/net/wireless/hostap/hostap_cs.c~hostap-replace-kmallocmemset-with-kzalloc drivers/net/wireless/hostap/hostap_cs.c
--- a/drivers/net/wireless/hostap/hostap_cs.c~hostap-replace-kmallocmemset-with-kzalloc
+++ a/drivers/net/wireless/hostap/hostap_cs.c
@@ -563,12 +563,11 @@ static int prism2_config(struct pcmcia_d
 	PDEBUG(DEBUG_FLOW, "prism2_config()\n");
 
 	parse = kmalloc(sizeof(cisparse_t), GFP_KERNEL);
-	hw_priv = kmalloc(sizeof(*hw_priv), GFP_KERNEL);
+	hw_priv = kzalloc(sizeof(*hw_priv), GFP_KERNEL);
 	if (parse == NULL || hw_priv == NULL) {
 		ret = -ENOMEM;
 		goto failed;
 	}
-	memset(hw_priv, 0, sizeof(*hw_priv));
 
 	tuple.Attributes = 0;
 	tuple.TupleData = buf;
diff -puN drivers/net/wireless/hostap/hostap_download.c~hostap-replace-kmallocmemset-with-kzalloc drivers/net/wireless/hostap/hostap_download.c
--- a/drivers/net/wireless/hostap/hostap_download.c~hostap-replace-kmallocmemset-with-kzalloc
+++ a/drivers/net/wireless/hostap/hostap_download.c
@@ -685,14 +685,12 @@ static int prism2_download(local_info_t 
 		goto out;
 	}
 
-	dl = kmalloc(sizeof(*dl) + param->num_areas *
+	dl = kzalloc(sizeof(*dl) + param->num_areas *
 		     sizeof(struct prism2_download_data_area), GFP_KERNEL);
 	if (dl == NULL) {
 		ret = -ENOMEM;
 		goto out;
 	}
-	memset(dl, 0, sizeof(*dl) + param->num_areas *
-	       sizeof(struct prism2_download_data_area));
 	dl->dl_cmd = param->dl_cmd;
 	dl->start_addr = param->start_addr;
 	dl->num_areas = param->num_areas;
diff -puN drivers/net/wireless/hostap/hostap_hw.c~hostap-replace-kmallocmemset-with-kzalloc drivers/net/wireless/hostap/hostap_hw.c
--- a/drivers/net/wireless/hostap/hostap_hw.c~hostap-replace-kmallocmemset-with-kzalloc
+++ a/drivers/net/wireless/hostap/hostap_hw.c
@@ -347,14 +347,12 @@ static int hfa384x_cmd(struct net_device
 	if (signal_pending(current))
 		return -EINTR;
 
-	entry = (struct hostap_cmd_queue *)
-		kmalloc(sizeof(*entry), GFP_ATOMIC);
+	entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
 	if (entry == NULL) {
 		printk(KERN_DEBUG "%s: hfa384x_cmd - kmalloc failed\n",
 		       dev->name);
 		return -ENOMEM;
 	}
-	memset(entry, 0, sizeof(*entry));
 	atomic_set(&entry->usecnt, 1);
 	entry->type = CMD_SLEEP;
 	entry->cmd = cmd;
@@ -517,14 +515,12 @@ static int hfa384x_cmd_callback(struct n
 		return -1;
 	}
 
-	entry = (struct hostap_cmd_queue *)
-		kmalloc(sizeof(*entry), GFP_ATOMIC);
+	entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
 	if (entry == NULL) {
 		printk(KERN_DEBUG "%s: hfa384x_cmd_callback - kmalloc "
 		       "failed\n", dev->name);
 		return -ENOMEM;
 	}
-	memset(entry, 0, sizeof(*entry));
 	atomic_set(&entry->usecnt, 1);
 	entry->type = CMD_CALLBACK;
 	entry->cmd = cmd;
@@ -3015,14 +3011,12 @@ static int prism2_set_tim(struct net_dev
 	iface = netdev_priv(dev);
 	local = iface->local;
 
-	new_entry = (struct set_tim_data *)
-		kmalloc(sizeof(*new_entry), GFP_ATOMIC);
+	new_entry = kzalloc(sizeof(*new_entry), GFP_ATOMIC);
 	if (new_entry == NULL) {
 		printk(KERN_DEBUG "%s: prism2_set_tim: kmalloc failed\n",
 		       local->dev->name);
 		return -ENOMEM;
 	}
-	memset(new_entry, 0, sizeof(*new_entry));
 	new_entry->aid = aid;
 	new_entry->set = set;
 
diff -puN drivers/net/wireless/hostap/hostap_info.c~hostap-replace-kmallocmemset-with-kzalloc drivers/net/wireless/hostap/hostap_info.c
--- a/drivers/net/wireless/hostap/hostap_info.c~hostap-replace-kmallocmemset-with-kzalloc
+++ a/drivers/net/wireless/hostap/hostap_info.c
@@ -327,11 +327,10 @@ static void prism2_info_hostscanresults(
 	ptr = (u8 *) pos;
 
 	new_count = left / result_size;
-	results = kmalloc(new_count * sizeof(struct hfa384x_hostscan_result),
+	results = kcalloc(new_count, sizeof(struct hfa384x_hostscan_result),
 			  GFP_ATOMIC);
 	if (results == NULL)
 		return;
-	memset(results, 0, new_count * sizeof(struct hfa384x_hostscan_result));
 
 	for (i = 0; i < new_count; i++) {
 		memcpy(&results[i], ptr, copy_len);
diff -puN drivers/net/wireless/hostap/hostap_ioctl.c~hostap-replace-kmallocmemset-with-kzalloc drivers/net/wireless/hostap/hostap_ioctl.c
--- a/drivers/net/wireless/hostap/hostap_ioctl.c~hostap-replace-kmallocmemset-with-kzalloc
+++ a/drivers/net/wireless/hostap/hostap_ioctl.c
@@ -181,12 +181,10 @@ static int prism2_ioctl_siwencode(struct
 		struct ieee80211_crypt_data *new_crypt;
 
 		/* take WEP into use */
-		new_crypt = (struct ieee80211_crypt_data *)
-			kmalloc(sizeof(struct ieee80211_crypt_data),
+		new_crypt = kzalloc(sizeof(struct ieee80211_crypt_data),
 				GFP_KERNEL);
 		if (new_crypt == NULL)
 			return -ENOMEM;
-		memset(new_crypt, 0, sizeof(struct ieee80211_crypt_data));
 		new_crypt->ops = ieee80211_get_crypto_ops("WEP");
 		if (!new_crypt->ops) {
 			request_module("ieee80211_crypt_wep");
@@ -3320,14 +3318,12 @@ static int prism2_ioctl_siwencodeext(str
 
 		prism2_crypt_delayed_deinit(local, crypt);
 
-		new_crypt = (struct ieee80211_crypt_data *)
-			kmalloc(sizeof(struct ieee80211_crypt_data),
+		new_crypt = kzalloc(sizeof(struct ieee80211_crypt_data),
 				GFP_KERNEL);
 		if (new_crypt == NULL) {
 			ret = -ENOMEM;
 			goto done;
 		}
-		memset(new_crypt, 0, sizeof(struct ieee80211_crypt_data));
 		new_crypt->ops = ops;
 		new_crypt->priv = new_crypt->ops->init(i);
 		if (new_crypt->priv == NULL) {
@@ -3538,14 +3534,12 @@ static int prism2_ioctl_set_encryption(l
 
 		prism2_crypt_delayed_deinit(local, crypt);
 
-		new_crypt = (struct ieee80211_crypt_data *)
-			kmalloc(sizeof(struct ieee80211_crypt_data),
+		new_crypt = kzalloc(sizeof(struct ieee80211_crypt_data),
 				GFP_KERNEL);
 		if (new_crypt == NULL) {
 			ret = -ENOMEM;
 			goto done;
 		}
-		memset(new_crypt, 0, sizeof(struct ieee80211_crypt_data));
 		new_crypt->ops = ops;
 		new_crypt->priv = new_crypt->ops->init(param->u.crypt.idx);
 		if (new_crypt->priv == NULL) {
diff -puN drivers/net/wireless/hostap/hostap_pci.c~hostap-replace-kmallocmemset-with-kzalloc drivers/net/wireless/hostap/hostap_pci.c
--- a/drivers/net/wireless/hostap/hostap_pci.c~hostap-replace-kmallocmemset-with-kzalloc
+++ a/drivers/net/wireless/hostap/hostap_pci.c
@@ -300,10 +300,9 @@ static int prism2_pci_probe(struct pci_d
 	struct hostap_interface *iface;
 	struct hostap_pci_priv *hw_priv;
 
-	hw_priv = kmalloc(sizeof(*hw_priv), GFP_KERNEL);
+	hw_priv = kzalloc(sizeof(*hw_priv), GFP_KERNEL);
 	if (hw_priv == NULL)
 		return -ENOMEM;
-	memset(hw_priv, 0, sizeof(*hw_priv));
 
 	if (pci_enable_device(pdev))
 		goto err_out_free;
diff -puN drivers/net/wireless/hostap/hostap_plx.c~hostap-replace-kmallocmemset-with-kzalloc drivers/net/wireless/hostap/hostap_plx.c
--- a/drivers/net/wireless/hostap/hostap_plx.c~hostap-replace-kmallocmemset-with-kzalloc
+++ a/drivers/net/wireless/hostap/hostap_plx.c
@@ -447,10 +447,9 @@ static int prism2_plx_probe(struct pci_d
 	int tmd7160;
 	struct hostap_plx_priv *hw_priv;
 
-	hw_priv = kmalloc(sizeof(*hw_priv), GFP_KERNEL);
+	hw_priv = kzalloc(sizeof(*hw_priv), GFP_KERNEL);
 	if (hw_priv == NULL)
 		return -ENOMEM;
-	memset(hw_priv, 0, sizeof(*hw_priv));
 
 	if (pci_enable_device(pdev))
 		goto err_out_free;
_

Patches currently in -mm which might be from burman.yan@gmail.com are

origin.patch
ia64-replace-kmallocmemset-with-kzalloc.patch
jffs2-replace-kmallocmemset-with-kzalloc.patch
nfsd-replace-kmallocmemset-with-kcalloc.patch

