From: akpm@linux-foundation.org
Subject: +
 mm-pgtable-dont-accumulate-addr-during-pgd-prepopulate-pmd.patch added to
 -mm tree
Date: Tue, 25 Jun 2013 15:23:51 -0700
Message-ID: <51ca1877.kDTDGrW7E/7TQ6gS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43478 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab3FYWXw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jun 2013 18:23:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, mhocko@suse.cz, liwanp@linux.vnet.ibm.com

Subject: + mm-pgtable-dont-accumulate-addr-during-pgd-prepopulate-pmd.patch added to -mm tree
To: liwanp@linux.vnet.ibm.com,mhocko@suse.cz,zhangyanfei@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Tue, 25 Jun 2013 15:23:51 -0700


The patch titled
     Subject: mm/pgtable: don't accumulate addr during pgd prepopulate pmd
has been added to the -mm tree.  Its filename is
     mm-pgtable-dont-accumulate-addr-during-pgd-prepopulate-pmd.patch

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
Subject: mm/pgtable: don't accumulate addr during pgd prepopulate pmd

The old codes accumulate addr to get right pmd, however, currently pmds
are preallocated and transfered as a parameter, there is unnecessary to
accumulate addr variable any more, this patch remove it.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pgtable.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN arch/x86/mm/pgtable.c~mm-pgtable-dont-accumulate-addr-during-pgd-prepopulate-pmd arch/x86/mm/pgtable.c
--- a/arch/x86/mm/pgtable.c~mm-pgtable-dont-accumulate-addr-during-pgd-prepopulate-pmd
+++ a/arch/x86/mm/pgtable.c
@@ -240,7 +240,6 @@ static void pgd_mop_up_pmds(struct mm_st
 static void pgd_prepopulate_pmd(struct mm_struct *mm, pgd_t *pgd, pmd_t *pmds[])
 {
 	pud_t *pud;
-	unsigned long addr;
 	int i;
 
 	if (PREALLOCATED_PMDS == 0) /* Work around gcc-3.4.x bug */
@@ -248,8 +247,7 @@ static void pgd_prepopulate_pmd(struct m
 
 	pud = pud_offset(pgd, 0);
 
- 	for (addr = i = 0; i < PREALLOCATED_PMDS;
-	     i++, pud++, addr += PUD_SIZE) {
+	for (i = 0; i < PREALLOCATED_PMDS; i++, pud++) {
 		pmd_t *pmd = pmds[i];
 
 		if (i >= KERNEL_PGD_BOUNDARY)
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

mm-memory-hotplug-fix-lowmem-count-overflow-when-offline-pages.patch
mm-memory-hotplug-fix-lowmem-count-overflow-when-offline-pages-fix.patch
mm-pageblock-remove-get-set_pageblock_flags.patch
mm-hugetlb-remove-hugetlb_prefault.patch
mm-hugetlb-use-already-exist-interface-huge_page_shift.patch
mm-writeback-remove-wb_reason_name.patch
mm-writeback-dont-check-force_wait-to-handle-bdi-work_list.patch
mm-writeback-commit-reason-of-wb_reason_forker_thread-mismatch-name.patch
mm-page_alloc-fix-doc-for-numa_zonelist_order.patch
mm-thp-fix-doc-for-transparent-huge-zero-page.patch
mm-pgtable-dont-accumulate-addr-during-pgd-prepopulate-pmd.patch

