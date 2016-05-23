From: akpm@linux-foundation.org
Subject: [merged] sysctl-use-generic-uuid-library.patch removed from -mm
 tree
Date: Mon, 23 May 2016 12:48:55 -0700
Message-ID: <57435ea7.fQ5lItx4FJq62oZe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37868 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073AbcEWTtB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:49:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, arnd@arndb.de, axboe@kernel.dk, dmitry.kasatkin@gmail.com, linux@rasmusvillemoes.dk, matt@codeblueprint.co.uk, tytso@mit.edu, viro@zeniv.linux.org.uk, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/sysctl_binary.c: use generic UUID library
has been removed from the -mm tree.  Its filename was
     sysctl-use-generic-uuid-library.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: kernel/sysctl_binary.c: use generic UUID library

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

 kernel/sysctl_binary.c |   23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff -puN kernel/sysctl_binary.c~sysctl-use-generic-uuid-library kernel/sysctl_binary.c
--- a/kernel/sysctl_binary.c~sysctl-use-generic-uuid-library
+++ a/kernel/sysctl_binary.c
@@ -13,6 +13,7 @@
 #include <linux/ctype.h>
 #include <linux/netdevice.h>
 #include <linux/kernel.h>
+#include <linux/uuid.h>
 #include <linux/slab.h>
 #include <linux/compat.h>
 
@@ -1117,9 +1118,8 @@ static ssize_t bin_uuid(struct file *fil
 
 	/* Only supports reads */
 	if (oldval && oldlen) {
-		char buf[40], *str = buf;
-		unsigned char uuid[16];
-		int i;
+		char buf[UUID_STRING_LEN + 1];
+		uuid_be uuid;
 
 		result = kernel_read(file, 0, buf, sizeof(buf) - 1);
 		if (result < 0)
@@ -1127,24 +1127,15 @@ static ssize_t bin_uuid(struct file *fil
 
 		buf[result] = '\0';
 
-		/* Convert the uuid to from a string to binary */
-		for (i = 0; i < 16; i++) {
-			result = -EIO;
-			if (!isxdigit(str[0]) || !isxdigit(str[1]))
-				goto out;
-
-			uuid[i] = (hex_to_bin(str[0]) << 4) |
-					hex_to_bin(str[1]);
-			str += 2;
-			if (*str == '-')
-				str++;
-		}
+		result = -EIO;
+		if (uuid_be_to_bin(buf, &uuid))
+			goto out;
 
 		if (oldlen > 16)
 			oldlen = 16;
 
 		result = -EFAULT;
-		if (copy_to_user(oldval, uuid, oldlen))
+		if (copy_to_user(oldval, &uuid, oldlen))
 			goto out;
 
 		copied = oldlen;
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

efi-redefine-type-constant-macro-from-generic-code.patch
efivars-use-generic-uuid-library.patch
genhd-move-to-use-generic-uuid-library.patch
ldm-use-generic-uuid-library.patch
wmi-use-generic-uuid-library.patch

