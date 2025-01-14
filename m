Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1FD23A115
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836959; cv=none; b=Q0t0PSzuw/h19nkaUIIjTYSOZlcs5qP8Ljy1klemcIu2quzAlhSMrigYiRM7Dkwm6f4vUd9ieY03+87VYA9dSCmlE07Y4qTvnrg6Ei+qHJRPGjDB2xpkkAZPl4Yrg6YA/Woa/x1Kbqc224R635F2w2o5q/XP+Te8VncJh1Ot898=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836959; c=relaxed/simple;
	bh=LF2p3teSzmUrfcgscVihwXh3c3rrdhTttEF2FLm7blg=;
	h=Date:To:From:Subject:Message-Id; b=AnSU/5otSGs2tdcrsLyDWi3XOGcp/AFj6VedYPjXoxOJELt7KzwhDhGcLkj1uanIC9e9Ayo6lOvlsAvBA/3N8INWut+WZXTXcTD1dfzWgEiOHs+KyUbY86Exc/vZoQ+yRAMiO8SZWxudpcD1fPwVs7Ss5WNOwOXwiI0ThmZlGEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KAP07Xwj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KAP07Xwj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60821C4CEDD;
	Tue, 14 Jan 2025 06:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836959;
	bh=LF2p3teSzmUrfcgscVihwXh3c3rrdhTttEF2FLm7blg=;
	h=Date:To:From:Subject:From;
	b=KAP07XwjtdvGztjNdYSkBmtupPBKLCLJUZn7tcH9T8OkDTYZ8jJS+/bExNw+QXRz9
	 5Y+lg9oMYEgnnDw2+KzgA9p39K+Pv66SqayVWHUJ3Bx1jocmUrL88CMNh0Z7daNZAx
	 z/1FwzXHqBvo9KIlK9sFn4qukdh18/Tmxic6ba6w=
Date: Mon, 13 Jan 2025 22:42:38 -0800
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,kerensun@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-unnecessary-whitespace-before-a-quoted-newline.patch removed from -mm tree
Message-Id: <20250114064239.60821C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove unnecessary whitespace before a quoted newline
has been removed from the -mm tree.  Its filename was
     mm-remove-unnecessary-whitespace-before-a-quoted-newline.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Keren Sun <kerensun@google.com>
Subject: mm: remove unnecessary whitespace before a quoted newline
Date: Fri, 15 Nov 2024 15:57:43 -0800

Remove whitespaces before newlines for strings in pr_warn_once()

Link: https://lkml.kernel.org/r/20241115235744.1419580-3-kerensun@google.com
Signed-off-by: Keren Sun <kerensun@google.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/memcontrol-v1.c~mm-remove-unnecessary-whitespace-before-a-quoted-newline
+++ a/mm/memcontrol-v1.c
@@ -1040,13 +1040,13 @@ static ssize_t memcg_write_event_control
 	} else if (!strcmp(name, "memory.oom_control")) {
 		pr_warn_once("oom_control is deprecated and will be removed. "
 			     "Please report your usecase to linux-mm-@kvack.org"
-			     " if you depend on this functionality. \n");
+			     " if you depend on this functionality.\n");
 		event->register_event = mem_cgroup_oom_register_event;
 		event->unregister_event = mem_cgroup_oom_unregister_event;
 	} else if (!strcmp(name, "memory.pressure_level")) {
 		pr_warn_once("pressure_level is deprecated and will be removed. "
 			     "Please report your usecase to linux-mm-@kvack.org "
-			     "if you depend on this functionality. \n");
+			     "if you depend on this functionality.\n");
 		event->register_event = vmpressure_register_event;
 		event->unregister_event = vmpressure_unregister_event;
 	} else if (!strcmp(name, "memory.memsw.usage_in_bytes")) {
@@ -1881,7 +1881,7 @@ static int mem_cgroup_oom_control_write(
 
 	pr_warn_once("oom_control is deprecated and will be removed. "
 		     "Please report your usecase to linux-mm-@kvack.org if you "
-		     "depend on this functionality. \n");
+		     "depend on this functionality.\n");
 
 	/* cannot set to root cgroup and only 0 and 1 are allowed */
 	if (mem_cgroup_is_root(memcg) || !((val == 0) || (val == 1)))
_

Patches currently in -mm which might be from kerensun@google.com are


