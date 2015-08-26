From: akpm@linux-foundation.org
Subject: + dma-mapping-consolidate-dma_allocfree_noncoherent-fix.patch
 added to -mm tree
Date: Wed, 26 Aug 2015 10:57:03 -0700
Message-ID: <55ddfdef.T7wKTbVOXt0HzNSS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58928 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756148AbbHZR5E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Aug 2015 13:57:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jcmvbkbc@gmail.com, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     Subject: dma-mapping-consolidate-dma_allocfree_noncoherent-fix
has been added to the -mm tree.  Its filename is
     dma-mapping-consolidate-dma_allocfree_noncoherent-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dma-mapping-consolidate-dma_allocfree_noncoherent-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dma-mapping-consolidate-dma_allocfree_noncoherent-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Max Filippov <jcmvbkbc@gmail.com>
Subject: dma-mapping-consolidate-dma_allocfree_noncoherent-fix

fix xtensa

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/include/asm/dma-mapping.h |    3 ---
 1 file changed, 3 deletions(-)

diff -puN arch/xtensa/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_noncoherent-fix arch/xtensa/include/asm/dma-mapping.h
--- a/arch/xtensa/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_noncoherent-fix
+++ a/arch/xtensa/include/asm/dma-mapping.h
@@ -32,9 +32,6 @@ static inline struct dma_map_ops *get_dm
 
 #include <asm-generic/dma-mapping-common.h>
 
-#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_attrs(d, s, h, f, NULL)
-#define dma_free_noncoherent(d, s, v, h) dma_free_attrs(d, s, v, h, NULL)
