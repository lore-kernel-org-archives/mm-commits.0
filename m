From: akpm@linux-foundation.org
Subject: [merged] lib-add-on-off-support-to-kstrtobool.patch removed from
 -mm tree
Date: Mon, 21 Mar 2016 11:42:36 -0700
Message-ID: <56f0409c.xDWhu9fRFC7UOC49%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52792 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757934AbcCUTVX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:21:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, akarwar@marvell.com, andy.shevchenko@gmail.com, daniel@iogearbox.net, heiko.carstens@de.ibm.com, joe@perches.com, kvalo@codeaurora.org, linux@rasmusvillemoes.dk, mpe@ellerman.id.au, nishants@marvell.com, schwidefsky@de.ibm.com, sfrench@samba.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: add "on"/"off" support to kstrtobool
has been removed from the -mm tree.  Its filename was
     lib-add-on-off-support-to-kstrtobool.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: lib: add "on"/"off" support to kstrtobool

Add support for "on" and "off" when converting to boolean.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Amitkumar Karwar <akarwar@marvell.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Joe Perches <joe@perches.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nishant Sarmukadam <nishants@marvell.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Steve French <sfrench@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kstrtox.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff -puN lib/kstrtox.c~lib-add-on-off-support-to-kstrtobool lib/kstrtox.c
--- a/lib/kstrtox.c~lib-add-on-off-support-to-kstrtobool
+++ a/lib/kstrtox.c
@@ -326,9 +326,9 @@ EXPORT_SYMBOL(kstrtos8);
  * @s: input string
  * @res: result
  *
- * This routine returns 0 iff the first character is one of 'Yy1Nn0'.
- * Otherwise it will return -EINVAL.  Value pointed to by res is
- * updated upon finding a match.
+ * This routine returns 0 iff the first character is one of 'Yy1Nn0', or
+ * [oO][NnFf] for "on" and "off". Otherwise it will return -EINVAL.  Value
+ * pointed to by res is updated upon finding a match.
  */
 int kstrtobool(const char *s, bool *res)
 {
@@ -346,6 +346,20 @@ int kstrtobool(const char *s, bool *res)
 	case '0':
 		*res = false;
 		return 0;
+	case 'o':
+	case 'O':
+		switch (s[1]) {
+		case 'n':
+		case 'N':
+			*res = true;
+			return 0;
+		case 'f':
+		case 'F':
+			*res = false;
+			return 0;
+		default:
+			break;
+		}
 	default:
 		break;
 	}
_

Patches currently in -mm which might be from keescook@chromium.org are


