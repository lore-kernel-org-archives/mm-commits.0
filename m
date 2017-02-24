From: akpm@linux-foundation.org
Subject: [folded-merged]
 lib-update-lz4-compressor-module-fix-fix-fix.patch removed from -mm tree
Date: Fri, 24 Feb 2017 14:45:49 -0800
Message-ID: <58b0b79d.E81tNE+68eJMp04Q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36610 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751163AbdBXWpu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:45:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, 4sschmid@informatik.uni-hamburg.de, arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-update-lz4-compressor-module-fix-fix-fix
has been removed from the -mm tree.  Its filename was
     lib-update-lz4-compressor-module-fix-fix-fix.patch

This patch was dropped because it was folded into lib-update-lz4-compressor-module.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-update-lz4-compressor-module-fix-fix-fix

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/lz4/lz4_decompress.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -puN lib/lz4/lz4_decompress.c~lib-update-lz4-compressor-module-fix-fix-fix lib/lz4/lz4_decompress.c
--- a/lib/lz4/lz4_decompress.c~lib-update-lz4-compressor-module-fix-fix-fix
+++ a/lib/lz4/lz4_decompress.c
@@ -475,17 +475,6 @@ int LZ4_decompress_fast_usingDict(const
 		originalSize, 0, dictStart, dictSize);
 }
 
-#ifndef STATIC
-EXPORT_SYMBOL(LZ4_decompress_safe);
-EXPORT_SYMBOL(LZ4_decompress_safe_partial);
-EXPORT_SYMBOL(LZ4_decompress_fast);
-EXPORT_SYMBOL(LZ4_setStreamDecode);
-EXPORT_SYMBOL(LZ4_decompress_safe_continue);
-EXPORT_SYMBOL(LZ4_decompress_fast_continue);
-EXPORT_SYMBOL(LZ4_decompress_safe_usingDict);
-EXPORT_SYMBOL(LZ4_decompress_fast_usingDict);
-#endif
-
 /*-******************************
  *	For backwards compatibility
  ********************************/
@@ -507,7 +496,6 @@ int lz4_decompress_unknownoutputsize(con
 	else
 		return -1;
 }
-EXPORT_SYMBOL(lz4_decompress_unknownoutputsize);
 
 int lz4_decompress(const unsigned char *src, size_t *src_len,
 	unsigned char *dest, size_t actual_dest_len) {
@@ -526,7 +514,19 @@ int lz4_decompress(const unsigned char *
 	else
 		return -1;
 }
+
+#ifndef STATIC
+EXPORT_SYMBOL(LZ4_decompress_safe);
+EXPORT_SYMBOL(LZ4_decompress_safe_partial);
+EXPORT_SYMBOL(LZ4_decompress_fast);
+EXPORT_SYMBOL(LZ4_setStreamDecode);
+EXPORT_SYMBOL(LZ4_decompress_safe_continue);
+EXPORT_SYMBOL(LZ4_decompress_fast_continue);
+EXPORT_SYMBOL(LZ4_decompress_safe_usingDict);
+EXPORT_SYMBOL(LZ4_decompress_fast_usingDict);
+EXPORT_SYMBOL(lz4_decompress_unknownoutputsize);
 EXPORT_SYMBOL(lz4_decompress);
 
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_DESCRIPTION("LZ4 decompressor");
+#endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory_hotplugc-unexport-__remove_pages.patch
z3fold-add-kref-refcounting-checkpatch-fixes.patch
lib-update-lz4-compressor-module.patch

