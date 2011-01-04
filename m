From: akpm@linux-foundation.org
Subject: + fs-binfmt_miscc-use-kernels-hex_to_bin-method.patch added to -mm tree
Date: Tue, 04 Jan 2011 15:21:15 -0800
Message-ID: <201101042321.p04NLF6L030049@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42001 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751310Ab1ADXV3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jan 2011 18:21:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andy.shevchenko@gmail.com, dhowells@redhat.com, jmorris@namei.org, serge@hallyn.com, zohar@us.ibm.com


The patch titled
     fs/binfmt_misc.c: use kernel's hex_to_bin() method
has been added to the -mm tree.  Its filename is
     fs-binfmt_miscc-use-kernels-hex_to_bin-method.patch

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
Subject: fs/binfmt_misc.c: use kernel's hex_to_bin() method
From: Andy Shevchenko <andy.shevchenko@gmail.com>

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Mimi Zohar <zohar@us.ibm.com>
Cc: Serge E. Hallyn <serge@hallyn.com>
Cc: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_misc.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN fs/binfmt_misc.c~fs-binfmt_miscc-use-kernels-hex_to_bin-method fs/binfmt_misc.c
--- a/fs/binfmt_misc.c~fs-binfmt_miscc-use-kernels-hex_to_bin-method
+++ a/fs/binfmt_misc.c
@@ -28,6 +28,7 @@
 #include <linux/mount.h>
 #include <linux/syscalls.h>
 #include <linux/fs.h>
+#include <linux/kernel.h>
 
 #include <asm/uaccess.h>
 
@@ -244,10 +245,8 @@ static int unquote(char *from)
 	while ((c = *s++) != '\0') {
 		if (c == '\\' && *s == 'x') {
 			s++;
-			c = toupper(*s++);
-			*p = (c - (isdigit(c) ? '0' : 'A' - 10)) << 4;
-			c = toupper(*s++);
-			*p++ |= c - (isdigit(c) ? '0' : 'A' - 10);
+			*p = hex_to_bin(*s++) << 4;
+			*p++ |= hex_to_bin(*s++);
 			continue;
 		}
 		*p++ = c;
_

Patches currently in -mm which might be from andy.shevchenko@gmail.com are

linux-next.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch

