From: akpm@linux-foundation.org
Subject: [merged]
 mm-proc-pid-pagemap-inspect-_page_soft_dirty-only-on-present-pages.patch
 removed from -mm tree
Date: Thu, 17 Oct 2013 11:13:07 -0700
Message-ID: <526028b3.IaSEJJBg7wqWbyFS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44336 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758877Ab3JQSNI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Oct 2013 14:13:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xiaoguangrong@linux.vnet.ibm.com, xemul@parallels.com, stable@vger.kernel.org, sfr@canb.auug.org.au, peterz@infradead.org, n-horiguchi@ah.jp.nec.com, mtosatti@redhat.com, mpm@selenic.com, mel@csn.ul.ie, luto@amacapital.net, kosaki.motohiro@gmail.com, gorcunov@openvz.org, aneesh.kumar@linux.vnet.ibm.com, gorcunov@gmail.com

Subject: [merged] mm-proc-pid-pagemap-inspect-_page_soft_dirty-only-on-present-pages.patch removed from -mm tree
To: gorcunov@gmail.com,aneesh.kumar@linux.vnet.ibm.com,gorcunov@openvz.org,kosaki.motohiro@gmail.com,luto@amacapital.net,mel@csn.ul.ie,mpm@selenic.com,mtosatti@redhat.com,n-horiguchi@ah.jp.nec.com,peterz@infradead.org,sfr@canb.auug.org.au,stable@vger.kernel.org,xemul@parallels.com,xiaoguangrong@linux.vnet.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 17 Oct 2013 11:13:07 -0700


The patch titled
     Subject: mm: /proc/pid/pagemap: inspect _PAGE_SOFT_DIRTY only on present pages
has been removed from the -mm tree.  Its filename was
     mm-proc-pid-pagemap-inspect-_page_soft_dirty-only-on-present-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: mm: /proc/pid/pagemap: inspect _PAGE_SOFT_DIRTY only on present pages

If a page we are inspecting is in swap we may occasionally report it as
having soft dirty bit (even if it is clean).  The pte_soft_dirty helper
should be called on present pte only.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/proc/task_mmu.c~mm-proc-pid-pagemap-inspect-_page_soft_dirty-only-on-present-pages fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-proc-pid-pagemap-inspect-_page_soft_dirty-only-on-present-pages
+++ a/fs/proc/task_mmu.c
@@ -941,6 +941,8 @@ static void pte_to_pagemap_entry(pagemap
 		frame = pte_pfn(pte);
 		flags = PM_PRESENT;
 		page = vm_normal_page(vma, addr, pte);
+		if (pte_soft_dirty(pte))
+			flags2 |= __PM_SOFT_DIRTY;
 	} else if (is_swap_pte(pte)) {
 		swp_entry_t entry;
 		if (pte_swp_soft_dirty(pte))
@@ -960,7 +962,7 @@ static void pte_to_pagemap_entry(pagemap
 
 	if (page && !PageAnon(page))
 		flags |= PM_FILE;
-	if ((vma->vm_flags & VM_SOFTDIRTY) || pte_soft_dirty(pte))
+	if ((vma->vm_flags & VM_SOFTDIRTY))
 		flags2 |= __PM_SOFT_DIRTY;
 
 	*pme = make_pme(PM_PFRAME(frame) | PM_STATUS2(pm->v2, flags2) | flags);
_

Patches currently in -mm which might be from gorcunov@gmail.com are

origin.patch
arch-x86-mnify-pte_to_pgoff-and-pgoff_to_pte-helpers.patch

