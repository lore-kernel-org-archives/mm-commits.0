From: akpm@linux-foundation.org
Subject: [merged]
 mm-fix-incorrect-pfn-passed-to-untrack_pfn-in-remap_pfn_range-v2.patch
 removed from -mm tree
Date: Mon, 23 May 2016 12:46:04 -0700
Message-ID: <57435dfc.UT9we1Ch513ZJ0af%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37055 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143AbcEWTqF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:46:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xyjxie@linux.vnet.ibm.com, aarcange@redhat.com, dahi@linux.vnet.ibm.com, dan.j.williams@intel.com, dave.hansen@linux.intel.com, jmarchan@redhat.com, kirill.shutemov@linux.intel.com, luto@kernel.org, matthew.r.wilcox@intel.com, mhocko@suse.com, mingo@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix incorrect pfn passed to untrack_pfn() in remap_pfn_range()
has been removed from the -mm tree.  Its filename was
     mm-fix-incorrect-pfn-passed-to-untrack_pfn-in-remap_pfn_range-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yongji Xie <xyjxie@linux.vnet.ibm.com>
Subject: mm: fix incorrect pfn passed to untrack_pfn() in remap_pfn_range()

We use generic hooks in remap_pfn_range() to help archs to
track pfnmap regions. The code is something like:

int remap_pfn_range()
{
	...
	track_pfn_remap(vma, &prot, pfn, addr, PAGE_ALIGN(size));
	...
	pfn -= addr >> PAGE_SHIFT;
	...
	untrack_pfn(vma, pfn, PAGE_ALIGN(size));
	...
}

Here we can easily find the pfn is changed but not recovered
before untrack_pfn() is called. That's incorrect.

There are no known runtime effects - this is from inspection.

Signed-off-by: Yongji Xie <xyjxie@linux.vnet.ibm.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: David Hildenbrand <dahi@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/memory.c~mm-fix-incorrect-pfn-passed-to-untrack_pfn-in-remap_pfn_range-v2 mm/memory.c
--- a/mm/memory.c~mm-fix-incorrect-pfn-passed-to-untrack_pfn-in-remap_pfn_range-v2
+++ a/mm/memory.c
@@ -1744,6 +1744,7 @@ int remap_pfn_range(struct vm_area_struc
 	unsigned long next;
 	unsigned long end = addr + PAGE_ALIGN(size);
 	struct mm_struct *mm = vma->vm_mm;
+	unsigned long remap_pfn = pfn;
 	int err;
 
 	/*
@@ -1770,7 +1771,7 @@ int remap_pfn_range(struct vm_area_struc
 		vma->vm_pgoff = pfn;
 	}
 
-	err = track_pfn_remap(vma, &prot, pfn, addr, PAGE_ALIGN(size));
+	err = track_pfn_remap(vma, &prot, remap_pfn, addr, PAGE_ALIGN(size));
 	if (err)
 		return -EINVAL;
 
@@ -1789,7 +1790,7 @@ int remap_pfn_range(struct vm_area_struc
 	} while (pgd++, addr = next, addr != end);
 
 	if (err)
-		untrack_pfn(vma, pfn, PAGE_ALIGN(size));
+		untrack_pfn(vma, remap_pfn, PAGE_ALIGN(size));
 
 	return err;
 }
_

Patches currently in -mm which might be from xyjxie@linux.vnet.ibm.com are


