Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFDA213254
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343149; cv=none; b=J+HtmmYvht7aPLFB7FBMwgmRQelBFOhMQzxnltKTQQMIo3NeIxA0WUzX3ReSafMM2N8yUkzeMNFVnq3TFa6zsJ2WBifwxlL7SKmFi9WzCwPmjcOfBd2oqCdQ0xTE+9cklabevTQyHOxQZ/K1lGvGwgNI3T9ySMyDCmewv4CWpA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343149; c=relaxed/simple;
	bh=KmMTF4y3pAFYYK7yRUi8gpTBNftJTWg139R6wl5f+8E=;
	h=Date:To:From:Subject:Message-Id; b=MkLA3CV9T4lwfSKLASGoZBsn9VM3KtoaNRiPT012KLxNQBZ6BhJVk9EJn6VRtS6GtDFATQtz89D+mNsJTAaWUmuaIIRjXOYGFrcsY9B8zghLmJKNWcgmHAwB5LpHV21VnyHFTD/xqrE9Sp5PxFuwFYPt74ZT8YW+VN3uqGnEGK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q/+TSBOt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q/+TSBOt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 009ECC113D0;
	Mon, 17 Nov 2025 01:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343149;
	bh=KmMTF4y3pAFYYK7yRUi8gpTBNftJTWg139R6wl5f+8E=;
	h=Date:To:From:Subject:From;
	b=q/+TSBOtbT+6nTrOgZhyEzfh0VEfLNGpeT5h/WzNR2Cb/x7VVwzVIhYSIN3aGP4ps
	 jCcbUvG4sqJhtY+hssycyiKgV6+qFzUoQKWtSh9KsGCp213pgGgXi9+6FRSQGbh1vQ
	 jEJGSW+An19q4tAxI9k0967jSDIFbzTW4z3KTUJs=
Date: Sun, 16 Nov 2025 17:32:28 -0800
To: mm-commits@vger.kernel.org,willemb@google.com,tj@kernel.org,roman.gushchin@linux.dev,pabeni@redhat.com,ncardwell@google.com,muchun.song@linux.dev,mhocko@kernel.org,kuniyu@google.com,kuba@kernel.org,horms@kernel.org,hannes@cmpxchg.org,edumazet@google.com,davem@davemloft.net,daniel.sedlak@cdn77.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-net-track-network-throttling-due-to-memcg-memory-pressure.patch removed from -mm tree
Message-Id: <20251117013229.009ECC113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: net: track network throttling due to memcg memory pressure
has been removed from the -mm tree.  Its filename was
     memcg-net-track-network-throttling-due-to-memcg-memory-pressure.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: net: track network throttling due to memcg memory pressure
Date: Thu, 16 Oct 2025 09:10:35 -0700

The kernel can throttle network sockets if the memory cgroup associated
with the corresponding socket is under memory pressure.  The throttling
actions include clamping the transmit window, failing to expand receive or
send buffers, aggressively prune out-of-order receive queue, FIN deferred
to a retransmitted packet and more.  Let's add memcg metric to track such
throttling actions.

At the moment memcg memory pressure is defined through vmpressure and in
future it may be defined using PSI or we may add more flexible way for the
users to define memory pressure, maybe through ebpf.  However the
potential throttling actions will remain the same, so this newly
introduced metric will continue to track throttling actions irrespective
of how memcg memory pressure is defined.

Link: https://lkml.kernel.org/r/20251016161035.86161-1-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Daniel Sedlak <daniel.sedlak@cdn77.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Willem de Bruijn <willemb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |    4 ++++
 include/linux/memcontrol.h              |    1 +
 include/net/sock.h                      |    6 +++++-
 kernel/cgroup/cgroup.c                  |    1 +
 mm/memcontrol.c                         |    3 +++
 5 files changed, 14 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/cgroup-v2.rst~memcg-net-track-network-throttling-due-to-memcg-memory-pressure
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1515,6 +1515,10 @@ The following nested keys are defined.
           oom_group_kill
                 The number of times a group OOM has occurred.
 
+          sock_throttled
+                The number of times network sockets associated with
+                this cgroup are throttled.
+
   memory.events.local
 	Similar to memory.events but the fields in the file are local
 	to the cgroup i.e. not hierarchical. The file modified event
--- a/include/linux/memcontrol.h~memcg-net-track-network-throttling-due-to-memcg-memory-pressure
+++ a/include/linux/memcontrol.h
@@ -52,6 +52,7 @@ enum memcg_memory_event {
 	MEMCG_SWAP_HIGH,
 	MEMCG_SWAP_MAX,
 	MEMCG_SWAP_FAIL,
+	MEMCG_SOCK_THROTTLED,
 	MEMCG_NR_MEMORY_EVENTS,
 };
 
--- a/include/net/sock.h~memcg-net-track-network-throttling-due-to-memcg-memory-pressure
+++ a/include/net/sock.h
@@ -2635,8 +2635,12 @@ static inline bool mem_cgroup_sk_under_m
 #endif /* CONFIG_MEMCG_V1 */
 
 	do {
-		if (time_before64(get_jiffies_64(), mem_cgroup_get_socket_pressure(memcg)))
+		if (time_before64(get_jiffies_64(),
+				  mem_cgroup_get_socket_pressure(memcg))) {
+			memcg_memory_event(mem_cgroup_from_sk(sk),
+					   MEMCG_SOCK_THROTTLED);
 			return true;
+		}
 	} while ((memcg = parent_mem_cgroup(memcg)));
 
 	return false;
--- a/kernel/cgroup/cgroup.c~memcg-net-track-network-throttling-due-to-memcg-memory-pressure
+++ a/kernel/cgroup/cgroup.c
@@ -4704,6 +4704,7 @@ void cgroup_file_notify(struct cgroup_fi
 	}
 	spin_unlock_irqrestore(&cgroup_file_kn_lock, flags);
 }
+EXPORT_SYMBOL_GPL(cgroup_file_notify);
 
 /**
  * cgroup_file_show - show or hide a hidden cgroup file
--- a/mm/memcontrol.c~memcg-net-track-network-throttling-due-to-memcg-memory-pressure
+++ a/mm/memcontrol.c
@@ -81,6 +81,7 @@ struct cgroup_subsys memory_cgrp_subsys
 EXPORT_SYMBOL(memory_cgrp_subsys);
 
 struct mem_cgroup *root_mem_cgroup __read_mostly;
+EXPORT_SYMBOL(root_mem_cgroup);
 
 /* Active memory cgroup to use from an interrupt context */
 DEFINE_PER_CPU(struct mem_cgroup *, int_active_memcg);
@@ -4463,6 +4464,8 @@ static void __memory_events_show(struct
 		   atomic_long_read(&events[MEMCG_OOM_KILL]));
 	seq_printf(m, "oom_group_kill %lu\n",
 		   atomic_long_read(&events[MEMCG_OOM_GROUP_KILL]));
+	seq_printf(m, "sock_throttled %lu\n",
+		   atomic_long_read(&events[MEMCG_SOCK_THROTTLED]));
 }
 
 static int memory_events_show(struct seq_file *m, void *v)
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

mm-memcg-dump-memcg-protection-info-on-oom-or-alloc-failures.patch

