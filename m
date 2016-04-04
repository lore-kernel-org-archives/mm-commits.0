From: akpm@linux-foundation.org
Subject: + sysctl-use-generic-uuid-library.patch added to -mm tree
Date: Mon, 04 Apr 2016 16:40:56 -0700
Message-ID: <5702fb88.nG8sQyz5inunp8tr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39124 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932468AbcDDXk5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Apr 2016 19:40:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, arnd@arndb.de, linux@rasmusvillemoes.dk, matt@codeblueprint.co.uk, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl: use generic UUID library
has been added to the -mm tree.  Its filename is
     sysctl-use-generic-uuid-library.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sysctl-use-generic-uuid-library.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sysctl-use-generic-uuid-library.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
-
-			uuid[i] = (hex_to_bin(str[0]) << 4) |
-					hex_to_bin(str[1]);
-			str += 2;
-			if (*str == '-')
-				str++;
-		}
+		if (uuid_be_to_bin(buf, &uuid))
+			return -EIO;
 
 		if (oldlen > 16)
 			oldlen = 16;
 
-		if (copy_to_user(oldval, uuid, oldlen))
+		if (copy_to_user(oldval, &uuid, oldlen))
 			return -EFAULT;
 
 		copied = oldlen;
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

lib-vsprintf-simplify-uuid-printing.patch
lib-uuid-move-generate_random_uuid-to-uuidc.patch
lib-uuid-introduce-few-more-generic-helpers-for-uuid.patch
lib-uuid-remove-fsf-address.patch
sysctl-drop-away-useless-label.patch
sysctl-use-generic-uuid-library.patch
efi-redefine-type-constant-macro-from-generic-code.patch
efivars-use-generic-uuid-library.patch

