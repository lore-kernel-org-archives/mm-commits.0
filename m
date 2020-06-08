From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 52/54] nommu: use flush_icache_user_range in brk
 and mmap
Date: Sun, 07 Jun 2020 21:42:49 -0700
Message-ID: <20200608044249.uBaIItegb%akpm@linux-foundation.org>
References: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726929AbgFHEmu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 00:42:50 -0400
In-Reply-To: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, geert@linux-m68k.org, gerg@linux-m68k.org, hch@lst.de, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Christoph Hellwig <hch@lst.de>
Subject: nommu: use flush_icache_user_range in brk and mmap

These obviously operate on user addresses.

Link: http://lkml.kernel.org/r/20200515143646.3857579-29-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/nommu.c~nommu-use-flush_icache_user_range-in-brk-and-mmap
+++ a/mm/nommu.c
@@ -433,7 +433,7 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
 	/*
 	 * Ok, looks good - let it rip.
 	 */
-	flush_icache_range(mm->brk, brk);
+	flush_icache_user_range(mm->brk, brk);
 	return mm->brk = brk;
 }
 
@@ -1277,7 +1277,7 @@ share:
 	/* we flush the region from the icache only when the first executable
 	 * mapping of it is made  */
 	if (vma->vm_flags & VM_EXEC && !region->vm_icache_flushed) {
-		flush_icache_range(region->vm_start, region->vm_end);
+		flush_icache_user_range(region->vm_start, region->vm_end);
 		region->vm_icache_flushed = true;
 	}
 
_
