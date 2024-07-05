Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9434BBE6C
	for <mm-commits@vger.kernel.org>; Fri,  5 Jul 2024 01:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720141627; cv=none; b=XbdoraDuuAbSxYSCojhsvJiy1jQRe8pW13rmaMXsTLn+u0B0ZfR1uVzdYo3T3FjiN1BG475z7fwFIJJxuLA+lGxh76D/1Aah2hCjqQfLVhtNPbDtjZu6efLLL3M/DS4kejkpcix+oqezCTtN2yE7PUdbcz0VQkWIKQkbcb8gbMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720141627; c=relaxed/simple;
	bh=4gRUS2nkOWMVNS4MO4T8vrvVqG4ucxHR0R3VOBfCydo=;
	h=Date:To:From:Subject:Message-Id; b=MFjGYBKpRHmEbF5NtKO86ww0fQLXSTwyNd/MAlxq5aVwWwuTDldqa98PazOztc/oZTHgLGPeELxuAWgujdGirCT9ITxOEvR2J5WYLSZFOrDfHyt4tKOY+GjZqajP9oFA5zsbLilr/PLQoEoeccqTRmjQ2UEw2XG9yNO0raDScKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gRJ4FDqP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gRJ4FDqP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52FD8C3277B;
	Fri,  5 Jul 2024 01:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720141627;
	bh=4gRUS2nkOWMVNS4MO4T8vrvVqG4ucxHR0R3VOBfCydo=;
	h=Date:To:From:Subject:From;
	b=gRJ4FDqP+hV/eqNr20eV0bCIUuUFbxt6WWBzwNkLkNa3iAGSNH6SGYAYsiZqeoJOP
	 KhN+g+Ou8oHDrYQTCGGXLggD4Dc7wTPX2WIKbrz9UJD9yDgf0EMhWsrUGF8TOH0BLz
	 n692smPk1DadcG7/pgAVgGAoC7Vz+jahU22VSaBY=
Date: Thu, 04 Jul 2024 18:07:06 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-put-struct-task_struct-memcg_in_oom-under-config_memcg_v1.patch removed from -mm tree
Message-Id: <20240705010707.52FD8C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg: put struct task_struct::memcg_in_oom under CONFIG_MEMCG_V1
has been removed from the -mm tree.  Its filename was
     mm-memcg-put-struct-task_struct-memcg_in_oom-under-config_memcg_v1.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm: memcg: put struct task_struct::memcg_in_oom under CONFIG_MEMCG_V1
Date: Fri, 28 Jun 2024 21:03:16 +0000

The memcg_in_oom field of the struct task_struct is not used by the cgroup
v2's memory controller, so it can be happily compiled out if
CONFIG_MEMCG_V1 is not set.

Link: https://lkml.kernel.org/r/20240628210317.272856-9-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/include/linux/sched.h~mm-memcg-put-struct-task_struct-memcg_in_oom-under-config_memcg_v1
+++ a/include/linux/sched.h
@@ -1447,9 +1447,11 @@ struct task_struct {
 	unsigned int			kcov_softirq;
 #endif
 
-#ifdef CONFIG_MEMCG
+#ifdef CONFIG_MEMCG_V1
 	struct mem_cgroup		*memcg_in_oom;
+#endif
 
+#ifdef CONFIG_MEMCG
 	/* Number of pages to reclaim on returning to userland: */
 	unsigned int			memcg_nr_pages_over_high;
 
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-memcg-drop-obsolete-cache-line-padding-in-struct-mem_cgroup.patch
mm-memcg-add-cache-line-padding-to-mem_cgroup_per_node.patch

