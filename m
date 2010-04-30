From: akpm@linux-foundation.org
Subject: + sysctl-dont-use-own-implementation-of-hex_to_bin.patch added to -mm tree
Date: Fri, 30 Apr 2010 12:02:16 -0700
Message-ID: <201004301902.o3UJ2Gak005912@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60490 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933085Ab0D3TCy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Apr 2010 15:02:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ext-andriy.shevchenko@nokia.com, ebiederm@xmission.com


The patch titled
     sysctl: don't use own implementation of hex_to_bin()
has been added to the -mm tree.  Its filename is
     sysctl-dont-use-own-implementation-of-hex_to_bin.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl: don't use own implementation of hex_to_bin()
From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Remove own implementation of hex_to_bin().

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl_binary.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN kernel/sysctl_binary.c~sysctl-dont-use-own-implementation-of-hex_to_bin kernel/sysctl_binary.c
--- a/kernel/sysctl_binary.c~sysctl-dont-use-own-implementation-of-hex_to_bin
+++ a/kernel/sysctl_binary.c
@@ -13,6 +13,7 @@
 #include <linux/file.h>
 #include <linux/ctype.h>
 #include <linux/netdevice.h>
+#include <linux/kernel.h>
 #include <linux/slab.h>
 
 #ifdef CONFIG_SYSCTL_SYSCALL
@@ -1125,11 +1126,6 @@ out:
 	return result;
 }
 
-static unsigned hex_value(int ch)
-{
-	return isdigit(ch) ? ch - '0' : ((ch | 0x20) - 'a') + 10;
-}
-
 static ssize_t bin_uuid(struct file *file,
 	void __user *oldval, size_t oldlen, void __user *newval, size_t newlen)
 {
@@ -1157,7 +1153,8 @@ static ssize_t bin_uuid(struct file *fil
 			if (!isxdigit(str[0]) || !isxdigit(str[1]))
 				goto out;
 
-			uuid[i] = (hex_value(str[0]) << 4) | hex_value(str[1]);
+			uuid[i] = (hex_to_bin(str[0]) << 4) |
+					hex_to_bin(str[1]);
 			str += 2;
 			if (*str == '-')
 				str++;
_

Patches currently in -mm which might be from ext-andriy.shevchenko@nokia.com are

linux-next.patch
lib-introduce-common-method-to-convert-hex-digits.patch
drivers-isdn-use-new-hex_to_bin-method.patch
usb-atm-speedtch-use-new-hex_to_bin-method.patch
sysctl-dont-use-own-implementation-of-hex_to_bin.patch
staging-rt2860-use-new-hex_to_bin-method.patch
fs-ldm-dont-use-own-implementation-of-hex_to_bin.patch
drivers-wireless-use-new-hex_to_bin-method.patch
drivers-acpi-dont-use-own-implementation-of-hex_to_bin.patch

