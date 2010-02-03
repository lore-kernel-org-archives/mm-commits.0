From: akpm@linux-foundation.org
Subject: [merged] pktcdvd-removing-device-does-not-remove-its-sysfs-dir.patch removed from -mm tree
Date: Wed, 03 Feb 2010 09:55:20 -0800
Message-ID: <201002031755.o13HtKt3008977@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49796 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932806Ab0BCR4d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 12:56:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cascardo@holoscopio.com, jens.axboe@oracle.com, kay.sievers@vrfy.org, petero2@telia.com, stable@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     pktcdvd: removing device does not remove its sysfs dir
has been removed from the -mm tree.  Its filename was
     pktcdvd-removing-device-does-not-remove-its-sysfs-dir.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pktcdvd: removing device does not remove its sysfs dir
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

This is the counterpart to cba767175becadc5c4016cceb7bfdd2c7fe722f4
("pktcdvd: remove broken dev_t export of class devices").  Device is not
registered using dev_t, so it should not be destroyed using device_destroy
which looks up the device by dev_t.  This will fail and adding the device
again will fail with the "duplicate name" error.  This is fixed using
device_unregister instead of device_destroy.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Peter Osterlund <petero2@telia.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/pktcdvd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/pktcdvd.c~pktcdvd-removing-device-does-not-remove-its-sysfs-dir drivers/block/pktcdvd.c
--- a/drivers/block/pktcdvd.c~pktcdvd-removing-device-does-not-remove-its-sysfs-dir
+++ a/drivers/block/pktcdvd.c
@@ -322,7 +322,7 @@ static void pkt_sysfs_dev_remove(struct 
 	pkt_kobj_remove(pd->kobj_stat);
 	pkt_kobj_remove(pd->kobj_wqueue);
 	if (class_pktcdvd)
-		device_destroy(class_pktcdvd, pd->pkt_dev);
+		device_unregister(pd->dev);
 }
 
 
_

Patches currently in -mm which might be from cascardo@holoscopio.com are

origin.patch
linux-next.patch
eisa-fix-coding-style-for-eisa-bus-code.patch
doc-console-doc-should-read-bind-unbind-instead-of-bind-bind.patch

