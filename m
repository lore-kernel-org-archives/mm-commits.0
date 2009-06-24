From: akpm@linux-foundation.org
Subject: [merged] devres-warn-and-return-dont-crash-on-device_del-of-uninitialized-device.patch removed from -mm tree
Date: Wed, 24 Jun 2009 12:10:51 -0700
Message-ID: <200906241910.n5OJApX7011136@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44573 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758791AbZFXTLz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jun 2009 15:11:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, greg@kroah.com, kay.sievers@vrfy.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     devres: WARN() and return, don't crash on device_del() of uninitialized device
has been removed from the -mm tree.  Its filename was
     devres-warn-and-return-dont-crash-on-device_del-of-uninitialized-device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: devres: WARN() and return, don't crash on device_del() of uninitialized device
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

I just debugged an obscure crash caused by a device_del() of a all NULL'd
out struct device (in usb-serial) and found that a patch like this one would
have saved me time (in addition to improved chances of a bug report from
users hitting similar driver bugs).

[akpm@linux-foundation.org: cleanup]
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/devres.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/base/devres.c~devres-warn-and-return-dont-crash-on-device_del-of-uninitialized-device drivers/base/devres.c
--- a/drivers/base/devres.c~devres-warn-and-return-dont-crash-on-device_del-of-uninitialized-device
+++ a/drivers/base/devres.c
@@ -428,6 +428,9 @@ int devres_release_all(struct device *de
 {
 	unsigned long flags;
 
+	/* Looks like an uninitialized device structure */
+	if (WARN_ON(dev->devres_head.next == NULL))
+		return -ENODEV;
 	spin_lock_irqsave(&dev->devres_lock, flags);
 	return release_nodes(dev, dev->devres_head.next, &dev->devres_head,
 			     flags);
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

origin.patch
linux-next.patch
platinumfb-misplaced-parenthesis.patch

