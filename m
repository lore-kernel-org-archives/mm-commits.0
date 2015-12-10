From: akpm@linux-foundation.org
Subject: + net-drop-tcp_memcontrolc.patch added to -mm tree
Date: Wed, 09 Dec 2015 16:09:09 -0800
Message-ID: <5668c2a5.skRwKYNxeunGiABm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45030 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbbLJAJK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Dec 2015 19:09:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, davem@davemloft.net, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: net: drop tcp_memcontrol.c
has been added to the -mm tree.  Its filename is
     net-drop-tcp_memcontrolc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/net-drop-tcp_memcontrolc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/net-drop-tcp_memcontrolc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: net: drop tcp_memcontrol.c

tcp_memcontrol.c only contains legacy memory.tcp.kmem.* file definitions
and mem_cgroup->tcp_mem init/destroy stuff.  This doesn't belong to
network subsys.  Let's move it to memcontrol.c.  This also allows us to
reuse generic code for handling legacy memcg files.

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/net/tcp_memcontrol.h |    7 -
 mm/memcontrol.c              |  100 +++++++++++++++-
 net/ipv4/Makefile            |    1 
 net/ipv4/sysctl_net_ipv4.c   |    1 
 net/ipv4/tcp_ipv4.c          |    1 
 net/ipv4/tcp_memcontrol.c    |  200 ---------------------------------
 net/ipv6/tcp_ipv6.c          |    1 
 7 files changed, 92 insertions(+), 219 deletions(-)

diff -puN include/net/tcp_memcontrol.h~net-drop-tcp_memcontrolc /dev/null
--- a/include/net/tcp_memcontrol.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef _TCP_MEMCG_H
-#define _TCP_MEMCG_H
-
-int tcp_init_cgroup(struct mem_cgroup *memcg);
-void tcp_destroy_cgroup(struct mem_cgroup *memcg);
-
-#endif /* _TCP_MEMCG_H */
diff -puN mm/memcontrol.c~net-drop-tcp_memcontrolc mm/memcontrol.c
--- a/mm/memcontrol.c~net-drop-tcp_memcontrolc
+++ a/mm/memcontrol.c
@@ -66,7 +66,6 @@
 #include "internal.h"
 #include <net/sock.h>
 #include <net/ip.h>
-#include <net/tcp_memcontrol.h>
 #include "slab.h"
 
 #include <asm/uaccess.h>
@@ -239,6 +238,7 @@ enum res_type {
 	_MEMSWAP,
 	_OOM_TYPE,
 	_KMEM,
+	_TCP,
 };
 
 #define MEMFILE_PRIVATE(x, val)	((x) << 16 | (val))
@@ -2813,6 +2813,11 @@ static u64 mem_cgroup_read_u64(struct cg
 	case _KMEM:
 		counter = &memcg->kmem;
 		break;
+#if defined(CONFIG_MEMCG_LEGACY_KMEM) && defined(CONFIG_INET)
+	case _TCP:
+		counter = &memcg->tcp_mem.memory_allocated;
+		break;
+#endif
 	default:
 		BUG();
 	}
@@ -2985,6 +2990,48 @@ static int memcg_update_kmem_limit(struc
 }
 #endif /* CONFIG_MEMCG_LEGACY_KMEM */
 
