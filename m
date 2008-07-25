From: akpm@linux-foundation.org
Subject: - dell_rbu-use-memory_read_from_buffer.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:02:05 -0700
Message-ID: <200807252302.m6PN25xR003795@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35203 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753387AbYGYXDF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:03:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, Abhay_Salunke@dell.com, Matt_Domsch@dell.com, rui.zhang@intel.com, mm-commits@vger.kernel.org


The patch titled
     dell_rbu: use memory_read_from_buffer()
has been removed from the -mm tree.  Its filename was
     dell_rbu-use-memory_read_from_buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dell_rbu: use memory_read_from_buffer()
From: Akinobu Mita <akinobu.mita@gmail.com>

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Abhay Salunke <Abhay_Salunke@dell.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/dell_rbu.c |   28 +++-------------------------
 1 file changed, 3 insertions(+), 25 deletions(-)

diff -puN drivers/firmware/dell_rbu.c~dell_rbu-use-memory_read_from_buffer drivers/firmware/dell_rbu.c
--- a/drivers/firmware/dell_rbu.c~dell_rbu-use-memory_read_from_buffer
+++ a/drivers/firmware/dell_rbu.c
@@ -507,11 +507,6 @@ static ssize_t read_packet_data(char *bu
 
 static ssize_t read_rbu_mono_data(char *buffer, loff_t pos, size_t count)
 {
-	unsigned char *ptemp = NULL;
-	size_t bytes_left = 0;
-	size_t data_length = 0;
-	ssize_t ret_count = 0;
-
 	/* check to see if we have something to return */
 	if ((rbu_data.image_update_buffer == NULL) ||
 		(rbu_data.bios_image_size == 0)) {
@@ -519,28 +514,11 @@ static ssize_t read_rbu_mono_data(char *
 			"bios_image_size %lu\n",
 			rbu_data.image_update_buffer,
 			rbu_data.bios_image_size);
-		ret_count = -ENOMEM;
-		goto read_rbu_data_exit;
-	}
-
-	if (pos > rbu_data.bios_image_size) {
-		ret_count = 0;
-		goto read_rbu_data_exit;
+		return -ENOMEM;
 	}
 
-	bytes_left = rbu_data.bios_image_size - pos;
-	data_length = min(bytes_left, count);
-
-	ptemp = rbu_data.image_update_buffer;
-	memcpy(buffer, (ptemp + pos), data_length);
-
-	if ((pos + count) > rbu_data.bios_image_size)
-		/* this was the last copy */
-		ret_count = bytes_left;
-	else
-		ret_count = count;
-      read_rbu_data_exit:
-	return ret_count;
+	return memory_read_from_buffer(buffer, count, &pos,
+			rbu_data.image_update_buffer, rbu_data.bios_image_size);
 }
 
 static ssize_t read_rbu_data(struct kobject *kobj,
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
ipr-use-memory_read_from_buffer.patch
qla2xxx-use-memory_read_from_buffer.patch
qla2xxx-use-memory_read_from_buffer-fix.patch
char-merge-ip2main-and-ip2base.patch
char-ip2-cleanup-globals.patch
char-ip2-fix-sparse-warnings.patch
char-ip2-init-deinit-cleanup.patch
ip2-avoid-add_timer-with-pending-timer.patch

