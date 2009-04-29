From: akpm@linux-foundation.org
Subject: + memcg-remove-mem_cgroup_cache_charge_swapin.patch added to -mm tree
Date: Wed, 29 Apr 2009 14:42:43 -0700
Message-ID: <200904292142.n3TLgh41009874@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33127 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759216AbZD2Vog (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Apr 2009 17:44:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     memcg: remove mem_cgroup_cache_charge_swapin()
has been added to the -mm tree.  Its filename is
     memcg-remove-mem_cgroup_cache_charge_swapin.patch

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
Subject: memcg: remove mem_cgroup_cache_charge_swapin()
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

mem_cgroup_cache_charge_swapin() isn't used any more, so remove no-op
definition of it in header file.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    6 ------
 1 file changed, 6 deletions(-)

diff -puN include/linux/swap.h~memcg-remove-mem_cgroup_cache_charge_swapin include/linux/swap.h
--- a/include/linux/swap.h~memcg-remove-mem_cgroup_cache_charge_swapin
+++ a/include/linux/swap.h
@@ -431,12 +431,6 @@ static inline swp_entry_t get_swap_page(
 #define has_swap_token(x) 0
 #define disable_swap_token() do { } while(0)
 
-static inline int mem_cgroup_cache_charge_swapin(struct page *page,
-			struct mm_struct *mm, gfp_t mask, bool locked)
-{
-	return 0;
-}
