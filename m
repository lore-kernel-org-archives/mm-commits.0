From: akpm@linux-foundation.org
Subject: - w1-allow-bus-master-to-have-reset-and-byte-ops.patch removed from -mm tree
Date: Tue, 08 May 2007 19:51:54 -0700
Message-ID: <200705090251.l492psHZ009515@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51544 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032189AbXEICwI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:52:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johnpol@2ka.mipt.ru, mreimer@vpop.net, mm-commits@vger.kernel.org


The patch titled
     w1: allow bus master to have reset and byte ops
has been removed from the -mm tree.  Its filename was
     w1-allow-bus-master-to-have-reset-and-byte-ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: w1: allow bus master to have reset and byte ops
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

Signed-off-by: Matt Reimer <mreimer@vpop.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/w1_int.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/w1/w1_int.c~w1-allow-bus-master-to-have-reset-and-byte-ops drivers/w1/w1_int.c
--- a/drivers/w1/w1_int.c~w1-allow-bus-master-to-have-reset-and-byte-ops
+++ a/drivers/w1/w1_int.c
@@ -100,7 +100,8 @@ int w1_add_master_device(struct w1_bus_m
 
         /* validate minimum functionality */
         if (!(master->touch_bit && master->reset_bus) &&
-            !(master->write_bit && master->read_bit)) {
+            !(master->write_bit && master->read_bit) &&
+	    !(master->write_byte && master->read_byte && master->reset_bus)) {
 		printk(KERN_ERR "w1_add_master_device: invalid function set\n");
 		return(-EINVAL);
         }
_

Patches currently in -mm which might be from johnpol@2ka.mipt.ru are

origin.patch
git-battery.patch
use-menuconfig-objects-connector.patch
use-menuconfig-objects-w1.patch
