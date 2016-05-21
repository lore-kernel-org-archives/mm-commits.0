From: akpm@linux-foundation.org
Subject: [patch 091/162] lib/uuid.c: introduce a few more generic helpers
Date: Fri, 20 May 2016 17:01:04 -0700
Message-ID: <573fa540.tvCvoVr/buiqd9n7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52814 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbcEUABF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:01:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com, arnd@arndb.de, axboe@kernel.dk, dmitry.kasatkin@gmail.com, linux@rasmusvillemoes.dk, matt@codeblueprint.co.uk, tytso@mit.edu, viro@zeniv.linux.org.uk, zohar@linux.vnet.ibm.com

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib/uuid.c: introduce a few more generic helpers

There are new helpers in this patch:

uuid_is_valid		checks if a UUID is valid
uuid_be_to_bin		converts from string to binary (big endian)
uuid_le_to_bin		converts from string to binary (little endian)

They will be used in future, i.e. in the following patches in the series.

This also moves the indices arrays to lib/uuid.c to be shared accross
modules.

[andriy.shevchenko@linux.intel.com: fix typo]
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

 include/linux/uuid.h |   13 ++++++++
 lib/uuid.c           |   65 +++++++++++++++++++++++++++++++++++++++++
 lib/vsprintf.c       |    9 ++---
 3 files changed, 82 insertions(+), 5 deletions(-)

diff -puN include/linux/uuid.h~lib-uuid-introduce-few-more-generic-helpers-for-uuid include/linux/uuid.h
--- a/include/linux/uuid.h~lib-uuid-introduce-few-more-generic-helpers-for-uuid
+++ a/include/linux/uuid.h
@@ -22,6 +22,11 @@
 
 #include <uapi/linux/uuid.h>
 
+/*
+ * The length of a UUID string ("aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee")
+ * not including trailing NUL.
+ */
+#define	UUID_STRING_LEN		36
 
 static inline int uuid_le_cmp(const uuid_le u1, const uuid_le u2)
 {
@@ -38,4 +43,12 @@ void generate_random_uuid(unsigned char
 extern void uuid_le_gen(uuid_le *u);
 extern void uuid_be_gen(uuid_be *u);
 
+bool __must_check uuid_is_valid(const char *uuid);
+
+extern const u8 uuid_le_index[16];
+extern const u8 uuid_be_index[16];
+
+int uuid_le_to_bin(const char *uuid, uuid_le *u);
+int uuid_be_to_bin(const char *uuid, uuid_be *u);
+
 #endif
diff -puN lib/uuid.c~lib-uuid-introduce-few-more-generic-helpers-for-uuid lib/uuid.c
--- a/lib/uuid.c~lib-uuid-introduce-few-more-generic-helpers-for-uuid
+++ a/lib/uuid.c
@@ -19,10 +19,17 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/ctype.h>
+#include <linux/errno.h>
 #include <linux/export.h>
 #include <linux/uuid.h>
 #include <linux/random.h>
 
+const u8 uuid_le_index[16] = {3,2,1,0,5,4,7,6,8,9,10,11,12,13,14,15};
+EXPORT_SYMBOL(uuid_le_index);
+const u8 uuid_be_index[16] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15};
+EXPORT_SYMBOL(uuid_be_index);
+
 /***************************************************************
  * Random UUID interface
  *
@@ -65,3 +72,61 @@ void uuid_be_gen(uuid_be *bu)
 	bu->b[6] = (bu->b[6] & 0x0F) | 0x40;
 }
 EXPORT_SYMBOL_GPL(uuid_be_gen);
+
+/**
+  * uuid_is_valid - checks if UUID string valid
+  * @uuid:	UUID string to check
+  *
+  * Description:
+  * It checks if the UUID string is following the format:
+  *	xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
+  * where x is a hex digit.
+  *
+  * Return: true if input is valid UUID string.
+  */
+bool uuid_is_valid(const char *uuid)
+{
+	unsigned int i;
+
+	for (i = 0; i < UUID_STRING_LEN; i++) {
+		if (i == 8 || i == 13 || i == 18 || i == 23) {
+			if (uuid[i] != '-')
+				return false;
+		} else if (!isxdigit(uuid[i])) {
+			return false;
+		}
+	}
+
+	return true;
+}
+EXPORT_SYMBOL(uuid_is_valid);
+
+static int __uuid_to_bin(const char *uuid, __u8 b[16], const u8 ei[16])
+{
+	static const u8 si[16] = {0,2,4,6,9,11,14,16,19,21,24,26,28,30,32,34};
+	unsigned int i;
+
+	if (!uuid_is_valid(uuid))
+		return -EINVAL;
+
+	for (i = 0; i < 16; i++) {
+		int hi = hex_to_bin(uuid[si[i]] + 0);
+		int lo = hex_to_bin(uuid[si[i]] + 1);
+
+		b[ei[i]] = (hi << 4) | lo;
+	}
+
+	return 0;
+}
+
+int uuid_le_to_bin(const char *uuid, uuid_le *u)
+{
+	return __uuid_to_bin(uuid, u->b, uuid_le_index);
+}
+EXPORT_SYMBOL(uuid_le_to_bin);
+
+int uuid_be_to_bin(const char *uuid, uuid_be *u)
+{
+	return __uuid_to_bin(uuid, u->b, uuid_be_index);
+}
+EXPORT_SYMBOL(uuid_be_to_bin);
diff -puN lib/vsprintf.c~lib-uuid-introduce-few-more-generic-helpers-for-uuid lib/vsprintf.c
--- a/lib/vsprintf.c~lib-uuid-introduce-few-more-generic-helpers-for-uuid
+++ a/lib/vsprintf.c
@@ -30,6 +30,7 @@
 #include <linux/ioport.h>
 #include <linux/dcache.h>
 #include <linux/cred.h>
+#include <linux/uuid.h>
 #include <net/addrconf.h>
 #ifdef CONFIG_BLOCK
 #include <linux/blkdev.h>
@@ -1304,19 +1305,17 @@ static noinline_for_stack
 char *uuid_string(char *buf, char *end, const u8 *addr,
 		  struct printf_spec spec, const char *fmt)
 {
-	char uuid[sizeof("xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx")];
+	char uuid[UUID_STRING_LEN + 1];
 	char *p = uuid;
 	int i;
-	static const u8 be[16] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15};
-	static const u8 le[16] = {3,2,1,0,5,4,7,6,8,9,10,11,12,13,14,15};
-	const u8 *index = be;
+	const u8 *index = uuid_be_index;
 	bool uc = false;
 
 	switch (*(++fmt)) {
 	case 'L':
 		uc = true;		/* fall-through */
 	case 'l':
-		index = le;
+		index = uuid_le_index;
 		break;
 	case 'B':
 		uc = true;
_
