From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 27/54] powerpc: unexport flush_icache_user_range
Date: Sun, 07 Jun 2020 21:41:32 -0700
Message-ID: <20200608044132.ijl3o88ep%akpm@linux-foundation.org>
References: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726929AbgFHEle (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 00:41:34 -0400
In-Reply-To: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, hch@lst.de, linux-mm@kvack.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, paulus@samba.org, torvalds@linux-foundation.org

From: Christoph Hellwig <hch@lst.de>
Subject: powerpc: unexport flush_icache_user_range

flush_icache_user_range is only used by copy_to_user_page, which is
only used by core VM code.

Link: http://lkml.kernel.org/r/20200515143646.3857579-4-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/mem.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/powerpc/mm/mem.c~powerpc-unexport-flush_icache_user_range
+++ a/arch/powerpc/mm/mem.c
@@ -586,7 +586,6 @@ void flush_icache_user_range(struct vm_a
 	flush_icache_range(maddr, maddr + len);
 	kunmap(page);
 }
-EXPORT_SYMBOL(flush_icache_user_range);
 
 /*
  * System memory should not be in /proc/iomem but various tools expect it
_
