Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15F24825B8
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865958; cv=none; b=Yg0awjirgcIGTQYGgS2L7nvxCcl/3qFKL2RMIvjYZznQE1sFIiclOk5UKGXIYFvlXY+KboQBPSEqydN5375JDzvHHgNYuaevDXmA1/UygnOKz5qrqGeOwy04GqoIGhIe1movWLCaW2yV1fQkuiZBi1iHT0fIMxeUyYRj6wHasak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865958; c=relaxed/simple;
	bh=67NlLZhMJXXl8MVX3vrE9kDAA3q6ElJsu6yAPf+wgiA=;
	h=Date:To:From:Subject:Message-Id; b=DvyciapbDuige+sRS437K9LU1T+ZuStgDfftWzhukeTkHybiMSN+yDTHbobaEcCIys+yMBiMFv+LVz9xMqesf2JIGjaS0Qr8PWcrx0NCtAmOD/UT1tv+4RWCHC6UUSdccmClEhJazr0EgmxqXm4l1uiyW5gkF99BQSEiQ+nJtvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iMEaaPJM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iMEaaPJM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD3A1F000FF;
	Tue, 13 Oct 2026 04:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865957;
	bh=Wl3Fj2UdLWs0DQMzWeyFGU11wQzcR2EomrIIH7FuZ3I=;
	h=Date:To:From:Subject;
	b=iMEaaPJMeeMJcKTsOXflpZ05m8sFAU7BKjPD/HTpiynYbZ25x+yF+NOH+EWV5Yx6U
	 yH2jzLIgwYG/LApMftO5TErW2xGmYmkNHEZcR9gL6v3iIr9HN9Ihr9bgyLrJtPOkB2
	 sAh4zxv24NPTu+f8tuU2wb4dq8iJUHSRANVPL7VI=
Date: Mon, 12 Oct 2026 21:32:37 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,willy@infradead.org,weixugc@google.com,vbabka@kernel.org,surenb@google.com,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,liam@infradead.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-constify-the-zswap-and-socket-pressure-helpers.patch removed from -mm tree
Message-Id: <20261013043237.7BD3A1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcontrol: constify the zswap and socket pressure helpers
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-constify-the-zswap-and-socket-pressure-helpers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm: memcontrol: constify the zswap and socket pressure helpers
Date: Tue, 15 Sep 2026 19:20:15 -0400

mem_cgroup_zswap_writeback_enabled() only reads the zswap_writeback flags,
and mem_cgroup_get_socket_pressure() only reads the socket pressure
timestamp.  Constify them.

Link: https://lore.kernel.org/20260915-folio_memcg-const-v3-11-c239a6010b58@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
---

 include/linux/memcontrol.h |    8 ++++----
 mm/memcontrol.c            |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-constify-the-zswap-and-socket-pressure-helpers
+++ a/include/linux/memcontrol.h
@@ -1684,7 +1684,7 @@ static inline void mem_cgroup_set_socket
 	write_sequnlock_irqrestore(&memcg->socket_pressure_seqlock, flags);
 }
 
-static inline u64 mem_cgroup_get_socket_pressure(struct mem_cgroup *memcg)
+static inline u64 mem_cgroup_get_socket_pressure(const struct mem_cgroup *memcg)
 {
 	unsigned int seq;
 	u64 val;
@@ -1702,7 +1702,7 @@ static inline void mem_cgroup_set_socket
 	WRITE_ONCE(memcg->socket_pressure, jiffies + HZ);
 }
 
-static inline u64 mem_cgroup_get_socket_pressure(struct mem_cgroup *memcg)
+static inline u64 mem_cgroup_get_socket_pressure(const struct mem_cgroup *memcg)
 {
 	return READ_ONCE(memcg->socket_pressure);
 }
@@ -1937,7 +1937,7 @@ static inline void mem_cgroup_calculate_
 bool obj_cgroup_may_zswap(struct obj_cgroup *objcg);
 void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size);
 void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size);
-bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg);
+bool mem_cgroup_zswap_writeback_enabled(const struct mem_cgroup *memcg);
 #else
 static inline bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
 {
@@ -1951,7 +1951,7 @@ static inline void obj_cgroup_uncharge_z
 					     size_t size)
 {
 }
-static inline bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg)
+static inline bool mem_cgroup_zswap_writeback_enabled(const struct mem_cgroup *memcg)
 {
 	/* if zswap is disabled, do not block pages going to the swapping device */
 	return true;
--- a/mm/memcontrol.c~mm-memcontrol-constify-the-zswap-and-socket-pressure-helpers
+++ a/mm/memcontrol.c
@@ -6318,7 +6318,7 @@ void obj_cgroup_uncharge_zswap(struct ob
 	rcu_read_unlock();
 }
 
-bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg)
+bool mem_cgroup_zswap_writeback_enabled(const struct mem_cgroup *memcg)
 {
 	/* if zswap is disabled, do not block pages going to the swapping device */
 	if (!zswap_is_enabled())
_

Patches currently in -mm which might be from tz2294@columbia.edu are


