Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9D938DC74
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068023; cv=none; b=QCfe1mlUsmQnxC9BFaDTA0GIUqOIM8/fYrjgfKUpWhEf4LE9wYv5xmvRJvIghkJsQ8MWE0vyopllDC+NNlHuX5VkUMT0qtnG2SAqKlaWi5vyJ7BgN6J+lbDzZvj8o4QGFuuNTMZiCfSXnGbvCTTXKJ7QT2+I9a9S3mAsnJjrHNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068023; c=relaxed/simple;
	bh=cVgC/deQxyR+05OhwOaeDTMaFmXOcHFrXZjHpSpqalc=;
	h=Date:To:From:Subject:Message-Id; b=by45DiEellH3Zr3bO5T8T0gR3sVyRRkTEKOeZw7MXyOFrFDy/AHMWG8Nhh2N5bhz+f4qeJAfBaMHpRGjY+kv+Sz9oH21unS5l5j7f6WjAXZly2GB08b3zYihjxuruDpohSwj3nFM1hAahzT7IOtvTT/dOW5za6dHgEcHjjuHJlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xbWUsigX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xbWUsigX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1ADD1F000E9;
	Fri,  7 Aug 2026 02:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068013;
	bh=rUlC/8C4M4+7WiPkKpOOBEz0EzWDD4QKHBv/5N/UcLo=;
	h=Date:To:From:Subject;
	b=xbWUsigXVP3QU0THJax//rnFL7M65VajjOga+NZp1vE1u+QvIGnhtaomaTAL8rkdU
	 ahdozcHWWovF1uqeG/2PlQBupdpLMYmWnU3n3WCFwdlGCqcXSy0xpojwOAxPwdXEYU
	 u567YCac76iSliaqQWdmqxrFEwRDaP92yA6SAhHQ=
Date: Thu, 06 Aug 2026 19:00:12 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,zhangguopeng@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-v1-make-mem_cgroup_oom_notify_cb-return-void.patch removed from -mm tree
Message-Id: <20260807020012.E1ADD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg-v1: make mem_cgroup_oom_notify_cb() return void
has been removed from the -mm tree.  Its filename was
     mm-memcg-v1-make-mem_cgroup_oom_notify_cb-return-void.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: mm: memcg-v1: make mem_cgroup_oom_notify_cb() return void
Date: Mon, 13 Jul 2026 17:37:37 +0800

Commit 7d74b06f240f ("memcg: use for_each_mem_cgroup") replaced the
mem_cgroup_walk_tree() call in mem_cgroup_oom_notify() with
for_each_mem_cgroup_tree(), but left mem_cgroup_oom_notify_cb() with the
int return type required by the old callback interface.

The function now has a single direct caller and no failure path.  Make it
return void.

Link: https://lore.kernel.org/20260713093737.3299646-1-guopeng.zhang@linux.dev
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: SJ Park <sj@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/memcontrol-v1.c~mm-memcg-v1-make-mem_cgroup_oom_notify_cb-return-void
+++ a/mm/memcontrol-v1.c
@@ -752,7 +752,7 @@ static int compare_thresholds(const void
 	return 0;
 }
 
-static int mem_cgroup_oom_notify_cb(struct mem_cgroup *memcg)
+static void mem_cgroup_oom_notify_cb(struct mem_cgroup *memcg)
 {
 	struct mem_cgroup_eventfd_list *ev;
 
@@ -762,7 +762,6 @@ static int mem_cgroup_oom_notify_cb(stru
 		eventfd_signal(ev->eventfd);
 
 	spin_unlock(&memcg_oom_lock);
-	return 0;
 }
 
 static void mem_cgroup_oom_notify(struct mem_cgroup *memcg)
_

Patches currently in -mm which might be from zhangguopeng@kylinos.cn are

mm-memcg-stop-reclaim-when-a-limit-update-is-superseded.patch

