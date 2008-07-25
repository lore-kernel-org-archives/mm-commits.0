From: akpm@linux-foundation.org
Subject: - firmware-use-memory_read_from_buffer.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:01:54 -0700
Message-ID: <200807252301.m6PN1sGu003748@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51222 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753056AbYGYXCa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:02:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, gregkh@suse.de, kay.sievers@vrfy.org, markus.rechberger@amd.com, mm-commits@vger.kernel.org


The patch titled
     firmware: use memory_read_from_buffer()
has been removed from the -mm tree.  Its filename was
     firmware-use-memory_read_from_buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: firmware: use memory_read_from_buffer()
From: Akinobu Mita <akinobu.mita@gmail.com>

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Markus Rechberger <markus.rechberger@amd.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/firmware_class.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff -puN drivers/base/firmware_class.c~firmware-use-memory_read_from_buffer drivers/base/firmware_class.c
--- a/drivers/base/firmware_class.c~firmware-use-memory_read_from_buffer
+++ a/drivers/base/firmware_class.c
@@ -184,7 +184,7 @@ firmware_data_read(struct kobject *kobj,
 	struct device *dev = to_dev(kobj);
 	struct firmware_priv *fw_priv = dev_get_drvdata(dev);
 	struct firmware *fw;
-	ssize_t ret_count = count;
+	ssize_t ret_count;
 
 	mutex_lock(&fw_lock);
 	fw = fw_priv->fw;
@@ -192,14 +192,8 @@ firmware_data_read(struct kobject *kobj,
 		ret_count = -ENODEV;
 		goto out;
 	}
-	if (offset > fw->size) {
-		ret_count = 0;
-		goto out;
-	}
-	if (offset + ret_count > fw->size)
-		ret_count = fw->size - offset;
