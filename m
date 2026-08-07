Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3373A6417;
	Fri,  7 Aug 2026 02:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068018; cv=none; b=tbKjp3m4BRMXkJju/b1604DfjsM4dTcQaClAHBYnBG9OuW7nl+hmnwB74DE+9ft/LVUOouMlvQZVrg2SkYB3qVOQuR3ZB819uClJHsgMsI4ERQgjgLvEPlz5agAzNzOI8yPE0b7rEOM0ZJJHhU0BCPh3CeQvfb4NJ0uOV4rUx5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068018; c=relaxed/simple;
	bh=q13mwXOfDj1yWBi5/FP75LuMh748vMXRPuq/MpRvMNQ=;
	h=Date:To:From:Subject:Message-Id; b=CsS6aqiiU6jbOfnEc0FlJM65cQb7I5mCTChYwd7hrBCiwOB/0HD6oocq0YkZ2JqosY0f29B3kotx3F34bM3MsA3wN+yqjNYSqyl+xoePYbjxdQZ86tjZG+KYw0NFAO3lTdJ28bNSlFqHKx+ltVJnT5d8og7sIVkV5+ekN7LQE9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LuHiKy7m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LuHiKy7m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD7E1F00A3D;
	Fri,  7 Aug 2026 02:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068009;
	bh=aDYvrNe+hwJM/nPB1kYfpxvQcIQJc7YjkZobH34uUNw=;
	h=Date:To:From:Subject;
	b=LuHiKy7mZZNhbHwvYVKJstKJ6HG1xdxeBQIHYh/ibk9YjJ6I6gWnZPKmZ5CxNkjZ7
	 TK2k9k7QYUmtjHZEOlCSVWEvGzG1JTHR4+yFMKGAExJrCkmA4NKgZ5CMIluw9IFZ8e
	 IiOpiScUNyW0kK5yrSExuvmxGPppjT9deUbyNxbk=
Date: Thu, 06 Aug 2026 19:00:08 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,zhangguopeng@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-v1-fix-wrong-linux-mm-list-address-in-deprecation-warnings.patch removed from -mm tree
Message-Id: <20260807020009.2AD7E1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg-v1: fix wrong linux-mm list address in deprecation warnings
has been removed from the -mm tree.  Its filename was
     mm-memcg-v1-fix-wrong-linux-mm-list-address-in-deprecation-warnings.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: mm: memcg-v1: fix wrong linux-mm list address in deprecation warnings
Date: Mon, 13 Jul 2026 16:57:56 +0800

The deprecation warnings for memory.oom_control and memory.pressure_level
use linux-mm-@kvack.org instead of the linux-mm mailing list address. 
Remove the extra hyphen.

Link: https://lore.kernel.org/20260713085756.2973549-1-guopeng.zhang@linux.dev
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/memcontrol-v1.c~mm-memcg-v1-fix-wrong-linux-mm-list-address-in-deprecation-warnings
+++ a/mm/memcontrol-v1.c
@@ -1182,13 +1182,13 @@ static ssize_t memcg_write_event_control
 		event->unregister_event = mem_cgroup_usage_unregister_event;
 	} else if (!strcmp(name, "memory.oom_control")) {
 		pr_warn_once("oom_control is deprecated and will be removed. "
-			     "Please report your usecase to linux-mm-@kvack.org"
+			     "Please report your usecase to linux-mm@kvack.org"
 			     " if you depend on this functionality.\n");
 		event->register_event = mem_cgroup_oom_register_event;
 		event->unregister_event = mem_cgroup_oom_unregister_event;
 	} else if (!strcmp(name, "memory.pressure_level")) {
 		pr_warn_once("pressure_level is deprecated and will be removed. "
-			     "Please report your usecase to linux-mm-@kvack.org "
+			     "Please report your usecase to linux-mm@kvack.org "
 			     "if you depend on this functionality.\n");
 		event->register_event = vmpressure_register_event;
 		event->unregister_event = vmpressure_unregister_event;
@@ -2340,7 +2340,7 @@ static int mem_cgroup_oom_control_write(
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 
 	pr_warn_once("oom_control is deprecated and will be removed. "
-		     "Please report your usecase to linux-mm-@kvack.org if you "
+		     "Please report your usecase to linux-mm@kvack.org if you "
 		     "depend on this functionality.\n");
 
 	/* cannot set to root cgroup and only 0 and 1 are allowed */
_

Patches currently in -mm which might be from zhangguopeng@kylinos.cn are

mm-memcg-stop-reclaim-when-a-limit-update-is-superseded.patch

