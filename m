Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8D20C0018C
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:11:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E5132342C
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:11:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgLPRLT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:11:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:60930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726798AbgLPRLS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:11:18 -0500
Date:   Wed, 16 Dec 2020 09:10:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138637;
        bh=V4BFqvt3uqdrUgUc2FxsaytCz3kCrG8W8laStooKUoo=;
        h=From:To:Subject:From;
        b=vINqDa1I3XS1Ti3/wWKDRUINb9NiXTuXjVA4oumkGjXlFzwKFbAZqoOQaVysy5OWE
         sI5HotZmpG/P/p8X4tl2iCZSsZCffWGIGPPJmM7J9f3ElfMIEvVe+2uEPDXvL7n6/J
         3pN7yCMdnnzORab6Y8hvuW+lgS+WsRSA9BjrJHQ8=
From:   akpm@linux-foundation.org
To:     alex.bou9@gmail.com, bigeasy@linutronix.de,
        mm-commits@vger.kernel.org, mporter@kernel.crashing.org
Subject:  [merged]
 rapidio-remove-unused-rio_get_asm-and-rio_get_device.patch removed from -mm
 tree
Message-ID: <20201216171037.25Q1N5N0R%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: remove unused rio_get_asm() and rio_get_device()
has been removed from the -mm tree.  Its filename was
     rapidio-remove-unused-rio_get_asm-and-rio_get_device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: rapidio: remove unused rio_get_asm() and rio_get_device()

The functions rio_get_asm() and rio_get_device() are globally exported
but have almost no users in tree. The only user is rio_init_mports()
which invokes it via rio_init().

rio_init() iterates over every registered device and invokes
rio_fixup_device().  It looks like a fixup function which should perform a
"change" to the device but does nothing.  It has been like this since its
introduction in commit 394b701ce4fbf ("[PATCH] RapidIO support: core
base") which was merged into v2.6.15-rc1.

Remove rio_init() because the performed fixup function
(rio_fixup_device()) does nothing.  Remove rio_get_asm() and
rio_get_device() which have no callers now.

Link: https://lkml.kernel.org/r/20201116170004.420143-1-bigeasy@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio.c   |   81 --------------------------------------
 include/linux/rio_drv.h |    3 -
 2 files changed, 84 deletions(-)

--- a/drivers/rapidio/rio.c~rapidio-remove-unused-rio_get_asm-and-rio_get_device
+++ a/drivers/rapidio/rio.c
@@ -1413,71 +1413,6 @@ rio_mport_get_feature(struct rio_mport *
 EXPORT_SYMBOL_GPL(rio_mport_get_feature);
 
 /**
- * rio_get_asm - Begin or continue searching for a RIO device by vid/did/asm_vid/asm_did
- * @vid: RIO vid to match or %RIO_ANY_ID to match all vids
- * @did: RIO did to match or %RIO_ANY_ID to match all dids
- * @asm_vid: RIO asm_vid to match or %RIO_ANY_ID to match all asm_vids
- * @asm_did: RIO asm_did to match or %RIO_ANY_ID to match all asm_dids
- * @from: Previous RIO device found in search, or %NULL for new search
- *
- * Iterates through the list of known RIO devices. If a RIO device is
- * found with a matching @vid, @did, @asm_vid, @asm_did, the reference
- * count to the device is incrememted and a pointer to its device
- * structure is returned. Otherwise, %NULL is returned. A new search
- * is initiated by passing %NULL to the @from argument. Otherwise, if
- * @from is not %NULL, searches continue from next device on the global
- * list. The reference count for @from is always decremented if it is
- * not %NULL.
- */
-struct rio_dev *rio_get_asm(u16 vid, u16 did,
-			    u16 asm_vid, u16 asm_did, struct rio_dev *from)
-{
-	struct list_head *n;
-	struct rio_dev *rdev;
-
-	WARN_ON(in_interrupt());
-	spin_lock(&rio_global_list_lock);
-	n = from ? from->global_list.next : rio_devices.next;
-
-	while (n && (n != &rio_devices)) {
-		rdev = rio_dev_g(n);
-		if ((vid == RIO_ANY_ID || rdev->vid == vid) &&
-		    (did == RIO_ANY_ID || rdev->did == did) &&
-		    (asm_vid == RIO_ANY_ID || rdev->asm_vid == asm_vid) &&
-		    (asm_did == RIO_ANY_ID || rdev->asm_did == asm_did))
-			goto exit;
-		n = n->next;
-	}
-	rdev = NULL;
-      exit:
-	rio_dev_put(from);
-	rdev = rio_dev_get(rdev);
-	spin_unlock(&rio_global_list_lock);
-	return rdev;
-}
-EXPORT_SYMBOL_GPL(rio_get_asm);
-
-/**
- * rio_get_device - Begin or continue searching for a RIO device by vid/did
- * @vid: RIO vid to match or %RIO_ANY_ID to match all vids
- * @did: RIO did to match or %RIO_ANY_ID to match all dids
- * @from: Previous RIO device found in search, or %NULL for new search
- *
- * Iterates through the list of known RIO devices. If a RIO device is
- * found with a matching @vid and @did, the reference count to the
- * device is incrememted and a pointer to its device structure is returned.
- * Otherwise, %NULL is returned. A new search is initiated by passing %NULL
- * to the @from argument. Otherwise, if @from is not %NULL, searches
- * continue from next device on the global list. The reference count for
- * @from is always decremented if it is not %NULL.
- */
-struct rio_dev *rio_get_device(u16 vid, u16 did, struct rio_dev *from)
-{
-	return rio_get_asm(vid, did, RIO_ANY_ID, RIO_ANY_ID, from);
-}
-EXPORT_SYMBOL_GPL(rio_get_device);
-
-/**
  * rio_std_route_add_entry - Add switch route table entry using standard
  *   registers defined in RIO specification rev.1.3
  * @mport: Master port to issue transaction
@@ -2106,20 +2041,6 @@ found:
 	return rc;
 }
 
-static void rio_fixup_device(struct rio_dev *dev)
-{
-}
-
-static int rio_init(void)
-{
-	struct rio_dev *dev = NULL;
-
-	while ((dev = rio_get_device(RIO_ANY_ID, RIO_ANY_ID, dev)) != NULL) {
-		rio_fixup_device(dev);
-	}
-	return 0;
-}
-
 static struct workqueue_struct *rio_wq;
 
 struct rio_disc_work {
@@ -2206,8 +2127,6 @@ int rio_init_mports(void)
 	kfree(work);
 
 no_disc:
-	rio_init();
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(rio_init_mports);
--- a/include/linux/rio_drv.h~rapidio-remove-unused-rio_get_asm-and-rio_get_device
+++ a/include/linux/rio_drv.h
@@ -444,9 +444,6 @@ static inline void rio_set_drvdata(struc
 /* Misc driver helpers */
 extern u16 rio_local_get_device_id(struct rio_mport *port);
 extern void rio_local_set_device_id(struct rio_mport *port, u16 did);
-extern struct rio_dev *rio_get_device(u16 vid, u16 did, struct rio_dev *from);
-extern struct rio_dev *rio_get_asm(u16 vid, u16 did, u16 asm_vid, u16 asm_did,
-				   struct rio_dev *from);
 extern int rio_init_mports(void);
 
 #endif				/* LINUX_RIO_DRV_H */
_

Patches currently in -mm which might be from bigeasy@linutronix.de are


