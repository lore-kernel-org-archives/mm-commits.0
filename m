From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-allow-to-disable-kmem-accounting-for-cgroup2.patch removed
 from -mm tree
Date: Thu, 21 Jan 2016 15:29:38 -0800
Message-ID: <56a169e2.HxkhMS47rsw8ygir%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36371 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbcAUX3i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 18:29:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: allow to disable kmem accounting for cgroup2
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-allow-to-disable-kmem-accounting-for-cgroup2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: mm: memcontrol: allow to disable kmem accounting for cgroup2

Kmem accounting might incur overhead that some users can't put up with. 
Besides, the implementation is still considered unstable.  So let's
provide a way to disable it for those users who aren't happy with it.

To disable kmem accounting for cgroup2, pass cgroup.memory=nokmem at
boot time.

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    1 +
 mm/memcontrol.c                     |    9 +++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff -puN Documentation/kernel-parameters.txt~mm-memcontrol-allow-to-disable-kmem-accounting-for-cgroup2 Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~mm-memcontrol-allow-to-disable-kmem-accounting-for-cgroup2
+++ a/Documentation/kernel-parameters.txt
@@ -611,6 +611,7 @@ bytes respectively. Such letter suffixes
 	cgroup.memory=	[KNL] Pass options to the cgroup memory controller.
 			Format: <string>
 			nosocket -- Disable socket memory accounting.
+			nokmem -- Disable kernel memory accounting.
 
 	checkreqprot	[SELINUX] Set initial checkreqprot flag value.
 			Format: { "0" | "1" }
diff -puN mm/memcontrol.c~mm-memcontrol-allow-to-disable-kmem-accounting-for-cgroup2 mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-allow-to-disable-kmem-accounting-for-cgroup2
+++ a/mm/memcontrol.c
@@ -83,6 +83,9 @@ struct mem_cgroup *root_mem_cgroup __rea
 /* Socket memory accounting disabled? */
 static bool cgroup_memory_nosocket;
 
+/* Kernel memory accounting disabled? */
+static bool cgroup_memory_nokmem;
+
 /* Whether the swap controller is active */
 #ifdef CONFIG_MEMCG_SWAP
 int do_swap_account __read_mostly;
@@ -2925,8 +2928,8 @@ static int memcg_propagate_kmem(struct m
 	 * onlined after this point, because it has at least one child
 	 * already.
 	 */
-	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) ||
-	    memcg_kmem_online(parent))
+	if (memcg_kmem_online(parent) ||
+	    (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nokmem))
 		ret = memcg_online_kmem(memcg);
 	mutex_unlock(&memcg_limit_mutex);
 	return ret;
@@ -5638,6 +5641,8 @@ static int __init cgroup_memory(char *s)
 			continue;
 		if (!strcmp(token, "nosocket"))
 			cgroup_memory_nosocket = true;
+		if (!strcmp(token, "nokmem"))
+			cgroup_memory_nokmem = true;
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are


