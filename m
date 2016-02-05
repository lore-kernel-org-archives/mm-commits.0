From: akpm@linux-foundation.org
Subject: + lib-add-on-off-support-to-kstrtobool.patch added to -mm tree
Date: Fri, 05 Feb 2016 15:05:10 -0800
Message-ID: <56b52aa6.JZlbxk/RTfLctY7z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36159 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbcBEXFL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Feb 2016 18:05:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, akarwar@marvell.com, andy.shevchenko@gmail.com, daniel@iogearbox.net, heiko.carstens@de.ibm.com, joe@perches.com, kvalo@codeaurora.org, linux@rasmusvillemoes.dk, mpe@ellerman.id.au, nishants@marvell.com, schwidefsky@de.ibm.com, sfrench@samba.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: add "on"/"off" support to kstrtobool
has been added to the -mm tree.  Its filename is
     lib-add-on-off-support-to-kstrtobool.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-add-on-off-support-to-kstrtobool.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-add-on-off-support-to-kstrtobool.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

lib-move-strtobool-to-kstrtobool.patch
lib-update-single-char-callers-of-strtobool.patch
lib-add-on-off-support-to-kstrtobool.patch
param-convert-some-on-off-users-to-strtobool.patch

