Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE3231283E;
	Mon, 13 Jul 2026 19:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783972760; cv=none; b=New4Qp4Btti3tcpCgGgz0RKJ2UKPpWGQbGFWGXrYhWo7jIJ7tPlq+auVaeD7/ARlWV+Gk+9SL83EfQZItazWJEYIjME7EP/oPqJTDHyDUGi2fRztIKPqTyG4ua0JQzWgZg8oDbTciciJadYMEZnbW722SuW5udE4AsLNchPD9Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783972760; c=relaxed/simple;
	bh=Apy9mRRYzWmoQg6ncTKp2wNjakOPkPBVy71t6WXPbyo=;
	h=Date:To:From:Subject:Message-Id; b=As8OontdF/UzS1i4o4cLh+/vt6OB1gP0LCJpq/xRBpcTcy6HrH/iyEsbQHkNyT0gHb4S0aWhI+OIBYccS9eYRtYbJwIbP3PLs65BVCl05lcbRdHs8ZLqsLgOomNmJ95NEiG3iXve3VW8rvfX+GyftEh3ajEdQ2BZKxw+wcCMlrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tGfpEgy2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tGfpEgy2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 230C01F000E9;
	Mon, 13 Jul 2026 19:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783972759;
	bh=JYdQLERzhBRpObVIusmPTCsbavr8zH0CU8vdERSNF2U=;
	h=Date:To:From:Subject;
	b=tGfpEgy25k2+RwJYSy0DBiEdHhl7svXbYwqN/9hP88DMYwNTJAITyoqBVwDs8YjOf
	 omnXwIfnjbBlpUKggznRiZPY6T6GoyYC2sQNZ20GTtutAfIvMzneGsEgQmjgfwAoO8
	 YEGTHIana0zAjvqJdonGML8DJysWdxjEyBirZSwk=
Date: Mon, 13 Jul 2026 12:59:18 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,zhangguopeng@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-v1-fix-wrong-linux-mm-list-address-in-deprecation-warnings.patch added to mm-new branch
Message-Id: <20260713195919.230C01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcg-v1: fix wrong linux-mm list address in deprecation warnings
has been added to the -mm mm-new branch.  Its filename is
     mm-memcg-v1-fix-wrong-linux-mm-list-address-in-deprecation-warnings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-v1-fix-wrong-linux-mm-list-address-in-deprecation-warnings.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
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

mm-memcg-remove-stray-text-from-obj_stock_pcp-comment.patch
mm-memcontrol-update-state_local-when-flushing-nmi-stats.patch
mm-memcg-v1-account-vmpressure-event-allocations.patch
mm-memcg-v1-fix-wrong-linux-mm-list-address-in-deprecation-warnings.patch

