From: akpm@linux-foundation.org
Subject: + mm-make-copy_pte_range-static-again.patch added to -mm tree
Date: Wed, 02 Jul 2014 12:50:12 -0700
Message-ID: <53b46274.Y3TipY1b1sMw94te%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f202.google.com ([209.85.223.202]:56349 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394AbaGBTuN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2014 15:50:13 -0400
Received: by mail-ie0-f202.google.com with SMTP id tr6so2689521ieb.3
        for <mm-commits@vger.kernel.org>; Wed, 02 Jul 2014 12:50:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jmarchan@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make copy_pte_range static again
has been added to the -mm tree.  Its filename is
     mm-make-copy_pte_range-static-again.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-make-copy_pte_range-static-again.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-make-copy_pte_range-static-again.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Jerome Marchand" <jmarchan@redhat.com>
Subject: mm: make copy_pte_range static again

Commit 71e3aac0724f ("thp: transparent hugepage core") adds copy_pte_range
prototype to huge_mm.h.  I'm not sure why (or if) this function have been
used outside of memory.c, but it currently isn't.  This patch makes
copy_pte_range() static again.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    4 ----
 mm/memory.c             |    2 +-
 2 files changed, 1 insertion(+), 5 deletions(-)

diff -puN include/linux/huge_mm.h~mm-make-copy_pte_range-static-again include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~mm-make-copy_pte_range-static-again
+++ a/include/linux/huge_mm.h
@@ -93,10 +93,6 @@ extern bool is_vma_temporary_stack(struc
 #endif /* CONFIG_DEBUG_VM */
 
 extern unsigned long transparent_hugepage_flags;
-extern int copy_pte_range(struct mm_struct *dst_mm, struct mm_struct *src_mm,
-			  pmd_t *dst_pmd, pmd_t *src_pmd,
-			  struct vm_area_struct *vma,
-			  unsigned long addr, unsigned long end);
 extern int split_huge_page_to_list(struct page *page, struct list_head *list);
 static inline int split_huge_page(struct page *page)
 {
diff -puN mm/memory.c~mm-make-copy_pte_range-static-again mm/memory.c
--- a/mm/memory.c~mm-make-copy_pte_range-static-again
+++ a/mm/memory.c
@@ -884,7 +884,7 @@ out_set_pte:
 	return 0;
 }
 
-int copy_pte_range(struct mm_struct *dst_mm, struct mm_struct *src_mm,
+static int copy_pte_range(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		   pmd_t *dst_pmd, pmd_t *src_pmd, struct vm_area_struct *vma,
 		   unsigned long addr, unsigned long end)
 {
_

Patches currently in -mm which might be from jmarchan@redhat.com are

zram-revalidate-disk-after-capacity-change.patch
mm-make-copy_pte_range-static-again.patch
zram-use-size_t-instead-of-u16.patch
zram-remove-global-tb_lock-with-fine-grain-lock.patch

