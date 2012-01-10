From: akpm@linux-foundation.org
Subject: [folded] mm-simplify-find_vma_prev-fix-2.patch removed from -mm tree
Date: Tue, 10 Jan 2012 14:46:03 -0800
Message-ID: <20120110224603.D454E1002D0@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:52777 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab2AJWqE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2012 17:46:04 -0500
Received: by ggnk3 with SMTP id k3so14874ggn.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2012 14:46:04 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: simplify find_vma_prev
has been removed from the -mm tree.  Its filename was
     mm-simplify-find_vma_prev-fix-2.patch

This patch was dropped because it was folded into mm-simplify-find_vma_prev.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: mm: simplify find_vma_prev

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN mm/mmap.c~mm-simplify-find_vma_prev-fix-2 mm/mmap.c
--- a/mm/mmap.c~mm-simplify-find_vma_prev-fix-2
+++ a/mm/mmap.c
@@ -1628,18 +1628,16 @@ EXPORT_SYMBOL(find_vma);
 
 /*
  * Same as find_vma, but also return a pointer to the previous VMA in *pprev.
- * Note: *pprev is set to NULL when the return value is NULL.
+ * Note: pprev is set to NULL when return value is NULL.
  */
 struct vm_area_struct *
-find_vma_prev(struct mm_struct *mm, unsigned long addr, struct vm_area_struct **pprev)
+find_vma_prev(struct mm_struct *mm, unsigned long addr,
+			struct vm_area_struct **pprev)
 {
 	struct vm_area_struct *vma;
 
-	*pprev = NULL;
 	vma = find_vma(mm, addr);
-	if (vma)
-		*pprev = vma->vm_prev;
