From: akpm@linux-foundation.org
Subject: [patch 02/11] thp: reduce indentation level in change_huge_pmd()
Date: Thu, 13 Apr 2017 14:56:17 -0700
Message-ID: <58eff401.72MFYM6BNXKQDe5z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53600 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751638AbdDMV4S (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Apr 2017 17:56:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, aarcange@redhat.com, hillf.zj@alibaba-inc.com, stable@vger.kernel.org, vbabka@suse.cz

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: reduce indentation level in change_huge_pmd()

Patch series "thp: fix few MADV_DONTNEED races"

For MADV_DONTNEED to work properly with huge pages, it's critical to not
clear pmd intermittently unless you hold down_write(mmap_sem).  Otherwise
MADV_DONTNEED can miss the THP which can lead to userspace breakage.

See example of such race in commit message of patch 2/4.

All these races are found by code inspection.  I haven't seen them
triggered.  I don't think it's worth to apply them to stable@.



This patch (of 4):

Restructure code in preparation for a fix.

Link: http://lkml.kernel.org/r/20170302151034.27829-2-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   56 ++++++++++++++++++++++-----------------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff -puN mm/huge_memory.c~thp-reduce-indentation-level-in-change_huge_pmd mm/huge_memory.c
--- a/mm/huge_memory.c~thp-reduce-indentation-level-in-change_huge_pmd
+++ a/mm/huge_memory.c
@@ -1724,37 +1724,37 @@ int change_huge_pmd(struct vm_area_struc
 {
 	struct mm_struct *mm = vma->vm_mm;
 	spinlock_t *ptl;
-	int ret = 0;
+	pmd_t entry;
+	bool preserve_write;
+	int ret;
 
 	ptl = __pmd_trans_huge_lock(pmd, vma);
-	if (ptl) {
-		pmd_t entry;
-		bool preserve_write = prot_numa && pmd_write(*pmd);
-		ret = 1;
-
-		/*
-		 * Avoid trapping faults against the zero page. The read-only
-		 * data is likely to be read-cached on the local CPU and
-		 * local/remote hits to the zero page are not interesting.
-		 */
-		if (prot_numa && is_huge_zero_pmd(*pmd)) {
-			spin_unlock(ptl);
-			return ret;
-		}
-
-		if (!prot_numa || !pmd_protnone(*pmd)) {
-			entry = pmdp_huge_get_and_clear_notify(mm, addr, pmd);
-			entry = pmd_modify(entry, newprot);
-			if (preserve_write)
-				entry = pmd_mk_savedwrite(entry);
-			ret = HPAGE_PMD_NR;
-			set_pmd_at(mm, addr, pmd, entry);
-			BUG_ON(vma_is_anonymous(vma) && !preserve_write &&
-					pmd_write(entry));
-		}
-		spin_unlock(ptl);
-	}
+	if (!ptl)
+		return 0;
 
+	preserve_write = prot_numa && pmd_write(*pmd);
+	ret = 1;
+
+	/*
+	 * Avoid trapping faults against the zero page. The read-only
+	 * data is likely to be read-cached on the local CPU and
+	 * local/remote hits to the zero page are not interesting.
+	 */
+	if (prot_numa && is_huge_zero_pmd(*pmd))
+		goto unlock;
+
+	if (prot_numa && pmd_protnone(*pmd))
+		goto unlock;
+
+	entry = pmdp_huge_get_and_clear_notify(mm, addr, pmd);
+	entry = pmd_modify(entry, newprot);
+	if (preserve_write)
+		entry = pmd_mk_savedwrite(entry);
+	ret = HPAGE_PMD_NR;
+	set_pmd_at(mm, addr, pmd, entry);
+	BUG_ON(vma_is_anonymous(vma) && !preserve_write && pmd_write(entry));
+unlock:
+	spin_unlock(ptl);
 	return ret;
 }
 
_
