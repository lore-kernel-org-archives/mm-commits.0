Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4DBE21D3C0
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489956; cv=none; b=jlAFvVQzUwKRc4ep34I22mum+i3QW4WQcdc6Y4GXre7uLrIPLUznSFqS8JHsZUaz6stG4UBX/6d/4L0aOgFVGjtXYA7ITqCriZKUiKKdDZuH1PrKlg86xn0t6qdiS7BNqvDw+UJ8MtZp9SmG6bq5YiaOQDO0I4rPOqYIsfqNbpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489956; c=relaxed/simple;
	bh=kQnOuWogNrBwJs6l2GNiZnauespKhQKEDlNWSXTw9aA=;
	h=Date:To:From:Subject:Message-Id; b=gxDlBUWhEkUVdZ86LP8asvfvCsoeFKiS7XTJT9TjTy+osZkzwvuFGcv8tk5cXPU5xdza+/4DidmLa+nLLeZaAnTcYu0grzmrrI83RvGAbQpZ3unN/OyxhSVx2nNnc5eaZx3ySx/bXi/t/HA48iTONMzOSBwuTEsRIb0saHCaVgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YE9N+/XF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YE9N+/XF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AAF6C4CEE7;
	Sun, 21 Sep 2025 21:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489956;
	bh=kQnOuWogNrBwJs6l2GNiZnauespKhQKEDlNWSXTw9aA=;
	h=Date:To:From:Subject:From;
	b=YE9N+/XFJbzKgDh7PfFhPsyTTgukZqJ1XTKrYnjTs04DhvNG3c1PHg4jbtabu5J7R
	 xCwu1H9XxDLKPQ1gjrovoxyxUQw5EgtN3clpqK1zobgcnXxgViDKVHStAtt2GX39n0
	 bMraXVv20pFP5DdSCuZnL/WSB2FjBpEnaALxA0JU=
Date: Sun, 21 Sep 2025 14:25:55 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,zhangjiao2@cmss.chinamobile.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] samples-cgroup-rm-unused-memcg_events-macro.patch removed from -mm tree
Message-Id: <20250921212556.7AAF6C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: samples/cgroup: rm unused MEMCG_EVENTS macro
has been removed from the -mm tree.  Its filename was
     samples-cgroup-rm-unused-memcg_events-macro.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: zhang jiao <zhangjiao2@cmss.chinamobile.com>
Subject: samples/cgroup: rm unused MEMCG_EVENTS macro
Date: Wed, 3 Sep 2025 15:30:59 +0800

MEMCG_EVENTS is never referenced in the code. Just remove it.

Link: https://lkml.kernel.org/r/20250903073100.2477-1-zhangjiao2@cmss.chinamobile.com
Signed-off-by: zhang jiao <zhangjiao2@cmss.chinamobile.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/cgroup/memcg_event_listener.c |    2 --
 1 file changed, 2 deletions(-)

--- a/samples/cgroup/memcg_event_listener.c~samples-cgroup-rm-unused-memcg_events-macro
+++ a/samples/cgroup/memcg_event_listener.c
@@ -18,8 +18,6 @@
 #include <sys/inotify.h>
 #include <unistd.h>
 
-#define MEMCG_EVENTS "memory.events"
-
 /* Size of buffer to use when reading inotify events */
 #define INOTIFY_BUFFER_SIZE 8192
 
_

Patches currently in -mm which might be from zhangjiao2@cmss.chinamobile.com are


