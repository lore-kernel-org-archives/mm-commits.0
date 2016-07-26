From: akpm@linux-foundation.org
Subject: [patch 026/126] mm/memcontrol.c: remove the useless parameter for mc_handle_swap_pte
Date: Tue, 26 Jul 2016 15:22:14 -0700
Message-ID: <5797e296.EETkc3ypPQ1BVbtY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56556 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757758AbcGZWWP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:22:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, roy.qing.li@gmail.com, mhocko@suse.com

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
