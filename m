From: akpm@linux-foundation.org
Subject: [to-be-updated] sysctl-drop-away-useless-label.patch removed from -mm tree
Date: Tue, 05 Apr 2016 14:57:15 -0700
Message-ID: <570434bb.k00FEmTeU9m4N5Oj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53890 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760525AbcDEV5Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 17:57:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, arnd@arndb.de, linux@rasmusvillemoes.dk, matt@codeblueprint.co.uk, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl: drop away useless label
has been removed from the -mm tree.  Its filename was
     sysctl-drop-away-useless-label.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: sysctl: drop away useless label

We have no locking in bin_uuid(). Thus, we may remove the out label and use
return statements directly.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl_binary.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff -puN kernel/sysctl_binary.c~sysctl-drop-away-useless-label kernel/sysctl_binary.c
--- a/kernel/sysctl_binary.c~sysctl-drop-away-useless-label
+++ a/kernel/sysctl_binary.c
@@ -1123,15 +1123,14 @@ static ssize_t bin_uuid(struct file *fil
 
 		result = kernel_read(file, 0, buf, sizeof(buf) - 1);
 		if (result < 0)
-			goto out;
+			return result;
 
 		buf[result] = '\0';
 
 		/* Convert the uuid to from a string to binary */
 		for (i = 0; i < 16; i++) {
-			result = -EIO;
 			if (!isxdigit(str[0]) || !isxdigit(str[1]))
-				goto out;
+				return -EIO;
 
 			uuid[i] = (hex_to_bin(str[0]) << 4) |
 					hex_to_bin(str[1]);
@@ -1143,15 +1142,12 @@ static ssize_t bin_uuid(struct file *fil
 		if (oldlen > 16)
 			oldlen = 16;
 
-		result = -EFAULT;
 		if (copy_to_user(oldval, uuid, oldlen))
-			goto out;
+			return -EFAULT;
 
 		copied = oldlen;
 	}
-	result = copied;
-out:
-	return result;
+	return copied;
 }
 
 static ssize_t bin_dn_node_address(struct file *file,
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

sysctl-use-generic-uuid-library.patch
efi-redefine-type-constant-macro-from-generic-code.patch
efivars-use-generic-uuid-library.patch

