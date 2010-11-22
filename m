From: akpm@linux-foundation.org
Subject: + decompressors-include-linux-slabh-in-linux-decompress-mmh.patch added to -mm tree
Date: Mon, 22 Nov 2010 12:01:25 -0800
Message-ID: <201011222001.oAMK1Pna006644@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43777 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757446Ab0KVUB7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Nov 2010 15:01:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lasse.collin@tukaani.org, alain@knaff.lu, albin.tonnerre@free-electrons.com, hpa@zytor.com, phillip@lougher.demon.co.uk


The patch titled
     Decompressors: include <linux/slab.h> in <linux/decompress/mm.h>
has been added to the -mm tree.  Its filename is
     decompressors-include-linux-slabh-in-linux-decompress-mmh.patch

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
Subject: Decompressors: include <linux/slab.h> in <linux/decompress/mm.h>
From: Lasse Collin <lasse.collin@tukaani.org>

Currently users of mm.h need to include <linux/slab.h> to use the macros
malloc() and free() provided by mm.h.  This fixes it.

Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alain Knaff <alain@knaff.lu>
Cc: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/decompress/mm.h |    1 +
 lib/decompress_bunzip2.c      |    1 -
 lib/decompress_inflate.c      |    1 -
 lib/decompress_unlzma.c       |    1 -
 lib/decompress_unlzo.c        |    1 -
 5 files changed, 1 insertion(+), 4 deletions(-)

diff -puN include/linux/decompress/mm.h~decompressors-include-linux-slabh-in-linux-decompress-mmh include/linux/decompress/mm.h
--- a/include/linux/decompress/mm.h~decompressors-include-linux-slabh-in-linux-decompress-mmh
+++ a/include/linux/decompress/mm.h
@@ -70,6 +70,7 @@ static void free(void *where)
 #include <linux/kernel.h>
 #include <linux/fs.h>
 #include <linux/string.h>
+#include <linux/slab.h>
 #include <linux/vmalloc.h>
 
 /* Use defines rather than static inline in order to avoid spurious
diff -puN lib/decompress_bunzip2.c~decompressors-include-linux-slabh-in-linux-decompress-mmh lib/decompress_bunzip2.c
--- a/lib/decompress_bunzip2.c~decompressors-include-linux-slabh-in-linux-decompress-mmh
+++ a/lib/decompress_bunzip2.c
@@ -49,7 +49,6 @@
 #define PREBOOT
 #else
 #include <linux/decompress/bunzip2.h>
-#include <linux/slab.h>
 #endif /* STATIC */
 
 #include <linux/decompress/mm.h>
diff -puN lib/decompress_inflate.c~decompressors-include-linux-slabh-in-linux-decompress-mmh lib/decompress_inflate.c
--- a/lib/decompress_inflate.c~decompressors-include-linux-slabh-in-linux-decompress-mmh
+++ a/lib/decompress_inflate.c
@@ -19,7 +19,6 @@
 #include "zlib_inflate/inflate.h"
 
 #include "zlib_inflate/infutil.h"
-#include <linux/slab.h>
 
 #endif /* STATIC */
 
diff -puN lib/decompress_unlzma.c~decompressors-include-linux-slabh-in-linux-decompress-mmh lib/decompress_unlzma.c
--- a/lib/decompress_unlzma.c~decompressors-include-linux-slabh-in-linux-decompress-mmh
+++ a/lib/decompress_unlzma.c
@@ -33,7 +33,6 @@
 #define PREBOOT
 #else
 #include <linux/decompress/unlzma.h>
-#include <linux/slab.h>
 #endif /* STATIC */
 
 #include <linux/decompress/mm.h>
diff -puN lib/decompress_unlzo.c~decompressors-include-linux-slabh-in-linux-decompress-mmh lib/decompress_unlzo.c
--- a/lib/decompress_unlzo.c~decompressors-include-linux-slabh-in-linux-decompress-mmh
+++ a/lib/decompress_unlzo.c
@@ -33,7 +33,6 @@
 #ifdef STATIC
 #include "lzo/lzo1x_decompress.c"
 #else
-#include <linux/slab.h>
 #include <linux/decompress/unlzo.h>
 #endif
 
_

Patches currently in -mm which might be from lasse.collin@tukaani.org are

decompressors-add-missing-init-ie-__init.patch
decompressors-get-rid-of-set_error_fn-macro.patch
decompressors-include-linux-slabh-in-linux-decompress-mmh.patch
decompressors-remove-unused-function-from-lib-decompress_unlzmac.patch

