From: akpm@linux-foundation.org
Subject: + pktcdvd-removing-device-does-not-remove-its-sysfs-dir.patch added to -mm tree
Date: Mon, 01 Feb 2010 14:35:32 -0800
Message-ID: <201002012235.o11MZWCR016835@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752418Ab0BAWgV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2010 17:36:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cascardo@holoscopio.com, jens.axboe@oracle.com, kay.sievers@vrfy.org, petero2@telia.com, stable@kernel.org, viro@zeniv.linux.org.uk


The patch titled
     pktcdvd: removing device does not remove its sysfs dir
has been added to the -mm tree.  Its filename is
     pktcdvd-removing-device-does-not-remove-its-sysfs-dir.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
pktcdvd-removing-device-does-not-remove-its-sysfs-dir.patch
eisa-fix-coding-style-for-eisa-bus-code.patch
doc-console-doc-should-read-bind-unbind-instead-of-bind-bind.patch

