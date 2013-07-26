From: akpm@linux-foundation.org
Subject: + mm-fix-potential-null-pointer-dereference.patch added to -mm
 tree
Date: Fri, 26 Jul 2013 14:39:41 -0700
Message-ID: <51f2ec9d.gNNbbc2q4S8LVGtn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51766 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760697Ab3GZVjo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 26 Jul 2013 17:39:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, mhocko@suse.cz, liwanp@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, huawei.libin@huawei.com

Subject: + mm-fix-potential-null-pointer-dereference.patch added to -mm tree
To: huawei.libin@huawei.com,kirill.shutemov@linux.intel.com,liwanp@linux.vnet.ibm.com,mhocko@suse.cz,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 26 Jul 2013 14:39:41 -0700


The patch titled
     Subject: mm/huge_memory.c: fix potential NULL pointer dereference
has been added to the -mm tree.  Its filename is
     mm-fix-potential-null-pointer-dereference.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-potential-null-pointer-dereference.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-potential-null-pointer-dereference.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Libin <huawei.libin@huawei.com>
Subject: mm/huge_memory.c: fix potential NULL pointer dereference

In collapse_huge_page() there is a race window between releasing the
mmap_sem read lock and taking the mmap_sem write lock, so find_vma() may
return NULL.  So check the return value to avoid NULL pointer dereference.

collapse_huge_page
	khugepaged_alloc_page
		up_read(&mm->mmap_sem)
	down_write(&mm->mmap_sem)
	vma = find_vma(mm, address)

Signed-off-by: Libin <huawei.libin@huawei.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: <stable@vger.kernel.org> # v3.0+
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/huge_memory.c~mm-fix-potential-null-pointer-dereference mm/huge_memory.c
--- a/mm/huge_memory.c~mm-fix-potential-null-pointer-dereference
+++ a/mm/huge_memory.c
@@ -2274,6 +2274,8 @@ static void collapse_huge_page(struct mm
 		goto out;
 
 	vma = find_vma(mm, address);
+	if (!vma)
+		goto out;
 	hstart = (vma->vm_start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
 	hend = vma->vm_end & HPAGE_PMD_MASK;
 	if (address < hstart || address + HPAGE_PMD_SIZE > hend)
_

Patches currently in -mm which might be from huawei.libin@huawei.com are

mm-fix-potential-null-pointer-dereference.patch

