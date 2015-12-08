From: akpm@linux-foundation.org
Subject: + mm-memcontrol-drop-unused-css-argument-in-memcg_init_kmem.patch added to -mm tree
Date: Tue, 08 Dec 2015 15:06:36 -0800
Message-ID: <5667627c.liOA4dzfKU/gZjhq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35219 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbbLHXGh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2015 18:06:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, tj@kernel.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: drop unused @css argument in memcg_init_kmem
has been added to the -mm tree.  Its filename is
     mm-memcontrol-drop-unused-css-argument-in-memcg_init_kmem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-drop-unused-css-argument-in-memcg_init_kmem.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-drop-unused-css-argument-in-memcg_init_kmem.patch

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
Subject: mm: memcontrol: drop unused @css argument in memcg_init_kmem

This series adds accounting of the historical "kmem" memory consumers to
the cgroup2 memory controller.

These consumers include the dentry cache, the inode cache, kernel stack
pages, and a few others that are pointed out in patch 7/8.  The footprint
of these consumers is directly tied to userspace activity in common
workloads, and so they have to be part of the minimally viable
configuration in order to present a complete feature to our users.

The cgroup2 interface of the memory controller is far from complete, but
this series, along with the socket memory accounting series, provides the
final semantic changes for the existing memory knobs in the cgroup2
interface, which is scheduled for initial release in the next merge
window.



This patch (of 8):

Remove unused css argument frmo memcg_init_kmem()

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/net/tcp_memcontrol.h |    3 ++-
 mm/memcontrol.c              |    6 +++---
 net/ipv4/tcp_memcontrol.c    |    2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff -puN include/net/tcp_memcontrol.h~mm-memcontrol-drop-unused-css-argument-in-memcg_init_kmem include/net/tcp_memcontrol.h
--- a/include/net/tcp_memcontrol.h~mm-memcontrol-drop-unused-css-argument-in-memcg_init_kmem
+++ a/include/net/tcp_memcontrol.h
@@ -1,6 +1,7 @@
 #ifndef _TCP_MEMCG_H
 #define _TCP_MEMCG_H
 
-int tcp_init_cgroup(struct mem_cgroup *memcg, struct cgroup_subsys *ss);
+int tcp_init_cgroup(struct mem_cgroup *memcg);
 void tcp_destroy_cgroup(struct mem_cgroup *memcg);
+
 #endif /* _TCP_MEMCG_H */
diff -puN mm/memcontrol.c~mm-memcontrol-drop-unused-css-argument-in-memcg_init_kmem mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-drop-unused-css-argument-in-memcg_init_kmem
+++ a/mm/memcontrol.c
@@ -3561,7 +3561,7 @@ static int mem_cgroup_oom_control_write(
 }
 
 #ifdef CONFIG_MEMCG_KMEM
-static int memcg_init_kmem(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
+static int memcg_init_kmem(struct mem_cgroup *memcg)
 {
 	int ret;
 
@@ -3569,7 +3569,7 @@ static int memcg_init_kmem(struct mem_cg
 	if (ret)
 		return ret;
 
-	return tcp_init_cgroup(memcg, ss);
+	return tcp_init_cgroup(memcg);
 }
 
 static void memcg_deactivate_kmem(struct mem_cgroup *memcg)
@@ -4252,7 +4252,7 @@ mem_cgroup_css_online(struct cgroup_subs
 	}
 	mutex_unlock(&memcg_create_mutex);
 
-	ret = memcg_init_kmem(memcg, &memory_cgrp_subsys);
+	ret = memcg_init_kmem(memcg);
 	if (ret)
 		return ret;
 
diff -puN net/ipv4/tcp_memcontrol.c~mm-memcontrol-drop-unused-css-argument-in-memcg_init_kmem net/ipv4/tcp_memcontrol.c
--- a/net/ipv4/tcp_memcontrol.c~mm-memcontrol-drop-unused-css-argument-in-memcg_init_kmem
+++ a/net/ipv4/tcp_memcontrol.c
@@ -6,7 +6,7 @@
 #include <linux/memcontrol.h>
 #include <linux/module.h>
 
-int tcp_init_cgroup(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
+int tcp_init_cgroup(struct mem_cgroup *memcg)
 {
 	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
 	struct page_counter *counter_parent = NULL;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

maintainers-make-vladimir-co-maintainer-of-the-memory-controller.patch
mm-page_alloc-generalize-the-dirty-balance-reserve.patch
proc-meminfo-estimate-available-memory-more-conservatively.patch
mm-memcontrol-export-root_mem_cgroup.patch
net-tcp_memcontrol-properly-detect-ancestor-socket-pressure.patch
net-tcp_memcontrol-remove-bogus-hierarchy-pressure-propagation.patch
net-tcp_memcontrol-protect-all-tcp_memcontrol-calls-by-jump-label.patch
net-tcp_memcontrol-remove-dead-per-memcg-count-of-allocated-sockets.patch
net-tcp_memcontrol-simplify-the-per-memcg-limit-access.patch
net-tcp_memcontrol-sanitize-tcp-memory-accounting-callbacks.patch
net-tcp_memcontrol-simplify-linkage-between-socket-and-page-counter.patch
mm-memcontrol-generalize-the-socket-accounting-jump-label.patch
mm-memcontrol-do-not-account-memoryswap-on-unified-hierarchy.patch
mm-memcontrol-move-socket-code-for-unified-hierarchy-accounting.patch
mm-memcontrol-account-socket-memory-in-unified-hierarchy-memory-controller.patch
mm-memcontrol-hook-up-vmpressure-to-socket-pressure.patch
mm-memcontrol-switch-to-the-updated-jump-label-api.patch
mm-memcontrol-drop-unused-css-argument-in-memcg_init_kmem.patch
mm-memcontrol-remove-double-kmem-page_counter-init.patch
mm-memcontrol-give-the-kmem-states-more-descriptive-names.patch
mm-memcontrol-group-kmem-init-and-exit-functions-together.patch
mm-memcontrol-separate-kmem-code-from-legacy-tcp-accounting-code.patch
mm-memcontrol-move-kmem-accounting-code-to-config_memcg.patch
mm-memcontrol-account-kmem-consumers-in-cgroup2-memory-controller.patch
mm-memcontrol-introduce-config_memcg_legacy_kmem.patch

