Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D72315D3A
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 03:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486144; cv=none; b=SxYULNHTey/ITEWTTBBxzgI0qYZTHK1MWg8pfp3WC7y1MWmq/Zrtig52+0sHKbpMXBhFE84B8zZFiBZZ56+jA9pR2ye74wEW8VQrMmMpg8VLTOZYnD/43r3J7cmEO5z1jMZk4v/KgelBA5ifCuCwoZT5O7y95ev9azrSKnkxsa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486144; c=relaxed/simple;
	bh=ci0QcFzsG+9D9KgcPRvJhhwRhIsWPOHg5GugN7bNyq0=;
	h=Date:To:From:Subject:Message-Id; b=W0j7kbzeuOAi90cBKaLmIyXprWXw+AeTnhv5sEUodSfgji5VXrs+SlopOeIgHl1z5yTk8ZhYbbqUqpp01gTsTRclreeWsa2/XXeJtiSuop5eDrHzV9Z7eetNTwM90g6gcdNcWyJBE25MaEvBz3gpia+2wJwNQO0PoK561YXYJ4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Jwp7Evp0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Jwp7Evp0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 433AAC116C6;
	Tue, 27 Jan 2026 03:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486144;
	bh=ci0QcFzsG+9D9KgcPRvJhhwRhIsWPOHg5GugN7bNyq0=;
	h=Date:To:From:Subject:From;
	b=Jwp7Evp0A45lrX4NqUjh/T3wrcjE4PLfoudvbsCryPX/t8MoXrsYLgRZA1hjrAw4r
	 xxWCJt47op5U8g7qkcLFoKEw9l3KfElyY7OfUqKsErA49W565dGqgM7VdVP3k1uCLw
	 kAy64OBLt4Ygrl0hCPk5FsuSFZgdiSMh2SHLEqRs=
Date: Mon, 26 Jan 2026 19:55:43 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix.patch removed from -mm tree
Message-Id: <20260127035544.433AAC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix
has been removed from the -mm tree.  Its filename was
     memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix.patch

This patch was dropped because it was folded into memcg-rename-mem_cgroup_ino-to-mem_cgroup_id.patch

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix
Date: Mon, 12 Jan 2026 13:34:27 -0800

replace ino with id, per SeongJae

Link: https://lkml.kernel.org/r/flkqanhyettp5uq22bjwg37rtmnpeg3mghznsylxcxxgaafpl4@nov2x7tagma7
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 ++--
 mm/memcontrol.c            |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/memcontrol.h~memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix
+++ a/include/linux/memcontrol.h
@@ -835,7 +835,7 @@ static inline u64 mem_cgroup_id(struct m
 	return memcg ? cgroup_id(memcg->css.cgroup) : 0;
 }
 
-struct mem_cgroup *mem_cgroup_get_from_id(u64 ino);
+struct mem_cgroup *mem_cgroup_get_from_id(u64 id);
 
 static inline struct mem_cgroup *mem_cgroup_from_seq(struct seq_file *m)
 {
@@ -1293,7 +1293,7 @@ static inline u64 mem_cgroup_id(struct m
 	return 0;
 }
 
-static inline struct mem_cgroup *mem_cgroup_get_from_id(u64 ino)
+static inline struct mem_cgroup *mem_cgroup_get_from_id(u64 id)
 {
 	return NULL;
 }
--- a/mm/memcontrol.c~memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix
+++ a/mm/memcontrol.c
@@ -3615,7 +3615,7 @@ struct mem_cgroup *mem_cgroup_from_priva
 	return xa_load(&mem_cgroup_private_ids, id);
 }
 
-struct mem_cgroup *mem_cgroup_get_from_id(u64 ino)
+struct mem_cgroup *mem_cgroup_get_from_id(u64 id)
 {
 	struct cgroup *cgrp;
 	struct cgroup_subsys_state *css;
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-introduce-private-id-api-for-in-kernel-users.patch
memcg-expose-mem_cgroup_ino-and-mem_cgroup_get_from_ino-unconditionally.patch
memcg-mem_cgroup_get_from_ino-returns-null-on-error.patch
memcg-use-cgroup_id-instead-of-cgroup_ino-for-memcg-id.patch
mm-damon-use-cgroup-id-instead-of-private-memcg-id.patch
mm-vmscan-use-cgroup-id-instead-of-private-memcg-id-in-lru_gen-interface.patch
memcg-remove-unused-mem_cgroup_id-and-mem_cgroup_from_id.patch
memcg-rename-mem_cgroup_ino-to-mem_cgroup_id.patch

