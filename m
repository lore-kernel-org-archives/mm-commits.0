From: akpm@linux-foundation.org
Subject: + thp-reduce-indentation-level-in-change_huge_pmd.patch added to
 -mm tree
Date: Fri, 03 Mar 2017 14:30:00 -0800
Message-ID: <58b9ee68.RPI5RUwEqFbv0qMX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42100 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752121AbdCCWkz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2017 17:40:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: reduce indentation level in change_huge_pmd()
has been added to the -mm tree.  Its filename is
     thp-reduce-indentation-level-in-change_huge_pmd.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-reduce-indentation-level-in-change_huge_pmd.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-reduce-indentation-level-in-change_huge_pmd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   56 ++++++++++++++++++++++-----------------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff -puN mm/huge_memory.c~thp-reduce-indentation-level-in-change_huge_pmd mm/huge_memory.c
--- a/mm/huge_memory.c~thp-reduce-indentation-level-in-change_huge_pmd
+++ a/mm/huge_memory.c
@@ -1723,37 +1723,37 @@ int change_huge_pmd(struct vm_area_struc
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

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

rmap-fix-null-pointer-dereference-on-thp-munlocking.patch
thp-reduce-indentation-level-in-change_huge_pmd.patch
thp-fix-madv_dontneed-vs-numa-balancing-race.patch
thp-fix-madv_dontneed-vs-madv_free-race.patch
thp-fix-madv_dontneed-vs-clear-soft-dirty-race.patch

