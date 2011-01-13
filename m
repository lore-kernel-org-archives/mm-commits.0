From: akpm@linux-foundation.org
Subject: [merged] decompressors-include-linux-slabh-in-linux-decompress-mmh.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:10:17 -0800
Message-ID: <201101132012.p0DKCw53030343@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55153 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751663Ab1AMU0m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:26:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lasse.collin@tukaani.org, alain@knaff.lu, albin.tonnerre@free-electrons.com, hpa@zytor.com, phillip@lougher.demon.co.uk, mm-commits@vger.kernel.org


The patch titled
     Decompressors: include <linux/slab.h> in <linux/decompress/mm.h>
has been removed from the -mm tree.  Its filename was
     decompressors-include-linux-slabh-in-linux-decompress-mmh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

