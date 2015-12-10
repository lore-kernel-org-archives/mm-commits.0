From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-allow-to-disable-kmem-accounting-for-cgroup2.patch added to
 -mm tree
Date: Wed, 09 Dec 2015 16:13:42 -0800
Message-ID: <5668c3b6.GVNgR5HBeCHYAUvH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45515 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbbLJANn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Dec 2015 19:13:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: allow to disable kmem accounting for cgroup2
has been added to the -mm tree.  Its filename is
     mm-memcontrol-allow-to-disable-kmem-accounting-for-cgroup2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-allow-to-disable-kmem-accounting-for-cgroup2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-allow-to-disable-kmem-accounting-for-cgroup2.patch

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
@@ -602,6 +602,7 @@ bytes respectively. Such letter suffixes
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
@@ -2898,8 +2901,8 @@ static int memcg_propagate_kmem(struct m
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
@@ -5587,6 +5590,8 @@ static int __init cgroup_memory(char *s)
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
mm-memcontrol-allow-to-disable-kmem-accounting-for-cgroup2.patch
net-drop-tcp_memcontrolc.patch

