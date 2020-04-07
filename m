From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 078/166] mm/hugetlb: add missing annotation for
 gather_surplus_pages()
Date: Mon, 06 Apr 2020 20:08:09 -0700
Message-ID: <20200407030809.CnGK_9x0F%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbgDGDIK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:08:10 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jbi.octave@gmail.com, linux-mm@kvack.org, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Jules Irenge <jbi.octave@gmail.com>
Subject: mm/hugetlb: add missing annotation for gather_surplus_pages()

Sparse reports a warning at gather_surplus_pages()

warning: context imbalance in hugetlb_cow() - unexpected unlock

The root cause is the missing annotation at gather_surplus_pages()
Add the missing __must_hold(&hugetlb_lock)

Link: http://lkml.kernel.org/r/20200214204741.94112-7-jbi.octave@gmail.com
Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/hugetlb.c~mm-hugetlb-add-missing-annotation-for-gather_surplus_pages
+++ a/mm/hugetlb.c
@@ -2010,6 +2010,7 @@ struct page *alloc_huge_page_vma(struct
  * of size 'delta'.
  */
 static int gather_surplus_pages(struct hstate *h, int delta)
+	__must_hold(&hugetlb_lock)
 {
 	struct list_head surplus_list;
 	struct page *page, *tmp;
_
