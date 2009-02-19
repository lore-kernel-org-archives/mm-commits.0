From: akpm@linux-foundation.org
Subject: + vmalloc-call-flush_cache_vunmap-from-unmap_kernel_range.patch added to -mm tree
Date: Thu, 19 Feb 2009 15:02:50 -0800
Message-ID: <200902192302.n1JN2o7I029143@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43562 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751838AbZBSXDt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 18:03:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, npiggin@suse.de, stable@kernel.org


The patch titled
     vmalloc: call flush_cache_vunmap() from unmap_kernel_range()
has been added to the -mm tree.  Its filename is
     vmalloc-call-flush_cache_vunmap-from-unmap_kernel_range.patch

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
Subject: vmalloc: call flush_cache_vunmap() from unmap_kernel_range()
From: Tejun Heo <tj@kernel.org>

Impact: proper vcache flush on unmap_kernel_range()

flush_cache_vunmap() should be called before pages are unmapped.  Add
a call to it in unmap_kernel_range().

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Nick Piggin <npiggin@suse.de>
Cc: <stable@kernel.org>		[2.6.28.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/vmalloc.c~vmalloc-call-flush_cache_vunmap-from-unmap_kernel_range mm/vmalloc.c
--- a/mm/vmalloc.c~vmalloc-call-flush_cache_vunmap-from-unmap_kernel_range
+++ a/mm/vmalloc.c
@@ -1013,6 +1013,8 @@ void __init vmalloc_init(void)
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

origin.patch
vmalloc-call-flush_cache_vunmap-from-unmap_kernel_range.patch
linux-next.patch
sysfs-reference-sysfs_dirent-from-sysfs-inodes.patch

