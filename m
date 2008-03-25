From: akpm@linux-foundation.org
Subject: - convert-acl-sem-in-a-mutex.patch removed from -mm tree
Date: Mon, 24 Mar 2008 17:19:36 -0700
Message-ID: <200803250019.m2P0Jao6032698@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58147 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753865AbYCYAVM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Mar 2008 20:21:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias@kaehlcke.net, flamingice@sourmilk.net, linville@tuxdriver.com, mcgrof@winlab.rutgers.edu, mm-commits@vger.kernel.org


The patch titled
     prism54: convert acl->sem in a mutex
has been removed from the -mm tree.  Its filename was
     convert-acl-sem-in-a-mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: prism54: convert acl->sem in a mutex
From: Matthias Kaehlcke <matthias@kaehlcke.net>

The semaphore acl->sem is used as mutex, convert it to the mutex API

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>
Cc: Michael Wu <flamingice@sourmilk.net>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/prism54/isl_ioctl.c  |   28 ++++++++++----------
 drivers/net/wireless/prism54/islpci_dev.h |    2 -
 2 files changed, 15 insertions(+), 15 deletions(-)

diff -puN drivers/net/wireless/prism54/isl_ioctl.c~convert-acl-sem-in-a-mutex drivers/net/wireless/prism54/isl_ioctl.c
--- a/drivers/net/wireless/prism54/isl_ioctl.c~convert-acl-sem-in-a-mutex
+++ a/drivers/net/wireless/prism54/isl_ioctl.c
@@ -1780,7 +1780,7 @@ prism54_set_raw(struct net_device *ndev,
 void
 prism54_acl_init(struct islpci_acl *acl)
 {
-	sema_init(&acl->sem, 1);
+	mutex_init(&acl->lock);
 	INIT_LIST_HEAD(&acl->mac_list);
 	acl->size = 0;
 	acl->policy = MAC_POLICY_OPEN;
@@ -1792,10 +1792,10 @@ prism54_clear_mac(struct islpci_acl *acl
 	struct list_head *ptr, *next;
 	struct mac_entry *entry;
 
-	down(&acl->sem);
+	mutex_lock(&acl->lock);
 
 	if (acl->size == 0) {
-		up(&acl->sem);
+		mutex_unlock(&acl->lock);
 		return;
 	}
 
@@ -1806,7 +1806,7 @@ prism54_clear_mac(struct islpci_acl *acl
 		kfree(entry);
 	}
 	acl->size = 0;
-	up(&acl->sem);
+	mutex_unlock(&acl->lock);
 }
 
 void
@@ -1833,13 +1833,13 @@ prism54_add_mac(struct net_device *ndev,
 
 	memcpy(entry->addr, addr->sa_data, ETH_ALEN);
 
-	if (down_interruptible(&acl->sem)) {
+	if (mutex_lock_interruptible(&acl->lock)) {
 		kfree(entry);
 		return -ERESTARTSYS;
 	}
 	list_add_tail(&entry->_list, &acl->mac_list);
 	acl->size++;
-	up(&acl->sem);
+	mutex_unlock(&acl->lock);
 
 	return 0;
 }
@@ -1856,18 +1856,18 @@ prism54_del_mac(struct net_device *ndev,
 	if (addr->sa_family != ARPHRD_ETHER)
 		return -EOPNOTSUPP;
 
-	if (down_interruptible(&acl->sem))
+	if (mutex_lock_interruptible(&acl->lock))
 		return -ERESTARTSYS;
 	list_for_each_entry(entry, &acl->mac_list, _list) {
 		if (memcmp(entry->addr, addr->sa_data, ETH_ALEN) == 0) {
 			list_del(&entry->_list);
 			acl->size--;
 			kfree(entry);
-			up(&acl->sem);
+			mutex_unlock(&acl->lock);
 			return 0;
 		}
 	}
-	up(&acl->sem);
+	mutex_unlock(&acl->lock);
 	return -EINVAL;
 }
 
@@ -1882,7 +1882,7 @@ prism54_get_mac(struct net_device *ndev,
 
 	dwrq->length = 0;
 
-	if (down_interruptible(&acl->sem))
+	if (mutex_lock_interruptible(&acl->lock))
 		return -ERESTARTSYS;
 
 	list_for_each_entry(entry, &acl->mac_list, _list) {
@@ -1891,7 +1891,7 @@ prism54_get_mac(struct net_device *ndev,
 		dwrq->length++;
 		dst++;
 	}
-	up(&acl->sem);
+	mutex_unlock(&acl->lock);
 	return 0;
 }
 
@@ -1955,11 +1955,11 @@ prism54_mac_accept(struct islpci_acl *ac
 	struct mac_entry *entry;
 	int res = 0;
 
-	if (down_interruptible(&acl->sem))
+	if (mutex_lock_interruptible(&acl->lock))
 		return -ERESTARTSYS;
 
 	if (acl->policy == MAC_POLICY_OPEN) {
-		up(&acl->sem);
+		mutex_unlock(&acl->lock);
 		return 1;
 	}
 
@@ -1970,7 +1970,7 @@ prism54_mac_accept(struct islpci_acl *ac
 		}
 	}
 	res = (acl->policy == MAC_POLICY_ACCEPT) ? !res : res;
-	up(&acl->sem);
+	mutex_unlock(&acl->lock);
 
 	return res;
 }
diff -puN drivers/net/wireless/prism54/islpci_dev.h~convert-acl-sem-in-a-mutex drivers/net/wireless/prism54/islpci_dev.h
--- a/drivers/net/wireless/prism54/islpci_dev.h~convert-acl-sem-in-a-mutex
+++ a/drivers/net/wireless/prism54/islpci_dev.h
@@ -55,7 +55,7 @@ struct islpci_acl {
    enum { MAC_POLICY_OPEN=0, MAC_POLICY_ACCEPT=1, MAC_POLICY_REJECT=2 } policy;
    struct list_head mac_list;  /* a list of mac_entry */
    int size;   /* size of queue */
-   struct semaphore sem;   /* accessed in ioctls and trap_work */
+   struct mutex lock;   /* accessed in ioctls and trap_work */
 };
 
 struct islpci_membuf {
_

Patches currently in -mm which might be from matthias@kaehlcke.net are

git-net.patch
alchemy-semi-au1000-pcmcia-driver-convert-pcmcia_sockets_lock-in-a-mutex.patch
git-scsi-misc.patch
fs-inodec-use-hlist_for_each_entry.patch
fs-inodec-use-hlist_for_each_entry-checkpatch-fixes.patch

