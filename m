From: akpm@google.com
Subject: [wrecked] fs-binfmt_miscc-use-kernels-hex_to_bin-method.patch removed from -mm tree
Date: Tue, 27 Sep 2011 12:11:03 -0700
Message-ID: <201109271911.p8RJB3EZ011257@wpaz17.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:45397 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab1I0TLY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Sep 2011 15:11:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andy.shevchenko@gmail.com, dhowells@redhat.com, jmorris@namei.org, serge@hallyn.com, zohar@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/binfmt_misc.c: use kernel's hex_to_bin() method
has been removed from the -mm tree.  Its filename was
     fs-binfmt_miscc-use-kernels-hex_to_bin-method.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: fs/binfmt_misc.c: use kernel's hex_to_bin() method

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Mimi Zohar <zohar@us.ibm.com>
Cc: Serge E. Hallyn <serge@hallyn.com>
Cc: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@google.com>
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
 
@@ -243,10 +244,8 @@ static int unquote(char *from)
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
lib-bitmapc-quiet-sparse-noise-about-address-space.patch
lib-bitmapc-quiet-sparse-noise-about-address-space-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch

