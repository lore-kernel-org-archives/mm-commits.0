From: akpm@linux-foundation.org
Subject: [to-be-updated] lib-uuid-move-generate_random_uuid-to-uuidc.patch removed from -mm tree
Date: Tue, 05 Apr 2016 14:57:06 -0700
Message-ID: <570434b2.4jMbafXtqrwV1FKK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53826 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760525AbcDEV5H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 17:57:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, arnd@arndb.de, linux@rasmusvillemoes.dk, matt@codeblueprint.co.uk, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/uuid: move generate_random_uuid() to uuid.c
has been removed from the -mm tree.  Its filename was
     lib-uuid-move-generate_random_uuid-to-uuidc.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib/uuid: move generate_random_uuid() to uuid.c

Let's gather the UUID related functions under one hood.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c  |   21 +--------------------
 fs/btrfs/volumes.c     |    2 +-
 fs/ext4/ioctl.c        |    2 +-
 fs/f2fs/file.c         |    2 +-
 fs/reiserfs/objectid.c |    2 +-
 fs/ubifs/sb.c          |    2 +-
 include/linux/random.h |    1 -
 include/linux/uuid.h   |    2 ++
 lib/uuid.c             |   20 ++++++++++++++++++++
 9 files changed, 28 insertions(+), 26 deletions(-)

diff -puN drivers/char/random.c~lib-uuid-move-generate_random_uuid-to-uuidc drivers/char/random.c
--- a/drivers/char/random.c~lib-uuid-move-generate_random_uuid-to-uuidc
+++ a/drivers/char/random.c
@@ -260,6 +260,7 @@
 #include <linux/irq.h>
 #include <linux/syscalls.h>
 #include <linux/completion.h>
+#include <linux/uuid.h>
 
 #include <asm/processor.h>
 #include <asm/uaccess.h>
@@ -1621,26 +1622,6 @@ SYSCALL_DEFINE3(getrandom, char __user *
 	return urandom_read(NULL, buf, count, NULL);
 }
 
-/***************************************************************
- * Random UUID interface
- *
- * Used here for a Boot ID, but can be useful for other kernel
- * drivers.
- ***************************************************************/
-
-/*
- * Generate random UUID
- */
-void generate_random_uuid(unsigned char uuid_out[16])
-{
-	get_random_bytes(uuid_out, 16);
-	/* Set UUID version to 4 --- truly random generation */
-	uuid_out[6] = (uuid_out[6] & 0x0F) | 0x40;
-	/* Set the UUID variant to DCE */
-	uuid_out[8] = (uuid_out[8] & 0x3F) | 0x80;
-}
-EXPORT_SYMBOL(generate_random_uuid);
-
 /********************************************************************
  *
  * Sysctl interface
diff -puN fs/btrfs/volumes.c~lib-uuid-move-generate_random_uuid-to-uuidc fs/btrfs/volumes.c
--- a/fs/btrfs/volumes.c~lib-uuid-move-generate_random_uuid-to-uuidc
+++ a/fs/btrfs/volumes.c
@@ -20,13 +20,13 @@
 #include <linux/slab.h>
 #include <linux/buffer_head.h>
 #include <linux/blkdev.h>
-#include <linux/random.h>
 #include <linux/iocontext.h>
 #include <linux/capability.h>
 #include <linux/ratelimit.h>
 #include <linux/kthread.h>
 #include <linux/raid/pq.h>
 #include <linux/semaphore.h>
+#include <linux/uuid.h>
 #include <asm/div64.h>
 #include "ctree.h"
 #include "extent_map.h"
diff -puN fs/ext4/ioctl.c~lib-uuid-move-generate_random_uuid-to-uuidc fs/ext4/ioctl.c
--- a/fs/ext4/ioctl.c~lib-uuid-move-generate_random_uuid-to-uuidc
+++ a/fs/ext4/ioctl.c
@@ -13,8 +13,8 @@
 #include <linux/compat.h>
 #include <linux/mount.h>
 #include <linux/file.h>
-#include <linux/random.h>
 #include <linux/quotaops.h>
+#include <linux/uuid.h>
 #include <asm/uaccess.h>
 #include "ext4_jbd2.h"
 #include "ext4.h"
diff -puN fs/f2fs/file.c~lib-uuid-move-generate_random_uuid-to-uuidc fs/f2fs/file.c
--- a/fs/f2fs/file.c~lib-uuid-move-generate_random_uuid-to-uuidc
+++ a/fs/f2fs/file.c
@@ -20,7 +20,7 @@
 #include <linux/uaccess.h>
 #include <linux/mount.h>
 #include <linux/pagevec.h>
-#include <linux/random.h>
+#include <linux/uuid.h>
 
 #include "f2fs.h"
 #include "node.h"
diff -puN fs/reiserfs/objectid.c~lib-uuid-move-generate_random_uuid-to-uuidc fs/reiserfs/objectid.c
--- a/fs/reiserfs/objectid.c~lib-uuid-move-generate_random_uuid-to-uuidc
+++ a/fs/reiserfs/objectid.c
@@ -3,8 +3,8 @@
  */
 
 #include <linux/string.h>
-#include <linux/random.h>
 #include <linux/time.h>
+#include <linux/uuid.h>
 #include "reiserfs.h"
 
 /* find where objectid map starts */
diff -puN fs/ubifs/sb.c~lib-uuid-move-generate_random_uuid-to-uuidc fs/ubifs/sb.c
--- a/fs/ubifs/sb.c~lib-uuid-move-generate_random_uuid-to-uuidc
+++ a/fs/ubifs/sb.c
@@ -28,8 +28,8 @@
 
 #include "ubifs.h"
 #include <linux/slab.h>
-#include <linux/random.h>
 #include <linux/math64.h>
+#include <linux/uuid.h>
 
 /*
  * Default journal size in logical eraseblocks as a percent of total
diff -puN include/linux/random.h~lib-uuid-move-generate_random_uuid-to-uuidc include/linux/random.h
--- a/include/linux/random.h~lib-uuid-move-generate_random_uuid-to-uuidc
+++ a/include/linux/random.h
@@ -26,7 +26,6 @@ extern void get_random_bytes(void *buf,
 extern int add_random_ready_callback(struct random_ready_callback *rdy);
 extern void del_random_ready_callback(struct random_ready_callback *rdy);
 extern void get_random_bytes_arch(void *buf, int nbytes);
-void generate_random_uuid(unsigned char uuid_out[16]);
 extern int random_int_secret_init(void);
 
 #ifndef MODULE
diff -puN include/linux/uuid.h~lib-uuid-move-generate_random_uuid-to-uuidc include/linux/uuid.h
--- a/include/linux/uuid.h~lib-uuid-move-generate_random_uuid-to-uuidc
+++ a/include/linux/uuid.h
@@ -33,6 +33,8 @@ static inline int uuid_be_cmp(const uuid
 	return memcmp(&u1, &u2, sizeof(uuid_be));
 }
 
+void generate_random_uuid(unsigned char uuid[16]);
+
 extern void uuid_le_gen(uuid_le *u);
 extern void uuid_be_gen(uuid_be *u);
 
diff -puN lib/uuid.c~lib-uuid-move-generate_random_uuid-to-uuidc lib/uuid.c
--- a/lib/uuid.c~lib-uuid-move-generate_random_uuid-to-uuidc
+++ a/lib/uuid.c
@@ -23,6 +23,26 @@
 #include <linux/uuid.h>
 #include <linux/random.h>
 
+/***************************************************************
+ * Random UUID interface
+ *
+ * Used here for a Boot ID, but can be useful for other kernel
+ * drivers.
+ ***************************************************************/
+
+/*
+ * Generate random UUID
+ */
+void generate_random_uuid(unsigned char uuid[16])
+{
+	get_random_bytes(uuid, 16);
+	/* Set UUID version to 4 --- truly random generation */
+	uuid[6] = (uuid[6] & 0x0F) | 0x40;
+	/* Set the UUID variant to DCE */
+	uuid[8] = (uuid[8] & 0x3F) | 0x80;
+}
+EXPORT_SYMBOL(generate_random_uuid);
+
 static void __uuid_gen_common(__u8 b[16])
 {
 	prandom_bytes(b, 16);
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

lib-uuid-introduce-few-more-generic-helpers-for-uuid.patch
lib-uuid-remove-fsf-address.patch
sysctl-drop-away-useless-label.patch
sysctl-use-generic-uuid-library.patch
efi-redefine-type-constant-macro-from-generic-code.patch
efivars-use-generic-uuid-library.patch

