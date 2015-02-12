From: akpm@linux-foundation.org
Subject: [merged] mm-add-vm_bug_on_page-for-page_mapcount.patch removed
 from -mm tree
Date: Thu, 12 Feb 2015 11:35:55 -0800
Message-ID: <54dd009b.bJNNBQwuCuv3SVLQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57947 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbbBLTf4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:35:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Yalin.Wang@sonymobile.com, kirill.shutemov@linux.intel.com, yalin.wang@sonymobile.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add VM_BUG_ON_PAGE() to page_mapcount()
has been removed from the -mm tree.  Its filename was
     mm-add-vm_bug_on_page-for-page_mapcount.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Subject: mm: add VM_BUG_ON_PAGE() to page_mapcount()

Add VM_BUG_ON_PAGE() for slab pages.  _mapcount is an union with slab
struct in struct page, so we must avoid accessing _mapcount if this page
is a slab page.  Also remove the unneeded bracket.

Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/mm.h~mm-add-vm_bug_on_page-for-page_mapcount include/linux/mm.h
--- a/include/linux/mm.h~mm-add-vm_bug_on_page-for-page_mapcount
+++ a/include/linux/mm.h
@@ -484,7 +484,8 @@ static inline void page_mapcount_reset(s
 
 static inline int page_mapcount(struct page *page)
 {
-	return atomic_read(&(page)->_mapcount) + 1;
+	VM_BUG_ON_PAGE(PageSlab(page), page);
+	return atomic_read(&page->_mapcount) + 1;
 }
 
 static inline int page_count(struct page *page)
_

Patches currently in -mm which might be from Yalin.Wang@sonymobile.com are

origin.patch
linux-next.patch

