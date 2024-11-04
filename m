Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7A9290F
	for <mm-commits@vger.kernel.org>; Mon,  4 Nov 2024 04:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730695878; cv=none; b=ZFw5mMZNDUyZgnQGglawsNepbu/WEQr6r9H0gydZ76xrx1EkfHJzSqpzVCXZn2yUsKeQ9VBEwHGqqVgaLwSoY3Jsgnx+oF7cJ8sGwWoHDMsf+AjCSfGCmRl5ONpOJ+FtmN3D/O5lEo3fsKO9sWAeJFKW5J+DY5Prs8cuCI8Y5wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730695878; c=relaxed/simple;
	bh=AGPe8aHZ8bmi6oxC1KoFHxG+yYtKyiLpl/zMltbIEXU=;
	h=Date:To:From:Subject:Message-Id; b=VcbhNhbduHlXilxvxaZtXVk+ZbtvtSz6Db9IZNQcQKvyRguGY0MuPCD8LIKEyMKMW+x0u5m3WoRMqP0qlw19YGJvLrqneV7/4iRNSQjx/0kzR/x2TouQpCJmDIiWxpvNGMcgDrJLPi//grTrZogfPuv4L2TWtJl6S3W7rBpE4lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k2ZnqyQ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k2ZnqyQ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE18C4CECE;
	Mon,  4 Nov 2024 04:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730695878;
	bh=AGPe8aHZ8bmi6oxC1KoFHxG+yYtKyiLpl/zMltbIEXU=;
	h=Date:To:From:Subject:From;
	b=k2ZnqyQ5Q3iZmpKuFbwLaQu1MY8CPEV5qzhwYaY83g0HxDjqGJQqSjKRsk7baXytw
	 BjIk99HmPwCFVXTTbEdcKTC2DK0Y324/IsNXKlU/at3UCjSB3Dz3jaSGveEqpkXzTT
	 CNCp0awNi52WeaYlOsq+BG9l9izLueWiWt3dvUZY=
Date: Sun, 03 Nov 2024 20:51:17 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,songmuchun@bytedance.com,rostedt@goodmis.org,roman.gushchin@linux.dev,mhocko@suse.com,inwardvessel@gmail.com,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] memcg-add-tracing-for-memcg-stat-updates-v2.patch removed from -mm tree
Message-Id: <20241104045117.EBE18C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg-add-tracing-for-memcg-stat-updates-v2
has been removed from the -mm tree.  Its filename was
     memcg-add-tracing-for-memcg-stat-updates-v2.patch

This patch was dropped because it was folded into memcg-add-tracing-for-memcg-stat-updates.patch

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg-add-tracing-for-memcg-stat-updates-v2
Date: Tue, 15 Oct 2024 14:37:21 -0700

use unsigned long type for memcg_rstat_events, per Yosry

Link: https://lkml.kernel.org/r/20241015213721.3804209-1-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: JP Kobryn <inwardvessel@gmail.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/memcg.h |   32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

--- a/include/trace/events/memcg.h~memcg-add-tracing-for-memcg-stat-updates-v2
+++ a/include/trace/events/memcg.h
@@ -9,7 +9,7 @@
 #include <linux/tracepoint.h>
 
 
-DECLARE_EVENT_CLASS(memcg_rstat,
+DECLARE_EVENT_CLASS(memcg_rstat_stats,
 
 	TP_PROTO(struct mem_cgroup *memcg, int item, int val),
 
@@ -31,23 +31,45 @@ DECLARE_EVENT_CLASS(memcg_rstat,
 		  __entry->id, __entry->item, __entry->val)
 );
 
-DEFINE_EVENT(memcg_rstat, mod_memcg_state,
+DEFINE_EVENT(memcg_rstat_stats, mod_memcg_state,
 
 	TP_PROTO(struct mem_cgroup *memcg, int item, int val),
 
 	TP_ARGS(memcg, item, val)
 );
 
-DEFINE_EVENT(memcg_rstat, mod_memcg_lruvec_state,
+DEFINE_EVENT(memcg_rstat_stats, mod_memcg_lruvec_state,
 
 	TP_PROTO(struct mem_cgroup *memcg, int item, int val),
 
 	TP_ARGS(memcg, item, val)
 );
 
-DEFINE_EVENT(memcg_rstat, count_memcg_events,
+DECLARE_EVENT_CLASS(memcg_rstat_events,
 
-	TP_PROTO(struct mem_cgroup *memcg, int item, int val),
+	TP_PROTO(struct mem_cgroup *memcg, int item, unsigned long val),
+
+	TP_ARGS(memcg, item, val),
+
+	TP_STRUCT__entry(
+		__field(u64, id)
+		__field(int, item)
+		__field(unsigned long, val)
+	),
+
+	TP_fast_assign(
+		__entry->id = cgroup_id(memcg->css.cgroup);
+		__entry->item = item;
+		__entry->val = val;
+	),
+
+	TP_printk("memcg_id=%llu item=%d val=%lu",
+		  __entry->id, __entry->item, __entry->val)
+);
+
+DEFINE_EVENT(memcg_rstat_events, count_memcg_events,
+
+	TP_PROTO(struct mem_cgroup *memcg, int item, unsigned long val),
 
 	TP_ARGS(memcg, item, val)
 );
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

mm-optimize-truncation-of-shadow-entries.patch
mm-optimize-invalidation-of-shadow-entries.patch
mm-truncate-reset-xa_has_values-flag-on-each-iteration.patch
memcg-add-tracing-for-memcg-stat-updates.patch
memcg-v1-fully-deprecate-move_charge_at_immigrate.patch
memcg-v1-remove-charge-move-code.patch
memcg-v1-no-need-for-memcg-locking-for-dirty-tracking.patch
memcg-v1-no-need-for-memcg-locking-for-writeback-tracking.patch
memcg-v1-no-need-for-memcg-locking-for-mglru.patch
memcg-v1-no-need-for-memcg-locking-for-mglru-fix-2.patch
memcg-v1-remove-memcg-move-locking-code.patch
memcg-workingset-remove-folio_memcg_rcu-usage.patch

