Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A836219F6
	for <mm-commits@vger.kernel.org>; Sat, 11 May 2024 22:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715467347; cv=none; b=IJLRCgZ2rlxF1b5apo9B1Y4F8gpdBP5H+uaIC9azJeLKXlcCBh50XcreFAYTcq83JYkFEnObi0WJxZdxfxUse3B4g3IzdmNaYTq+tz/VdxnfE7/39ATBbDVPOAhTguzQ2nSm8QE0fAaydSGEwFMEwcpkoi81NXT8VytFZqtL/Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715467347; c=relaxed/simple;
	bh=3xutJpGHICFK5EWfqfXK/Lg85KXfK3GnBTNHyahPmsc=;
	h=Date:To:From:Subject:Message-Id; b=cNXWcp74nKoHvV8QVmn566PZIpi71Rygj4FN8r3bxZ50+okLeS66EnR+jXlsL/2UfWeL8tfKXLCiSc3RqhidbMpqgDoLcOrK2lre5zwwhBnjw3ZAVsljE9u0aLDCsPzbJRc4VI/DWTG9kDzGp8cONUPPyrAA8wv5vf22245JiAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xq4sFpJR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xq4sFpJR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB812C2BBFC;
	Sat, 11 May 2024 22:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715467346;
	bh=3xutJpGHICFK5EWfqfXK/Lg85KXfK3GnBTNHyahPmsc=;
	h=Date:To:From:Subject:From;
	b=xq4sFpJRts4iZ5WcdpRiQmyeqs6GWIMVrZMeWKJTOm/kLYArVtDoOM80hee6hRxSL
	 +7WEjZ12c4QtZLiAHEmLf/ukZm17NfcQWHs/MaEpmm5Qz8wzrjtJtWjkqL681PGvqW
	 DvYC/6RDncCjmVwGUyxOt79JFnP7PwpFDuj61F3Y=
Date: Sat, 11 May 2024 15:42:26 -0700
To: mm-commits@vger.kernel.org,vschneid@redhat.com,vincent.guittot@linaro.org,songmuchun@bytedance.com,shakeel.butt@linux.dev,rostedt@goodmis.org,roman.gushchin@linux.dev,peterz@infradead.org,mingo@redhat.com,mhocko@suse.com,mgorman@suse.de,juri.lelli@redhat.com,hannes@cmpxchg.org,dietmar.eggemann@arm.com,bsegall@google.com,bristot@redhat.com,xiujianfeng@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-oom-cleanup-unused-memcg_oom_gfp_mask-and-memcg_oom_order.patch removed from -mm tree
Message-Id: <20240511224226.DB812C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg, oom: cleanup unused memcg_oom_gfp_mask and memcg_oom_order
has been removed from the -mm tree.  Its filename was
     memcg-oom-cleanup-unused-memcg_oom_gfp_mask-and-memcg_oom_order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xiu Jianfeng <xiujianfeng@huawei.com>
Subject: memcg, oom: cleanup unused memcg_oom_gfp_mask and memcg_oom_order
Date: Thu, 9 May 2024 03:26:28 +0000

Since commit 857f21397f71 ("memcg, oom: remove unnecessary check in
mem_cgroup_oom_synchronize()"), memcg_oom_gfp_mask and memcg_oom_order are
no longer used any more.

Link: https://lkml.kernel.org/r/20240509032628.1217652-1-xiujianfeng@huawei.com
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Benjamin Segall <bsegall@google.com>
Cc: Daniel Bristot de Oliveira <bristot@redhat.com>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    2 --
 mm/memcontrol.c       |    2 --
 2 files changed, 4 deletions(-)

--- a/include/linux/sched.h~memcg-oom-cleanup-unused-memcg_oom_gfp_mask-and-memcg_oom_order
+++ a/include/linux/sched.h
@@ -1448,8 +1448,6 @@ struct task_struct {
 
 #ifdef CONFIG_MEMCG
 	struct mem_cgroup		*memcg_in_oom;
-	gfp_t				memcg_oom_gfp_mask;
-	int				memcg_oom_order;
 
 	/* Number of pages to reclaim on returning to userland: */
 	unsigned int			memcg_nr_pages_over_high;
--- a/mm/memcontrol.c~memcg-oom-cleanup-unused-memcg_oom_gfp_mask-and-memcg_oom_order
+++ a/mm/memcontrol.c
@@ -2188,8 +2188,6 @@ static bool mem_cgroup_oom(struct mem_cg
 		if (current->in_user_fault) {
 			css_get(&memcg->css);
 			current->memcg_in_oom = memcg;
-			current->memcg_oom_gfp_mask = mask;
-			current->memcg_oom_order = order;
 		}
 		return false;
 	}
_

Patches currently in -mm which might be from xiujianfeng@huawei.com are


