From: akpm@linux-foundation.org
Subject: [folded] memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing-try_charge-fix.patch removed from -mm tree
Date: Thu, 12 Jan 2012 16:54:17 -0800
Message-ID: <20120113005417.F1F3D1E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:37231 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756312Ab2AMAyT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jan 2012 19:54:19 -0500
Received: by yhjj52 with SMTP id j52so8025yhj.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2012 16:54:18 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mszeredi@suse.cz, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing-try_charge-fix
has been removed from the -mm tree.  Its filename was
     memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing-try_charge-fix.patch

This patch was dropped because it was folded into memcg-simplify-lru-handling-by-new-rule.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing-try_charge-fix

clean up code comment

Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Miklos Szeredi <mszeredi@suse.cz>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff -puN mm/memcontrol.c~memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing-try_charge-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing-try_charge-fix
+++ a/mm/memcontrol.c
@@ -2190,20 +2190,19 @@ static int mem_cgroup_do_charge(struct m
  * 3. call memory reclaim if necessary.
  *
  * In some special case, if the task is fatal, fatal_signal_pending() or
- * TIF_MEMDIE, this functoion returns -EINTR with filling *ptr as
- * root_mem_cgroup. There are 2 reasons for this. 1st is that
- * fatal threads should quit as soon as possible without any hazards.
- * 2nd is that all page should have valid pc->mem_cgroup if it will be
- * used. If mm is NULL and the caller doesn't pass valid memcg pointer,
- * that's treated as charge to root_mem_cgroup.
+ * has TIF_MEMDIE, this function returns -EINTR while writing root_mem_cgroup
+ * to *ptr. There are two reasons for this. 1: fatal threads should quit as soon
+ * as possible without any hazards. 2: all pages should have a valid
+ * pc->mem_cgroup. If mm is NULL and the caller doesn't pass a valid memcg
+ * pointer, that is treated as a charge to root_mem_cgroup.
  *
- * So, try_charge will return
- *  0       ...  at success. filling *ptr with a valid memcg pointer.
+ * So __mem_cgroup_try_charge() will return
+ *  0       ...  on success, filling *ptr with a valid memcg pointer.
  *  -ENOMEM ...  charge failure because of resource limits.
  *  -EINTR  ...  if thread is fatal. *ptr is filled with root_mem_cgroup.
  *
- * Unlike exported interface, "oom" parameter is added. if oom==true,
- * oom-killer can be invoked.
+ * Unlike the exported interface, an "oom" parameter is added. if oom==true,
+ * the oom-killer can be invoked.
  */
 static int __mem_cgroup_try_charge(struct mm_struct *mm,
 				   gfp_t gfp_mask,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn.patch
drivers-video-nvidia-nvidiac-fix-warning.patch
pipe-fail-cleanly-when-root-tries-f_setpipe_sz-with-big-size.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient.patch
memcg-clear-pc-mem_cgorup-if-necessary.patch
memcg-simplify-lru-handling-by-new-rule.patch
mm-compaction-introduce-sync-light-migration-for-use-by-compaction-fix-fix.patch
mm-compaction-introduce-sync-light-migration-for-use-by-compaction-fix-fix-3.patch
mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path-fix.patch
kexec-remove-kmsg_dump_kexec.patch
panic-dont-print-redundant-backtraces-on-oops-fix.patch
drivers-parport-parport_pcc-fix-warnings.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
selftests-new-very-basic-kernel-selftests-directory.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4-fix.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries-fix.patch
fixed-use-of-rounddown_pow_of_two-in-ramoops.patch

