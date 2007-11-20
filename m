From: akpm@linux-foundation.org
Subject: + avoid-divide-in-is_align.patch added to -mm tree
Date: Tue, 20 Nov 2007 12:23:18 -0800
Message-ID: <200711202023.lAKKNISs021732@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42272 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761668AbXKTUXw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Nov 2007 15:23:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: herbert@gondor.apana.org.au


The patch titled
     Avoid divide in IS_ALIGN
has been added to the -mm tree.  Its filename is
     avoid-divide-in-is_align.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-net.patch
git-cryptodev.patch
avoid-divide-in-is_align.patch
