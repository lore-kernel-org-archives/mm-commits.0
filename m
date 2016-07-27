From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-remove-the-useless-parameter-for-mc_handle_swap_pte.patch
 removed from -mm tree
Date: Wed, 27 Jul 2016 11:59:34 -0700
Message-ID: <57990496.0VsB3yFN0BR4Pbm/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40002 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758148AbcG0S7f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 14:59:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roy.qing.li@gmail.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcontrol.c: remove the useless parameter for mc_handle_swap_pte
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-remove-the-useless-parameter-for-mc_handle_swap_pte.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Li RongQing <roy.qing.li@gmail.com>
Subject: mm/memcontrol.c: remove the useless parameter for mc_handle_swap_pte

It seems like this parameter has never been used since being introduced by
90254a65833b ("memcg: clean up move charge").  Not a big deal because I
assume the function would get inlined into the caller anyway but why not
get rid of it.

[mhocko@suse.com: wrote changelog]
  Link: http://lkml.kernel.org/r/20160525151831.GJ20132@dhcp22.suse.cz
Link: http://lkml.kernel.org/r/1464145026-26693-1-git-send-email-roy.qing.li@gmail.com
Signed-off-by: Li RongQing <roy.qing.li@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-remove-the-useless-parameter-for-mc_handle_swap_pte mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-remove-the-useless-parameter-for-mc_handle_swap_pte
+++ a/mm/memcontrol.c
@@ -4409,7 +4409,7 @@ static struct page *mc_handle_present_pt
 
 #ifdef CONFIG_SWAP
 static struct page *mc_handle_swap_pte(struct vm_area_struct *vma,
-			unsigned long addr, pte_t ptent, swp_entry_t *entry)
+			pte_t ptent, swp_entry_t *entry)
 {
 	struct page *page = NULL;
 	swp_entry_t ent = pte_to_swp_entry(ptent);
@@ -4428,7 +4428,7 @@ static struct page *mc_handle_swap_pte(s
 }
 #else
 static struct page *mc_handle_swap_pte(struct vm_area_struct *vma,
-			unsigned long addr, pte_t ptent, swp_entry_t *entry)
+			pte_t ptent, swp_entry_t *entry)
 {
 	return NULL;
 }
@@ -4593,7 +4593,7 @@ static enum mc_target_type get_mctgt_typ
 	if (pte_present(ptent))
 		page = mc_handle_present_pte(vma, addr, ptent);
 	else if (is_swap_pte(ptent))
-		page = mc_handle_swap_pte(vma, addr, ptent, &ent);
+		page = mc_handle_swap_pte(vma, ptent, &ent);
 	else if (pte_none(ptent))
 		page = mc_handle_file_pte(vma, addr, ptent, &ent);
 
_

Patches currently in -mm which might be from roy.qing.li@gmail.com are


