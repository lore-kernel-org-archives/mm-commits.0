From: akpm@linux-foundation.org
Subject: [patch 102/126] vmscan: split file huge pages before paging them
 out
Date: Tue, 26 Jul 2016 15:25:56 -0700
Message-ID: <5797e374.VNTyceJ0bNIzq7AT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57059 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758604AbcGZWZ5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:25:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com

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
