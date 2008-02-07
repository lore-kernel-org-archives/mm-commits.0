From: akpm@linux-foundation.org
Subject: - avoid-divide-in-is_align.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:22:51 -0800
Message-ID: <200802070022.m170MWS3006428@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48180 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934937AbYBGAoR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: herbert@gondor.apana.org.au, mm-commits@vger.kernel.org


The patch titled
     Avoid divide in IS_ALIGN
has been removed from the -mm tree.  Its filename was
     avoid-divide-in-is_align.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Avoid divide in IS_ALIGN
From: Herbert Xu <herbert@gondor.apana.org.au>

I was happy to discover the brand new IS_ALIGN macro and quickly used it in
my code.  To my dismay I found that the generated code used division to
perform the test.

This patch fixes it by changing the % test to an &.  This avoids the
division.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/kernel.h~avoid-divide-in-is_align include/linux/kernel.h
--- a/include/linux/kernel.h~avoid-divide-in-is_align
+++ a/include/linux/kernel.h
@@ -35,7 +35,7 @@ extern const char linux_proc_banner[];
 #define ALIGN(x,a)		__ALIGN_MASK(x,(typeof(x))(a)-1)
 #define __ALIGN_MASK(x,mask)	(((x)+(mask))&~(mask))
 #define PTR_ALIGN(p, a)		((typeof(p))ALIGN((unsigned long)(p), (a)))
-#define IS_ALIGNED(x,a)		(((x) % ((typeof(x))(a))) == 0)
+#define IS_ALIGNED(x, a)		(((x) & ((typeof(x))(a) - 1)) == 0)
 
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
 
_

Patches currently in -mm which might be from herbert@gondor.apana.org.au are

origin.patch
