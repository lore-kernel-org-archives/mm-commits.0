From: akpm@linux-foundation.org
Subject: + memcg-cleanup-kmem-tcp-ifdefs.patch added to -mm tree
Date: Mon, 17 Sep 2012 15:20:51 -0700
Message-ID: <20120917222052.240CC200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:48680 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756803Ab2IQWUy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Sep 2012 18:20:54 -0400
Received: by faet1 with SMTP id t1so106400fae.1
        for <mm-commits@vger.kernel.org>; Mon, 17 Sep 2012 15:20:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, glommer@parallels.com, sachin.kamat@linaro.org


The patch titled
     Subject: memcg: cleanup kmem tcp ifdefs
has been added to the -mm tree.  Its filename is
     memcg-cleanup-kmem-tcp-ifdefs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-ia64-fix-a-memory-block-size-bug.patch
mm-page_alloc-fix-the-page-address-of-higher-pages-buddy-calculation.patch
linux-next.patch
mm-hugetlb-add-arch-hook-for-clearing-page-flags-before-entering-pool.patch
mm-memblock-reduce-overhead-in-binary-search.patch
mm-memblock-use-existing-interface-to-set-nid.patch
mm-memblock-cleanup-early_node_map-related-comments.patch
mm-thp-fix-the-pmd_clear-arguments-in-pmdp_get_and_clear.patch
mm-thp-fix-the-update_mmu_cache-last-argument-passing-in-mm-huge_memoryc.patch
memcg-trivial-fixes-for-documentation-cgroups-memorytxt.patch
memcg-cleanup-kmem-tcp-ifdefs.patch

