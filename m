From: akpm@linux-foundation.org
Subject: - use-list_for_each_entry-for-iteration-in-prism-54-driver.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:09:20 -0700
Message-ID: <200707172309.l6HN9KkU012365@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47594 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933991AbXGQXQ2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:16:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias.kaehlcke@gmail.com, hch@lst.de, linville@tuxdriver.com, mcgrof@gmail.com, mm-commits@vger.kernel.org


The patch titled
     use list_for_each_entry() for iteration in Prism 54 driver
has been removed from the -mm tree.  Its filename was
     use-list_for_each_entry-for-iteration-in-prism-54-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: use list_for_each_entry() for iteration in Prism 54 driver
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

Use list_for_each_entry() instead of manual iteration and substitute a
list_for_each_safe() loop with list_for_each_entry_safe()

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "John W. Linville" <linville@tuxdriver.com>
Acked-by: Luis R. Rodriguez <mcgrof@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/prism54/isl_ioctl.c |   22 +++++----------------
 1 files changed, 6 insertions(+), 16 deletions(-)

diff -puN drivers/net/wireless/prism54/isl_ioctl.c~use-list_for_each_entry-for-iteration-in-prism-54-driver drivers/net/wireless/prism54/isl_ioctl.c
--- a/drivers/net/wireless/prism54/isl_ioctl.c~use-list_for_each_entry-for-iteration-in-prism-54-driver
+++ a/drivers/net/wireless/prism54/isl_ioctl.c
@@ -1853,7 +1853,6 @@ prism54_del_mac(struct net_device *ndev,
 	islpci_private *priv = netdev_priv(ndev);
 	struct islpci_acl *acl = &priv->acl;
 	struct mac_entry *entry;
-	struct list_head *ptr;
 	struct sockaddr *addr = (struct sockaddr *) extra;
 
 	if (addr->sa_family != ARPHRD_ETHER)
@@ -1861,11 +1860,9 @@ prism54_del_mac(struct net_device *ndev,
 
 	if (down_interruptible(&acl->sem))
 		return -ERESTARTSYS;
-	for (ptr = acl->mac_list.next; ptr != &acl->mac_list; ptr = ptr->next) {
-		entry = list_entry(ptr, struct mac_entry, _list);
-
+	list_for_each_entry(entry, &acl->mac_list, _list) {
 		if (memcmp(entry->addr, addr->sa_data, ETH_ALEN) == 0) {
-			list_del(ptr);
+			list_del(&entry->_list);
 			acl->size--;
 			kfree(entry);
 			up(&acl->sem);
@@ -1883,7 +1880,6 @@ prism54_get_mac(struct net_device *ndev,
 	islpci_private *priv = netdev_priv(ndev);
 	struct islpci_acl *acl = &priv->acl;
 	struct mac_entry *entry;
-	struct list_head *ptr;
 	struct sockaddr *dst = (struct sockaddr *) extra;
 
 	dwrq->length = 0;
@@ -1891,9 +1887,7 @@ prism54_get_mac(struct net_device *ndev,
 	if (down_interruptible(&acl->sem))
 		return -ERESTARTSYS;
 
-	for (ptr = acl->mac_list.next; ptr != &acl->mac_list; ptr = ptr->next) {
-		entry = list_entry(ptr, struct mac_entry, _list);
-
+	list_for_each_entry(entry, &acl->mac_list, _list) {
 		memcpy(dst->sa_data, entry->addr, ETH_ALEN);
 		dst->sa_family = ARPHRD_ETHER;
 		dwrq->length++;
@@ -1960,7 +1954,6 @@ prism54_get_policy(struct net_device *nd
 static int
 prism54_mac_accept(struct islpci_acl *acl, char *mac)
 {
-	struct list_head *ptr;
 	struct mac_entry *entry;
 	int res = 0;
 
@@ -1972,8 +1965,7 @@ prism54_mac_accept(struct islpci_acl *ac
 		return 1;
 	}
 
-	for (ptr = acl->mac_list.next; ptr != &acl->mac_list; ptr = ptr->next) {
-		entry = list_entry(ptr, struct mac_entry, _list);
+	list_for_each_entry(entry, &acl->mac_list, _list) {
 		if (memcmp(entry->addr, mac, ETH_ALEN) == 0) {
 			res = 1;
 			break;
@@ -2216,11 +2208,9 @@ prism54_wpa_bss_ie_init(islpci_private *
 void
 prism54_wpa_bss_ie_clean(islpci_private *priv)
 {
-	struct list_head *ptr, *n;
+	struct islpci_bss_wpa_ie *bss, *n;
 
-	list_for_each_safe(ptr, n, &priv->bss_wpa_list) {
-		struct islpci_bss_wpa_ie *bss;
-		bss = list_entry(ptr, struct islpci_bss_wpa_ie, list);
+	list_for_each_entry_safe(bss, n, &priv->bss_wpa_list, list) {
 		kfree(bss);
 	}
 }
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

origin.patch
kcopyd-use-mutex-instead-of-semaphore.patch
git-dvb.patch
git-mtd.patch
videopix-frame-grabber-fix-unreleased-lock-in-vfc_debug.patch
use-mutex-instead-of-semaphore-in-the-usb-gadget-serial-driver.patch
use-mutex-instead-of-semaphore-in-the-elan-u132-adapter-driver.patch
use-mutex-instead-of-semaphore-in-the-adutux-driver.patch
use-mutex-instead-of-semaphore-in-the-ftdi-elan-driver.patch
drivers-edac-change-from-semaphore-to-mutex-operation.patch
