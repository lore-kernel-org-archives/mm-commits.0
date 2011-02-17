From: akpm@linux-foundation.org
Subject: + memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update-fix.patch added to -mm tree
Date: Thu, 17 Feb 2011 13:10:45 -0800
Message-ID: <201102172110.p1HLAjqO011891@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43198 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754105Ab1BQVM5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Feb 2011 16:12:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com


The patch titled
     memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update-fix
has been added to the -mm tree.  Its filename is
     memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update-fix.patch

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
Subject: memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update-fix
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

- print pc->flags in hex.
- print the path of the cgroup in the same line as pc->mem_cgroup.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update-fix
+++ a/mm/memcontrol.c
@@ -3048,7 +3048,7 @@ void mem_cgroup_print_bad_page(struct pa
 		int ret = -1;
 		char *path;
 
-		printk(KERN_ALERT "pc:%p pc->flags:%ld pc->mem_cgroup:%p",
+		printk(KERN_ALERT "pc:%p pc->flags:%lx pc->mem_cgroup:%p",
 		       pc, pc->flags, pc->mem_cgroup);
 
 		path = kmalloc(PATH_MAX, GFP_KERNEL);
@@ -3059,7 +3059,7 @@ void mem_cgroup_print_bad_page(struct pa
 			rcu_read_unlock();
 		}
 
-		printk(KERN_ALERT "(%s)\n",
+		printk(KERN_CONT "(%s)\n",
 				(ret < 0) ? "cannot get the path" : path);
 		kfree(path);
 	}
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

memsw-remove-noswapaccount-kernel-parameter.patch
memcg-fix-ugly-initialization-of-return-value-is-in-caller.patch
memcg-soft-limit-reclaim-should-end-at-limit-not-below.patch
memcg-simplify-the-way-memory-limits-are-checked.patch
memcg-remove-unused-page-flag-bitfield-defines.patch
memcg-remove-impossible-conditional-when-committing.patch
memcg-remove-null-check-from-lookup_page_cgroup-result.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update-fix.patch
memcg-no-uncharged-pages-reach-page_cgroup_zoneinfo.patch
memcg-change-page_cgroup_zoneinfo-signature.patch
memcg-fold-__mem_cgroup_move_account-into-caller.patch
memcg-condense-page_cgroup-to-page-lookup-points.patch
memcg-remove-direct-page_cgroup-to-page-pointer.patch
memcg-remove-direct-page_cgroup-to-page-pointer-fix.patch
memcg-charged-pages-always-have-valid-per-memcg-zone-info.patch
memcg-remove-memcg-reclaim_param_lock.patch
memcg-keep-only-one-charge-cancelling-function.patch
memcg-keep-only-one-charge-cancelling-function-fix.patch
memcg-convert-per-cpu-stock-from-bytes-to-page-granularity.patch
memcg-convert-uncharge-batching-from-bytes-to-page-granularity.patch
memcg-unify-charge-uncharge-quantities-to-units-of-pages.patch

