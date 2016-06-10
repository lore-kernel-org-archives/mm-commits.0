From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-fix-huge-page-reserve-accounting-for-private-mappings.patch
 removed from -mm tree
Date: Fri, 10 Jun 2016 12:12:08 -0700
Message-ID: <575b1108.mZlG7GCSAu014mE/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50072 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbcFJTMJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 Jun 2016 15:12:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, aneesh.kumar@linux.vnet.ibm.com, dave.hansen@linux.intel.com, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: fix huge page reserve accounting for private mappings
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-huge-page-reserve-accounting-for-private-mappings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: mm/hugetlb: fix huge page reserve accounting for private mappings

When creating a private mapping of a hugetlbfs file, it is possible to
unmap pages via ftruncate or fallocate hole punch.  If subsequent faults
repopulate these mappings, the reserve counts will go negative.  This is
because the code currently assumes all faults to private mappings will
consume reserves.  The problem can be recreated as follows:

- mmap(MAP_PRIVATE) a file in hugetlbfs filesystem
- write fault in pages in the mapping
- fallocate(FALLOC_FL_PUNCH_HOLE) some pages in the mapping
- write fault in pages in the hole

This will result in negative huge page reserve counts and negative subpool
usage counts for the hugetlbfs.  Note that this can also be recreated with
ftruncate, but fallocate is more straight forward.

This patch modifies the routines vma_needs_reserves and vma_has_reserves
to examine the reserve map associated with private mappings similar to
that for shared mappings.  However, the reserve map semantics for private
and shared mappings are very different.  This results in subtly different
code that is explained in the comments.

Link: http://lkml.kernel.org/r/1464720957-15698-1-git-send-email-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   42 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 40 insertions(+), 2 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-fix-huge-page-reserve-accounting-for-private-mappings mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-fix-huge-page-reserve-accounting-for-private-mappings
+++ a/mm/hugetlb.c
@@ -832,8 +832,27 @@ static bool vma_has_reserves(struct vm_a
 	 * Only the process that called mmap() has reserves for
 	 * private mappings.
 	 */
-	if (is_vma_resv_set(vma, HPAGE_RESV_OWNER))
-		return true;
+	if (is_vma_resv_set(vma, HPAGE_RESV_OWNER)) {
+		/*
+		 * Like the shared case above, a hole punch or truncate
+		 * could have been performed on the private mapping.
+		 * Examine the value of chg to determine if reserves
+		 * actually exist or were previously consumed.
+		 * Very Subtle - The value of chg comes from a previous
+		 * call to vma_needs_reserves().  The reserve map for
+		 * private mappings has different (opposite) semantics
+		 * than that of shared mappings.  vma_needs_reserves()
+		 * has already taken this difference in semantics into
+		 * account.  Therefore, the meaning of chg is the same
+		 * as in the shared case above.  Code could easily be
+		 * combined, but keeping it separate draws attention to
+		 * subtle differences.
+		 */
+		if (chg)
+			return false;
+		else
+			return true;
+	}
 
 	return false;
 }
@@ -1816,6 +1835,25 @@ static long __vma_reservation_common(str
 
 	if (vma->vm_flags & VM_MAYSHARE)
 		return ret;
+	else if (is_vma_resv_set(vma, HPAGE_RESV_OWNER) && ret >= 0) {
+		/*
+		 * In most cases, reserves always exist for private mappings.
+		 * However, a file associated with mapping could have been
+		 * hole punched or truncated after reserves were consumed.
+		 * As subsequent fault on such a range will not use reserves.
+		 * Subtle - The reserve map for private mappings has the
+		 * opposite meaning than that of shared mappings.  If NO
+		 * entry is in the reserve map, it means a reservation exists.
+		 * If an entry exists in the reserve map, it means the
+		 * reservation has already been consumed.  As a result, the
+		 * return value of this routine is the opposite of the
+		 * value returned from reserve map manipulation routines above.
+		 */
+		if (ret)
+			return 0;
+		else
+			return 1;
+	}
 	else
 		return ret < 0 ? ret : 0;
 }
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

selftests-vm-compaction_test-fix-write-to-restore-nr_hugepages.patch

