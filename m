From: akpm@linux-foundation.org
Subject: + dma-fix-order-calculation-in-dma_mark_declared_memory_occupied.patch added to -mm tree
Date: Thu, 31 Jul 2008 14:32:27 -0700
Message-ID: <200807312132.m6VLWRcX013294@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40035 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753861AbYGaVco (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Jul 2008 17:32:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbeulich@novell.com, James.Bottomley@HansenPartnership.com, dbaryshkov@gmail.com, jbarnes@virtuousgeek.org, mingo@elte.hu


The patch titled
     dma: fix order calculation in dma_mark_declared_memory_occupied()
has been added to the -mm tree.  Its filename is
     dma-fix-order-calculation-in-dma_mark_declared_memory_occupied.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dma: fix order calculation in dma_mark_declared_memory_occupied()
From: "Jan Beulich" <jbeulich@novell.com>

get_order() takes byte-sized input, not a page-granular one.

Irrespective of this fix I'm inclined to believe that this doesn't work
right anyway - bitmap_allocate_region() has an implicit assumption of
'pos' being suitable for 'order', which this function doesn't seem to
enforce (and since it's being called with a byte-granular value there's no
reason to believe that the callers would make sure device_addr is passed
accordingly - it's also not documented that way).

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/dma-coherent.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN kernel/dma-coherent.c~dma-fix-order-calculation-in-dma_mark_declared_memory_occupied kernel/dma-coherent.c
--- a/kernel/dma-coherent.c~dma-fix-order-calculation-in-dma_mark_declared_memory_occupied
+++ a/kernel/dma-coherent.c
@@ -77,15 +77,14 @@ void *dma_mark_declared_memory_occupied(
 {
 	struct dma_coherent_mem *mem = dev->dma_mem;
 	int pos, err;
-	int pages = (size + (device_addr & ~PAGE_MASK) + PAGE_SIZE - 1);
 
-	pages >>= PAGE_SHIFT;
+	size += device_addr & ~PAGE_MASK;
 
 	if (!mem)
 		return ERR_PTR(-EINVAL);
 
 	pos = (device_addr - mem->device_base) >> PAGE_SHIFT;
-	err = bitmap_allocate_region(mem->bitmap, pos, get_order(pages));
+	err = bitmap_allocate_region(mem->bitmap, pos, get_order(size));
 	if (err != 0)
 		return ERR_PTR(err);
 	return mem->virt_base + (pos << PAGE_SHIFT);
_

Patches currently in -mm which might be from jbeulich@novell.com are

origin.patch
dma-fix-order-calculation-in-dma_mark_declared_memory_occupied.patch

