From: akpm@linux-foundation.org
Subject: [merged]
 vmscan-split-file-huge-pages-before-paging-them-out.patch removed from -mm
 tree
Date: Wed, 27 Jul 2016 12:02:40 -0700
Message-ID: <57990550.jyMEKWfk85k7dbUl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40711 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757955AbcG0TCl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 15:02:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vmscan: split file huge pages before paging them out
has been removed from the -mm tree.  Its filename was
     vmscan-split-file-huge-pages-before-paging-them-out.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: vmscan: split file huge pages before paging them out

This is preparation of vmscan for file huge pages. We cannot write out
huge pages, so we need to split them on the way out.

Link: http://lkml.kernel.org/r/1466021202-61880-22-git-send-email-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN mm/vmscan.c~vmscan-split-file-huge-pages-before-paging-them-out mm/vmscan.c
--- a/mm/vmscan.c~vmscan-split-file-huge-pages-before-paging-them-out
+++ a/mm/vmscan.c
@@ -1055,8 +1055,14 @@ static unsigned long shrink_page_list(st
 
 			/* Adding to swap updated mapping */
 			mapping = page_mapping(page);
+		} else if (unlikely(PageTransHuge(page))) {
+			/* Split file THP */
+			if (split_huge_page_to_list(page, page_list))
+				goto keep_locked;
 		}
 
+		VM_BUG_ON_PAGE(PageTransHuge(page), page);
+
 		/*
 		 * The page is mapped into the page tables of one or more
 		 * processes. Try to unmap it here.
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are


