From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-refactor-do_wp_page-extract-the-reuse-case-fix.patch removed from -mm
 tree
Date: Tue, 14 Apr 2015 15:16:05 -0700
Message-ID: <552d91a5.BsRi3wqY2R7Oa+d9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54309 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950AbbDNWQG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Apr 2015 18:16:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raindel@mellanox.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-refactor-do_wp_page-extract-the-reuse-case-fix
has been removed from the -mm tree.  Its filename was
     mm-refactor-do_wp_page-extract-the-reuse-case-fix.patch

This patch was dropped because it was folded into mm-refactor-do_wp_page-extract-the-reuse-case.patch

------------------------------------------------------
From: Shachar Raindel <raindel@mellanox.com>
Subject: mm-refactor-do_wp_page-extract-the-reuse-case-fix

inline wp_page_reuse for a small code-size saving

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/memory.c~mm-refactor-do_wp_page-extract-the-reuse-case-fix mm/memory.c
--- a/mm/memory.c~mm-refactor-do_wp_page-extract-the-reuse-case-fix
+++ a/mm/memory.c
@@ -1990,11 +1990,11 @@ static int do_page_mkwrite(struct vm_are
  * case, all we need to do here is to mark the page as writable and update
  * any related book-keeping.
  */
-static int wp_page_reuse(struct mm_struct *mm, struct vm_area_struct *vma,
-			 unsigned long address, pte_t *page_table,
-			 spinlock_t *ptl, pte_t orig_pte,
-			 struct page *page, int page_mkwrite,
-			 int dirty_shared)
+static inline int wp_page_reuse(struct mm_struct *mm,
+			struct vm_area_struct *vma, unsigned long address,
+			pte_t *page_table, spinlock_t *ptl, pte_t orig_pte,
+			struct page *page, int page_mkwrite,
+			int dirty_shared)
 	__releases(ptl)
 {
 	pte_t entry;
_

Patches currently in -mm which might be from raindel@mellanox.com are

mm-refactor-do_wp_page-extract-the-reuse-case.patch
mm-refactor-do_wp_page-rewrite-the-unlock-flow.patch
mm-refactor-do_wp_page-extract-the-page-copy-flow.patch
mm-refactor-do_wp_page-handling-of-shared-vma-into-a-function.patch

