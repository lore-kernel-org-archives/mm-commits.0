Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC642C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:22:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9175761CA9
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:22:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbhGFTZR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:25:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:58552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229811AbhGFTZR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:25:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 825D961CA3;
        Tue,  6 Jul 2021 19:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599357;
        bh=7diE05//ojgdnQu+eXUkf/eYbpZNaC9qI8B618we6XA=;
        h=Date:From:To:Subject:From;
        b=ZIvWwESFvNcSABk/UJ9id4LBHtzyYrUoxLt21RMUND5tslC+37GIlhlNWcRNZaL+G
         SQkyhgHi6Wq/DFqYB/kiFNN3/1yHO0XPqB1FSju4eA/mTrLVWSt8IB6BdzWubXGO1f
         AsSrTBDRlWl2tuleaQ3R/Embh95OJIlTH8eS50/o=
Date:   Tue, 06 Jul 2021 12:22:37 -0700
From:   akpm@linux-foundation.org
To:     jkosina@suse.cz, mm-commits@vger.kernel.org,
        thunder.leizhen@huawei.com, tsbogend@alpha.franken.de
Subject:  [merged] lib-decompressors-fix-spelling-mistakes.patch
 removed from -mm tree
Message-ID: <20210706192237.e1UYtE9iH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/decompressors: fix spelling mistakes
has been removed from the -mm tree.  Its filename was
     lib-decompressors-fix-spelling-mistakes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhen Lei <thunder.leizhen@huawei.com>
Subject: lib/decompressors: fix spelling mistakes

Fix some spelling mistakes in comments:
sentinal ==> sentinel
compresed ==> compressed
dependeny ==> dependency
immediatelly ==> immediately
dervied ==> derived
splitted ==> split
nore ==> not
independed ==> independent
asumed ==> assumed

Link: https://lkml.kernel.org/r/20210604085656.12257-1-thunder.leizhen@huawei.com
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/decompress_bunzip2.c   |    4 ++--
 lib/decompress_unxz.c      |    2 +-
 lib/decompress_unzstd.c    |    4 ++--
 lib/xz/xz_dec_bcj.c        |    2 +-
 lib/xz/xz_dec_lzma2.c      |    8 ++++----
 lib/zlib_inflate/inffast.c |    2 +-
 lib/zstd/huf.h             |    2 +-
 7 files changed, 12 insertions(+), 12 deletions(-)

