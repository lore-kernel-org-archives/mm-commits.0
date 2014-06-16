From: akpm@linux-foundation.org
Subject: [withdrawn] memcg-allow-setting-low_limit.patch removed from -mm
 tree
Date: Mon, 16 Jun 2014 15:35:03 -0700
Message-ID: <539f7117.gFub5Nl0A1Q+UMYF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46079 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbaFPWfE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jun 2014 18:35:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, tj@kernel.org, kosaki.motohiro@jp.fujitsu.com, klamm@yandex-team.ru, kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com, hannes@cmpxchg.org, gthelen@google.com, mhocko@suse.cz


The patch titled
     Subject: memcg: allow setting low_limit
has been removed from the -mm tree.  Its filename was
     memcg-allow-setting-low_limit.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg: allow setting low_limit

Export memory.low_limit_in_bytes knob with the same rules as the hard
limit represented by limit_in_bytes knob (e.g.  no limit to be set for the
root cgroup).  There is no memsw alternative for low_limit_in_bytes
because the primary motivation behind this limit is to protect the working
set of the group and so considering swap doesn't make much sense.  There
is also no kmem variant exported because we do not have any easy way to
protect kernel allocations now.

Please note that the low limit might exceed the hard limit which basically
means that the group is not reclaimable if there is other reclaim target
in the hierarchy under pressure.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Roman Gushchin <klamm@yandex-team.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/res_counter.h |   13 +++++++++++++
 kernel/res_counter.c        |    2 ++
 mm/memcontrol.c             |   27 ++++++++++++++++++++++++++-
 3 files changed, 41 insertions(+), 1 deletion(-)

diff -puN include/linux/res_counter.h~memcg-allow-setting-low_limit include/linux/res_counter.h
--- a/include/linux/res_counter.h~memcg-allow-setting-low_limit
+++ a/include/linux/res_counter.h
@@ -93,6 +93,7 @@ enum {
 	RES_LIMIT,
 	RES_FAILCNT,
 	RES_SOFT_LIMIT,
+	RES_LOW_LIMIT,
 };
 
 /*
@@ -246,5 +247,17 @@ res_counter_set_soft_limit(struct res_co
 	spin_unlock_irqrestore(&cnt->lock, flags);
 	return 0;
 }
+
+static inline int
+res_counter_set_low_limit(struct res_counter *cnt,
+				unsigned long long low_limit)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&cnt->lock, flags);
+	cnt->low_limit = low_limit;
+	spin_unlock_irqrestore(&cnt->lock, flags);
+	return 0;
+}
 
 #endif
diff -puN kernel/res_counter.c~memcg-allow-setting-low_limit kernel/res_counter.c
--- a/kernel/res_counter.c~memcg-allow-setting-low_limit
+++ a/kernel/res_counter.c
@@ -136,6 +136,8 @@ res_counter_member(struct res_counter *c
 		return &counter->failcnt;
 	case RES_SOFT_LIMIT:
 		return &counter->soft_limit;
+	case RES_LOW_LIMIT:
+		return &counter->low_limit;
 	};
 
 	BUG();
diff -puN mm/memcontrol.c~memcg-allow-setting-low_limit mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-allow-setting-low_limit
+++ a/mm/memcontrol.c
@@ -1666,8 +1666,9 @@ void mem_cgroup_print_oom_info(struct me
 
 	rcu_read_unlock();
 
-	pr_info("memory: usage %llukB, limit %llukB, failcnt %llu\n",
+	pr_info("memory: usage %llukB, low_limit %llukB limit %llukB, failcnt %llu\n",
 		res_counter_read_u64(&memcg->res, RES_USAGE) >> 10,
+		res_counter_read_u64(&memcg->res, RES_LOW_LIMIT) >> 10,
 		res_counter_read_u64(&memcg->res, RES_LIMIT) >> 10,
 		res_counter_read_u64(&memcg->res, RES_FAILCNT));
 	pr_info("memory+swap: usage %llukB, limit %llukB, failcnt %llu\n",
@@ -5083,6 +5084,24 @@ static ssize_t mem_cgroup_write(struct k
 		else
 			return -EINVAL;
 		break;
+	case RES_LOW_LIMIT:
+		if (mem_cgroup_is_root(memcg)) { /* Can't set limit on root */
+			ret = -EINVAL;
+			break;
+		}
+		ret = res_counter_memparse_write_strategy(buf, &val);
+		if (ret)
+			break;
+		if (type == _MEM) {
+			ret = res_counter_set_low_limit(&memcg->res, val);
+			break;
+		}
+		/*
+		 * memsw low limit doesn't make any sense and kmem is not
+		 * implemented yet - if ever
+		 */
+		return -EINVAL;
+
 	case RES_SOFT_LIMIT:
 		ret = res_counter_memparse_write_strategy(buf, &val);
 		if (ret)
@@ -6008,6 +6027,12 @@ static struct cftype mem_cgroup_files[]
 		.write = mem_cgroup_write,
 		.read_u64 = mem_cgroup_read_u64,
 	},
+	{
+		.name = "low_limit_in_bytes",
+		.private = MEMFILE_PRIVATE(_MEM, RES_LOW_LIMIT),
+		.write = mem_cgroup_write,
+		.read_u64 = mem_cgroup_read_u64,
+	},
 	{
 		.name = "soft_limit_in_bytes",
 		.private = MEMFILE_PRIVATE(_MEM, RES_SOFT_LIMIT),
_

Patches currently in -mm which might be from mhocko@suse.cz are

mm-vmscanc-avoid-recording-the-original-scan-targets-in-shrink_lruvec.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-pagewalk-remove-pgd_entry-and-pud_entry.patch
mm-pagewalk-replace-mm_walk-skip-with-more-general-mm_walk-control.patch
madvise-cleanup-swapin_walk_pmd_entry.patch
memcg-separate-mem_cgroup_move_charge_pte_range.patch
arch-powerpc-mm-subpage-protc-cleanup-subpage_walk_pmd_entry.patch
mm-pagewalk-move-pmd_trans_huge_lock-from-callbacks-to-common-code.patch
mincore-apply-page-table-walker-on-do_mincore.patch
memcg-doc-clarify-global-vs-limit-reclaims.patch
memcg-doc-clarify-global-vs-limit-reclaims-fix.patch
memcg-document-memorylow_limit_in_bytes.patch
vmscan-memcg-check-whether-the-low-limit-should-be-ignored.patch
memcg-deprecate-memoryforce_empty-knob.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch

