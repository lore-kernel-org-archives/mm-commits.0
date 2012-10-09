From: akpm@linux-foundation.org
Subject: [merged] memcg-cleanup-kmem-tcp-ifdefs.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:13:26 -0700
Message-ID: <20121009181326.C3F64100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:39481 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756796Ab2JISN2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:13:28 -0400
Received: by mail-yh0-f74.google.com with SMTP id 10so574501yhl.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:13:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, glommer@parallels.com, sachin.kamat@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: cleanup kmem tcp ifdefs
has been removed from the -mm tree.  Its filename was
     memcg-cleanup-kmem-tcp-ifdefs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg: cleanup kmem tcp ifdefs

TCP kmem accounting is currently guarded by CONFIG_MEMCG_KMEM ifdefs but
the code is not used if !CONFIG_INET so we should rather test for both. 
The same applies to net/sock.h, net/ip.h and net/tcp_memcontrol.h but
let's keep those outside of any ifdefs because it is considered safer wrt.
 future maintainability.

Tested with
- CONFIG_INET && CONFIG_MEMCG_KMEM
- !CONFIG_INET && CONFIG_MEMCG_KMEM
- CONFIG_INET && !CONFIG_MEMCG_KMEM
- !CONFIG_INET && !CONFIG_MEMCG_KMEM

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff -puN mm/memcontrol.c~memcg-cleanup-kmem-tcp-ifdefs mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-cleanup-kmem-tcp-ifdefs
+++ a/mm/memcontrol.c
@@ -51,6 +51,7 @@
 #include <linux/oom.h>
 #include "internal.h"
 #include <net/sock.h>
+#include <net/ip.h>
 #include <net/tcp_memcontrol.h>
 
 #include <asm/uaccess.h>
@@ -326,7 +327,7 @@ struct mem_cgroup {
 	struct mem_cgroup_stat_cpu nocpu_base;
 	spinlock_t pcp_counter_lock;
 
-#ifdef CONFIG_INET
+#if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_INET)
 	struct tcp_memcontrol tcp_mem;
 #endif
 };
@@ -412,9 +413,7 @@ struct mem_cgroup *mem_cgroup_from_css(s
 }
 
 /* Writing them here to avoid exposing memcg's inner layout */
-#ifdef CONFIG_MEMCG_KMEM
-#include <net/sock.h>
-#include <net/ip.h>
+#if defined(CONFIG_INET) && defined(CONFIG_MEMCG_KMEM)
 
 static bool mem_cgroup_is_root(struct mem_cgroup *memcg);
 void sock_update_memcg(struct sock *sk)
@@ -461,7 +460,6 @@ void sock_release_memcg(struct sock *sk)
 	}
 }
 
-#ifdef CONFIG_INET
 struct cg_proto *tcp_proto_cgroup(struct mem_cgroup *memcg)
 {
 	if (!memcg || mem_cgroup_is_root(memcg))
@@ -470,10 +468,7 @@ struct cg_proto *tcp_proto_cgroup(struct
 	return &memcg->tcp_mem.cg_proto;
 }
 EXPORT_SYMBOL(tcp_proto_cgroup);
-#endif /* CONFIG_INET */
-#endif /* CONFIG_MEMCG_KMEM */
 
-#if defined(CONFIG_INET) && defined(CONFIG_MEMCG_KMEM)
 static void disarm_sock_keys(struct mem_cgroup *memcg)
 {
 	if (!memcg_proto_activated(&memcg->tcp_mem.cg_proto))
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
mm-memblock-reduce-overhead-in-binary-search.patch