+#if defined(CONFIG_MEMCG_LEGACY_KMEM) && defined(CONFIG_INET)
+static int memcg_update_tcp_limit(struct mem_cgroup *memcg, unsigned long limit)
+{
+	int ret;
+
+	mutex_lock(&memcg_limit_mutex);
+
+	ret = page_counter_limit(&memcg->tcp_mem.memory_allocated, limit);
+	if (ret)
+		goto out;
+
+	if (!memcg->tcp_mem.active) {
+		/*
+		 * The active flag needs to be written after the static_key
+		 * update. This is what guarantees that the socket activation
+		 * function is the last one to run. See sock_update_memcg() for
+		 * details, and note that we don't mark any socket as belonging
+		 * to this memcg until that flag is up.
+		 *
+		 * We need to do this, because static_keys will span multiple
+		 * sites, but we can't control their order. If we mark a socket
+		 * as accounted, but the accounting functions are not patched in
+		 * yet, we'll lose accounting.
+		 *
+		 * We never race with the readers in sock_update_memcg(),
+		 * because when this value change, the code to process it is not
+		 * patched in yet.
+		 */
+		static_branch_inc(&memcg_sockets_enabled_key);
+		memcg->tcp_mem.active = true;
+	}
+out:
+	mutex_unlock(&memcg_limit_mutex);
+	return ret;
+}
+#else
+static int memcg_update_tcp_limit(struct mem_cgroup *memcg, unsigned long limit)
+{
+	return -EINVAL;
+}
+#endif /* CONFIG_MEMCG_LEGACY_KMEM && CONFIG_INET */
+
 /*
  * The user of this function is...
  * RES_LIMIT.
@@ -3017,6 +3064,9 @@ static ssize_t mem_cgroup_write(struct k
 		case _KMEM:
 			ret = memcg_update_kmem_limit(memcg, nr_pages);
 			break;
+		case _TCP:
+			ret = memcg_update_tcp_limit(memcg, nr_pages);
+			break;
 		}
 		break;
 	case RES_SOFT_LIMIT:
@@ -3043,6 +3093,11 @@ static ssize_t mem_cgroup_reset(struct k
 	case _KMEM:
 		counter = &memcg->kmem;
 		break;
+#if defined(CONFIG_MEMCG_LEGACY_KMEM) && defined(CONFIG_INET)
+	case _TCP:
+		counter = &memcg->tcp_mem.memory_allocated;
+		break;
+#endif
 	default:
 		BUG();
 	}
@@ -4028,6 +4083,31 @@ static struct cftype mem_cgroup_legacy_f
 		.seq_show = memcg_slab_show,
 	},
 #endif
+#ifdef CONFIG_INET
+	{
+		.name = "kmem.tcp.limit_in_bytes",
+		.private = MEMFILE_PRIVATE(_TCP, RES_LIMIT),
+		.write = mem_cgroup_write,
+		.read_u64 = mem_cgroup_read_u64,
+	},
+	{
+		.name = "kmem.tcp.usage_in_bytes",
+		.private = MEMFILE_PRIVATE(_TCP, RES_USAGE),
+		.read_u64 = mem_cgroup_read_u64,
+	},
+	{
+		.name = "kmem.tcp.failcnt",
+		.private = MEMFILE_PRIVATE(_TCP, RES_FAILCNT),
+		.write = mem_cgroup_reset,
+		.read_u64 = mem_cgroup_read_u64,
+	},
+	{
+		.name = "kmem.tcp.max_usage_in_bytes",
+		.private = MEMFILE_PRIVATE(_TCP, RES_MAX_USAGE),
+		.write = mem_cgroup_reset,
+		.read_u64 = mem_cgroup_read_u64,
+	},
+#endif
 #endif
 	{ },	/* terminate */
 };
