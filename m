From: akpm@linux-foundation.org
Subject: [withdrawn] thp-mm-locking-tail-page-is-a-bug-fix.patch removed
 from -mm tree
Date: Thu, 19 Sep 2013 14:39:18 -0700
Message-ID: <523b6f06.gRqMhoY58NJbthZX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57650 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab3ISVjT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Sep 2013 17:39:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kirill.shutemov@linux.intel.com

Subject: [withdrawn] thp-mm-locking-tail-page-is-a-bug-fix.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 19 Sep 2013 14:39:18 -0700


The patch titled
     Subject: thp-mm-locking-tail-page-is-a-bug-fix
has been removed from the -mm tree.  Its filename was
     thp-mm-locking-tail-page-is-a-bug-fix.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp-mm-locking-tail-page-is-a-bug-fix



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/pagemap.h~thp-mm-locking-tail-page-is-a-bug-fix include/linux/pagemap.h
--- a/include/linux/pagemap.h~thp-mm-locking-tail-page-is-a-bug-fix
+++ a/include/linux/pagemap.h
@@ -339,6 +339,7 @@ static inline void __clear_page_locked(s
 
 static inline int trylock_page(struct page *page)
 {
+	VM_BUG_ON(PageTail(page));
 	return (likely(!test_and_set_bit_lock(PG_locked, &page->flags)));
 }
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-huge_memoryc-fix-stale-comments-of-transparent_hugepage_flags.patch
thp-mm-locking-tail-page-is-a-bug.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

