From: akpm@linux-foundation.org
Subject: [merged] shmem-fix-pageflags-after-swapping-dma32-object.patch
 removed from -mm tree
Date: Mon, 14 Nov 2016 12:02:35 -0800
Message-ID: <582a185b.tIPtzcZvbSuEBBra%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37874 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935195AbcKNUCg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2016 15:02:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, kirill.shutemov@linux.intel.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: fix pageflags after swapping DMA32 object
has been removed from the -mm tree.  Its filename was
     shmem-fix-pageflags-after-swapping-dma32-object.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: shmem: fix pageflags after swapping DMA32 object

If shmem_alloc_page() does not set PageLocked and PageSwapBacked, then
shmem_replace_page() needs to do so for itself.  Without this, it puts
newpage on the wrong lru, re-unlocks the unlocked newpage, and system
descends into "Bad page" reports and freeze; or if CONFIG_DEBUG_VM=y, it
hits an earlier VM_BUG_ON_PAGE(!PageLocked), depending on config.

But shmem_replace_page() is not a common path: it's only called when
swapin (or swapoff) finds the page was already read into an unsuitable
zone: usually all zones are suitable, but gem objects for a few drm
devices (gma500, omapdrm, crestline, broadwater) require zone DMA32 if
there's more than 4GB of ram.

Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
Link: http://lkml.kernel.org/r/alpine.LSU.2.11.1611062003510.11253@eggly.anvils
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: <stable@vger.kernel.org>	[4.8.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/shmem.c~shmem-fix-pageflags-after-swapping-dma32-object mm/shmem.c
--- a/mm/shmem.c~shmem-fix-pageflags-after-swapping-dma32-object
+++ a/mm/shmem.c
@@ -1483,6 +1483,8 @@ static int shmem_replace_page(struct pag
 	copy_highpage(newpage, oldpage);
 	flush_dcache_page(newpage);
 
+	__SetPageLocked(newpage);
+	__SetPageSwapBacked(newpage);
 	SetPageUptodate(newpage);
 	set_page_private(newpage, swap_index);
 	SetPageSwapCache(newpage);
_

Patches currently in -mm which might be from hughd@google.com are


