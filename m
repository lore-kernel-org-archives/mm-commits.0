From: akpm@linux-foundation.org
Subject: [merged] genhd-move-to-use-generic-uuid-library.patch removed
 from -mm tree
Date: Mon, 23 May 2016 12:49:01 -0700
Message-ID: <57435ead.X4MoZID/Yvn4VGLJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37898 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076AbcEWTtC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:49:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, arnd@arndb.de, axboe@kernel.dk, dmitry.kasatkin@gmail.com, linux@rasmusvillemoes.dk, matt@codeblueprint.co.uk, tytso@mit.edu, viro@zeniv.linux.org.uk, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/genhd.h: move to use generic UUID library
has been removed from the -mm tree.  Its filename was
     genhd-move-to-use-generic-uuid-library.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: include/linux/genhd.h: move to use generic UUID library

UUID library provides uuid_be type and uuid_be_to_bin() function.  This
substitutes open coded variant by generic library calls.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/genhd.h |   23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

diff -puN include/linux/genhd.h~genhd-move-to-use-generic-uuid-library include/linux/genhd.h
--- a/include/linux/genhd.h~genhd-move-to-use-generic-uuid-library
+++ a/include/linux/genhd.h
@@ -14,6 +14,7 @@
 #include <linux/rcupdate.h>
 #include <linux/slab.h>
 #include <linux/percpu-refcount.h>
+#include <linux/uuid.h>
 
 #ifdef CONFIG_BLOCK
 
@@ -93,7 +94,7 @@ struct disk_stats {
  * Enough for the string representation of any kind of UUID plus NULL.
  * EFI UUID is 36 characters. MSDOS UUID is 11 characters.
  */
-#define PARTITION_META_INFO_UUIDLTH	37
+#define PARTITION_META_INFO_UUIDLTH	(UUID_STRING_LEN + 1)
 
 struct partition_meta_info {
 	char uuid[PARTITION_META_INFO_UUIDLTH];
@@ -228,27 +229,9 @@ static inline struct gendisk *part_to_di
 	return NULL;
 }
 
-static inline void part_pack_uuid(const u8 *uuid_str, u8 *to)
-{
-	int i;
-	for (i = 0; i < 16; ++i) {
-		*to++ = (hex_to_bin(*uuid_str) << 4) |
-			(hex_to_bin(*(uuid_str + 1)));
-		uuid_str += 2;
-		switch (i) {
-		case 3:
-		case 5:
-		case 7:
-		case 9:
-			uuid_str++;
-			continue;
-		}
-	}
-}
