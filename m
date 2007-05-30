From: akpm@linux-foundation.org
Subject: - use-list_for_each_entry-for-iteration-in-hostap_apc.patch removed from -mm tree
Date: Wed, 30 May 2007 16:28:37 -0700
Message-ID: <200705302328.l4UNSa65007768@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:39925 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759158AbXE3X3Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 May 2007 19:29:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias.kaehlcke@gmail.com, hch@lst.de, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     use list_for_each_entry() for iteration in hostap_ap.c
has been removed from the -mm tree.  Its filename was
     use-list_for_each_entry-for-iteration-in-hostap_apc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: use list_for_each_entry() for iteration in hostap_ap.c
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

hostap_ap.c: Use list_for_each_entry() instead of manual iteration and
substitute some list_for_each() loops with list_for_each_entry()

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/hostap/hostap_ap.c |   33 +++++++---------------
 1 files changed, 11 insertions(+), 22 deletions(-)

diff -puN drivers/net/wireless/hostap/hostap_ap.c~use-list_for_each_entry-for-iteration-in-hostap_apc drivers/net/wireless/hostap/hostap_ap.c
--- a/drivers/net/wireless/hostap/hostap_ap.c~use-list_for_each_entry-for-iteration-in-hostap_apc
+++ a/drivers/net/wireless/hostap/hostap_ap.c
@@ -326,7 +326,6 @@ static int ap_control_proc_read(char *pa
 	char *p = page;
 	struct ap_data *ap = (struct ap_data *) data;
 	char *policy_txt;
-	struct list_head *ptr;
 	struct mac_entry *entry;
 
 	if (off != 0) {
@@ -352,14 +351,12 @@ static int ap_control_proc_read(char *pa
 	p += sprintf(p, "MAC entries: %u\n", ap->mac_restrictions.entries);
 	p += sprintf(p, "MAC list:\n");
 	spin_lock_bh(&ap->mac_restrictions.lock);
-	for (ptr = ap->mac_restrictions.mac_list.next;
-	     ptr != &ap->mac_restrictions.mac_list; ptr = ptr->next) {
+	list_for_each_entry(entry, &ap->mac_restrictions.mac_list, list) {
 		if (p - page > PAGE_SIZE - 80) {
 			p += sprintf(p, "All entries did not fit one page.\n");
 			break;
 		}
 
-		entry = list_entry(ptr, struct mac_entry, list);
 		p += sprintf(p, MACSTR "\n", MAC2STR(entry->addr));
 	}
 	spin_unlock_bh(&ap->mac_restrictions.lock);
@@ -410,10 +407,10 @@ int ap_control_del_mac(struct mac_restri
 }
 
 
+
 static int ap_control_mac_deny(struct mac_restrictions *mac_restrictions,
 			       u8 *mac)
 {
-	struct list_head *ptr;
 	struct mac_entry *entry;
 	int found = 0;
 
@@ -421,10 +418,7 @@ static int ap_control_mac_deny(struct ma
 		return 0;
 
 	spin_lock_bh(&mac_restrictions->lock);
-	for (ptr = mac_restrictions->mac_list.next;
-	     ptr != &mac_restrictions->mac_list; ptr = ptr->next) {
-		entry = list_entry(ptr, struct mac_entry, list);
-
+	list_for_each_entry(entry, &mac_restrictions->mac_list, list) {
 		if (memcmp(entry->addr, mac, ETH_ALEN) == 0) {
 			found = 1;
 			break;
@@ -519,7 +513,7 @@ static int prism2_ap_proc_read(char *pag
 {
 	char *p = page;
 	struct ap_data *ap = (struct ap_data *) data;
-	struct list_head *ptr;
+	struct sta_info *sta;
 	int i;
 
 	if (off > PROC_LIMIT) {
@@ -529,9 +523,7 @@ static int prism2_ap_proc_read(char *pag
 
 	p += sprintf(p, "# BSSID CHAN SIGNAL NOISE RATE SSID FLAGS\n");
 	spin_lock_bh(&ap->sta_table_lock);
-	for (ptr = ap->sta_list.next; ptr != &ap->sta_list; ptr = ptr->next) {
-		struct sta_info *sta = (struct sta_info *) ptr;
-
+	list_for_each_entry(sta, &ap->sta_list, list) {
 		if (!sta->ap)
 			continue;
 
@@ -861,7 +853,7 @@ void hostap_init_ap_proc(local_info_t *l
 
 void hostap_free_data(struct ap_data *ap)
 {
-	struct list_head *n, *ptr;
+	struct sta_info *n, *sta;
 
 	if (ap == NULL || !ap->initialized) {
 		printk(KERN_DEBUG "hostap_free_data: ap has not yet been "
@@ -875,8 +867,7 @@ void hostap_free_data(struct ap_data *ap
 	ap->crypt = ap->crypt_priv = NULL;
 #endif /* PRISM2_NO_KERNEL_IEEE80211_MGMT */
 
-	list_for_each_safe(ptr, n, &ap->sta_list) {
-		struct sta_info *sta = list_entry(ptr, struct sta_info, list);
+	list_for_each_entry_safe(sta, n, &ap->sta_list, list) {
 		ap_sta_hash_del(ap, sta);
 		list_del(&sta->list);
 		if ((sta->flags & WLAN_STA_ASSOC) && !sta->ap && sta->local)
@@ -3198,15 +3189,14 @@ int hostap_update_rx_stats(struct ap_dat
 
 void hostap_update_rates(local_info_t *local)
 {
-	struct list_head *ptr;
+	struct sta_info *sta;
 	struct ap_data *ap = local->ap;
 
 	if (!ap)
 		return;
 
 	spin_lock_bh(&ap->sta_table_lock);
-	for (ptr = ap->sta_list.next; ptr != &ap->sta_list; ptr = ptr->next) {
-		struct sta_info *sta = (struct sta_info *) ptr;
+	list_for_each_entry(sta, &ap->sta_list, list) {
 		prism2_check_tx_rates(sta);
 	}
 	spin_unlock_bh(&ap->sta_table_lock);
@@ -3242,11 +3232,10 @@ void * ap_crypt_get_ptrs(struct ap_data 
 void hostap_add_wds_links(local_info_t *local)
 {
 	struct ap_data *ap = local->ap;
-	struct list_head *ptr;
+	struct sta_info *sta;
 
 	spin_lock_bh(&ap->sta_table_lock);
-	list_for_each(ptr, &ap->sta_list) {
-		struct sta_info *sta = list_entry(ptr, struct sta_info, list);
+	list_for_each_entry(sta, &ap->sta_list, list) {
 		if (sta->ap)
 			hostap_wds_link_oper(local, sta->addr, WDS_ADD);
 	}
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

kcopyd-use-mutex-instead-of-semaphore.patch
power-management-use-mutexes-instead-of-semaphores.patch
sysdev-use-mutex-instead-of-semaphore.patch
use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver.patch
use-mutex-instead-of-semaphore-in-the-mtd-dataflash-driver.patch
git-netdev-all.patch
use-mutex-instead-of-binary-semaphore-in-cdu-31a-driver.patch
use-mutex-instead-of-semaphore-in-sbpcd-driver.patch
block-device-elevator-use-list_for_each_entry-instead-of-list_for_each.patch
drivers-block-ubc-use-list_for_each_entry.patch
use-list_for_each_entry-for-iteration-in-prism-54-driver.patch
use-mutexes-instead-of-semaphores-in-i2o-driver.patch
fs-block_devc-use-list_for_each_entry.patch
use-mutex-instead-of-semaphore-in-capi-20-driver.patch
