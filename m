From: akpm@linux-foundation.org
Subject: + mm-memcontrol-consolidate-cgroup-socket-tracking-fix-2.patch
 added to -mm tree
Date: Fri, 16 Sep 2016 16:04:53 -0700
Message-ID: <57dc7a95.6RZZns55EA7VwPk/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58953 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758080AbcIPXEy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Sep 2016 19:04:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcontrol-consolidate-cgroup-socket-tracking-fix-2
has been added to the -mm tree.  Its filename is
     mm-memcontrol-consolidate-cgroup-socket-tracking-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-consolidate-cgroup-socket-tracking-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-consolidate-cgroup-socket-tracking-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
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
mm-memcontrol-consolidate-cgroup-socket-tracking-fix-2.patch

