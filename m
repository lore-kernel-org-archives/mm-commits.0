From: akpm@linux-foundation.org
Subject: [patch 085/126] mm, thp: fix locking inconsistency in
 collapse_huge_page
Date: Tue, 26 Jul 2016 15:25:09 -0700
Message-ID: <5797e345.74E/Ny0q9I6+RFRy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57005 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758601AbcGZWZL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:25:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, ebru.akagunduz@gmail.com, aarcange@redhat.com, kirill.shutemov@linux.intel.com, riel@redhat.com, sergey.senozhatsky.work@gmail.com, sfr@canb.auug.org.au, vbabka@suse.cz

From: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Subject: mm, thp: fix locking inconsistency in collapse_huge_page

After creating revalidate vma function, locking inconsistency occured
due to directing the code path to wrong label. This patch directs
to correct label and fix the inconsistency.

Related commit that caused inconsistency:
http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/?id=da4360877094368f6dfe75bbe804b0f0a5d575b0

Link: http://lkml.kernel.org/r/1464956884-4644-1-git-send-email-ebru.akagunduz@gmail.com
Link: http://lkml.kernel.org/r/1466021202-61880-4-git-send-email-kirill.shutemov@linux.intel.com
Signed-off-by: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff -puN mm/huge_memory.c~mm-thp-fix-locking-inconsistency-in-collapse_huge_page mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-fix-locking-inconsistency-in-collapse_huge_page
+++ a/mm/huge_memory.c
@@ -2483,13 +2483,18 @@ static void collapse_huge_page(struct mm
 
 	down_read(&mm->mmap_sem);
 	result = hugepage_vma_revalidate(mm, address);
-	if (result)
-		goto out;
+	if (result) {
+		mem_cgroup_cancel_charge(new_page, memcg, true);
+		up_read(&mm->mmap_sem);
+		goto out_nolock;
+	}
 
 	pmd = mm_find_pmd(mm, address);
 	if (!pmd) {
 		result = SCAN_PMD_NULL;
-		goto out;
+		mem_cgroup_cancel_charge(new_page, memcg, true);
+		up_read(&mm->mmap_sem);
+		goto out_nolock;
 	}
 
 	/*
@@ -2498,8 +2503,9 @@ static void collapse_huge_page(struct mm
 	 * Continuing to collapse causes inconsistency.
 	 */
 	if (!__collapse_huge_page_swapin(mm, vma, address, pmd)) {
+		mem_cgroup_cancel_charge(new_page, memcg, true);
 		up_read(&mm->mmap_sem);
-		goto out;
+		goto out_nolock;
 	}
 
 	up_read(&mm->mmap_sem);
_
