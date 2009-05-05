From: akpm@linux-foundation.org
Subject: + libata-avoid-world-writable-sysfs-files.patch added to -mm tree
Date: Tue, 05 May 2009 12:48:18 -0700
Message-ID: <200905051948.n45JmIvj020465@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59170 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752700AbZEETvH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 May 2009 15:51:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: v.mayatskih@gmail.com, jeff@garzik.org


The patch titled
     libata: avoid world-writable sysfs files
has been added to the -mm tree.  Its filename is
     libata-avoid-world-writable-sysfs-files.patch

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
Subject: libata: avoid world-writable sysfs files
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>

Avoid world-writable sysfs files in libata driver.

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-scsi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/ata/libata-scsi.c~libata-avoid-world-writable-sysfs-files drivers/ata/libata-scsi.c
--- a/drivers/ata/libata-scsi.c~libata-avoid-world-writable-sysfs-files
+++ a/drivers/ata/libata-scsi.c
@@ -313,7 +313,7 @@ ata_scsi_em_message_show(struct device *
 		return ap->ops->em_show(ap, buf);
 	return -EINVAL;
 }
-DEVICE_ATTR(em_message, S_IRUGO | S_IWUGO,
+DEVICE_ATTR(em_message, S_IRUGO | S_IWUSR,
 		ata_scsi_em_message_show, ata_scsi_em_message_store);
 EXPORT_SYMBOL_GPL(dev_attr_em_message);
 
@@ -366,7 +366,7 @@ ata_scsi_activity_store(struct device *d
 	}
 	return -EINVAL;
 }
-DEVICE_ATTR(sw_activity, S_IWUGO | S_IRUGO, ata_scsi_activity_show,
+DEVICE_ATTR(sw_activity, S_IWUSR | S_IRUGO, ata_scsi_activity_show,
 			ata_scsi_activity_store);
 EXPORT_SYMBOL_GPL(dev_attr_sw_activity);
 
_

Patches currently in -mm which might be from v.mayatskih@gmail.com are

origin.patch
libata-avoid-world-writable-sysfs-files.patch

