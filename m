From: akpm@linux-foundation.org
Subject: [merged] memcg-remove-mem_cgroup_cache_charge_swapin.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:45:59 -0700
Message-ID: <200906182245.n5IMjx0E005048@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52232 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758119AbZFRWq2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:46:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memcg: remove mem_cgroup_cache_charge_swapin()
has been removed from the -mm tree.  Its filename was
     memcg-remove-mem_cgroup_cache_charge_swapin.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: remove mem_cgroup_cache_charge_swapin()
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

mem_cgroup_cache_charge_swapin() isn't used any more, so remove no-op
definition of it in header file.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    6 ------
 1 file changed, 6 deletions(-)

diff -puN include/linux/swap.h~memcg-remove-mem_cgroup_cache_charge_swapin include/linux/swap.h
--- a/include/linux/swap.h~memcg-remove-mem_cgroup_cache_charge_swapin
+++ a/include/linux/swap.h
@@ -423,12 +423,6 @@ static inline swp_entry_t get_swap_page(
 #define has_swap_token(x) 0
 #define disable_swap_token() do { } while(0)
 
-static inline int mem_cgroup_cache_charge_swapin(struct page *page,
-			struct mm_struct *mm, gfp_t mask, bool locked)
-{
-	return 0;
-}
