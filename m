From: akpm@linux-foundation.org
Subject: + aoe-the-aoeminor-doesnt-need-a-long-format.patch added to -mm tree
Date: Fri, 21 Dec 2007 22:03:58 -0800
Message-ID: <200712220603.lBM63wrb020132@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58013 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751375AbXLVGEB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 22 Dec 2007 01:04:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ecashin@coraid.com, greg@kroah.com


The patch titled
     aoe: the aoeminor doesn't need a long format
has been added to the -mm tree.  Its filename is
     aoe-the-aoeminor-doesnt-need-a-long-format.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aoe: the aoeminor doesn't need a long format
From: "Ed L. Cashin" <ecashin@coraid.com>

The aoedev aoeminor member doesn't need a long format.

Signed-off-by: Ed L. Cashin <ecashin@coraid.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoeblk.c |    7 ++++---
 drivers/block/aoe/aoecmd.c |    5 +++--
 2 files changed, 7 insertions(+), 5 deletions(-)

diff -puN drivers/block/aoe/aoeblk.c~aoe-the-aoeminor-doesnt-need-a-long-format drivers/block/aoe/aoeblk.c
--- a/drivers/block/aoe/aoeblk.c~aoe-the-aoeminor-doesnt-need-a-long-format
+++ a/drivers/block/aoe/aoeblk.c
@@ -202,7 +202,7 @@ aoeblk_make_request(struct request_queue
 	spin_lock_irqsave(&d->lock, flags);
 
 	if ((d->flags & DEVFL_UP) == 0) {
-		printk(KERN_INFO "aoe: device %ld.%ld is not up\n",
+		printk(KERN_INFO "aoe: device %ld.%d is not up\n",
 			d->aoemajor, d->aoeminor);
 		spin_unlock_irqrestore(&d->lock, flags);
 		mempool_free(buf, d->bufpool);
@@ -255,14 +255,15 @@ aoeblk_gdalloc(void *vp)
 
 	gd = alloc_disk(AOE_PARTITIONS);
 	if (gd == NULL) {
-		printk(KERN_ERR "aoe: cannot allocate disk structure for %ld.%ld\n",
+		printk(KERN_ERR
+			"aoe: cannot allocate disk structure for %ld.%d\n",
 			d->aoemajor, d->aoeminor);
 		goto err;
 	}
 
 	d->bufpool = mempool_create_slab_pool(MIN_BUFS, buf_pool_cache);
 	if (d->bufpool == NULL) {
-		printk(KERN_ERR "aoe: cannot allocate bufpool for %ld.%ld\n",
+		printk(KERN_ERR "aoe: cannot allocate bufpool for %ld.%d\n",
 			d->aoemajor, d->aoeminor);
 		goto err_disk;
 	}
diff -puN drivers/block/aoe/aoecmd.c~aoe-the-aoeminor-doesnt-need-a-long-format drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-the-aoeminor-doesnt-need-a-long-format
+++ a/drivers/block/aoe/aoecmd.c
@@ -697,7 +697,8 @@ ataid_complete(struct aoedev *d, struct 
 	}
 
 	if (d->ssize != ssize)
-		printk(KERN_INFO "aoe: %012llx e%lu.%lu v%04x has %llu sectors\n",
+		printk(KERN_INFO
+			"aoe: %012llx e%ld.%d v%04x has %llu sectors\n",
 			mac_addr(t->addr),
 			d->aoemajor, d->aoeminor,
 			d->fw_ver, (long long)ssize);
@@ -822,7 +823,7 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 
 	if (ahin->cmdstat & 0xa9) {	/* these bits cleared on success */
 		printk(KERN_ERR
-			"aoe: ata error cmd=%2.2Xh stat=%2.2Xh from e%ld.%ld\n",
+			"aoe: ata error cmd=%2.2Xh stat=%2.2Xh from e%ld.%d\n",
 			ahout->cmdstat, ahin->cmdstat,
 			d->aoemajor, d->aoeminor);
 		if (buf)
_

Patches currently in -mm which might be from ecashin@coraid.com are

aoe-bring-driver-version-number-to-47.patch
aoe-handle-multiple-network-paths-to-aoe-device.patch
aoe-mac_addr-avoid-64-bit-arch-compiler-warnings.patch
aoe-clean-up-udev-configuration-example.patch
aoe-eliminate-goto-and-improve-readability.patch
aoe-user-can-ask-driver-to-forget-previously-detected-devices.patch
aoe-dynamically-allocate-a-capped-number-of-skbs-when-necessary.patch
aoe-only-install-new-aoe-device-once.patch
aoe-add-module-parameter-for-users-who-need-more-outstanding-i-o.patch
aoe-the-aoeminor-doesnt-need-a-long-format.patch
aoe-make-error-messages-more-specific.patch
aoe-update-copyright-date.patch
aoe-statically-initialise-devlist_lock.patch
