From: akpm@linux-foundation.org
Subject: + lib-decompress_unlzma-do-a-null-check-for-pointer.patch added
 to -mm tree
Date: Fri, 14 Aug 2015 13:53:43 -0700
Message-ID: <55ce5557.WrOvN8qdAKoaQZTu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54106 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbbHNUxn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Aug 2015 16:53:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabio.estevam@freescale.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/decompress_unlzma: Do a NULL check for pointer
has been added to the -mm tree.  Its filename is
     lib-decompress_unlzma-do-a-null-check-for-pointer.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-decompress_unlzma-do-a-null-check-for-pointer.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-decompress_unlzma-do-a-null-check-for-pointer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

origin.patch
lib-decompress_unlzma-do-a-null-check-for-pointer.patch
linux-next.patch

