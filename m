From: akpm@linux-foundation.org
Subject: + mm-refactor-do_wp_page-extract-the-reuse-case-fix.patch added
 to -mm tree
Date: Wed, 25 Feb 2015 13:47:41 -0800
Message-ID: <54ee42fd.mmhNIKydGvv+QVnR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36734 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932165AbbBYVrm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Feb 2015 16:47:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raindel@mellanox.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-refactor-do_wp_page-extract-the-reuse-case-fix
has been added to the -mm tree.  Its filename is
     mm-refactor-do_wp_page-extract-the-reuse-case-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-refactor-do_wp_page-extract-the-reuse-case-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-refactor-do_wp_page-extract-the-reuse-case-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-refactor-do_wp_page-extract-the-reuse-case-fix.patch
mm-refactor-do_wp_page-rewrite-the-unlock-flow.patch
mm-refactor-do_wp_page-extract-the-page-copy-flow.patch
mm-refactor-do_wp_page-handling-of-shared-vma-into-a-function.patch

