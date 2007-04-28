From: akpm@linux-foundation.org
Subject: + w1-allow-bus-master-to-have-reset-and-byte-ops.patch added to -mm tree
Date: Fri, 27 Apr 2007 17:40:10 -0700
Message-ID: <200704280040.l3S0eAOr011694@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52404 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757911AbXD1Akv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 20:40:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johnpol@2ka.mipt.ru, mreimer@vpop.net


The patch titled
     w1: allow bus master to have reset and byte ops
has been added to the -mm tree.  Its filename is
     w1-allow-bus-master-to-have-reset-and-byte-ops.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: w1: allow bus master to have reset and byte ops
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

Signed-off-by: Matt Reimer <mreimer@vpop.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/w1_int.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

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

w1-printk-format-warning.patch
w1-allow-bus-master-to-have-reset-and-byte-ops.patch
driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core.patch
use-menuconfig-objects-connector.patch
use-menuconfig-objects-w1.patch
