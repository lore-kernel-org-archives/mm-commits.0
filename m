From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memcontrol-consolidate-cgroup-socket-tracking-fix-2.patch removed from
 -mm tree
Date: Fri, 07 Oct 2016 16:40:36 -0700
Message-ID: <57f83274.lXHnx8btiDFAB3CB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38390 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932814AbcJGXkh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 19:40:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcontrol-consolidate-cgroup-socket-tracking-fix-2
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-consolidate-cgroup-socket-tracking-fix-2.patch

This patch was dropped because it was folded into mm-memcontrol-consolidate-cgroup-socket-tracking.patch

------------------------------------------------------
From:  Johannes Weiner <hannes@cmpxchg.org>
Subject: mm-memcontrol-consolidate-cgroup-socket-tracking-fix-2

Link: http://lkml.kernel.org/r/20160915142733.GA25519@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcontrol-consolidate-cgroup-socket-tracking-fix-2 include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-consolidate-cgroup-socket-tracking-fix-2
+++ a/include/linux/memcontrol.h
@@ -773,13 +773,13 @@ static inline void mem_cgroup_wb_stats(s
 #endif	/* CONFIG_CGROUP_WRITEBACK */
 
 struct sock;
-void mem_cgroup_sk_alloc(struct sock *sk);
-void mem_cgroup_sk_free(struct sock *sk);
 bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages);
 void mem_cgroup_uncharge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages);
 #ifdef CONFIG_MEMCG
 extern struct static_key_false memcg_sockets_enabled_key;
 #define mem_cgroup_sockets_enabled static_branch_unlikely(&memcg_sockets_enabled_key)
+void mem_cgroup_sk_alloc(struct sock *sk);
+void mem_cgroup_sk_free(struct sock *sk);
 static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
 {
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->tcpmem_pressure)
@@ -792,6 +792,8 @@ static inline bool mem_cgroup_under_sock
 }
 #else
 #define mem_cgroup_sockets_enabled 0
+static inline void mem_cgroup_sk_alloc(struct sock *sk) { };
+static inline void mem_cgroup_sk_free(struct sock *sk) { };
 static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
 {
 	return false;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-memcontrol-consolidate-cgroup-socket-tracking.patch

