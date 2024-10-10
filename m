Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5657619A2A3
	for <mm-commits@vger.kernel.org>; Thu, 10 Oct 2024 21:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728596776; cv=none; b=J5PBXTELeSvJbVvv9DWtM7u6tgEOsXNh/FTwyL3R5dDhPXwUlqbqDWZp/otaiTUGby1KPTbhe8Rglwjz3cPy908+UVF3JAgJUgqboju9PCbzf696eGjHqlq3wWSqpGBwxEYCEBoAUpLEiNkag4Ju3WAoeJzNnQnCdnYTZ20DIQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728596776; c=relaxed/simple;
	bh=pFgcXliqxHkJi0hwcbSeLi+45hK212qk3AaG0YJghco=;
	h=Date:To:From:Subject:Message-Id; b=BcpBz9IWI0F6cbJQLQdU7P0tO752mlK5upMW8JlOZB6mD+8+EyCi0ZsgG3gL6pe5fq68WIlRdOrN9nB2YzjQnQ76WiRA/2HHLSJtPQWv2+0ooLpaO3tZS370QwD1wLFU9mmgnQOUh7m+OoYRtbsXF+m+l+6AwO9Rsw5oWbxICLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yyWAREdC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yyWAREdC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C15E6C4CEC5;
	Thu, 10 Oct 2024 21:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728596775;
	bh=pFgcXliqxHkJi0hwcbSeLi+45hK212qk3AaG0YJghco=;
	h=Date:To:From:Subject:From;
	b=yyWAREdCfr+RoOgCTeNr2phLbpayPrkRGRgF0rYnQDip+BpSTEA4euIk+qLl1iq9r
	 Ems5e/reWe8IucRtUSDLEiXY0mg163FUfEekD+vLNaGW8TQo84wex5ajV0Yr4dMfQw
	 k/86pc0QL5DxV+naYyudVFcuidj6gYu5Y9lEEK7s=
Date: Thu, 10 Oct 2024 14:46:15 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,songmuchun@bytedance.com,rostedt@goodmis.org,roman.gushchin@linux.dev,mhocko@suse.com,inwardvessel@gmail.com,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-add-tracing-for-memcg-stat-updates.patch added to mm-unstable branch
Message-Id: <20241010214615.C15E6C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: add tracing for memcg stat updates
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-add-tracing-for-memcg-stat-updates.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-add-tracing-for-memcg-stat-updates.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: add tracing for memcg stat updates
Date: Wed, 9 Oct 2024 17:35:50 -0700

The memcg stats are maintained in rstat infrastructure which provides very
fast updates side and reasonable read side.  However memcg added plethora
of stats and made the read side, which is cgroup rstat flush, very slow. 
To solve that, threshold was added in the memcg stats read side i.e.  no
need to flush the stats if updates are within the threshold.

This threshold based improvement worked for sometime but more stats were
added to memcg and also the read codepath was getting triggered in the
performance sensitive paths which made threshold based ratelimiting
ineffective.  We need more visibility into the hot and cold stats i.e. 
stats with a lot of updates.  Let's add trace to get that visibility.

Link: https://lkml.kernel.org/r/20241010003550.3695245-1-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: JP Kobryn <inwardvessel@gmail.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/memcg.h |   59 +++++++++++++++++++++++++++++++++
 mm/memcontrol.c              |   13 ++++++-
 2 files changed, 70 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/memcg.h a/include/trace/events/memcg.h
new file mode 100644
--- /dev/null
+++ a/include/trace/events/memcg.h
@@ -0,0 +1,59 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM memcg
+
+#if !defined(_TRACE_MEMCG_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_MEMCG_H
+
+#include <linux/memcontrol.h>
+#include <linux/tracepoint.h>
+
+
+DECLARE_EVENT_CLASS(memcg_rstat,
+
+	TP_PROTO(struct mem_cgroup *memcg, int item, int val),
+
+	TP_ARGS(memcg, item, val),
+
+	TP_STRUCT__entry(
+		__field(u64, id)
+		__field(int, item)
+		__field(int, val)
+	),
+
+	TP_fast_assign(
+		__entry->id = cgroup_id(memcg->css.cgroup);
+		__entry->item = item;
+		__entry->val = val;
+	),
+
+	TP_printk("memcg_id=%llu item=%d val=%d",
+		  __entry->id, __entry->item, __entry->val)
+);
+
+DEFINE_EVENT(memcg_rstat, mod_memcg_state,
+
+	TP_PROTO(struct mem_cgroup *memcg, int item, int val),
+
+	TP_ARGS(memcg, item, val)
+);
+
+DEFINE_EVENT(memcg_rstat, mod_memcg_lruvec_state,
+
+	TP_PROTO(struct mem_cgroup *memcg, int item, int val),
+
+	TP_ARGS(memcg, item, val)
+);
+
+DEFINE_EVENT(memcg_rstat, count_memcg_events,
+
+	TP_PROTO(struct mem_cgroup *memcg, int item, int val),
+
+	TP_ARGS(memcg, item, val)
+);
+
+
+#endif /* _TRACE_MEMCG_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
--- a/mm/memcontrol.c~memcg-add-tracing-for-memcg-stat-updates
+++ a/mm/memcontrol.c
@@ -71,6 +71,10 @@
 
 #include <linux/uaccess.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/memcg.h>
+#undef CREATE_TRACE_POINTS
+
 #include <trace/events/vmscan.h>
 
 struct cgroup_subsys memory_cgrp_subsys __read_mostly;
@@ -682,7 +686,9 @@ void __mod_memcg_state(struct mem_cgroup
 		return;
 
 	__this_cpu_add(memcg->vmstats_percpu->state[i], val);
-	memcg_rstat_updated(memcg, memcg_state_val_in_pages(idx, val));
+	val = memcg_state_val_in_pages(idx, val);
+	memcg_rstat_updated(memcg, val);
+	trace_mod_memcg_state(memcg, idx, val);
 }
 
 /* idx can be of type enum memcg_stat_item or node_stat_item. */
@@ -741,7 +747,9 @@ static void __mod_memcg_lruvec_state(str
 	/* Update lruvec */
 	__this_cpu_add(pn->lruvec_stats_percpu->state[i], val);
 
-	memcg_rstat_updated(memcg, memcg_state_val_in_pages(idx, val));
+	val = memcg_state_val_in_pages(idx, val);
+	memcg_rstat_updated(memcg, val);
+	trace_mod_memcg_lruvec_state(memcg, idx, val);
 	memcg_stats_unlock();
 }
 
@@ -832,6 +840,7 @@ void __count_memcg_events(struct mem_cgr
 	memcg_stats_lock();
 	__this_cpu_add(memcg->vmstats_percpu->events[i], count);
 	memcg_rstat_updated(memcg, count);
+	trace_count_memcg_events(memcg, idx, count);
 	memcg_stats_unlock();
 }
 
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

mm-optimize-truncation-of-shadow-entries.patch
mm-optimize-invalidation-of-shadow-entries.patch
mm-truncate-reset-xa_has_values-flag-on-each-iteration.patch
memcg-add-tracing-for-memcg-stat-updates.patch

