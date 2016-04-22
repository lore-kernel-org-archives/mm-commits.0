From: akpm@linux-foundation.org
Subject: +
 mm-fix-incorrect-pfn-passed-to-untrack_pfn-in-remap_pfn_range.patch added
 to -mm tree
Date: Fri, 22 Apr 2016 11:39:35 -0700
Message-ID: <571a6fe7.ZGMeBgWv+cUjBhPq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52539 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbcDVSjg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2016 14:39:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xyjxie@linux.vnet.ibm.com, aarcange@redhat.com, dahi@linux.vnet.ibm.com, dan.j.williams@intel.com, dave.hansen@linux.intel.com, jmarchan@redhat.com, kirill.shutemov@linux.intel.com, luto@kernel.org, matthew.r.wilcox@intel.com, mhocko@suse.com, mingo@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix incorrect pfn passed to untrack_pfn() in remap_pfn_range()
has been added to the -mm tree.  Its filename is
     mm-fix-incorrect-pfn-passed-to-untrack_pfn-in-remap_pfn_range.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-incorrect-pfn-passed-to-untrack_pfn-in-remap_pfn_range.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-incorrect-pfn-passed-to-untrack_pfn-in-remap_pfn_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-fix-incorrect-pfn-passed-to-untrack_pfn-in-remap_pfn_range.patch

