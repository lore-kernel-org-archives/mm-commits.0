Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B20F5318ED9
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486676; cv=none; b=cHpAfTzpec6z2FXx/ZNQe3n3ZNu0j0zOgDhjaBBcfrsjp2hrRJH13SYWZVFLITb8ITcXTB6MSsPpIIO/rP77qbnnKNmyZtGHSaZIdAzy37KK/WZcZlg4J1FS5E0lvGPZhkkYFamjjblF7o3aU26YN//G5mEVELciTsiGU6vtWRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486676; c=relaxed/simple;
	bh=CWucjrjzBe2e4cKVEHLPb9jig0dgJjAAUrnny53P0NI=;
	h=Date:To:From:Subject:Message-Id; b=mtvtAhrZyJzVJu/AHrOtEbZUJepvcjMvjiI/LFCe3x7QAhMT3y66E6G86iUkqwBm1qgmtvDbz5f0rpFPhBZaHQiDIvhs86+oMds2j/EOmz0ZSTb9hsnrSOoa+STRH0iJYdsFJE+52izitjUEYQ2HP5nscKKzLwlyLon+24DAI90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NxxBx/OV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NxxBx/OV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A651C116C6;
	Tue, 27 Jan 2026 04:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486676;
	bh=CWucjrjzBe2e4cKVEHLPb9jig0dgJjAAUrnny53P0NI=;
	h=Date:To:From:Subject:From;
	b=NxxBx/OV1gK1IaZ4IfK82OvDhTGhcjjwyPKSALIsTh/M8UY2MAveu9b05Si9R5v/2
	 ZPrAwuTqBqt7qvfUkGFom+2rXrrtEpTpMESZavbsJtrvRfpwT0fUyjn5mjkfbSNkRd
	 PlYy0un6JMneRQLxiqyS1VxwyOjTYGH/kNVx2j5s=
Date: Mon, 26 Jan 2026 20:04:36 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,sj@kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,david@kernel.org,david@fromorbit.com,axelrasmussen@google.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-mem_cgroup_get_from_ino-returns-null-on-error.patch removed from -mm tree
Message-Id: <20260127040436.8A651C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: mem_cgroup_get_from_ino() returns NULL on error
has been removed from the -mm tree.  Its filename was
     memcg-mem_cgroup_get_from_ino-returns-null-on-error.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: mem_cgroup_get_from_ino() returns NULL on error
Date: Thu, 25 Dec 2025 15:21:11 -0800

Change mem_cgroup_get_from_ino() to return NULL on error instead of
ERR_PTR values.  This simplifies the API: NULL indicates failure, and a
valid pointer indicates success with a CSS reference held that the caller
must release via mem_cgroup_put().

Link: https://lkml.kernel.org/r/20251225232116.294540-4-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: SeongJae Park <sj@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c     |    6 ++----
 mm/shrinker_debug.c |    2 +-
 2 files changed, 3 insertions(+), 5 deletions(-)

--- a/mm/memcontrol.c~memcg-mem_cgroup_get_from_ino-returns-null-on-error
+++ a/mm/memcontrol.c
@@ -3624,17 +3624,15 @@ struct mem_cgroup *mem_cgroup_get_from_i
 {
 	struct cgroup *cgrp;
 	struct cgroup_subsys_state *css;
-	struct mem_cgroup *memcg;
+	struct mem_cgroup *memcg = NULL;
 
 	cgrp = cgroup_get_from_id(ino);
 	if (IS_ERR(cgrp))
-		return ERR_CAST(cgrp);
+		return NULL;
 
 	css = cgroup_get_e_css(cgrp, &memory_cgrp_subsys);
 	if (css)
 		memcg = container_of(css, struct mem_cgroup, css);
-	else
-		memcg = ERR_PTR(-ENOENT);
 
 	cgroup_put(cgrp);
 
--- a/mm/shrinker_debug.c~memcg-mem_cgroup_get_from_ino-returns-null-on-error
+++ a/mm/shrinker_debug.c
@@ -130,7 +130,7 @@ static ssize_t shrinker_debugfs_scan_wri
 
 	if (shrinker->flags & SHRINKER_MEMCG_AWARE) {
 		memcg = mem_cgroup_get_from_ino(ino);
-		if (!memcg || IS_ERR(memcg))
+		if (!memcg)
 			return -ENOENT;
 
 		if (!mem_cgroup_online(memcg)) {
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


