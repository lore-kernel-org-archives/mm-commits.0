From: akpm@linux-foundation.org
Subject: + memcg-clean-up-move-charge.patch added to -mm tree
Date: Fri, 09 Apr 2010 13:52:48 -0700
Message-ID: <201004092052.o39KqmAF010506@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43746 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755624Ab0DIUxb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Apr 2010 16:53:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nishimura@mxp.nes.nec.co.jp, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     memcg: clean up move charge
has been added to the -mm tree.  Its filename is
     memcg-clean-up-move-charge.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: clean up move charge
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

This patch cleans up move charge code by:

- define functions to handle pte for each types, and make
  is_target_pte_for_mc() cleaner.

- instead of checking the MOVE_CHARGE_TYPE_ANON bit, define a function
  that checks the bit.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |  106 ++++++++++++++++++++++++++++------------------
 1 file changed, 65 insertions(+), 41 deletions(-)

diff -puN mm/memcontrol.c~memcg-clean-up-move-charge mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-clean-up-move-charge
+++ a/mm/memcontrol.c
@@ -266,6 +266,12 @@ static struct move_charge_struct {
 	.waitq = __WAIT_QUEUE_HEAD_INITIALIZER(mc.waitq),
 };
 
+static bool move_anon(void)
+{
+	return test_bit(MOVE_CHARGE_TYPE_ANON,
+					&mc.to->move_charge_at_immigrate);
+}
+
 /*
  * Maximum loops in mem_cgroup_hierarchical_reclaim(), used for soft
  * limit reclaim to prevent infinite loops, if they ever occur.
@@ -4182,50 +4188,66 @@ enum mc_target_type {
 	MC_TARGET_SWAP,
 };
 
-static int is_target_pte_for_mc(struct vm_area_struct *vma,
-		unsigned long addr, pte_t ptent, union mc_target *target)
+static struct page *mc_handle_present_pte(struct vm_area_struct *vma,
+						unsigned long addr, pte_t ptent)
 {
-	struct page *page = NULL;
-	struct page_cgroup *pc;
-	int ret = 0;
-	swp_entry_t ent = { .val = 0 };
-	int usage_count = 0;
-	bool move_anon = test_bit(MOVE_CHARGE_TYPE_ANON,
-					&mc.to->move_charge_at_immigrate);
+	struct page *page = vm_normal_page(vma, addr, ptent);
 
-	if (!pte_present(ptent)) {
-		/* TODO: handle swap of shmes/tmpfs */
-		if (pte_none(ptent) || pte_file(ptent))
-			return 0;
-		else if (is_swap_pte(ptent)) {
-			ent = pte_to_swp_entry(ptent);
-			if (!move_anon || non_swap_entry(ent))
-				return 0;
-			usage_count = mem_cgroup_count_swap_user(ent, &page);
-		}
-	} else {
-		page = vm_normal_page(vma, addr, ptent);
-		if (!page || !page_mapped(page))
-			return 0;
+	if (!page || !page_mapped(page))
+		return NULL;
+	if (PageAnon(page)) {
+		/* we don't move shared anon */
+		if (!move_anon() || page_mapcount(page) > 2)
+			return NULL;
+	} else
 		/*
 		 * TODO: We don't move charges of file(including shmem/tmpfs)
 		 * pages for now.
 		 */
-		if (!move_anon || !PageAnon(page))
-			return 0;
-		if (!get_page_unless_zero(page))
-			return 0;
-		usage_count = page_mapcount(page);
-	}
-	if (usage_count > 1) {
-		/*
-		 * TODO: We don't move charges of shared(used by multiple
-		 * processes) pages for now.
-		 */
+		return NULL;
+	if (!get_page_unless_zero(page))
+		return NULL;
+
+	return page;
+}
+
+static struct page *mc_handle_swap_pte(struct vm_area_struct *vma,
+			unsigned long addr, pte_t ptent, swp_entry_t *entry)
+{
+	int usage_count;
+	struct page *page = NULL;
+	swp_entry_t ent = pte_to_swp_entry(ptent);
+
+	if (!move_anon() || non_swap_entry(ent))
+		return NULL;
+	usage_count = mem_cgroup_count_swap_user(ent, &page);
+	if (usage_count > 1) { /* we don't move shared anon */
 		if (page)
 			put_page(page);
-		return 0;
+		return NULL;
 	}
+	if (do_swap_account)
+		entry->val = ent.val;
+
+	return page;
+}
+
+static int is_target_pte_for_mc(struct vm_area_struct *vma,
+		unsigned long addr, pte_t ptent, union mc_target *target)
+{
+	struct page *page = NULL;
+	struct page_cgroup *pc;
+	int ret = 0;
+	swp_entry_t ent = { .val = 0 };
+
+	if (pte_present(ptent))
+		page = mc_handle_present_pte(vma, addr, ptent);
+	else if (is_swap_pte(ptent))
+		page = mc_handle_swap_pte(vma, addr, ptent, &ent);
+	/* TODO: handle swap of shmes/tmpfs */
+
+	if (!page && !ent.val)
+		return 0;
 	if (page) {
 		pc = lookup_page_cgroup(page);
 		/*
@@ -4241,13 +4263,15 @@ static int is_target_pte_for_mc(struct v
 		if (!ret || !target)
 			put_page(page);
 	}
-	/* throught */
-	if (ent.val && do_swap_account && !ret &&
-			css_id(&mc.from->css) == lookup_swap_cgroup(ent)) {
-		ret = MC_TARGET_SWAP;
-		if (target)
-			target->ent = ent;
+	/* Threre is a swap entry and a page doesn't exist or isn't charged */
+	if (ent.val && !ret) {
+		if (css_id(&mc.from->css) == lookup_swap_cgroup(ent)) {
+			ret = MC_TARGET_SWAP;
+			if (target)
+				target->ent = ent;
+		}
 	}
+
 	return ret;
 }
 
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

origin.patch
linux-next.patch
memcg-oom-wakeup-filter.patch
memcg-oom-wakeup-filter-update.patch
memcg-oom-notifier.patch
memcg-oom-notifier-update.patch
memcg-oom-kill-disable-and-oom-status.patch
memcg-oom-kill-disable-and-oom-status-update.patch
memcg-clean-up-move-charge.patch
memcg-move-charge-of-file-pages.patch
memcg-move-charge-of-file-pages-fix.patch

