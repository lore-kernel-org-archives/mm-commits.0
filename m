From: akpm@linux-foundation.org
Subject: [merged] thp-add-debug-checks-for-mapcount-related-invariants.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:48:37 -0800
Message-ID: <201101142251.p0EMpRxK005509@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43789 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753058Ab1ANWvf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:51:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: add debug checks for mapcount related invariants
has been removed from the -mm tree.  Its filename was
     thp-add-debug-checks-for-mapcount-related-invariants.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: add debug checks for mapcount related invariants
From: Andrea Arcangeli <aarcange@redhat.com>

Add debug checks for invariants that if broken could lead to mapcount vs
page_mapcount debug checks to trigger later in split_huge_page.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/memory.c~thp-add-debug-checks-for-mapcount-related-invariants mm/memory.c
--- a/mm/memory.c~thp-add-debug-checks-for-mapcount-related-invariants
+++ a/mm/memory.c
@@ -804,6 +804,7 @@ static inline int copy_pmd_range(struct 
 		next = pmd_addr_end(addr, end);
 		if (pmd_trans_huge(*src_pmd)) {
 			int err;
+			VM_BUG_ON(next-addr != HPAGE_PMD_SIZE);
 			err = copy_huge_pmd(dst_mm, src_mm,
 					    dst_pmd, src_pmd, addr, vma);
 			if (err == -ENOMEM)
@@ -1015,9 +1016,10 @@ static inline unsigned long zap_pmd_rang
 	do {
 		next = pmd_addr_end(addr, end);
 		if (pmd_trans_huge(*pmd)) {
-			if (next-addr != HPAGE_PMD_SIZE)
+			if (next-addr != HPAGE_PMD_SIZE) {
+				VM_BUG_ON(!rwsem_is_locked(&tlb->mm->mmap_sem));
 				split_huge_page_pmd(vma->vm_mm, pmd);
-			else if (zap_huge_pmd(tlb, vma, pmd)) {
+			} else if (zap_huge_pmd(tlb, vma, pmd)) {
 				(*zap_work)--;
 				continue;
 			}
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
thp-add-pagetranscompound.patch

