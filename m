From: akpm@linux-foundation.org
Subject: [merged] lib-decompress_unlzma-do-a-null-check-for-pointer.patch
 removed from -mm tree
Date: Fri, 11 Sep 2015 11:13:38 -0700
Message-ID: <55f319d2.a5DOS6ADD2dWYxSl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54102 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761AbbIKSNi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:13:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabio.estevam@freescale.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/decompress_unlzma: Do a NULL check for pointer
has been removed from the -mm tree.  Its filename was
     lib-decompress_unlzma-do-a-null-check-for-pointer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabio Estevam <fabio.estevam@freescale.com>
Subject: lib/decompress_unlzma: Do a NULL check for pointer

Compare pointer-typed values to NULL rather than 0.

The semantic patch that makes this change is available
in scripts/coccinelle/null/badzero.cocci.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/decompress_unlzma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/decompress_unlzma.c~lib-decompress_unlzma-do-a-null-check-for-pointer lib/decompress_unlzma.c
--- a/lib/decompress_unlzma.c~lib-decompress_unlzma-do-a-null-check-for-pointer
+++ a/lib/decompress_unlzma.c
@@ -620,7 +620,7 @@ STATIC inline int INIT unlzma(unsigned c
 
 	num_probs = LZMA_BASE_SIZE + (LZMA_LIT_SIZE << (lc + lp));
 	p = (uint16_t *) large_malloc(num_probs * sizeof(*p));
-	if (p == 0)
+	if (p == NULL)
 		goto exit_2;
 	num_probs = LZMA_LITERAL + (LZMA_LIT_SIZE << (lc + lp));
 	for (i = 0; i < num_probs; i++)
_

Patches currently in -mm which might be from fabio.estevam@freescale.com are


