From: akpm@linux-foundation.org
Subject: [merged] rapidio-fix-potential-null-pointer-dereference.patch
 removed from -mm tree
Date: Fri, 29 Apr 2016 15:05:50 -0700
Message-ID: <5723dabe.Hb80kscFYpf05PD2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45462 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbcD2WFv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2016 18:05:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vz@mleia.com, alexandre.bounine@idt.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: fix potential NULL pointer dereference
has been removed from the -mm tree.  Its filename was
     rapidio-fix-potential-null-pointer-dereference.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Zapolskiy <vz@mleia.com>
Subject: rapidio: fix potential NULL pointer dereference

The change fixes improper check for a returned error value by
class_create() function, which on error returns ERR_PTR() value, thus the
original check always results in a dead code on error path.

Signed-off-by: Vladimir Zapolskiy <vz@mleia.com>
Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/rio_mport_cdev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rapidio/devices/rio_mport_cdev.c~rapidio-fix-potential-null-pointer-dereference drivers/rapidio/devices/rio_mport_cdev.c
--- a/drivers/rapidio/devices/rio_mport_cdev.c~rapidio-fix-potential-null-pointer-dereference
+++ a/drivers/rapidio/devices/rio_mport_cdev.c
@@ -2669,9 +2669,9 @@ static int __init mport_init(void)
 
 	/* Create device class needed by udev */
 	dev_class = class_create(THIS_MODULE, DRV_NAME);
-	if (!dev_class) {
+	if (IS_ERR(dev_class)) {
 		rmcd_error("Unable to create " DRV_NAME " class");
-		return -EINVAL;
+		return PTR_ERR(dev_class);
 	}
 
 	ret = alloc_chrdev_region(&dev_number, 0, RIO_MAX_MPORTS, DRV_NAME);
_

Patches currently in -mm which might be from vz@mleia.com are


