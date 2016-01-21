From: akpm@linux-foundation.org
Subject: [merged] rapidio-use-kobj_to_dev.patch removed from -mm tree
Date: Thu, 21 Jan 2016 15:28:08 -0800
Message-ID: <56a16988.yaYNUKrvdlIPsqp7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35811 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbcAUX2J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 18:28:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@163.com, Alexandre.Bounine@idt.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: use kobj_to_dev()
has been removed from the -mm tree.  Its filename was
     rapidio-use-kobj_to_dev.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geliang Tang <geliangtang@163.com>
Subject: rapidio: use kobj_to_dev()

Use kobj_to_dev() instead of open-coding it.

Signed-off-by: Geliang Tang <geliangtang@163.com>
Acked-by: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-sysfs.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/rapidio/rio-sysfs.c~rapidio-use-kobj_to_dev drivers/rapidio/rio-sysfs.c
--- a/drivers/rapidio/rio-sysfs.c~rapidio-use-kobj_to_dev
+++ a/drivers/rapidio/rio-sysfs.c
@@ -125,8 +125,7 @@ rio_read_config(struct file *filp, struc
 		struct bin_attribute *bin_attr,
 		char *buf, loff_t off, size_t count)
 {
-	struct rio_dev *dev =
-	    to_rio_dev(container_of(kobj, struct device, kobj));
+	struct rio_dev *dev = to_rio_dev(kobj_to_dev(kobj));
 	unsigned int size = 0x100;
 	loff_t init_off = off;
 	u8 *data = (u8 *) buf;
@@ -197,8 +196,7 @@ rio_write_config(struct file *filp, stru
 		 struct bin_attribute *bin_attr,
 		 char *buf, loff_t off, size_t count)
 {
-	struct rio_dev *dev =
-	    to_rio_dev(container_of(kobj, struct device, kobj));
+	struct rio_dev *dev = to_rio_dev(kobj_to_dev(kobj));
 	unsigned int size = count;
 	loff_t init_off = off;
 	u8 *data = (u8 *) buf;
_

Patches currently in -mm which might be from geliangtang@163.com are


