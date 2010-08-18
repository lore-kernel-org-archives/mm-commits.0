From: akpm@linux-foundation.org
Subject: + kfifo-fix-a-memory-leak-in-dma-example.patch added to -mm tree
Date: Wed, 18 Aug 2010 11:54:15 -0700
Message-ID: <201008181854.o7IIsF7Y006098@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40567 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753732Ab0HRSzF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Aug 2010 14:55:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arighi@develer.com, stefani@seibold.net


The patch titled
     kfifo: fix a memory leak in dma example
has been added to the -mm tree.  Its filename is
     kfifo-fix-a-memory-leak-in-dma-example.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kfifo: fix a memory leak in dma example
From: Andrea Righi <arighi@develer.com>

We use a dynamically allocated kfifo in the dma example, so we need to
free it when unloading the module.

Signed-off-by: Andrea Righi <arighi@develer.com>
Acked-by: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/kfifo/dma-example.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN samples/kfifo/dma-example.c~kfifo-fix-a-memory-leak-in-dma-example samples/kfifo/dma-example.c
--- a/samples/kfifo/dma-example.c~kfifo-fix-a-memory-leak-in-dma-example
+++ a/samples/kfifo/dma-example.c
@@ -105,9 +105,7 @@ static int __init example_init(void)
 
 static void __exit example_exit(void)
 {
-#ifdef DYNAMIC
-	kfifo_free(&test);
-#endif
+	kfifo_free(&fifo);
 }
 
 module_init(example_init);
_

Patches currently in -mm which might be from arighi@develer.com are

kfifo-implement-missing-__kfifo_skip_r.patch
kfifo-add-kfifo_skip-testcase.patch
kfifo-add-explicit-error-checking-in-byte-stream-example.patch
kfifo-fix-kernel-bug-in-dma-example.patch
kfifo-fix-a-memory-leak-in-dma-example.patch
kfifo-add-explicit-error-checking-in-all-the-examples.patch

