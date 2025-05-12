Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAEB71A08CA
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011149; cv=none; b=X8yFi6QqGZgdx/I2+luFloMHpN0UNP+3bGR0uprplnmxwZKnLOOrfzn4/MvYxjI6DFX4mII6JWEIoo+h2wa4BRJXMhgucjDhLJXc7yZDZMx59b4+04gHibz7u0CkSG7UbDkUuSk5cnbOOvC+TTwTOGJf8bkZfy47wiImsMezYN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011149; c=relaxed/simple;
	bh=WSKKq4rZonpyLApSCrO2m5seOBz2YQYuBU42oIcH5Qw=;
	h=Date:To:From:Subject:Message-Id; b=NBoLhDNqNUdtr9WqbZgKt7cswpf0WClV6N/UgB9KePF0SViuZV/jJpm6RbFmb4EdGgcDFdYaBhQkb+9e/s4oulp8c5SsCS/F3M7aBZ9l4uQeCFZZvqLr4BDliXM8jH7wW/216SfkkgJugfE1nLrhUEFeFJY2acq7MfzJkpnmR5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rHaGXIUt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rHaGXIUt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 923D3C4CEE4;
	Mon, 12 May 2025 00:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011149;
	bh=WSKKq4rZonpyLApSCrO2m5seOBz2YQYuBU42oIcH5Qw=;
	h=Date:To:From:Subject:From;
	b=rHaGXIUt4Ga37RY4scT9KQg2VzlUEMSwIrnyY+T6WoLHbYCx+YLSFEWbkn+mtAx5y
	 uPypzWJBSQko9jrd64chQO4UurKeXIJ8j2xwG8S/ZUM+YjXSuUBGAPUnhG+L1VnO2X
	 UrYWaLKlmkTi9mUB2+eCPm/ueWEmbpGE4E04dSnY=
Date: Sun, 11 May 2025 17:52:29 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,nichen@iscas.ac.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-remove-unnecessary-null-check-before-free_percpu.patch removed from -mm tree
Message-Id: <20250512005229.923D3C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcontrol: remove unnecessary NULL check before free_percpu()
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-remove-unnecessary-null-check-before-free_percpu.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chen Ni <nichen@iscas.ac.cn>
Subject: mm: memcontrol: remove unnecessary NULL check before free_percpu()
Date: Thu, 17 Apr 2025 16:43:30 +0800

free_percpu() checks for NULL pointers internally.  Remove unneeded NULL
check here.

Link: https://lkml.kernel.org/r/20250417084330.937380-1-nichen@iscas.ac.cn
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/memcontrol-v1.c~mm-memcontrol-remove-unnecessary-null-check-before-free_percpu
+++ a/mm/memcontrol-v1.c
@@ -2198,8 +2198,7 @@ bool memcg1_alloc_events(struct mem_cgro
 
 void memcg1_free_events(struct mem_cgroup *memcg)
 {
-	if (memcg->events_percpu)
-		free_percpu(memcg->events_percpu);
+	free_percpu(memcg->events_percpu);
 }
 
 static int __init memcg1_init(void)
_

Patches currently in -mm which might be from nichen@iscas.ac.cn are

ocfs2-remove-unnecessary-null-check-before-unregister_sysctl_table.patch

