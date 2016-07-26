From: akpm@linux-foundation.org
Subject: [patch 063/126] mm: thp: check pmd_trans_unstable() after
 split_huge_pmd()
Date: Tue, 26 Jul 2016 15:24:03 -0700
Message-ID: <5797e303.CEKgi7HEoecH9iTx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56814 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758305AbcGZWYF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:24:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, n-horiguchi@ah.jp.nec.com, hughd@google.com, kirill@shutemov.name, mgorman@techsingularity.net

From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: thp: check pmd_trans_unstable() after split_huge_pmd()

split_huge_pmd() doesn't guarantee that the pmd is normal pmd pointing to
pte entries, which can be checked with pmd_trans_unstable().  Some callers
make this assertion and some do it differently and some not, so let's do
it in a unified manner.

Link: http://lkml.kernel.org/r/1464741400-12143-1-git-send-email-n-horiguchi@ah.jp.nec.com
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c       |    2 ++
 mm/mempolicy.c |    2 ++
 mm/mprotect.c  |    2 +-
 mm/mremap.c    |    3 +--
 4 files changed, 6 insertions(+), 3 deletions(-)

diff -puN mm/gup.c~mm-thp-check-pmd_trans_unstable-after-split_huge_pmd mm/gup.c
--- a/mm/gup.c~mm-thp-check-pmd_trans_unstable-after-split_huge_pmd
+++ a/mm/gup.c
@@ -279,6 +279,8 @@ struct page *follow_page_mask(struct vm_
 			spin_unlock(ptl);
 			ret = 0;
 			split_huge_pmd(vma, pmd, address);
+			if (pmd_trans_unstable(pmd))
+				ret = -EBUSY;
 		} else {
 			get_page(page);
 			spin_unlock(ptl);
diff -puN mm/mempolicy.c~mm-thp-check-pmd_trans_unstable-after-split_huge_pmd mm/mempolicy.c
--- a/mm/mempolicy.c~mm-thp-check-pmd_trans_unstable-after-split_huge_pmd
+++ a/mm/mempolicy.c
@@ -512,6 +512,8 @@ static int queue_pages_pte_range(pmd_t *
 		}
 	}
 
+	if (pmd_trans_unstable(pmd))
+		return 0;
 retry:
 	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
 	for (; addr != end; pte++, addr += PAGE_SIZE) {
diff -puN mm/mprotect.c~mm-thp-check-pmd_trans_unstable-after-split_huge_pmd mm/mprotect.c
--- a/mm/mprotect.c~mm-thp-check-pmd_trans_unstable-after-split_huge_pmd
+++ a/mm/mprotect.c
@@ -163,7 +163,7 @@ static inline unsigned long change_pmd_r
 		if (pmd_trans_huge(*pmd) || pmd_devmap(*pmd)) {
 			if (next - addr != HPAGE_PMD_SIZE) {
 				split_huge_pmd(vma, pmd, addr);
-				if (pmd_none(*pmd))
+				if (pmd_trans_unstable(pmd))
 					continue;
 			} else {
 				int nr_ptes = change_huge_pmd(vma, pmd, addr,
diff -puN mm/mremap.c~mm-thp-check-pmd_trans_unstable-after-split_huge_pmd mm/mremap.c
--- a/mm/mremap.c~mm-thp-check-pmd_trans_unstable-after-split_huge_pmd
+++ a/mm/mremap.c
@@ -210,9 +210,8 @@ unsigned long move_page_tables(struct vm
 				}
 			}
 			split_huge_pmd(vma, old_pmd, old_addr);
-			if (pmd_none(*old_pmd))
+			if (pmd_trans_unstable(old_pmd))
 				continue;
-			VM_BUG_ON(pmd_trans_huge(*old_pmd));
 		}
 		if (pte_alloc(new_vma->vm_mm, new_pmd, new_addr))
 			break;
_
