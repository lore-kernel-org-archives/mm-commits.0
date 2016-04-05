From: akpm@linux-foundation.org
Subject: [to-be-updated] sysctl-use-generic-uuid-library.patch removed
 from -mm tree
Date: Tue, 05 Apr 2016 14:57:17 -0700
Message-ID: <570434bd.3obbvwJkfekiyAmP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53896 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760525AbcDEV5S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 17:57:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, arnd@arndb.de, linux@rasmusvillemoes.dk, matt@codeblueprint.co.uk, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl: use generic UUID library
has been removed from the -mm tree.  Its filename was
     sysctl-use-generic-uuid-library.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: sysctl: use generic UUID library

UUID library provides uuid_be type and uuid_be_to_bin() function. This
substitutes open coded variant by generic library calls.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl_binary.c |   20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

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
@@ -1128,21 +1128,13 @@ static ssize_t bin_uuid(struct file *fil
 		buf[result] = '\0';
 
 		/* Convert the uuid to from a string to binary */
-		for (i = 0; i < 16; i++) {
-			if (!isxdigit(str[0]) || !isxdigit(str[1]))
-				return -EIO;
