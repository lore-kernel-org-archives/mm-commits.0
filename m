Return-Path: <SRS0=lzHQ=BG=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CED0C433E5
	for <mm-commits@archiver.kernel.org>; Mon, 27 Jul 2020 20:12:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12FD120759
	for <mm-commits@archiver.kernel.org>; Mon, 27 Jul 2020 20:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595880733;
	bh=dvyh79rMCwngBVHk62lCVK5Q5OYXpfrFPSwFIMUoEPI=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=quwMGRATlzvJ3oP05KWQwpktoj2YJqI3ElYXChMz4JKGMO+wJu5JIH8oSsOY/XTT7
	 FCvCmB7vY1Mlx1KlfHQrvIkHnknp1haZ5eAKTPbCQSsrJanqz00wGgZh5sEHdm7sDR
	 UBoTBhpC8xUs+U0QLEjlPcaILz3McwVlKXkrU4zg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729094AbgG0UMM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Jul 2020 16:12:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:47604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726451AbgG0UMM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 27 Jul 2020 16:12:12 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AF3420729;
        Mon, 27 Jul 2020 20:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595880731;
        bh=dvyh79rMCwngBVHk62lCVK5Q5OYXpfrFPSwFIMUoEPI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=OH9bZ0WX3YYQOscIFMkU6epJbpvD7MxtD7bnowQCmqpQ1TFNHbWU62UzFoRy6yxKx
         hDKrg27/ZQWE4BNOd/b68Xf2QXtrtMMZzgA9hXMlj9SKwLVmsC0IQO3lAuHQs5SfOc
         18/Ta6MNYRutDfT65+9Y2HX8oUNG62AJhtOzH2NU=
Date:   Mon, 27 Jul 2020 13:12:11 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     colyli@suse.de, grandmaster@al2klimov.de,
        mm-commits@vger.kernel.org
Subject:  + lib-replace-http-links-with-https-ones.patch added to
 -mm tree
Message-ID: <20200727201211.SMzFKLcyn%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/: replace HTTP links with HTTPS ones
has been added to the -mm tree.  Its filename is
     lib-replace-http-links-with-https-ones.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-replace-http-links-with-https-ones.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-replace-http-links-with-https-ones.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Alexander A. Klimov" <grandmaster@al2klimov.de>
Subject: lib/: replace HTTP links with HTTPS ones

Rationale:
Reduces attack surface on kernel devs opening the links for MITM
as HTTPS traffic is much harder to manipulate.

Link: http://lkml.kernel.org/r/20200726112154.16510-1-grandmaster@al2klimov.de
Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
Acked-by: Coly Li <colyli@suse.de>	[crc64.c]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug        |    2 +-
 lib/crc64.c              |    2 +-
 lib/decompress_bunzip2.c |    2 +-
 lib/decompress_unlzma.c  |    6 +++---
 lib/math/rational.c      |    2 +-
 lib/rbtree.c             |    2 +-
 lib/ts_bm.c              |    2 +-
 lib/xxhash.c             |    2 +-
 lib/xz/xz_crc32.c        |    2 +-
 lib/xz/xz_dec_bcj.c      |    2 +-
 lib/xz/xz_dec_lzma2.c    |    2 +-
 lib/xz/xz_lzma2.h        |    2 +-
 lib/xz/xz_stream.h       |    2 +-
 13 files changed, 15 insertions(+), 15 deletions(-)

--- a/lib/crc64.c~lib-replace-http-links-with-https-ones
+++ a/lib/crc64.c
@@ -4,7 +4,7 @@
  *
  * This is a basic crc64 implementation following ECMA-182 specification,
  * which can be found from,
- * http://www.ecma-international.org/publications/standards/Ecma-182.htm
+ * https://www.ecma-international.org/publications/standards/Ecma-182.htm
  *
  * Dr. Ross N. Williams has a great document to introduce the idea of CRC
  * algorithm, here the CRC64 code is also inspired by the table-driven
--- a/lib/decompress_bunzip2.c~lib-replace-http-links-with-https-ones
+++ a/lib/decompress_bunzip2.c
@@ -34,7 +34,7 @@
 		Phone (337) 232-1234 or 1-800-738-2226
 		Fax   (337) 232-1297
 
-		http://www.hospiceacadiana.com/
+		https://www.hospiceacadiana.com/
 
 	Manuel
  */
--- a/lib/decompress_unlzma.c~lib-replace-http-links-with-https-ones
+++ a/lib/decompress_unlzma.c
@@ -8,7 +8,7 @@
  *implementation for lzma.
  *Copyright (C) 2006  Aurelien Jacobs < aurel@gnuage.org >
  *