--- a/lib/decompress_bunzip2.c~lib-decompressors-fix-spelling-mistakes
+++ a/lib/decompress_bunzip2.c
@@ -80,7 +80,7 @@
 
 /* This is what we know about each Huffman coding group */
 struct group_data {
-	/* We have an extra slot at the end of limit[] for a sentinal value. */
+	/* We have an extra slot at the end of limit[] for a sentinel value. */
 	int limit[MAX_HUFCODE_BITS+1];
 	int base[MAX_HUFCODE_BITS];
 	int permute[MAX_SYMBOLS];
@@ -337,7 +337,7 @@ static int INIT get_next_block(struct bu
 			pp <<= 1;
 			base[i+1] = pp-(t += temp[i]);
 		}
-		limit[maxLen+1] = INT_MAX; /* Sentinal value for
+		limit[maxLen+1] = INT_MAX; /* Sentinel value for
 					    * reading next sym. */
 		limit[maxLen] = pp+temp[maxLen]-1;
 		base[minLen] = 0;
--- a/lib/decompress_unxz.c~lib-decompressors-fix-spelling-mistakes
+++ a/lib/decompress_unxz.c
@@ -23,7 +23,7 @@
  * uncompressible. Thus, we must look for worst-case expansion when the
  * compressor is encoding uncompressible data.
  *
- * The structure of the .xz file in case of a compresed kernel is as follows.
+ * The structure of the .xz file in case of a compressed kernel is as follows.
  * Sizes (as bytes) of the fields are in parenthesis.
  *
  *    Stream Header (12)
--- a/lib/decompress_unzstd.c~lib-decompressors-fix-spelling-mistakes
+++ a/lib/decompress_unzstd.c
@@ -16,7 +16,7 @@
  * uncompressible. Thus, we must look for worst-case expansion when the
  * compressor is encoding uncompressible data.
  *
- * The structure of the .zst file in case of a compresed kernel is as follows.
+ * The structure of the .zst file in case of a compressed kernel is as follows.
  * Maximum sizes (as bytes) of the fields are in parenthesis.
  *
  *    Frame Header: (18)
@@ -56,7 +56,7 @@
 /*
  * Preboot environments #include "path/to/decompress_unzstd.c".
  * All of the source files we depend on must be #included.
- * zstd's only source dependeny is xxhash, which has no source
+ * zstd's only source dependency is xxhash, which has no source
  * dependencies.
  *
  * When UNZSTD_PREBOOT is defined we declare __decompress(), which is
--- a/lib/xz/xz_dec_bcj.c~lib-decompressors-fix-spelling-mistakes
+++ a/lib/xz/xz_dec_bcj.c
@@ -422,7 +422,7 @@ XZ_EXTERN enum xz_ret xz_dec_bcj_run(str
 
 	/*
 	 * Flush pending already filtered data to the output buffer. Return
-	 * immediatelly if we couldn't flush everything, or if the next
+	 * immediately if we couldn't flush everything, or if the next
 	 * filter in the chain had already returned XZ_STREAM_END.
 	 */
 	if (s->temp.filtered > 0) {
--- a/lib/xz/xz_dec_lzma2.c~lib-decompressors-fix-spelling-mistakes
+++ a/lib/xz/xz_dec_lzma2.c
@@ -147,8 +147,8 @@ struct lzma_dec {
 
 	/*
 	 * LZMA properties or related bit masks (number of literal
-	 * context bits, a mask dervied from the number of literal
-	 * position bits, and a mask dervied from the number
+	 * context bits, a mask derived from the number of literal
+	 * position bits, and a mask derived from the number
 	 * position bits)
 	 */
 	uint32_t lc;
@@ -484,7 +484,7 @@ static __always_inline void rc_normalize
 }
 
 /*
- * Decode one bit. In some versions, this function has been splitted in three
+ * Decode one bit. In some versions, this function has been split in three
  * functions so that the compiler is supposed to be able to more easily avoid
  * an extra branch. In this particular version of the LZMA decoder, this
  * doesn't seem to be a good idea (tested with GCC 3.3.6, 3.4.6, and 4.3.3
@@ -761,7 +761,7 @@ static bool lzma_main(struct xz_dec_lzma
 }
 
 /*
- * Reset the LZMA decoder and range decoder state. Dictionary is nore reset
+ * Reset the LZMA decoder and range decoder state. Dictionary is not reset
  * here, because LZMA state may be reset without resetting the dictionary.
  */
 static void lzma_reset(struct xz_dec_lzma2 *s)
--- a/lib/zlib_inflate/inffast.c~lib-decompressors-fix-spelling-mistakes
+++ a/lib/zlib_inflate/inffast.c
@@ -15,7 +15,7 @@ union uu {
 	unsigned char b[2];
 };
 
-/* Endian independed version */
+/* Endian independent version */
 static inline unsigned short
 get_unaligned16(const unsigned short *p)
 {
--- a/lib/zstd/huf.h~lib-decompressors-fix-spelling-mistakes
+++ a/lib/zstd/huf.h
@@ -134,7 +134,7 @@ typedef enum {
 	HUF_repeat_none,  /**< Cannot use the previous table */
 	HUF_repeat_check, /**< Can use the previous table but it must be checked. Note : The previous table must have been constructed by HUF_compress{1,
 			     4}X_repeat */
-	HUF_repeat_valid  /**< Can use the previous table and it is asumed to be valid */
+	HUF_repeat_valid  /**< Can use the previous table and it is assumed to be valid */
 } HUF_repeat;
 /** HUF_compress4X_repeat() :
 *   Same as HUF_compress4X_wksp(), but considers using hufTable if *repeat != HUF_repeat_none.
_

Patches currently in -mm which might be from thunder.leizhen@huawei.com are

lib-test-fix-spelling-mistakes.patch
lib-fix-spelling-mistakes.patch
lib-fix-spelling-mistakes-in-header-files.patch
mm-fix-spelling-mistakes-in-header-files.patch

