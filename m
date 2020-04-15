From: akpm@linux-foundation.org
Subject: + mm-use-false-for-bool-variable.patch added to -mm tree
Date: Wed, 15 Apr 2020 16:03:23 -0700
Message-ID: <20200415230323.1vX2Qguey%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387864AbgDOXDZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 15 Apr 2020 19:03:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hulkci@huawei.com, mm-commits@vger.kernel.org, zou_wei@huawei.com


The patch titled
     Subject: mm: use false for bool variable
has been added to the -mm tree.  Its filename is
     mm-use-false-for-bool-variable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-false-for-bool-variable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-false-for-bool-variable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -774,7 +774,7 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
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

mm-use-false-for-bool-variable.patch
