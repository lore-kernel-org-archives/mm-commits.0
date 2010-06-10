From: akpm@linux-foundation.org
Subject: + memcg-remove-mem-from-arg-of-charge_common.patch added to -mm tree
Date: Thu, 10 Jun 2010 14:16:41 -0700
Message-ID: <201006102116.o5ALGfUN024076@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37145 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752984Ab0FJVQx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jun 2010 17:16:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     memcg: remove mem from arg of charge_common
has been added to the -mm tree.  Its filename is
     memcg-remove-mem-from-arg-of-charge_common.patch

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
Subject: memcg: remove mem from arg of charge_common
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

mem_cgroup_charge_common() is always called with @mem = NULL, so it's
meaningless.  This patch removes it.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff -puN mm/memcontrol.c~memcg-remove-mem-from-arg-of-charge_common mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-mem-from-arg-of-charge_common
+++ a/mm/memcontrol.c
@@ -2025,10 +2025,9 @@ out:
  * < 0 if the cgroup is over its limit
  */
 static int mem_cgroup_charge_common(struct page *page, struct mm_struct *mm,
-				gfp_t gfp_mask, enum charge_type ctype,
-				struct mem_cgroup *memcg)
+				gfp_t gfp_mask, enum charge_type ctype)
 {
-	struct mem_cgroup *mem;
+	struct mem_cgroup *mem = NULL;
 	struct page_cgroup *pc;
 	int ret;
 
@@ -2038,7 +2037,6 @@ static int mem_cgroup_charge_common(stru
 		return 0;
 	prefetchw(pc);
 
-	mem = memcg;
 	ret = __mem_cgroup_try_charge(mm, gfp_mask, &mem, true);
 	if (ret || !mem)
 		return ret;
@@ -2066,7 +2064,7 @@ int mem_cgroup_newpage_charge(struct pag
 	if (unlikely(!mm))
 		mm = &init_mm;
 	return mem_cgroup_charge_common(page, mm, gfp_mask,
-				MEM_CGROUP_CHARGE_TYPE_MAPPED, NULL);
+				MEM_CGROUP_CHARGE_TYPE_MAPPED);
 }
 
 static void
@@ -2076,7 +2074,6 @@ __mem_cgroup_commit_charge_swapin(struct
 int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
 				gfp_t gfp_mask)
 {
-	struct mem_cgroup *mem = NULL;
 	int ret;
 
 	if (mem_cgroup_disabled())
@@ -2108,22 +2105,24 @@ int mem_cgroup_cache_charge(struct page 
 		unlock_page_cgroup(pc);
 	}
 
-	if (unlikely(!mm && !mem))
+	if (unlikely(!mm))
 		mm = &init_mm;
 
 	if (page_is_file_cache(page))
 		return mem_cgroup_charge_common(page, mm, gfp_mask,
-				MEM_CGROUP_CHARGE_TYPE_CACHE, NULL);
+				MEM_CGROUP_CHARGE_TYPE_CACHE);
 
 	/* shmem */
 	if (PageSwapCache(page)) {
+		struct mem_cgroup *mem = NULL;
+
 		ret = mem_cgroup_try_charge_swapin(mm, page, gfp_mask, &mem);
 		if (!ret)
 			__mem_cgroup_commit_charge_swapin(page, mem,
 					MEM_CGROUP_CHARGE_TYPE_SHMEM);
 	} else
 		ret = mem_cgroup_charge_common(page, mm, gfp_mask,
-					MEM_CGROUP_CHARGE_TYPE_SHMEM, mem);
+					MEM_CGROUP_CHARGE_TYPE_SHMEM);
 
 	return ret;
 }
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

memcg-fix-wake-up-in-oom-wait-queue.patch
memcg-remove-experimental-from-swap-account-config.patch
memcg-clean-up-try_charge-main-loop-v2.patch
memcg-clean-up-waiting-move-acct-v2.patch
memcg-remove-redundant-codes.patch
memcg-remove-mem-from-arg-of-charge_common.patch

