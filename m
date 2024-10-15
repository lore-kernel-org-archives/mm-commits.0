Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3841B3948
	for <mm-commits@vger.kernel.org>; Tue, 15 Oct 2024 22:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729032953; cv=none; b=IuCYaUA7ofTqbVn3iZSV/BDyVOb4zIJTToKx13nMOmuzwVqp/XowzTPbSnwRwPqeTWXdEK3KWw0V2Hu7vsR4PegF5rbW2CQSKOT5Hw2/V/bqOs9Uvv6c1m6Cu8MgceOlqqIHX5kkLjtfEic5SazhnXli/jHHcpPObm0bL9o+ccQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729032953; c=relaxed/simple;
	bh=/do9T5XY9Y3M1sVSKqcDYAdp3eM64YLd83yrzzewAJU=;
	h=Date:To:From:Subject:Message-Id; b=jnm7vLvTBhLmq9ax3c451K7Ce3lLHlN2IB/VgGUjdxX2os7DLR/trpErcJOzjvvoaHajIKrUFvZZW+dJb7a1dr5T0AorTYhsGU1wy1HbGejQhVyZsVORt9SRB7XqRuW7O8cvvYtXgaNFITKItX54ASq44Xx64cQl5Nx1XMYVGns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HQ772xHU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HQ772xHU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB257C4CEC6;
	Tue, 15 Oct 2024 22:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729032952;
	bh=/do9T5XY9Y3M1sVSKqcDYAdp3eM64YLd83yrzzewAJU=;
	h=Date:To:From:Subject:From;
	b=HQ772xHUJPS/mJkTDlwkTQpu6fB6sOXk9OQCDw6qW2N1HKQndnLaFs1QLscELgFIY
	 9FkF1Z9SsWB4pU8MJGqZvSYDT369yEZWcNsqeylazWcSgUSsUkN//Lm6JUm/SuGH/b
	 jfwWJm9ml6EnAFPMRdpXjfP7ThrzYtpi21CLr6T8=
Date: Tue, 15 Oct 2024 15:55:52 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,songmuchun@bytedance.com,rostedt@goodmis.org,roman.gushchin@linux.dev,mhocko@suse.com,inwardvessel@gmail.com,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-add-tracing-for-memcg-stat-updates-v2.patch added to mm-unstable branch
Message-Id: <20241015225552.BB257C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg-add-tracing-for-memcg-stat-updates-v2
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-add-tracing-for-memcg-stat-updates-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-add-tracing-for-memcg-stat-updates-v2.patch

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
memcg-add-tracing-for-memcg-stat-updates-v2.patch

