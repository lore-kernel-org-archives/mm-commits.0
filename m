From: akpm@linux-foundation.org
Subject: [patch 03/15] shmem: fix pageflags after swapping DMA32 object
Date: Thu, 10 Nov 2016 10:46:11 -0800
Message-ID: <5824c073.Y3O0H8L6kOdCIujV%akpm__15894.9133860462$1478803616$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49260 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755752AbcKJSqM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Nov 2016 13:46:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, hughd@google.com, kirill.shutemov@linux.intel.com, stable@vger.kernel.org

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
