From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 04/25] lib/lz4/lz4_decompress.c: document
 deliberate use of `&'
Date: Wed, 10 Jun 2020 18:41:32 -0700
Message-ID: <20200611014132.ApEMh2E59%akpm@linux-foundation.org>
References: <20200610184053.3fa7368ab80e23bfd44de71f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726163AbgFKBld (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Jun 2020 21:41:33 -0400
In-Reply-To: <20200610184053.3fa7368ab80e23bfd44de71f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cyan@fb.com, hsiangkao@aol.com, joe@perches.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, vvs@virtuozzo.com

From: Joe Perches <joe@perches.com>
Subject: lib/lz4/lz4_decompress.c: document deliberate use of `&'

This operation was intentional, but tools such as smatch will warn that it
might not have been.

Link: http://lkml.kernel.org/r/3bf931c6ea0cae3e23f3485801986859851b4f04.camel@perches.com
Cc: Yann Collet <cyan@fb.com>
Cc: Vasily Averin <vvs@virtuozzo.com>
Cc: Gao Xiang <hsiangkao@aol.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/lz4/lz4_decompress.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/lib/lz4/lz4_decompress.c~lib-lz4-lz4_decompressc-document-deliberate-use-of
+++ a/lib/lz4/lz4_decompress.c
@@ -141,6 +141,9 @@ static FORCE_INLINE int LZ4_decompress_g
 		 * space in the output for those 18 bytes earlier, upon
 		 * entering the shortcut (in other words, there is a
 		 * combined check for both stages).
+		 *
+		 * The & in the likely() below is intentionally not && so that
+		 * some compilers can produce better parallelized runtime code
 		 */
 		if ((endOnInput ? length != RUN_MASK : length <= 8)
 		   /*
_
