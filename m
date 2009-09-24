From: akpm@linux-foundation.org
Subject: [merged] memory-controller-soft-limit-interface-v9.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:34:39 -0700
Message-ID: <200909241934.n8OJYdFM031253@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43977 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754318AbZIXTfC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:35:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lizf@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memory controller: soft limit interface
has been removed from the -mm tree.  Its filename was
     memory-controller-soft-limit-interface-v9.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory controller: soft limit interface
From: Balbir Singh <balbir@linux.vnet.ibm.com>

Add an interface to allow get/set of soft limits.  Soft limits for memory
plus swap controller (memsw) is currently not supported.  Resource
counters have been enhanced to support soft limits and new type
RES_SOFT_LIMIT has been added.  Unlike hard limits, soft limits can be
directly set and do not need any reclaim or checks before setting them to
a newer value.

Kamezawa-San raised a question as to whether soft limit should belong to
res_counter.  Since all resources understand the basic concepts of hard
and soft limits, it is justified to add soft limits here.  Soft limits are
a generic resource usage feature, even file system quotas support soft
limits.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/res_counter.h |   58 ++++++++++++++++++++++++++++++++++
 kernel/res_counter.c        |    3 +
 mm/memcontrol.c             |   20 +++++++++++
 3 files changed, 81 insertions(+)

diff -puN include/linux/res_counter.h~memory-controller-soft-limit-interface-v9 include/linux/res_counter.h
--- a/include/linux/res_counter.h~memory-controller-soft-limit-interface-v9
+++ a/include/linux/res_counter.h
@@ -35,6 +35,10 @@ struct res_counter {
 	 */
 	unsigned long long limit;
 	/*
+	 * the limit that usage can be exceed
+	 */
+	unsigned long long soft_limit;
+	/*
 	 * the number of unsuccessful attempts to consume the resource
 	 */
 	unsigned long long failcnt;
@@ -87,6 +91,7 @@ enum {
 	RES_MAX_USAGE,
 	RES_LIMIT,
 	RES_FAILCNT,
+	RES_SOFT_LIMIT,
 };
 
 /*
@@ -132,6 +137,36 @@ static inline bool res_counter_limit_che
 	return false;
 }
 
+static inline bool res_counter_soft_limit_check_locked(struct res_counter *cnt)
+{
+	if (cnt->usage < cnt->soft_limit)
+		return true;
+
+	return false;
+}
+
+/**
+ * Get the difference between the usage and the soft limit
+ * @cnt: The counter
+ *
+ * Returns 0 if usage is less than or equal to soft limit
+ * The difference between usage and soft limit, otherwise.
+ */
+static inline unsigned long long
+res_counter_soft_limit_excess(struct res_counter *cnt)
+{
+	unsigned long long excess;
+	unsigned long flags;
+
+	spin_lock_irqsave(&cnt->lock, flags);
+	if (cnt->usage <= cnt->soft_limit)
+		excess = 0;
+	else
+		excess = cnt->usage - cnt->soft_limit;
+	spin_unlock_irqrestore(&cnt->lock, flags);
+	return excess;
+}
+
 /*
  * Helper function to detect if the cgroup is within it's limit or
  * not. It's currently called from cgroup_rss_prepare()
@@ -147,6 +182,17 @@ static inline bool res_counter_check_und
 	return ret;
 }
 
+static inline bool res_counter_check_under_soft_limit(struct res_counter *cnt)
+{
+	bool ret;
+	unsigned long flags;
+
+	spin_lock_irqsave(&cnt->lock, flags);
+	ret = res_counter_soft_limit_check_locked(cnt);
+	spin_unlock_irqrestore(&cnt->lock, flags);
+	return ret;
+}
+
 static inline void res_counter_reset_max(struct res_counter *cnt)
 {
 	unsigned long flags;
@@ -180,4 +226,16 @@ static inline int res_counter_set_limit(
 	return ret;
 }
 
+static inline int
+res_counter_set_soft_limit(struct res_counter *cnt,
+				unsigned long long soft_limit)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&cnt->lock, flags);
+	cnt->soft_limit = soft_limit;
+	spin_unlock_irqrestore(&cnt->lock, flags);
+	return 0;
+}
+
 #endif
diff -puN kernel/res_counter.c~memory-controller-soft-limit-interface-v9 kernel/res_counter.c
--- a/kernel/res_counter.c~memory-controller-soft-limit-interface-v9
+++ a/kernel/res_counter.c
@@ -19,6 +19,7 @@ void res_counter_init(struct res_counter
 {
 	spin_lock_init(&counter->lock);
 	counter->limit = RESOURCE_MAX;
+	counter->soft_limit = RESOURCE_MAX;
 	counter->parent = parent;
 }
 
@@ -101,6 +102,8 @@ res_counter_member(struct res_counter *c
 		return &counter->limit;
 	case RES_FAILCNT:
 		return &counter->failcnt;
+	case RES_SOFT_LIMIT:
+		return &counter->soft_limit;
 	};
 
 	BUG();
diff -puN mm/memcontrol.c~memory-controller-soft-limit-interface-v9 mm/memcontrol.c
--- a/mm/memcontrol.c~memory-controller-soft-limit-interface-v9
+++ a/mm/memcontrol.c
@@ -2123,6 +2123,20 @@ static int mem_cgroup_write(struct cgrou
 		else
 			ret = mem_cgroup_resize_memsw_limit(memcg, val);
 		break;
+	case RES_SOFT_LIMIT:
+		ret = res_counter_memparse_write_strategy(buffer, &val);
+		if (ret)
+			break;
+		/*
+		 * For memsw, soft limits are hard to implement in terms
+		 * of semantics, for now, we support soft limits for
+		 * control without swap
+		 */
+		if (type == _MEM)
+			ret = res_counter_set_soft_limit(&memcg->res, val);
+		else
+			ret = -EINVAL;
+		break;
 	default:
 		ret = -EINVAL; /* should be BUG() ? */
 		break;
@@ -2376,6 +2390,12 @@ static struct cftype mem_cgroup_files[] 
 		.read_u64 = mem_cgroup_read,
 	},
 	{
+		.name = "soft_limit_in_bytes",
+		.private = MEMFILE_PRIVATE(_MEM, RES_SOFT_LIMIT),
+		.write_string = mem_cgroup_write,
+		.read_u64 = mem_cgroup_read,
+	},
+	{
 		.name = "failcnt",
 		.private = MEMFILE_PRIVATE(_MEM, RES_FAILCNT),
 		.trigger = mem_cgroup_reset,
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

origin.patch

