From: akpm@linux-foundation.org
Subject: +
 mm-dmapool-add-remove-sysfs-file-outside-of-the-pool-lock-lock.patch added
 to -mm tree
Date: Thu, 18 Sep 2014 15:43:20 -0700
Message-ID: <541b6008.+qg0AolhBuHIp6qo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42624 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbaIRWnV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Sep 2014 18:43:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bigeasy@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: dmapool: add/remove sysfs file outside of the pool lock lock
has been added to the -mm tree.  Its filename is
     mm-dmapool-add-remove-sysfs-file-outside-of-the-pool-lock-lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dmapool-add-remove-sysfs-file-outside-of-the-pool-lock-lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dmapool-add-remove-sysfs-file-outside-of-the-pool-lock-lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: mm: dmapool: add/remove sysfs file outside of the pool lock lock

cat /sys/.../pools followed by removal the device leads to:

|======================================================
|[ INFO: possible circular locking dependency detected ]
|3.17.0-rc4+ #1498 Not tainted
|-------------------------------------------------------
|rmmod/2505 is trying to acquire lock:
| (s_active#28){++++.+}, at: [<c017f754>] kernfs_remove_by_name_ns+0x3c/0x88
|
|but task is already holding lock:
| (pools_lock){+.+.+.}, at: [<c011494c>] dma_pool_destroy+0x18/0x17c
|
|which lock already depends on the new lock.
|the existing dependency chain (in reverse order) is:
|
|-> #1 (pools_lock){+.+.+.}:
|   [<c0114ae8>] show_pools+0x30/0xf8
|   [<c0313210>] dev_attr_show+0x1c/0x48
|   [<c0180e84>] sysfs_kf_seq_show+0x88/0x10c
|   [<c017f960>] kernfs_seq_show+0x24/0x28
|   [<c013efc4>] seq_read+0x1b8/0x480
|   [<c011e820>] vfs_read+0x8c/0x148
|   [<c011ea10>] SyS_read+0x40/0x8c
|   [<c000e960>] ret_fast_syscall+0x0/0x48
|
|-> #0 (s_active#28){++++.+}:
|   [<c017e9ac>] __kernfs_remove+0x258/0x2ec
|   [<c017f754>] kernfs_remove_by_name_ns+0x3c/0x88
|   [<c0114a7c>] dma_pool_destroy+0x148/0x17c
|   [<c03ad288>] hcd_buffer_destroy+0x20/0x34
|   [<c03a4780>] usb_remove_hcd+0x110/0x1a4

The problem is the lock order of pools_lock and kernfs_mutex in
dma_pool_destroy() vs show_pools() call path.

This patch breaks out the creation of the sysfs file outside of the
pools_lock mutex.  The newly added pools_reg_lock ensures that there is no
race of create vs destroy code path in terms whether or not the sysfs file
has to be deleted (and was it deleted before we try to create a new one)
and what to do if device_create_file() failed.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/dmapool.c |   41 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 34 insertions(+), 7 deletions(-)

diff -puN mm/dmapool.c~mm-dmapool-add-remove-sysfs-file-outside-of-the-pool-lock-lock mm/dmapool.c
--- a/mm/dmapool.c~mm-dmapool-add-remove-sysfs-file-outside-of-the-pool-lock-lock
+++ a/mm/dmapool.c
@@ -62,6 +62,7 @@ struct dma_page {		/* cacheable header f
 };
 
 static DEFINE_MUTEX(pools_lock);
+static DEFINE_MUTEX(pools_reg_lock);
 
 static ssize_t
 show_pools(struct device *dev, struct device_attribute *attr, char *buf)
@@ -132,6 +133,7 @@ struct dma_pool *dma_pool_create(const c
 {
 	struct dma_pool *retval;
 	size_t allocation;
+	bool empty = false;
 
 	if (align == 0) {
 		align = 1;
@@ -172,15 +174,34 @@ struct dma_pool *dma_pool_create(const c
 
 	INIT_LIST_HEAD(&retval->pools);
 
+	/*
+	 * pools_lock ensures that the ->dma_pools list does not get corrupted.
+	 * pools_reg_lock ensures that there is not a race between
+	 * dma_pool_create() and dma_pool_destroy() or within dma_pool_create()
+	 * when the first invocation of dma_pool_create() failed on
+	 * device_create_file() and the second assumes that it has been done (I
+	 * know it is a short window).
+	 */
+	mutex_lock(&pools_reg_lock);
 	mutex_lock(&pools_lock);
-	if (list_empty(&dev->dma_pools) &&
-	    device_create_file(dev, &dev_attr_pools)) {
-		kfree(retval);
-		return NULL;
-	} else
-		list_add(&retval->pools, &dev->dma_pools);
+	if (list_empty(&dev->dma_pools))
+		empty = true;
+	list_add(&retval->pools, &dev->dma_pools);
 	mutex_unlock(&pools_lock);
+	if (empty) {
+		int err;
 
+		err = device_create_file(dev, &dev_attr_pools);
+		if (err) {
+			mutex_lock(&pools_lock);
+			list_del(&retval->pools);
+			mutex_unlock(&pools_lock);
+			mutex_unlock(&pools_reg_lock);
+			kfree(retval);
+			return NULL;
+		}
+	}
+	mutex_unlock(&pools_reg_lock);
 	return retval;
 }
 EXPORT_SYMBOL(dma_pool_create);
@@ -251,11 +272,17 @@ static void pool_free_page(struct dma_po
  */
 void dma_pool_destroy(struct dma_pool *pool)
 {
+	bool empty = false;
+
+	mutex_lock(&pools_reg_lock);
 	mutex_lock(&pools_lock);
 	list_del(&pool->pools);
 	if (pool->dev && list_empty(&pool->dev->dma_pools))
-		device_remove_file(pool->dev, &dev_attr_pools);
+		empty = true;
 	mutex_unlock(&pools_lock);
+	if (empty)
+		device_remove_file(pool->dev, &dev_attr_pools);
+	mutex_unlock(&pools_reg_lock);
 
 	while (!list_empty(&pool->page_list)) {
 		struct dma_page *page;
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

mm-dmapool-add-remove-sysfs-file-outside-of-the-pool-lock-lock.patch
linux-next.patch

