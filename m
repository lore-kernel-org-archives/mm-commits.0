From: akpm@linux-foundation.org
Subject: + mm-add-vm_bug_on_page-for-page_mapcount.patch added to -mm tree
Date: Fri, 19 Dec 2014 15:36:51 -0800
Message-ID: <5494b693.hJpxnSMAEmnp8N0m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44055 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbaLSXgw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Dec 2014 18:36:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Yalin.Wang@sonymobile.com, kirill.shutemov@linux.intel.com, yalin.wang@sonymobile.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add VM_BUG_ON_PAGE() to page_mapcount()
has been added to the -mm tree.  Its filename is
     mm-add-vm_bug_on_page-for-page_mapcount.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-vm_bug_on_page-for-page_mapcount.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-vm_bug_on_page-for-page_mapcount.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -467,7 +467,8 @@ static inline void page_mapcount_reset(s
 
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
mm-add-vm_bug_on_page-for-page_mapcount.patch

