From: akpm@linux-foundation.org
Subject: [patch 106/126] truncate: handle file thp
Date: Tue, 26 Jul 2016 15:26:07 -0700
Message-ID: <5797e37f.JdNTq41Ed2rEUljR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57072 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758604AbcGZW0I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:26:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: truncate: handle file thp

For shmem/tmpfs we only need to tweak truncate_inode_page() and
invalidate_mapping_pages().

truncate_inode_pages_range() and invalidate_inode_pages2_range() are
adjusted to use page_to_pgoff().

Link: http://lkml.kernel.org/r/1466021202-61880-26-git-send-email-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/truncate.c |   28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff -puN mm/truncate.c~truncate-handle-file-thp mm/truncate.c
--- a/mm/truncate.c~truncate-handle-file-thp
+++ a/mm/truncate.c
@@ -155,10 +155,14 @@ invalidate_complete_page(struct address_
 
 int truncate_inode_page(struct address_space *mapping, struct page *page)
 {
+	loff_t holelen;
+	VM_BUG_ON_PAGE(PageTail(page), page);
+
+	holelen = PageTransHuge(page) ? HPAGE_PMD_SIZE : PAGE_SIZE;
 	if (page_mapped(page)) {
 		unmap_mapping_range(mapping,
 				   (loff_t)page->index << PAGE_SHIFT,
-				   PAGE_SIZE, 0);
+				   holelen, 0);
 	}
 	return truncate_complete_page(mapping, page);
 }
@@ -279,7 +283,7 @@ void truncate_inode_pages_range(struct a
 
 			if (!trylock_page(page))
 				continue;
-			WARN_ON(page->index != index);
+			WARN_ON(page_to_pgoff(page) != index);
 			if (PageWriteback(page)) {
 				unlock_page(page);
 				continue;
@@ -367,7 +371,7 @@ void truncate_inode_pages_range(struct a
 			}
 
 			lock_page(page);
-			WARN_ON(page->index != index);
+			WARN_ON(page_to_pgoff(page) != index);
 			wait_on_page_writeback(page);
 			truncate_inode_page(mapping, page);
 			unlock_page(page);
@@ -487,7 +491,21 @@ unsigned long invalidate_mapping_pages(s
 
 			if (!trylock_page(page))
 				continue;
-			WARN_ON(page->index != index);
+
+			WARN_ON(page_to_pgoff(page) != index);
+
+			/* Middle of THP: skip */
+			if (PageTransTail(page)) {
+				unlock_page(page);
+				continue;
+			} else if (PageTransHuge(page)) {
+				index += HPAGE_PMD_NR - 1;
+				i += HPAGE_PMD_NR - 1;
+				/* 'end' is in the middle of THP */
+				if (index ==  round_down(end, HPAGE_PMD_NR))
+					continue;
+			}
+
 			ret = invalidate_inode_page(page);
 			unlock_page(page);
 			/*
@@ -594,7 +612,7 @@ int invalidate_inode_pages2_range(struct
 			}
 
 			lock_page(page);
-			WARN_ON(page->index != index);
+			WARN_ON(page_to_pgoff(page) != index);
 			if (page->mapping != mapping) {
 				unlock_page(page);
 				continue;
_
