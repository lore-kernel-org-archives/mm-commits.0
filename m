From: akpm@linux-foundation.org
Subject: [merged] vmalloc-call-flush_cache_vunmap-from-unmap_kernel_range.patch removed from -mm tree
Date: Mon, 23 Feb 2009 12:06:48 -0800
Message-ID: <200902232006.n1NK6mJv013429@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39720 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754498AbZBWUTF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Feb 2009 15:19:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, davem@davemloft.net, npiggin@suse.de, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     vmalloc: call flush_cache_vunmap() from unmap_kernel_range()
has been removed from the -mm tree.  Its filename was
     vmalloc-call-flush_cache_vunmap-from-unmap_kernel_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmalloc: call flush_cache_vunmap() from unmap_kernel_range()
From: Tejun Heo <tj@kernel.org>

Impact: proper vcache flush on unmap_kernel_range()

flush_cache_vunmap() should be called before pages are unmapped.  Add
a call to it in unmap_kernel_range().

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Nick Piggin <npiggin@suse.de>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: <stable@kernel.org>		[2.6.28.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/vmalloc.c~vmalloc-call-flush_cache_vunmap-from-unmap_kernel_range mm/vmalloc.c
--- a/mm/vmalloc.c~vmalloc-call-flush_cache_vunmap-from-unmap_kernel_range
+++ a/mm/vmalloc.c
@@ -1012,6 +1012,8 @@ void __init vmalloc_init(void)
 void unmap_kernel_range(unsigned long addr, unsigned long size)
 {
 	unsigned long end = addr + size;
+
+	flush_cache_vunmap(addr, end);
 	vunmap_page_range(addr, end);
 	flush_tlb_kernel_range(addr, end);
 }
_

Patches currently in -mm which might be from tj@kernel.org are

linux-next.patch

