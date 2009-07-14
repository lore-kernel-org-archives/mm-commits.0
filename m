From: akpm@linux-foundation.org
Subject: [merged] base-firmware_class-fix-lock-imbalance.patch removed from -mm tree
Date: Tue, 14 Jul 2009 13:33:20 -0700
Message-ID: <200907142033.n6EKXKFU013344@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42169 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756525AbZGNUdW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Jul 2009 16:33:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     base: firmware_class, fix lock imbalance
has been removed from the -mm tree.  Its filename was
     base-firmware_class-fix-lock-imbalance.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: base: firmware_class, fix lock imbalance
From: Jiri Slaby <jirislaby@gmail.com>

Add omitted unlock in firmware_data_read.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/firmware_class.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/base/firmware_class.c~base-firmware_class-fix-lock-imbalance drivers/base/firmware_class.c
--- a/drivers/base/firmware_class.c~base-firmware_class-fix-lock-imbalance
+++ a/drivers/base/firmware_class.c
@@ -217,8 +217,10 @@ firmware_data_read(struct kobject *kobj,
 		ret_count = -ENODEV;
 		goto out;
 	}
-	if (offset > fw->size)
-		return 0;
+	if (offset > fw->size) {
+		ret_count = 0;
+		goto out;
+	}
 	if (count > fw->size - offset)
 		count = fw->size - offset;
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

linux-next.patch
toshiba_acpi-return-on-a-fail-path.patch
isdn-hisax-fix-lock-imbalance.patch
icom-converting-space-to-tabs.patch
reiser4.patch

