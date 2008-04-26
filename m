From: akpm@linux-foundation.org
Subject: - block2mtd-logging-typo-fixes.patch removed from -mm tree
Date: Sat, 26 Apr 2008 09:41:13 -0700
Message-ID: <200804261641.m3QGfDkf031109@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57513 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756798AbYDZQmB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Apr 2008 12:42:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stephane.chazelas@emerson.com, dwmw2@infradead.org, joern@lazybastard.org, mm-commits@vger.kernel.org


The patch titled
     block2mtd: logging typo fixes
has been removed from the -mm tree.  Its filename was
     block2mtd-logging-typo-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: block2mtd: logging typo fixes
From: Stephane Chazelas <stephane.chazelas@emerson.com>

Address a number of small issues mainly regarding the output made by this
driver to dmesg:

- Some of the blkmtd's had not been changed to block2mtd which caused
  display problem

- the parse_err() macro was displaying "block2mtd: " twice

Signed-off-by: Stephane Chazelas <stephane.chazelas@emerson.com>
Acked-by: Joern Engel <joern@lazybastard.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/devices/block2mtd.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/mtd/devices/block2mtd.c~block2mtd-logging-typo-fixes drivers/mtd/devices/block2mtd.c
--- a/drivers/mtd/devices/block2mtd.c~block2mtd-logging-typo-fixes
+++ a/drivers/mtd/devices/block2mtd.c
@@ -305,7 +305,7 @@ static struct block2mtd_dev *add_device(
 	}
 	list_add(&dev->list, &blkmtd_device_list);
 	INFO("mtd%d: [%s] erase_size = %dKiB [%d]", dev->mtd.index,
-			dev->mtd.name + strlen("blkmtd: "),
+			dev->mtd.name + strlen("block2mtd: "),
 			dev->mtd.erasesize >> 10, dev->mtd.erasesize);
 	return dev;
 
@@ -366,9 +366,9 @@ static inline void kill_final_newline(ch
 }
 
 
-#define parse_err(fmt, args...) do {		\
-	ERROR("block2mtd: " fmt "\n", ## args);	\
-	return 0;				\
+#define parse_err(fmt, args...) do {	\
+	ERROR(fmt, ## args);		\
+	return 0;			\
 } while (0)
 
 #ifndef MODULE
@@ -473,7 +473,7 @@ static void __devexit block2mtd_exit(voi
 		block2mtd_sync(&dev->mtd);
 		del_mtd_device(&dev->mtd);
 		INFO("mtd%d: [%s] removed", dev->mtd.index,
-				dev->mtd.name + strlen("blkmtd: "));
+				dev->mtd.name + strlen("block2mtd: "));
 		list_del(&dev->list);
 		block2mtd_free_device(dev);
 	}
_

Patches currently in -mm which might be from stephane.chazelas@emerson.com are

origin.patch

