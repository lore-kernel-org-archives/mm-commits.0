From: akpm@linux-foundation.org
Subject: + mm-hugetlb-remove-hugetlb_prefault.patch added to -mm tree
Date: Tue, 28 May 2013 16:02:07 -0700
Message-ID: <51a5376f.7+WqPUgrl8wg9huL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33736 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758199Ab3E1XCI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 19:02:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, liwanp@linux.vnet.ibm.com

Subject: + mm-hugetlb-remove-hugetlb_prefault.patch added to -mm tree
To: liwanp@linux.vnet.ibm.com,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,rientjes@google.com
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 16:02:07 -0700


The patch titled
     Subject: mm/hugetlb: remove hugetlb_prefault
has been added to the -mm tree.  Its filename is
     mm-hugetlb-remove-hugetlb_prefault.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/hugetlb: remove hugetlb_prefault

hugetlb_prefault() is not used any more, this patch removes it.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN include/linux/hugetlb.h~mm-hugetlb-remove-hugetlb_prefault include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlb-remove-hugetlb_prefault
+++ a/include/linux/hugetlb.h
@@ -55,7 +55,6 @@ void __unmap_hugepage_range_final(struct
 void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 				unsigned long start, unsigned long end,
 				struct page *ref_page);
-int hugetlb_prefault(struct address_space *, struct vm_area_struct *);
 void hugetlb_report_meminfo(struct seq_file *);
 int hugetlb_report_node_meminfo(int, char *);
 void hugetlb_show_meminfo(void);
@@ -110,7 +109,6 @@ static inline unsigned long hugetlb_tota
 #define follow_hugetlb_page(m,v,p,vs,a,b,i,w)	({ BUG(); 0; })
 #define follow_huge_addr(mm, addr, write)	ERR_PTR(-EINVAL)
 #define copy_hugetlb_page_range(src, dst, vma)	({ BUG(); 0; })
-#define hugetlb_prefault(mapping, vma)		({ BUG(); 0; })
 static inline void hugetlb_report_meminfo(struct seq_file *m)
 {
 }
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

mm-memory-hotplug-fix-lowmem-count-overflow-when-offline-pages.patch
mm-pageblock-remove-get-set_pageblock_flags.patch
mm-hugetlb-remove-hugetlb_prefault.patch
mm-hugetlb-use-already-exist-interface-huge_page_shift.patch

