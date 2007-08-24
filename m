From: akpm@linux-foundation.org
Subject: - w1-fix-w1_remove_master_device-searching.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:56:42 -0700
Message-ID: <200708242056.l7OKugkG014089@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44197 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762885AbXHXVJD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:09:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johnpol@2ka.mipt.ru, bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     w1: fix w1_remove_master_device() searching
has been removed from the -mm tree.  Its filename was
     w1-fix-w1_remove_master_device-searching.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: w1: fix w1_remove_master_device() searching
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

In case bus master driver provided bogus value as its private data, search
can be incorrect.  Problem found by Adrian Bunk.

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/w1_int.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/w1/w1_int.c~w1-fix-w1_remove_master_device-searching drivers/w1/w1_int.c
--- a/drivers/w1/w1_int.c~w1-fix-w1_remove_master_device-searching
+++ a/drivers/w1/w1_int.c
@@ -170,22 +170,24 @@ void __w1_remove_master_device(struct w1
 
 void w1_remove_master_device(struct w1_bus_master *bm)
 {
-	struct w1_master *dev = NULL;
+	struct w1_master *dev, *found = NULL;
 
 	list_for_each_entry(dev, &w1_masters, w1_master_entry) {
 		if (!dev->initialized)
 			continue;
 
-		if (dev->bus_master->data == bm->data)
+		if (dev->bus_master->data == bm->data) {
+			found = dev;
 			break;
+		}
 	}
 
-	if (!dev) {
+	if (!found) {
 		printk(KERN_ERR "Device doesn't exist.\n");
 		return;
 	}
 
-	__w1_remove_master_device(dev);
+	__w1_remove_master_device(found);
 }
 
 EXPORT_SYMBOL(w1_add_master_device);
_

Patches currently in -mm which might be from johnpol@2ka.mipt.ru are

origin.patch
clean-up-duplicate-includes-in-drivers-w1.patch
connector-change-connectors-max-message-size.patch
uvesafb-add-connector-entries.patch
add-missing-newlines-to-some-uses-of-dev_level-messages.patch
