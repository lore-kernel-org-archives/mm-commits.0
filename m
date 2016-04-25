From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-fix-incorrect-pfn-passed-to-untrack_pfn-in-remap_pfn_range.patch removed from -mm tree
Date: Mon, 25 Apr 2016 13:17:05 -0700
Message-ID: <571e7b41.Ao9oJjQ1tvp0aYCq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55765 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933495AbcDYURH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Apr 2016 16:17:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xyjxie@linux.vnet.ibm.com, aarcange@redhat.com, dahi@linux.vnet.ibm.com, dan.j.williams@intel.com, dave.hansen@linux.intel.com, jmarchan@redhat.com, kirill.shutemov@linux.intel.com, luto@kernel.org, matthew.r.wilcox@intel.com, mhocko@suse.com, mingo@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix incorrect pfn passed to untrack_pfn() in remap_pfn_range()
has been removed from the -mm tree.  Its filename was
     mm-fix-incorrect-pfn-passed-to-untrack_pfn-in-remap_pfn_range.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Yongji Xie <xyjxie@linux.vnet.ibm.com>
Subject: mm: fix incorrect pfn passed to untrack_pfn() in remap_pfn_range()

We use generic hooks in remap_pfn_range() to help archs to track pfnmap
regions.  The code is something like:

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

Here we can easily find the pfn is changed but not recovered before
untrack_pfn() is called.  That's incorrect.

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

 mm/memory.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/memory.c~mm-fix-incorrect-pfn-passed-to-untrack_pfn-in-remap_pfn_range mm/memory.c
--- a/mm/memory.c~mm-fix-incorrect-pfn-passed-to-untrack_pfn-in-remap_pfn_range
+++ a/mm/memory.c
@@ -1795,6 +1795,7 @@ int remap_pfn_range(struct vm_area_struc
 			break;
 	} while (pgd++, addr = next, addr != end);
 
+	pfn += (end - PAGE_ALIGN(size)) >> PAGE_SHIFT;
 	if (err)
 		untrack_pfn(vma, pfn, PAGE_ALIGN(size));
 
_

Patches currently in -mm which might be from xyjxie@linux.vnet.ibm.com are


