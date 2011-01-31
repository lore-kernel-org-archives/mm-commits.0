From: akpm@linux-foundation.org
Subject: + memcg-prevent-endless-loop-when-charging-huge-pages-to-near-limit-group.patch added to -mm tree
Date: Mon, 31 Jan 2011 14:30:33 -0800
Message-ID: <201101312230.p0VMUXAu005693@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54972 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754129Ab1AaWap (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Jan 2011 17:30:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: prevent endless loop when charging huge pages to near-limit group
has been added to the -mm tree.  Its filename is
     memcg-prevent-endless-loop-when-charging-huge-pages-to-near-limit-group.patch

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
Subject: memcg: prevent endless loop when charging huge pages to near-limit group
From: Johannes Weiner <hannes@cmpxchg.org>

If reclaim after a failed charging was unsuccessful, the limits are
checked again, just in case they settled by means of other tasks.

This is all fine as long as every charge is of size PAGE_SIZE, because in
that case, being below the limit means having at least PAGE_SIZE bytes
available.

But with transparent huge pages, we may end up in an endless loop where
charging and reclaim fail, but we keep going because the limits are not
yet exceeded, although not allowing for a huge page.

Fix this up by explicitely checking for enough room, not just whether we
are within limits.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/res_counter.h |   12 ++++++++++++
 mm/memcontrol.c             |   27 ++++++++++++++++++++-------
 2 files changed, 32 insertions(+), 7 deletions(-)

diff -puN include/linux/res_counter.h~memcg-prevent-endless-loop-when-charging-huge-pages-to-near-limit-group include/linux/res_counter.h
--- a/include/linux/res_counter.h~memcg-prevent-endless-loop-when-charging-huge-pages-to-near-limit-group
+++ a/include/linux/res_counter.h
@@ -182,6 +182,18 @@ static inline bool res_counter_check_und
 	return ret;
 }
 
+static inline bool res_counter_check_margin(struct res_counter *cnt,
+					    unsigned long bytes)
+{
+	bool ret;
+	unsigned long flags;
+
+	spin_lock_irqsave(&cnt->lock, flags);
+	ret = cnt->limit - cnt->usage >= bytes;
+	spin_unlock_irqrestore(&cnt->lock, flags);
+	return ret;
+}
+
 static inline bool res_counter_check_under_soft_limit(struct res_counter *cnt)
 {
 	bool ret;
diff -puN mm/memcontrol.c~memcg-prevent-endless-loop-when-charging-huge-pages-to-near-limit-group mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-prevent-endless-loop-when-charging-huge-pages-to-near-limit-group
+++ a/mm/memcontrol.c
@@ -1111,6 +1111,15 @@ static bool mem_cgroup_check_under_limit
 	return false;
 }
 
+static bool mem_cgroup_check_margin(struct mem_cgroup *mem, unsigned long bytes)
+{
+	if (!res_counter_check_margin(&mem->res, bytes))
+		return false;
+	if (do_swap_account && !res_counter_check_margin(&mem->memsw, bytes))
+		return false;
+	return true;
+}
+
 static unsigned int get_swappiness(struct mem_cgroup *memcg)
 {
 	struct cgroup *cgrp = memcg->css.cgroup;
@@ -1852,15 +1861,19 @@ static int __mem_cgroup_do_charge(struct
 		return CHARGE_WOULDBLOCK;
 
 	ret = mem_cgroup_hierarchical_reclaim(mem_over_limit, NULL,
-					gfp_mask, flags);
+					      gfp_mask, flags);
+	if (mem_cgroup_check_margin(mem_over_limit, csize))
+		return CHARGE_RETRY;
 	/*
-	 * try_to_free_mem_cgroup_pages() might not give us a full
-	 * picture of reclaim. Some pages are reclaimed and might be
-	 * moved to swap cache or just unmapped from the cgroup.
-	 * Check the limit again to see if the reclaim reduced the
-	 * current usage of the cgroup before giving up
+	 * Even though the limit is exceeded at this point, reclaim
+	 * may have been able to free some pages.  Retry the charge
+	 * before killing the task.
+	 *
+	 * Only for regular pages, though: huge pages are rather
+	 * unlikely to succeed so close to the limit, and we fall back
+	 * to regular pages anyway in case of failure.
 	 */
-	if (ret || mem_cgroup_check_under_limit(mem_over_limit))
+	if (csize == PAGE_SIZE && ret)
 		return CHARGE_RETRY;
 
 	/*
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
memcg-prevent-endless-loop-when-charging-huge-pages.patch
memcg-prevent-endless-loop-when-charging-huge-pages-to-near-limit-group.patch
memcg-never-oom-when-charging-huge-pages.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path-fix.patch
memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch
memcg-fix-ugly-initialization-of-return-value-is-in-caller.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch

