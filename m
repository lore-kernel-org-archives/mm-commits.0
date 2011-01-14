From: akpm@linux-foundation.org
Subject: [merged] thp-pmd_trans_huge-migrate-bugcheck.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:47:30 -0800
Message-ID: <201101142250.p0EMoKBT005401@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54395 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752786Ab1ANWub (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:50:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: pmd_trans_huge migrate bugcheck
has been removed from the -mm tree.  Its filename was
     thp-pmd_trans_huge-migrate-bugcheck.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: pmd_trans_huge migrate bugcheck
From: Andrea Arcangeli <aarcange@redhat.com>

No pmd_trans_huge should ever materialize in migration ptes areas, because
we split the hugepage before migration ptes are instantiated.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 +
 mm/memory.c        |    5 +++++
 mm/migrate.c       |    7 ++++++-
 3 files changed, 12 insertions(+), 1 deletion(-)

diff -puN include/linux/mm.h~thp-pmd_trans_huge-migrate-bugcheck include/linux/mm.h
--- a/include/linux/mm.h~thp-pmd_trans_huge-migrate-bugcheck
+++ a/include/linux/mm.h
@@ -1490,6 +1490,7 @@ struct page *follow_page(struct vm_area_
 #define FOLL_DUMP	0x08	/* give error on hole if it would be zero */
 #define FOLL_FORCE	0x10	/* get_user_pages read/write w/o permission */
 #define FOLL_MLOCK	0x40	/* mark page as mlocked */
+#define FOLL_SPLIT	0x80	/* don't return transhuge pages, split them */
 
 typedef int (*pte_fn_t)(pte_t *pte, pgtable_t token, unsigned long addr,
 			void *data);
diff -puN mm/memory.c~thp-pmd_trans_huge-migrate-bugcheck mm/memory.c
--- a/mm/memory.c~thp-pmd_trans_huge-migrate-bugcheck
+++ a/mm/memory.c
@@ -1305,6 +1305,10 @@ struct page *follow_page(struct vm_area_
 		goto out;
 	}
 	if (pmd_trans_huge(*pmd)) {
+		if (flags & FOLL_SPLIT) {
+			split_huge_page_pmd(mm, pmd);
+			goto split_fallthrough;
+		}
 		spin_lock(&mm->page_table_lock);
 		if (likely(pmd_trans_huge(*pmd))) {
 			if (unlikely(pmd_trans_splitting(*pmd))) {
@@ -1320,6 +1324,7 @@ struct page *follow_page(struct vm_area_
 			spin_unlock(&mm->page_table_lock);
 		/* fall through */
 	}
+split_fallthrough:
 	if (unlikely(pmd_bad(*pmd)))
 		goto no_page_table;
 
diff -puN mm/migrate.c~thp-pmd_trans_huge-migrate-bugcheck mm/migrate.c
--- a/mm/migrate.c~thp-pmd_trans_huge-migrate-bugcheck
+++ a/mm/migrate.c
@@ -113,6 +113,8 @@ static int remove_migration_pte(struct p
 			goto out;
 
 		pmd = pmd_offset(pud, addr);
+		if (pmd_trans_huge(*pmd))
+			goto out;
 		if (!pmd_present(*pmd))
 			goto out;
 
@@ -632,6 +634,9 @@ static int unmap_and_move(new_page_t get
 		/* page was freed from under us. So we are done. */
 		goto move_newpage;
 	}
+	if (unlikely(PageTransHuge(page)))
+		if (unlikely(split_huge_page(page)))
+			goto move_newpage;
 
 	/* prepare cgroup just returns 0 or -ENOMEM */
 	rc = -EAGAIN;
@@ -1063,7 +1068,7 @@ static int do_move_page_to_node_array(st
 		if (!vma || pp->addr < vma->vm_start || !vma_migratable(vma))
 			goto set_status;
 
-		page = follow_page(vma, pp->addr, FOLL_GET);
+		page = follow_page(vma, pp->addr, FOLL_GET|FOLL_SPLIT);
 
 		err = PTR_ERR(page);
 		if (IS_ERR(page))
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
thp-add-pagetranscompound.patch

