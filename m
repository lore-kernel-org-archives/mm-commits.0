From: akpm@linux-foundation.org
Subject: [merged]
 mm-migrate-remove-vm_hugetlb-from-vma-flag-check-in-vma_migratable.patch
 removed from -mm tree
Date: Thu, 12 Sep 2013 12:44:21 -0700
Message-ID: <52321995.UeyawKIAwGtpRprN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58362 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab3ILToW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:44:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mhocko@suse.cz, mgorman@suse.de, liwanp@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, hughd@google.com, dhillf@gmail.com, aneesh.kumar@linux.vnet.ibm.com, ak@linux.intel.com, n-horiguchi@ah.jp.nec.com

Subject: [merged] mm-migrate-remove-vm_hugetlb-from-vma-flag-check-in-vma_migratable.patch removed from -mm tree
To: n-horiguchi@ah.jp.nec.com,ak@linux.intel.com,aneesh.kumar@linux.vnet.ibm.com,dhillf@gmail.com,hughd@google.com,kosaki.motohiro@jp.fujitsu.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,mhocko@suse.cz,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:44:21 -0700


The patch titled
     Subject: mm: migrate: remove VM_HUGETLB from vma flag check in vma_migratable()
has been removed from the -mm tree.  Its filename was
     mm-migrate-remove-vm_hugetlb-from-vma-flag-check-in-vma_migratable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: migrate: remove VM_HUGETLB from vma flag check in vma_migratable()

Enable hugepage migration from migrate_pages(2), move_pages(2), and
mbind(2).

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Hillf Danton <dhillf@gmail.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/mempolicy.h~mm-migrate-remove-vm_hugetlb-from-vma-flag-check-in-vma_migratable include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mm-migrate-remove-vm_hugetlb-from-vma-flag-check-in-vma_migratable
+++ a/include/linux/mempolicy.h
@@ -173,7 +173,7 @@ extern int mpol_to_str(char *buffer, int
 /* Check if a vma is migratable */
 static inline int vma_migratable(struct vm_area_struct *vma)
 {
-	if (vma->vm_flags & (VM_IO | VM_HUGETLB | VM_PFNMAP))
+	if (vma->vm_flags & (VM_IO | VM_PFNMAP))
 		return 0;
 	/*
 	 * Migration allocates pages in the highest zone. If we cannot
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch

