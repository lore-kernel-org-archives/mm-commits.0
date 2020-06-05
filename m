From: akpm@linux-foundation.org
Subject: [merged] mm-use-false-for-bool-variable.patch removed
 from -mm tree
Date: Fri, 05 Jun 2020 13:18:48 -0700
Message-ID: <20200605201848.YnonZEQmC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728140AbgFEUSt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:18:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hulkci@huawei.com, mm-commits@vger.kernel.org, zou_wei@huawei.com


The patch titled
     Subject: mm: use false for bool variable
has been removed from the -mm tree.  Its filename was
     mm-use-false-for-bool-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zou Wei <zou_wei@huawei.com>
Subject: mm: use false for bool variable

Fixes coccicheck warning:

mm/zbud.c:246:1-20: WARNING: Assignment of 0/1 to bool variable
mm/mremap.c:777:2-8: WARNING: Assignment of 0/1 to bool variable
mm/huge_memory.c:525:9-10: WARNING: return of 0/1 in function
'is_transparent_hugepage' with return type bool

Link: http://lkml.kernel.org/r/1586835930-47076-1-git-send-email-zou_wei@huawei.com
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 mm/mremap.c      |    2 +-
 mm/zbud.c        |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/mm/huge_memory.c~mm-use-false-for-bool-variable
+++ a/mm/huge_memory.c
@@ -522,7 +522,7 @@ void prep_transhuge_page(struct page *pa
 bool is_transparent_hugepage(struct page *page)
 {
 	if (!PageCompound(page))
-		return 0;
+		return false;
 
 	page = compound_head(page);
 	return is_huge_zero_page(page) ||
--- a/mm/mremap.c~mm-use-false-for-bool-variable
+++ a/mm/mremap.c
@@ -785,7 +785,7 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 out:
 	if (offset_in_page(ret)) {
 		vm_unacct_memory(charged);
-		locked = 0;
+		locked = false;
 	}
 	if (downgraded)
 		up_read(&current->mm->mmap_sem);
--- a/mm/zbud.c~mm-use-false-for-bool-variable
+++ a/mm/zbud.c
@@ -243,7 +243,7 @@ static struct zbud_header *init_zbud_pag
 	zhdr->last_chunks = 0;
 	INIT_LIST_HEAD(&zhdr->buddy);
 	INIT_LIST_HEAD(&zhdr->lru);
-	zhdr->under_reclaim = 0;
+	zhdr->under_reclaim = false;
 	return zhdr;
 }
 
_

Patches currently in -mm which might be from zou_wei@huawei.com are
