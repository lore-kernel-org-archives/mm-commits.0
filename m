From: akpm@linux-foundation.org
Subject: + uml-fix-compile-error-in-dma_get_cache_alignment.patch added to -mm tree
Date: Wed, 18 Aug 2010 11:25:44 -0700
Message-ID: <201008181825.o7IIPjgs004830@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43438 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753226Ab0HRS0Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Aug 2010 14:26:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, fujita.tomonori@lab.ntt.co.jp, jdike@addtoit.com


The patch titled
     uml: fix compile error in dma_get_cache_alignment()
has been added to the -mm tree.  Its filename is
     uml-fix-compile-error-in-dma_get_cache_alignment.patch

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
Subject: uml: fix compile error in dma_get_cache_alignment()
From: Miklos Szeredi <mszeredi@suse.cz>

Fix uml compile error:

include/linux/dma-mapping.h:145: error: redefinition of 'dma_get_cache_alignment'
/store/git/linux-2.6/arch/um/include/asm/dma-mapping.h:99: note: previous definition of 'dma_get_cache_alignment' was here

Introduced by this commit:

commit 4565f0170dfc849b3629c27d769db800467baa62
Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date:   Tue Aug 10 18:03:22 2010 -0700

    dma-mapping: unify dma_get_cache_alignment implementations

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/asm/dma-mapping.h |    7 -------
 1 file changed, 7 deletions(-)

diff -puN arch/um/include/asm/dma-mapping.h~uml-fix-compile-error-in-dma_get_cache_alignment arch/um/include/asm/dma-mapping.h
--- a/arch/um/include/asm/dma-mapping.h~uml-fix-compile-error-in-dma_get_cache_alignment
+++ a/arch/um/include/asm/dma-mapping.h
@@ -95,13 +95,6 @@ dma_sync_sg_for_cpu(struct device *dev, 
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
 
-static inline int
-dma_get_cache_alignment(void)
-{
-	BUG();
-	return(0);
-}
