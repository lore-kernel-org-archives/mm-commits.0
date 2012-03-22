From: akpm@linux-foundation.org
Subject: [merged] memcg-clean-up-existing-move-charge-code.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:20:10 -0700
Message-ID: <20120322202010.85469A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:34091 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759504Ab2CVUUM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:20:12 -0400
Received: by wgbdt11 with SMTP id dt11so80894wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:20:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, dhillf@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: clean up existing move charge code
has been removed from the -mm tree.  Its filename was
     memcg-clean-up-existing-move-charge-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: memcg: clean up existing move charge code

- Replace lengthy function name is_target_pte_for_mc() with a shorter
  one in order to avoid ugly line breaks.

- explicitly use MC_TARGET_* instead of simply using integers.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Acked-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff -puN mm/memcontrol.c~memcg-clean-up-existing-move-charge-code mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-clean-up-existing-move-charge-code
+++ a/mm/memcontrol.c
@@ -5110,7 +5110,7 @@ one_by_one:
 }
 
 /**
- * is_target_pte_for_mc - check a pte whether it is valid for move charge
+ * get_mctgt_type - get target type of moving charge
  * @vma: the vma the pte to be checked belongs
  * @addr: the address corresponding to the pte to be checked
  * @ptent: the pte to be checked
@@ -5133,7 +5133,7 @@ union mc_target {
 };
 
 enum mc_target_type {
-	MC_TARGET_NONE,	/* not used */
+	MC_TARGET_NONE = 0,
 	MC_TARGET_PAGE,
 	MC_TARGET_SWAP,
 };
@@ -5214,12 +5214,12 @@ static struct page *mc_handle_file_pte(s
 	return page;
 }
 
-static int is_target_pte_for_mc(struct vm_area_struct *vma,
+static enum mc_target_type get_mctgt_type(struct vm_area_struct *vma,
 		unsigned long addr, pte_t ptent, union mc_target *target)
 {
 	struct page *page = NULL;
 	struct page_cgroup *pc;
-	int ret = 0;
+	enum mc_target_type ret = MC_TARGET_NONE;
 	swp_entry_t ent = { .val = 0 };
 
 	if (pte_present(ptent))
@@ -5230,7 +5230,7 @@ static int is_target_pte_for_mc(struct v
 		page = mc_handle_file_pte(vma, addr, ptent, &ent);
 
 	if (!page && !ent.val)
-		return 0;
+		return ret;
 	if (page) {
 		pc = lookup_page_cgroup(page);
 		/*
@@ -5270,7 +5270,7 @@ static int mem_cgroup_count_precharge_pt
 
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	for (; addr != end; pte++, addr += PAGE_SIZE)
-		if (is_target_pte_for_mc(vma, addr, *pte, NULL))
+		if (get_mctgt_type(vma, addr, *pte, NULL))
 			mc.precharge++;	/* increment precharge temporarily */
 	pte_unmap_unlock(pte - 1, ptl);
 	cond_resched();
@@ -5442,8 +5442,7 @@ retry:
 		if (!mc.precharge)
 			break;
 
-		type = is_target_pte_for_mc(vma, addr, ptent, &target);
-		switch (type) {
+		switch (get_mctgt_type(vma, addr, ptent, &target)) {
 		case MC_TARGET_PAGE:
 			page = target.page;
 			if (isolate_lru_page(page))
@@ -5456,7 +5455,7 @@ retry:
 				mc.moved_charge++;
 			}
 			putback_lru_page(page);
-put:			/* is_target_pte_for_mc() gets the page */
+put:			/* get_mctgt_type() gets the page */
 			put_page(page);
 			break;
 		case MC_TARGET_SWAP:
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
linux-next.patch

