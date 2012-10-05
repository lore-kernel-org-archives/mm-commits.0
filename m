From: akpm@linux-foundation.org
Subject: [merged] lib-decompressc-add-__init-to-decompress_method-and-data.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:22:26 -0700
Message-ID: <20121005202227.4D8A6200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:63590 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab2JEUW3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:22:29 -0400
Received: by mail-lb0-f202.google.com with SMTP id l12so141223lbo.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:22:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hein_tibosch@yahoo.es, albin.tonnerre@free-electrons.com, hpa@zytor.com, phillip@lougher.demon.co.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/decompress.c add __init to decompress_method and data
has been removed from the -mm tree.  Its filename was
     lib-decompressc-add-__init-to-decompress_method-and-data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hein Tibosch <hein_tibosch@yahoo.es>
Subject: lib/decompress.c add __init to decompress_method and data

WARNING: vmlinux.o(.text+0x14cfd8): Section mismatch in
reference from the variable compressed_formats to the function
.init.text:gunzip()
The function compressed_formats() references
the function __init gunzip().
etc..

This patch should solve it:

Within decompress.c, compressed_formats[] needs 'a __initdata annotation',
because some of it's data members refer to functions which will be
unloaded after init.

Consequently, its user decompress_method() will get the __init prefix.

Signed-off-by: Hein Tibosch <hein_tibosch@yahoo.es>
Cc: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/decompress.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN lib/decompress.c~lib-decompressc-add-__init-to-decompress_method-and-data lib/decompress.c
--- a/lib/decompress.c~lib-decompressc-add-__init-to-decompress_method-and-data
+++ a/lib/decompress.c
@@ -14,6 +14,7 @@
 
 #include <linux/types.h>
 #include <linux/string.h>
+#include <linux/init.h>
 
 #ifndef CONFIG_DECOMPRESS_GZIP
 # define gunzip NULL
@@ -31,11 +32,13 @@
 # define unlzo NULL
 #endif
 
-static const struct compress_format {
+struct compress_format {
 	unsigned char magic[2];
 	const char *name;
 	decompress_fn decompressor;
-} compressed_formats[] = {
+};
+
+static const struct compress_format compressed_formats[] __initdata = {
 	{ {037, 0213}, "gzip", gunzip },
 	{ {037, 0236}, "gzip", gunzip },
 	{ {0x42, 0x5a}, "bzip2", bunzip2 },
@@ -45,7 +48,7 @@ static const struct compress_format {
 	{ {0, 0}, NULL, NULL }
 };
 
-decompress_fn decompress_method(const unsigned char *inbuf, int len,
+decompress_fn __init decompress_method(const unsigned char *inbuf, int len,
 				const char **name)
 {
 	const struct compress_format *cf;
_

Patches currently in -mm which might be from hein_tibosch@yahoo.es are

origin.patch
linux-next.patch