- *Based on LzmaDecode.c from the LZMA SDK 4.22 (http://www.7-zip.org/)
+ *Based on LzmaDecode.c from the LZMA SDK 4.22 (https://www.7-zip.org/)
  *Copyright (C) 1999-2005  Igor Pavlov
  *
  *Copyrights of the parts, see headers below.
@@ -56,7 +56,7 @@ static long long INIT read_int(unsigned
 /* Small range coder implementation for lzma.
  *Copyright (C) 2006  Aurelien Jacobs < aurel@gnuage.org >
  *
- *Based on LzmaDecode.c from the LZMA SDK 4.22 (http://www.7-zip.org/)
+ *Based on LzmaDecode.c from the LZMA SDK 4.22 (https://www.7-zip.org/)
  *Copyright (c) 1999-2005  Igor Pavlov
  */
 
@@ -213,7 +213,7 @@ rc_bit_tree_decode(struct rc *rc, uint16
  * Small lzma deflate implementation.
  * Copyright (C) 2006  Aurelien Jacobs < aurel@gnuage.org >
  *
- * Based on LzmaDecode.c from the LZMA SDK 4.22 (http://www.7-zip.org/)
+ * Based on LzmaDecode.c from the LZMA SDK 4.22 (https://www.7-zip.org/)
  * Copyright (C) 1999-2005  Igor Pavlov
  */
 
--- a/lib/Kconfig.debug~lib-replace-http-links-with-https-ones
+++ a/lib/Kconfig.debug
@@ -2164,7 +2164,7 @@ config LIST_KUNIT_TEST
 	  and associated macros.
 
 	  KUnit tests run during boot and output the results to the debug log
-	  in TAP format (http://testanything.org/). Only useful for kernel devs
+	  in TAP format (https://testanything.org/). Only useful for kernel devs
 	  running the KUnit test harness, and not intended for inclusion into a
 	  production build.
 
--- a/lib/math/rational.c~lib-replace-http-links-with-https-ones
+++ a/lib/math/rational.c
@@ -27,7 +27,7 @@
  * with the fractional part size described in given_denominator.
  *
  * for theoretical background, see:
- * http://en.wikipedia.org/wiki/Continued_fraction
+ * https://en.wikipedia.org/wiki/Continued_fraction
  */
 
 void rational_best_approximation(
--- a/lib/rbtree.c~lib-replace-http-links-with-https-ones
+++ a/lib/rbtree.c
@@ -13,7 +13,7 @@
 #include <linux/export.h>
 
 /*
- * red-black trees properties:  http://en.wikipedia.org/wiki/Rbtree
+ * red-black trees properties:  https://en.wikipedia.org/wiki/Rbtree
  *
  *  1) A node is either red or black
  *  2) The root is black
--- a/lib/ts_bm.c~lib-replace-http-links-with-https-ones
+++ a/lib/ts_bm.c
@@ -11,7 +11,7 @@
  *   [1] A Fast String Searching Algorithm, R.S. Boyer and Moore.
  *       Communications of the Association for Computing Machinery, 
  *       20(10), 1977, pp. 762-772.
- *       http://www.cs.utexas.edu/users/moore/publications/fstrpos.pdf
+ *       https://www.cs.utexas.edu/users/moore/publications/fstrpos.pdf
  *
  *   [2] Handbook of Exact String Matching Algorithms, Thierry Lecroq, 2004
  *       http://www-igm.univ-mlv.fr/~lecroq/string/string.pdf
--- a/lib/xxhash.c~lib-replace-http-links-with-https-ones
+++ a/lib/xxhash.c
@@ -34,7 +34,7 @@
  * ("BSD").
  *
  * You can contact the author at:
- * - xxHash homepage: http://cyan4973.github.io/xxHash/
+ * - xxHash homepage: https://cyan4973.github.io/xxHash/
  * - xxHash source repository: https://github.com/Cyan4973/xxHash
  */
 
--- a/lib/xz/xz_crc32.c~lib-replace-http-links-with-https-ones
+++ a/lib/xz/xz_crc32.c
@@ -2,7 +2,7 @@
  * CRC32 using the polynomial from IEEE-802.3
  *
  * Authors: Lasse Collin <lasse.collin@tukaani.org>
- *          Igor Pavlov <http://7-zip.org/>
+ *          Igor Pavlov <https://7-zip.org/>
  *
  * This file has been put into the public domain.
  * You can do whatever you want with this file.
--- a/lib/xz/xz_dec_bcj.c~lib-replace-http-links-with-https-ones
+++ a/lib/xz/xz_dec_bcj.c
@@ -2,7 +2,7 @@
  * Branch/Call/Jump (BCJ) filter decoders
  *
  * Authors: Lasse Collin <lasse.collin@tukaani.org>
- *          Igor Pavlov <http://7-zip.org/>
+ *          Igor Pavlov <https://7-zip.org/>
  *
  * This file has been put into the public domain.
  * You can do whatever you want with this file.
--- a/lib/xz/xz_dec_lzma2.c~lib-replace-http-links-with-https-ones
+++ a/lib/xz/xz_dec_lzma2.c
@@ -2,7 +2,7 @@
  * LZMA2 decoder
  *
  * Authors: Lasse Collin <lasse.collin@tukaani.org>
- *          Igor Pavlov <http://7-zip.org/>
+ *          Igor Pavlov <https://7-zip.org/>
  *
  * This file has been put into the public domain.
  * You can do whatever you want with this file.
--- a/lib/xz/xz_lzma2.h~lib-replace-http-links-with-https-ones
+++ a/lib/xz/xz_lzma2.h
@@ -2,7 +2,7 @@
  * LZMA2 definitions
  *
  * Authors: Lasse Collin <lasse.collin@tukaani.org>
- *          Igor Pavlov <http://7-zip.org/>
+ *          Igor Pavlov <https://7-zip.org/>
  *
  * This file has been put into the public domain.
  * You can do whatever you want with this file.
--- a/lib/xz/xz_stream.h~lib-replace-http-links-with-https-ones
+++ a/lib/xz/xz_stream.h
@@ -19,7 +19,7 @@
 
 /*
  * See the .xz file format specification at
- * http://tukaani.org/xz/xz-file-format.txt
+ * https://tukaani.org/xz/xz-file-format.txt
  * to understand the container format.
  */
 
_

Patches currently in -mm which might be from grandmaster@al2klimov.de are

tools-replace-http-links-with-https-ones.patch
ocfs2-replace-http-links-with-https-ones.patch
mm-thp-replace-http-links-with-https-ones.patch
lib-replace-http-links-with-https-ones.patch
vfat-fat-msdos-filesystem-replace-http-links-with-https-ones.patch

