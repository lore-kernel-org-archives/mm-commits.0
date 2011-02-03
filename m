From: akpm@linux-foundation.org
Subject: + memcg-soft-limit-reclaim-should-end-at-limit-not-below.patch added to -mm tree
Date: Thu, 03 Feb 2011 15:25:01 -0800
Message-ID: <201102032325.p13NP1uQ030974@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44039 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752210Ab1BCXZu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Feb 2011 18:25:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: soft limit reclaim should end at limit not below
has been added to the -mm tree.  Its filename is
     memcg-soft-limit-reclaim-should-end-at-limit-not-below.patch

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
Subject: memcg: soft limit reclaim should end at limit not below
From: Johannes Weiner <hannes@cmpxchg.org>

Soft limit reclaim continues until the usage is below the current soft
limit, but the documented semantics are actually that soft limit reclaim
will push usage back until the soft limits are met again.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/res_counter.h |    4 ++--
 mm/memcontrol.c             |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/res_counter.h~memcg-soft-limit-reclaim-should-end-at-limit-not-below include/linux/res_counter.h
--- a/include/linux/res_counter.h~memcg-soft-limit-reclaim-should-end-at-limit-not-below
+++ a/include/linux/res_counter.h
@@ -139,7 +139,7 @@ static inline bool res_counter_limit_che
 
 static inline bool res_counter_soft_limit_check_locked(struct res_counter *cnt)
 {
-	if (cnt->usage < cnt->soft_limit)
+	if (cnt->usage <= cnt->soft_limit)
 		return true;
 
 	return false;
@@ -202,7 +202,7 @@ static inline bool res_counter_check_mar
 	return ret;
 }
 
-static inline bool res_counter_check_under_soft_limit(struct res_counter *cnt)
+static inline bool res_counter_check_within_soft_limit(struct res_counter *cnt)
 {
 	bool ret;
 	unsigned long flags;
diff -puN mm/memcontrol.c~memcg-soft-limit-reclaim-should-end-at-limit-not-below mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-soft-limit-reclaim-should-end-at-limit-not-below
+++ a/mm/memcontrol.c
@@ -1451,7 +1451,7 @@ static int mem_cgroup_hierarchical_recla
 			return ret;
 		total += ret;
 		if (check_soft) {
-			if (res_counter_check_under_soft_limit(&root_mem->res))
+			if (res_counter_check_within_soft_limit(&root_mem->res))
 				return total;
 		} else if (mem_cgroup_check_under_limit(root_mem))
 			return 1 + total;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path-fix.patch
memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch
memcg-fix-ugly-initialization-of-return-value-is-in-caller.patch
memcg-soft-limit-reclaim-should-end-at-limit-not-below.patch
memcg-simplify-the-way-memory-limits-are-checked.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch

