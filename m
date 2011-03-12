From: akpm@linux-foundation.org
Subject: + memcg-add-cgroupfs-interface-to-memcg-dirty-limits.patch added to -mm tree
Date: Fri, 11 Mar 2011 17:23:18 -0800
Message-ID: <201103120123.p2C1NJ2f007057@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42516 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752963Ab1CLBYL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Mar 2011 20:24:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gthelen@google.com, arighi@develer.com, balbir@linux.vnet.ibm.com, ctalbott@google.com, fengguang.wu@intel.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp, rientjes@google.com, teravest@google.com


The patch titled
     memcg: add cgroupfs interface to memcg dirty limits
has been added to the -mm tree.  Its filename is
     memcg-add-cgroupfs-interface-to-memcg-dirty-limits.patch

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
Subject: memcg: add cgroupfs interface to memcg dirty limits
From: Greg Thelen <gthelen@google.com>

Add cgroupfs interface to memcg dirty page limits:
  Direct write-out is controlled with:
  - memory.dirty_ratio
  - memory.dirty_limit_in_bytes

  Background write-out is controlled with:
  - memory.dirty_background_ratio
  - memory.dirty_background_limit_bytes

Other memcg cgroupfs files support 'M', 'm', 'k', 'K', 'g' and 'G'
suffixes for byte counts.  This patch provides the same functionality for
memory.dirty_limit_in_bytes and memory.dirty_background_limit_bytes.

Signed-off-by: Andrea Righi <arighi@develer.com>
Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Greg Thelen <gthelen@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Chad Talbott <ctalbott@google.com>
Cc: Justin TerAvest <teravest@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |  114 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 114 insertions(+)

diff -puN mm/memcontrol.c~memcg-add-cgroupfs-interface-to-memcg-dirty-limits mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-cgroupfs-interface-to-memcg-dirty-limits
+++ a/mm/memcontrol.c
@@ -113,6 +113,13 @@ enum mem_cgroup_events_target {
 #define THRESHOLDS_EVENTS_TARGET (128)
 #define SOFTLIMIT_EVENTS_TARGET (1024)
 
+enum {
+	MEM_CGROUP_DIRTY_RATIO,
+	MEM_CGROUP_DIRTY_LIMIT_IN_BYTES,
+	MEM_CGROUP_DIRTY_BACKGROUND_RATIO,
+	MEM_CGROUP_DIRTY_BACKGROUND_LIMIT_IN_BYTES,
+};
+
 struct mem_cgroup_stat_cpu {
 	long count[MEM_CGROUP_STAT_NSTATS];
 	unsigned long events[MEM_CGROUP_EVENTS_NSTATS];
@@ -4391,6 +4398,89 @@ static int mem_cgroup_oom_control_write(
 	return 0;
 }
 
+static u64 mem_cgroup_dirty_read(struct cgroup *cgrp, struct cftype *cft)
+{
+	struct mem_cgroup *mem = mem_cgroup_from_cont(cgrp);
+	bool use_sys = !mem_cgroup_has_dirty_limit(mem);
+
+	switch (cft->private) {
+	case MEM_CGROUP_DIRTY_RATIO:
+		return use_sys ? vm_dirty_ratio : mem->dirty_param.dirty_ratio;
+	case MEM_CGROUP_DIRTY_LIMIT_IN_BYTES:
+		return use_sys ? vm_dirty_bytes : mem->dirty_param.dirty_bytes;
+	case MEM_CGROUP_DIRTY_BACKGROUND_RATIO:
+		return use_sys ? dirty_background_ratio :
+			mem->dirty_param.dirty_background_ratio;
+	case MEM_CGROUP_DIRTY_BACKGROUND_LIMIT_IN_BYTES:
+		return use_sys ? dirty_background_bytes :
+			mem->dirty_param.dirty_background_bytes;
+	default:
+		BUG();
+	}
+}
+
+static int
+mem_cgroup_dirty_write_string(struct cgroup *cgrp, struct cftype *cft,
+				const char *buffer)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
+	int type = cft->private;
+	int ret = -EINVAL;
+	unsigned long long val;
+
+	if (!mem_cgroup_has_dirty_limit(memcg))
+		return ret;
+
+	switch (type) {
+	case MEM_CGROUP_DIRTY_LIMIT_IN_BYTES:
+		/* This function does all necessary parse...reuse it */
+		ret = res_counter_memparse_write_strategy(buffer, &val);
+		if (ret)
+			break;
+		memcg->dirty_param.dirty_bytes = val;
+		memcg->dirty_param.dirty_ratio  = 0;
+		break;
+	case MEM_CGROUP_DIRTY_BACKGROUND_LIMIT_IN_BYTES:
+		ret = res_counter_memparse_write_strategy(buffer, &val);
+		if (ret)
+			break;
+		memcg->dirty_param.dirty_background_bytes = val;
+		memcg->dirty_param.dirty_background_ratio = 0;
+		break;
+	default:
+		BUG();
+		break;
+	}
+	return ret;
+}
+
+static int
+mem_cgroup_dirty_write(struct cgroup *cgrp, struct cftype *cft, u64 val)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
+	int type = cft->private;
+
+	if (!mem_cgroup_has_dirty_limit(memcg))
+		return -EINVAL;
+	if ((type == MEM_CGROUP_DIRTY_RATIO ||
+	     type == MEM_CGROUP_DIRTY_BACKGROUND_RATIO) && val > 100)
+		return -EINVAL;
+	switch (type) {
+	case MEM_CGROUP_DIRTY_RATIO:
+		memcg->dirty_param.dirty_ratio = val;
+		memcg->dirty_param.dirty_bytes = 0;
+		break;
+	case MEM_CGROUP_DIRTY_BACKGROUND_RATIO:
+		memcg->dirty_param.dirty_background_ratio = val;
+		memcg->dirty_param.dirty_background_bytes = 0;
+		break;
+	default:
+		BUG();
+		break;
+	}
+	return 0;
+}
+
 static struct cftype mem_cgroup_files[] = {
 	{
 		.name = "usage_in_bytes",
@@ -4454,6 +4544,30 @@ static struct cftype mem_cgroup_files[] 
 		.unregister_event = mem_cgroup_oom_unregister_event,
 		.private = MEMFILE_PRIVATE(_OOM_TYPE, OOM_CONTROL),
 	},
+	{
+		.name = "dirty_ratio",
+		.read_u64 = mem_cgroup_dirty_read,
+		.write_u64 = mem_cgroup_dirty_write,
+		.private = MEM_CGROUP_DIRTY_RATIO,
+	},
+	{
+		.name = "dirty_limit_in_bytes",
+		.read_u64 = mem_cgroup_dirty_read,
+		.write_string = mem_cgroup_dirty_write_string,
+		.private = MEM_CGROUP_DIRTY_LIMIT_IN_BYTES,
+	},
+	{
+		.name = "dirty_background_ratio",
+		.read_u64 = mem_cgroup_dirty_read,
+		.write_u64 = mem_cgroup_dirty_write,
+		.private = MEM_CGROUP_DIRTY_BACKGROUND_RATIO,
+	},
+	{
+		.name = "dirty_background_limit_in_bytes",
+		.read_u64 = mem_cgroup_dirty_read,
+		.write_string = mem_cgroup_dirty_write_string,
+		.private = MEM_CGROUP_DIRTY_BACKGROUND_LIMIT_IN_BYTES,
+	},
 };
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
_

Patches currently in -mm which might be from gthelen@google.com are

linux-next.patch
memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch
memcg-break-out-event-counters-from-other-stats.patch
memcg-use-native-word-page-statistics-counters.patch
mm-memcontrolc-suppress-uninitializer-var-warning-with-older-gccs.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-add-dirty-page-accounting-infrastructure.patch
memcg-add-kernel-calls-for-memcg-dirty-page-stats.patch
memcg-add-dirty-limits-to-mem_cgroup.patch
memcg-add-cgroupfs-interface-to-memcg-dirty-limits.patch
memcg-add-dirty-limiting-routines.patch
memcg-check-memcg-dirty-limits-in-page-writeback.patch
memcg-make-background-writeback-memcg-aware.patch

