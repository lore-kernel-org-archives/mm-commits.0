From: akpm@linux-foundation.org
Subject: [merged]
 mm-pgtable-dont-accumulate-addr-during-pgd-prepopulate-pmd.patch removed
 from -mm tree
Date: Tue, 09 Jul 2013 16:20:15 -0700
Message-ID: <51dc9aaf.wuECgVHd6X+CCaMo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38893 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab3GIXUP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:20:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, mhocko@suse.cz, liwanp@linux.vnet.ibm.com

Subject: [merged] mm-pgtable-dont-accumulate-addr-during-pgd-prepopulate-pmd.patch removed from -mm tree
To: liwanp@linux.vnet.ibm.com,mhocko@suse.cz,zhangyanfei@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:20:15 -0700


The patch titled
     Subject: mm/pgtable: don't accumulate addr during pgd prepopulate pmd
has been removed from the -mm tree.  Its filename was
     mm-pgtable-dont-accumulate-addr-during-pgd-prepopulate-pmd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

