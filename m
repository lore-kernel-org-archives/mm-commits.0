Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48453216E24
	for <mm-commits@vger.kernel.org>; Thu, 16 Oct 2025 19:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760643979; cv=none; b=sN1B76jOQln3ajvJu0JNlexlquBBxOfJPRt0AVEfljF/5tAoZahcW19UFctMOlfcLSOMqcsn/aoZwA/fSa60iNIW+4PZsle99HhXP0rmcO72Ji/twi/qEaes/2wmUccIn8PmI4phfH/UCk2X8OcdSMojtnZoQefF0+tCrWuunKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760643979; c=relaxed/simple;
	bh=H8bqkMJzdfxzXbM1hIO0VXQLtFZCg2wZrNyhqwX32dI=;
	h=Date:To:From:Subject:Message-Id; b=AcVIllJHbh/HkPT/LsTDmsH6gNDXfD9sdlhveT7ztAZ2qD1BG9vFzpWwBD6DLFvwDJBst8xVXZKpglgwHefIm8pvBvJoPYQj438BlevDkNERR/UmEAFg71I7+fDKeQi3XphY2m2tkjwkRJRO2ZnbJ8c4D6EcHKNRC6r8+vG7jgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tPzW6E8l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tPzW6E8l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4A3C4CEF1;
	Thu, 16 Oct 2025 19:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760643978;
	bh=H8bqkMJzdfxzXbM1hIO0VXQLtFZCg2wZrNyhqwX32dI=;
	h=Date:To:From:Subject:From;
	b=tPzW6E8lym8qYS8AQqkBRHPHGHYGAkaTakL091ugIkcryDXwShmxOsC5JVe9GFPlN
	 mYKQelgB9hFNwF2zekDaLLhE1TlmLEzk7N7x0nBhPpE/ii/61SMG1IwYWecUflIw3B
	 EhbZQ1fshyANMmQy/CqpakpR3i0rdAHwB7mR4Zc8=
Date: Thu, 16 Oct 2025 12:46:18 -0700
To: mm-commits@vger.kernel.org,willemb@google.com,tj@kernel.org,roman.gushchin@linux.dev,pabeni@redhat.com,ncardwell@google.com,muchun.song@linux.dev,mhocko@kernel.org,kuniyu@google.com,kuba@kernel.org,horms@kernel.org,hannes@cmpxchg.org,edumazet@google.com,davem@davemloft.net,daniel.sedlak@cdn77.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-net-track-network-throttling-due-to-memcg-memory-pressure.patch added to mm-new branch
Message-Id: <20251016194618.BB4A3C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: net: track network throttling due to memcg memory pressure
has been added to the -mm mm-new branch.  Its filename is
     memcg-net-track-network-throttling-due-to-memcg-memory-pressure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-net-track-network-throttling-due-to-memcg-memory-pressure.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
@@ -4464,6 +4465,8 @@ static void __memory_events_show(struct
 		   atomic_long_read(&events[MEMCG_OOM_KILL]));
 	seq_printf(m, "oom_group_kill %lu\n",
 		   atomic_long_read(&events[MEMCG_OOM_GROUP_KILL]));
+	seq_printf(m, "sock_throttled %lu\n",
+		   atomic_long_read(&events[MEMCG_SOCK_THROTTLED]));
 }
 
 static int memory_events_show(struct seq_file *m, void *v)
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-net-track-network-throttling-due-to-memcg-memory-pressure.patch

