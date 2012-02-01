From: akpm@linux-foundation.org
Subject: + hugetlb-try-to-search-again-if-it-is-really-needed.patch added to -mm tree
Date: Wed, 01 Feb 2012 14:45:46 -0800
Message-ID: <20120201224547.00897A03A7@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:58766 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757740Ab2BAWps (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Feb 2012 17:45:48 -0500
Received: by ghrr17 with SMTP id r17so190943ghr.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Feb 2012 14:45:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiaoguangrong@linux.vnet.ibm.com, aarcange@redhat.com, dhillf@gmail.com, hpa@zytor.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mingo@redhat.com, tglx@linutronix.de


The patch titled
     Subject: hugetlb: try to search again if it is really needed
has been added to the -mm tree.  Its filename is
     hugetlb-try-to-search-again-if-it-is-really-needed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: hugetlb: try to search again if it is really needed

Search again only if some holes may be skipped in the first pass.

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/hugetlbpage.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/x86/mm/hugetlbpage.c~hugetlb-try-to-search-again-if-it-is-really-needed arch/x86/mm/hugetlbpage.c
--- a/arch/x86/mm/hugetlbpage.c~hugetlb-try-to-search-again-if-it-is-really-needed
+++ a/arch/x86/mm/hugetlbpage.c
@@ -309,9 +309,8 @@ static unsigned long hugetlb_get_unmappe
 	struct hstate *h = hstate_file(file);
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
-	unsigned long base = mm->mmap_base, addr = addr0;
+	unsigned long base = mm->mmap_base, addr = addr0, start_addr;
 	unsigned long largest_hole = mm->cached_hole_size;
-	int first_time = 1;
 
 	/* don't allow allocations above current base */
 	if (mm->free_area_cache > base)
@@ -322,6 +321,8 @@ static unsigned long hugetlb_get_unmappe
 		mm->free_area_cache  = base;
 	}
 try_again:
+	start_addr = mm->free_area_cache;
+
 	/* make sure it can fit in the remaining address space */
 	if (mm->free_area_cache < len)
 		goto fail;
@@ -357,10 +358,9 @@ fail:
 	 * if hint left us with no space for the requested
 	 * mapping then try again:
 	 */
-	if (first_time) {
+	if (start_addr != base) {
 		mm->free_area_cache = base;
 		largest_hole = 0;
-		first_time = 0;
 		goto try_again;
 	}
 	/*
_
Subject: Subject: hugetlb: try to search again if it is really needed

Patches currently in -mm which might be from xiaoguangrong@linux.vnet.ibm.com are

hugetlbfs-fix-hugetlb_get_unmapped_area.patch
hugetlb-drop-prev_vma-in-hugetlb_get_unmapped_area_topdown.patch
hugetlb-try-to-search-again-if-it-is-really-needed.patch
hugetlb-try-to-search-again-if-it-is-really-needed-fix.patch
mm-do-not-reset-cached_hole_size-when-vma-is-unmapped.patch
mm-search-from-free_area_cache-for-the-bigger-size.patch

