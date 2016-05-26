From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-remove-the-useless-parameter-for-mc_handle_swap_pte.patch
 added to -mm tree
Date: Thu, 26 May 2016 14:13:02 -0700
Message-ID: <574766de.5sZMLmOZBU91xJoj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48100 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198AbcEZVND (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 May 2016 17:13:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roy.qing.li@gmail.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcontrol.c: remove the useless parameter for mc_handle_swap_pte
has been added to the -mm tree.  Its filename is
     mm-memcontrol-remove-the-useless-parameter-for-mc_handle_swap_pte.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-remove-the-useless-parameter-for-mc_handle_swap_pte.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-remove-the-useless-parameter-for-mc_handle_swap_pte.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -4361,7 +4361,7 @@ static struct page *mc_handle_present_pt
 
 #ifdef CONFIG_SWAP
 static struct page *mc_handle_swap_pte(struct vm_area_struct *vma,
-			unsigned long addr, pte_t ptent, swp_entry_t *entry)
+			pte_t ptent, swp_entry_t *entry)
 {
 	struct page *page = NULL;
 	swp_entry_t ent = pte_to_swp_entry(ptent);
@@ -4380,7 +4380,7 @@ static struct page *mc_handle_swap_pte(s
 }
 #else
 static struct page *mc_handle_swap_pte(struct vm_area_struct *vma,
-			unsigned long addr, pte_t ptent, swp_entry_t *entry)
+			pte_t ptent, swp_entry_t *entry)
 {
 	return NULL;
 }
@@ -4526,7 +4526,7 @@ static enum mc_target_type get_mctgt_typ
 	if (pte_present(ptent))
 		page = mc_handle_present_pte(vma, addr, ptent);
 	else if (is_swap_pte(ptent))
-		page = mc_handle_swap_pte(vma, addr, ptent, &ent);
+		page = mc_handle_swap_pte(vma, ptent, &ent);
 	else if (pte_none(ptent))
 		page = mc_handle_file_pte(vma, addr, ptent, &ent);
 
_

Patches currently in -mm which might be from roy.qing.li@gmail.com are

mm-memcontrol-remove-the-useless-parameter-for-mc_handle_swap_pte.patch

