From: akpm@linux-foundation.org
Subject: [patch 095/162] fs/efivarfs/inode.c: use generic UUID library
Date: Fri, 20 May 2016 17:01:21 -0700
Message-ID: <573fa551.cdlW7cya5orBmGWD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52861 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbcEUABX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:01:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com, arnd@arndb.de, axboe@kernel.dk, dmitry.kasatkin@gmail.com, linux@rasmusvillemoes.dk, matt@codeblueprint.co.uk, tytso@mit.edu, viro@zeniv.linux.org.uk, zohar@linux.vnet.ibm.com

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: fs/efivarfs/inode.c: use generic UUID library

Instead of opencoding let's use generic UUID library functions here.

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

 fs/efivarfs/inode.c |   40 +++-------------------------------------
 1 file changed, 3 insertions(+), 37 deletions(-)

diff -puN fs/efivarfs/inode.c~efivars-use-generic-uuid-library fs/efivarfs/inode.c
--- a/fs/efivarfs/inode.c~efivars-use-generic-uuid-library
+++ a/fs/efivarfs/inode.c
@@ -11,6 +11,7 @@
 #include <linux/fs.h>
 #include <linux/ctype.h>
 #include <linux/slab.h>
+#include <linux/uuid.h>
 
 #include "internal.h"
 
@@ -46,11 +47,7 @@ struct inode *efivarfs_get_inode(struct
  */
 bool efivarfs_valid_name(const char *str, int len)
 {
-	static const char dashes[EFI_VARIABLE_GUID_LEN] = {
-		[8] = 1, [13] = 1, [18] = 1, [23] = 1
-	};
 	const char *s = str + len - EFI_VARIABLE_GUID_LEN;
-	int i;
 
 	/*
 	 * We need a GUID, plus at least one letter for the variable name,
@@ -68,37 +65,7 @@ bool efivarfs_valid_name(const char *str
 	 *
 	 *	12345678-1234-1234-1234-123456789abc
 	 */
-	for (i = 0; i < EFI_VARIABLE_GUID_LEN; i++) {
-		if (dashes[i]) {
-			if (*s++ != '-')
-				return false;
-		} else {
-			if (!isxdigit(*s++))
-				return false;
-		}
-	}
-
-	return true;
-}
-
-static void efivarfs_hex_to_guid(const char *str, efi_guid_t *guid)
-{
-	guid->b[0] = hex_to_bin(str[6]) << 4 | hex_to_bin(str[7]);
-	guid->b[1] = hex_to_bin(str[4]) << 4 | hex_to_bin(str[5]);
-	guid->b[2] = hex_to_bin(str[2]) << 4 | hex_to_bin(str[3]);
-	guid->b[3] = hex_to_bin(str[0]) << 4 | hex_to_bin(str[1]);
-	guid->b[4] = hex_to_bin(str[11]) << 4 | hex_to_bin(str[12]);
-	guid->b[5] = hex_to_bin(str[9]) << 4 | hex_to_bin(str[10]);
-	guid->b[6] = hex_to_bin(str[16]) << 4 | hex_to_bin(str[17]);
-	guid->b[7] = hex_to_bin(str[14]) << 4 | hex_to_bin(str[15]);
-	guid->b[8] = hex_to_bin(str[19]) << 4 | hex_to_bin(str[20]);
-	guid->b[9] = hex_to_bin(str[21]) << 4 | hex_to_bin(str[22]);
-	guid->b[10] = hex_to_bin(str[24]) << 4 | hex_to_bin(str[25]);
-	guid->b[11] = hex_to_bin(str[26]) << 4 | hex_to_bin(str[27]);
-	guid->b[12] = hex_to_bin(str[28]) << 4 | hex_to_bin(str[29]);
-	guid->b[13] = hex_to_bin(str[30]) << 4 | hex_to_bin(str[31]);
-	guid->b[14] = hex_to_bin(str[32]) << 4 | hex_to_bin(str[33]);
-	guid->b[15] = hex_to_bin(str[34]) << 4 | hex_to_bin(str[35]);
+	return uuid_is_valid(s);
 }
 
 static int efivarfs_create(struct inode *dir, struct dentry *dentry,
@@ -119,8 +86,7 @@ static int efivarfs_create(struct inode
 	/* length of the variable name itself: remove GUID and separator */
 	namelen = dentry->d_name.len - EFI_VARIABLE_GUID_LEN - 1;
 
-	efivarfs_hex_to_guid(dentry->d_name.name + namelen + 1,
-			&var->var.VendorGuid);
+	uuid_le_to_bin(dentry->d_name.name + namelen + 1, &var->var.VendorGuid);
 
 	if (efivar_variable_is_removable(var->var.VendorGuid,
 					 dentry->d_name.name, namelen))
_