@@ -4195,6 +4275,10 @@ mem_cgroup_css_online(struct cgroup_subs
 		memcg->soft_limit = PAGE_COUNTER_MAX;
 		page_counter_init(&memcg->memsw, &parent->memsw);
 		page_counter_init(&memcg->kmem, &parent->kmem);
+#if defined(CONFIG_MEMCG_LEGACY_KMEM) && defined(CONFIG_INET)
+		page_counter_init(&memcg->tcp_mem.memory_allocated,
+				  &parent->tcp_mem.memory_allocated);
+#endif
 
 		/*
 		 * No need to take a reference to the parent because cgroup
@@ -4206,6 +4290,9 @@ mem_cgroup_css_online(struct cgroup_subs
 		memcg->soft_limit = PAGE_COUNTER_MAX;
 		page_counter_init(&memcg->memsw, NULL);
 		page_counter_init(&memcg->kmem, NULL);
+#if defined(CONFIG_MEMCG_LEGACY_KMEM) && defined(CONFIG_INET)
+		page_counter_init(&memcg->tcp_mem.memory_allocated, NULL);
+#endif
 		/*
 		 * Deeper hierachy with use_hierarchy == false doesn't make
 		 * much sense so let cgroup subsystem know about this
@@ -4221,12 +4308,6 @@ mem_cgroup_css_online(struct cgroup_subs
 		return ret;
 
 #ifdef CONFIG_INET
-#ifdef CONFIG_MEMCG_LEGACY_KMEM
-	ret = tcp_init_cgroup(memcg);
-	if (ret)
-		return ret;
-#endif
-
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nosocket)
 		static_branch_inc(&memcg_sockets_enabled_key);
 #endif
@@ -4277,9 +4358,12 @@ static void mem_cgroup_css_free(struct c
 	memcg_free_kmem(memcg);
 
 #if defined(CONFIG_MEMCG_LEGACY_KMEM) && defined(CONFIG_INET)
-	tcp_destroy_cgroup(memcg);
+	if (memcg->tcp_mem.active)
+		static_branch_dec(&memcg_sockets_enabled_key);
 #endif
 
+	memcg_free_kmem(memcg);
+
 	__mem_cgroup_free(memcg);
 }
 
diff -puN net/ipv4/Makefile~net-drop-tcp_memcontrolc net/ipv4/Makefile
--- a/net/ipv4/Makefile~net-drop-tcp_memcontrolc
+++ a/net/ipv4/Makefile
@@ -56,7 +56,6 @@ obj-$(CONFIG_TCP_CONG_SCALABLE) += tcp_s
 obj-$(CONFIG_TCP_CONG_LP) += tcp_lp.o
 obj-$(CONFIG_TCP_CONG_YEAH) += tcp_yeah.o
 obj-$(CONFIG_TCP_CONG_ILLINOIS) += tcp_illinois.o
-obj-$(CONFIG_MEMCG_LEGACY_KMEM) += tcp_memcontrol.o
 obj-$(CONFIG_NETLABEL) += cipso_ipv4.o
 
 obj-$(CONFIG_XFRM) += xfrm4_policy.o xfrm4_state.o xfrm4_input.o \
diff -puN net/ipv4/sysctl_net_ipv4.c~net-drop-tcp_memcontrolc net/ipv4/sysctl_net_ipv4.c
--- a/net/ipv4/sysctl_net_ipv4.c~net-drop-tcp_memcontrolc
+++ a/net/ipv4/sysctl_net_ipv4.c
@@ -24,7 +24,6 @@
 #include <net/cipso_ipv4.h>
 #include <net/inet_frag.h>
 #include <net/ping.h>
-#include <net/tcp_memcontrol.h>
 
 static int zero;
 static int one = 1;
diff -puN net/ipv4/tcp_ipv4.c~net-drop-tcp_memcontrolc net/ipv4/tcp_ipv4.c
--- a/net/ipv4/tcp_ipv4.c~net-drop-tcp_memcontrolc
+++ a/net/ipv4/tcp_ipv4.c
@@ -73,7 +73,6 @@
 #include <net/timewait_sock.h>
 #include <net/xfrm.h>
 #include <net/secure_seq.h>
-#include <net/tcp_memcontrol.h>
 #include <net/busy_poll.h>
 
 #include <linux/inet.h>
diff -puN net/ipv4/tcp_memcontrol.c~net-drop-tcp_memcontrolc /dev/null
--- a/net/ipv4/tcp_memcontrol.c
+++ /dev/null
@@ -1,200 +0,0 @@
-#include <net/tcp.h>
-#include <net/tcp_memcontrol.h>
-#include <net/sock.h>
-#include <net/ip.h>
-#include <linux/nsproxy.h>
-#include <linux/memcontrol.h>
-#include <linux/module.h>
-
-int tcp_init_cgroup(struct mem_cgroup *memcg)
-{
-	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
-	struct page_counter *counter_parent = NULL;
-	/*
-	 * The root cgroup does not use page_counters, but rather,
-	 * rely on the data already collected by the network
-	 * subsystem
-	 */
-	if (memcg == root_mem_cgroup)
-		return 0;
-
-	memcg->tcp_mem.memory_pressure = 0;
-
-	if (parent)
-		counter_parent = &parent->tcp_mem.memory_allocated;
-
-	page_counter_init(&memcg->tcp_mem.memory_allocated, counter_parent);
-
-	return 0;
-}
-
-void tcp_destroy_cgroup(struct mem_cgroup *memcg)
-{
-	if (memcg == root_mem_cgroup)
-		return;
-
-	if (memcg->tcp_mem.active)
-		static_branch_dec(&memcg_sockets_enabled_key);
-}
-
-static int tcp_update_limit(struct mem_cgroup *memcg, unsigned long nr_pages)
-{
-	int ret;
-
-	if (memcg == root_mem_cgroup)
-		return -EINVAL;
-
-	ret = page_counter_limit(&memcg->tcp_mem.memory_allocated, nr_pages);
-	if (ret)
-		return ret;
-
-	if (!memcg->tcp_mem.active) {
-		/*
-		 * The active flag needs to be written after the static_key
-		 * update. This is what guarantees that the socket activation
-		 * function is the last one to run. See sock_update_memcg() for
-		 * details, and note that we don't mark any socket as belonging
-		 * to this memcg until that flag is up.
-		 *
-		 * We need to do this, because static_keys will span multiple
-		 * sites, but we can't control their order. If we mark a socket
-		 * as accounted, but the accounting functions are not patched in
-		 * yet, we'll lose accounting.
-		 *
-		 * We never race with the readers in sock_update_memcg(),
-		 * because when this value change, the code to process it is not
-		 * patched in yet.
-		 */
-		static_branch_inc(&memcg_sockets_enabled_key);
-		memcg->tcp_mem.active = true;
-	}
-
-	return 0;
-}
-
-enum {
-	RES_USAGE,
-	RES_LIMIT,
-	RES_MAX_USAGE,
-	RES_FAILCNT,
-};
-
-static DEFINE_MUTEX(tcp_limit_mutex);
-
-static ssize_t tcp_cgroup_write(struct kernfs_open_file *of,
-				char *buf, size_t nbytes, loff_t off)
-{
-	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
-	unsigned long nr_pages;
-	int ret = 0;
-
-	buf = strstrip(buf);
-
-	switch (of_cft(of)->private) {
-	case RES_LIMIT:
-		/* see memcontrol.c */
-		ret = page_counter_memparse(buf, "-1", &nr_pages);
-		if (ret)
-			break;
-		mutex_lock(&tcp_limit_mutex);
-		ret = tcp_update_limit(memcg, nr_pages);
-		mutex_unlock(&tcp_limit_mutex);
-		break;
-	default:
-		ret = -EINVAL;
-		break;
-	}
-	return ret ?: nbytes;
-}
-
-static u64 tcp_cgroup_read(struct cgroup_subsys_state *css, struct cftype *cft)
-{
-	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
-	u64 val;
-
-	switch (cft->private) {
-	case RES_LIMIT:
-		if (memcg == root_mem_cgroup)
-			val = PAGE_COUNTER_MAX;
-		else
-			val = memcg->tcp_mem.memory_allocated.limit;
-		val *= PAGE_SIZE;
-		break;
-	case RES_USAGE:
-		if (memcg == root_mem_cgroup)
-			val = atomic_long_read(&tcp_memory_allocated);
-		else
-			val = page_counter_read(&memcg->tcp_mem.memory_allocated);
-		val *= PAGE_SIZE;
-		break;
-	case RES_FAILCNT:
-		if (memcg == root_mem_cgroup)
-			return 0;
-		val = memcg->tcp_mem.memory_allocated.failcnt;
-		break;
-	case RES_MAX_USAGE:
-		if (memcg == root_mem_cgroup)
-			return 0;
-		val = memcg->tcp_mem.memory_allocated.watermark;
-		val *= PAGE_SIZE;
-		break;
-	default:
-		BUG();
-	}
-	return val;
-}
-
-static ssize_t tcp_cgroup_reset(struct kernfs_open_file *of,
-				char *buf, size_t nbytes, loff_t off)
-{
-	struct mem_cgroup *memcg;
-
-	memcg = mem_cgroup_from_css(of_css(of));
-	if (memcg == root_mem_cgroup)
-		return nbytes;
-
-	switch (of_cft(of)->private) {
-	case RES_MAX_USAGE:
-		page_counter_reset_watermark(&memcg->tcp_mem.memory_allocated);
-		break;
-	case RES_FAILCNT:
-		memcg->tcp_mem.memory_allocated.failcnt = 0;
-		break;
-	}
-
-	return nbytes;
-}
-
-static struct cftype tcp_files[] = {
-	{
-		.name = "kmem.tcp.limit_in_bytes",
-		.write = tcp_cgroup_write,
-		.read_u64 = tcp_cgroup_read,
-		.private = RES_LIMIT,
-	},
-	{
-		.name = "kmem.tcp.usage_in_bytes",
-		.read_u64 = tcp_cgroup_read,
-		.private = RES_USAGE,
-	},
-	{
-		.name = "kmem.tcp.failcnt",
-		.private = RES_FAILCNT,
-		.write = tcp_cgroup_reset,
-		.read_u64 = tcp_cgroup_read,
-	},
-	{
-		.name = "kmem.tcp.max_usage_in_bytes",
-		.private = RES_MAX_USAGE,
-		.write = tcp_cgroup_reset,
-		.read_u64 = tcp_cgroup_read,
-	},
-	{ }	/* terminate */
-};
-
-static int __init tcp_memcontrol_init(void)
-{
-	WARN_ON(cgroup_add_legacy_cftypes(&memory_cgrp_subsys, tcp_files));
-	return 0;
-}
-__initcall(tcp_memcontrol_init);
diff -puN net/ipv6/tcp_ipv6.c~net-drop-tcp_memcontrolc net/ipv6/tcp_ipv6.c
--- a/net/ipv6/tcp_ipv6.c~net-drop-tcp_memcontrolc
+++ a/net/ipv6/tcp_ipv6.c
@@ -61,7 +61,6 @@
 #include <net/timewait_sock.h>
 #include <net/inet_common.h>
 #include <net/secure_seq.h>
-#include <net/tcp_memcontrol.h>
 #include <net/busy_poll.h>
 
 #include <linux/proc_fs.h>
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

memcg-fix-memoryhigh-target.patch
revert-kernfs-do-not-account-ino_ida-allocations-to-memcg.patch
revert-gfp-add-__gfp_noaccount.patch
memcg-only-account-kmem-allocations-marked-as-__gfp_account.patch
slab-add-slab_account-flag.patch
vmalloc-allow-to-account-vmalloc-to-memcg.patch
account-certain-kmem-allocations-to-memcg.patch
vmscan-do-not-force-scan-file-lru-if-its-absolute-size-is-small.patch
vmscan-do-not-force-scan-file-lru-if-its-absolute-size-is-small-v2.patch
memcg-do-not-allow-to-disable-tcp-accounting-after-limit-is-set.patch
mm-add-page_check_address_transhuge-helper.patch
mm-add-page_check_address_transhuge-helper-fix.patch
net-drop-tcp_memcontrolc.patch

