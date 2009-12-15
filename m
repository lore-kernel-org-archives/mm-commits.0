From: akpm@linux-foundation.org
Subject: [merged] ctype-constify-read-only-_ctype-string.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:57:36 -0800
Message-ID: <200912152157.nBFLvan2015731@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59376 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761302AbZLOV6G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:58:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andre.goddard@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ctype: constify read-only _ctype string
has been removed from the -mm tree.  Its filename was
     ctype-constify-read-only-_ctype-string.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: ctype: constify read-only _ctype string
=46rom: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>

While at it, use tabs to indent the comments.

Signed-off-by: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ctype.h |    2 -
 lib/ctype.c           |   50 ++++++++++++++++++++--------------------
 2 files changed, 26 insertions(+), 26 deletions(-)

diff -puN include/linux/ctype.h~ctype-constify-read-only-_ctype-string =
include/linux/ctype.h
--- a/include/linux/ctype.h~ctype-constify-read-only-_ctype-string
+++ a/include/linux/ctype.h
@@ -15,7 +15,7 @@
 #define _X	0x40	/* hex digit */
 #define _SP	0x80	/* hard space (0x20) */
=20
-extern unsigned char _ctype[];
+extern const unsigned char _ctype[];
=20
 #define __ismask(x) (_ctype[(int)(unsigned char)(x)])
=20
diff -puN lib/ctype.c~ctype-constify-read-only-_ctype-string lib/ctype.=
c
--- a/lib/ctype.c~ctype-constify-read-only-_ctype-string
+++ a/lib/ctype.c
@@ -7,30 +7,30 @@
 #include <linux/ctype.h>
 #include <linux/module.h>
=20
-unsigned char _ctype[] =3D {
-_C,_C,_C,_C,_C,_C,_C,_C,			/* 0-7 */
-_C,_C|_S,_C|_S,_C|_S,_C|_S,_C|_S,_C,_C,		/* 8-15 */
-_C,_C,_C,_C,_C,_C,_C,_C,			/* 16-23 */
-_C,_C,_C,_C,_C,_C,_C,_C,			/* 24-31 */
-_S|_SP,_P,_P,_P,_P,_P,_P,_P,			/* 32-39 */
-_P,_P,_P,_P,_P,_P,_P,_P,			/* 40-47 */
-_D,_D,_D,_D,_D,_D,_D,_D,			/* 48-55 */
-_D,_D,_P,_P,_P,_P,_P,_P,			/* 56-63 */
-_P,_U|_X,_U|_X,_U|_X,_U|_X,_U|_X,_U|_X,_U,	/* 64-71 */
-_U,_U,_U,_U,_U,_U,_U,_U,			/* 72-79 */
-_U,_U,_U,_U,_U,_U,_U,_U,			/* 80-87 */
-_U,_U,_U,_P,_P,_P,_P,_P,			/* 88-95 */
-_P,_L|_X,_L|_X,_L|_X,_L|_X,_L|_X,_L|_X,_L,	/* 96-103 */
-_L,_L,_L,_L,_L,_L,_L,_L,			/* 104-111 */
-_L,_L,_L,_L,_L,_L,_L,_L,			/* 112-119 */
-_L,_L,_L,_P,_P,_P,_P,_C,			/* 120-127 */
-0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,		/* 128-143 */
-0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,		/* 144-159 */
-_S|_SP,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,   /* 160-175 */
-_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,       /* 176-191 */
-_U,_U,_U,_U,_U,_U,_U,_U,_U,_U,_U,_U,_U,_U,_U,_U,       /* 192-207 */
-_U,_U,_U,_U,_U,_U,_U,_P,_U,_U,_U,_U,_U,_U,_U,_L,       /* 208-223 */
-_L,_L,_L,_L,_L,_L,_L,_L,_L,_L,_L,_L,_L,_L,_L,_L,       /* 224-239 */
-_L,_L,_L,_L,_L,_L,_L,_P,_L,_L,_L,_L,_L,_L,_L,_L};      /* 240-255 */
+const unsigned char _ctype[] =3D {
+_C,_C,_C,_C,_C,_C,_C,_C,				/* 0-7 */
+_C,_C|_S,_C|_S,_C|_S,_C|_S,_C|_S,_C,_C,			/* 8-15 */
+_C,_C,_C,_C,_C,_C,_C,_C,				/* 16-23 */
+_C,_C,_C,_C,_C,_C,_C,_C,				/* 24-31 */
+_S|_SP,_P,_P,_P,_P,_P,_P,_P,				/* 32-39 */
+_P,_P,_P,_P,_P,_P,_P,_P,				/* 40-47 */
+_D,_D,_D,_D,_D,_D,_D,_D,				/* 48-55 */
+_D,_D,_P,_P,_P,_P,_P,_P,				/* 56-63 */
+_P,_U|_X,_U|_X,_U|_X,_U|_X,_U|_X,_U|_X,_U,		/* 64-71 */
+_U,_U,_U,_U,_U,_U,_U,_U,				/* 72-79 */
+_U,_U,_U,_U,_U,_U,_U,_U,				/* 80-87 */
+_U,_U,_U,_P,_P,_P,_P,_P,				/* 88-95 */
+_P,_L|_X,_L|_X,_L|_X,_L|_X,_L|_X,_L|_X,_L,		/* 96-103 */
+_L,_L,_L,_L,_L,_L,_L,_L,				/* 104-111 */
+_L,_L,_L,_L,_L,_L,_L,_L,				/* 112-119 */
+_L,_L,_L,_P,_P,_P,_P,_C,				/* 120-127 */
+0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,			/* 128-143 */
+0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,			/* 144-159 */
+_S|_SP,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,	/* 160-175 */
+_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,	/* 176-191 */
+_U,_U,_U,_U,_U,_U,_U,_U,_U,_U,_U,_U,_U,_U,_U,_U,	/* 192-207 */
+_U,_U,_U,_U,_U,_U,_U,_P,_U,_U,_U,_U,_U,_U,_U,_L,	/* 208-223 */
+_L,_L,_L,_L,_L,_L,_L,_L,_L,_L,_L,_L,_L,_L,_L,_L,	/* 224-239 */
+_L,_L,_L,_L,_L,_L,_L,_P,_L,_L,_L,_L,_L,_L,_L,_L};	/* 240-255 */
=20
 EXPORT_SYMBOL(_ctype);
_

Patches currently in -mm which might be from andre.goddard@gmail.com ar=
e

origin.patch
pid-tighten-pidmap-spinlock-critical-section-by-removing-kfree.patch
pid-reduce-code-size-by-using-a-pointer-to-iterate-over-array.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
