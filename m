From: akpm@linux-foundation.org
Subject: + mm-memcontrol-avoid-unused-function-warning.patch added to -mm
 tree
Date: Wed, 24 Aug 2016 14:24:57 -0700
Message-ID: <57be10a9.sKqx55u5bl959QN2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58552 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756102AbcHXVZk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 Aug 2016 17:25:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, mhocko@suse.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: avoid unused function warning
has been added to the -mm tree.  Its filename is
     mm-memcontrol-avoid-unused-function-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-avoid-unused-function-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-avoid-unused-function-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm: memcontrol: avoid unused function warning

A bugfix in v4.8-rc2 introduced a harmless warning when CONFIG_MEMCG_SWAP
is disabled but CONFIG_MEMCG is enabled:

mm/memcontrol.c:4085:27: error: 'mem_cgroup_id_get_online' defined but not used [-Werror=unused-function]
 static struct mem_cgroup *mem_cgroup_id_get_online(struct mem_cgroup *memcg)

This moves the function inside of the #ifdef block that hides the
calling function, to avoid the warning.

Fixes: 1f47b61fb407 ("mm: memcontrol: fix swap counter leak on swapout from offline cgroup")
Link: http://lkml.kernel.org/r/20160824113733.2776701-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-avoid-unused-function-warning mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-avoid-unused-function-warning
+++ a/mm/memcontrol.c
@@ -4082,24 +4082,6 @@ static void mem_cgroup_id_get_many(struc
 	atomic_add(n, &memcg->id.ref);
 }
 
-static struct mem_cgroup *mem_cgroup_id_get_online(struct mem_cgroup *memcg)
-{
-	while (!atomic_inc_not_zero(&memcg->id.ref)) {
-		/*
-		 * The root cgroup cannot be destroyed, so it's refcount must
-		 * always be >= 1.
-		 */
-		if (WARN_ON_ONCE(memcg == root_mem_cgroup)) {
-			VM_BUG_ON(1);
-			break;
-		}
-		memcg = parent_mem_cgroup(memcg);
-		if (!memcg)
-			memcg = root_mem_cgroup;
-	}
-	return memcg;
-}
-
 static void mem_cgroup_id_put_many(struct mem_cgroup *memcg, unsigned int n)
 {
 	if (atomic_sub_and_test(n, &memcg->id.ref)) {
@@ -5821,6 +5803,24 @@ static int __init mem_cgroup_init(void)
 subsys_initcall(mem_cgroup_init);
 
 #ifdef CONFIG_MEMCG_SWAP
+static struct mem_cgroup *mem_cgroup_id_get_online(struct mem_cgroup *memcg)
+{
+	while (!atomic_inc_not_zero(&memcg->id.ref)) {
+		/*
+		 * The root cgroup cannot be destroyed, so it's refcount must
+		 * always be >= 1.
+		 */
+		if (WARN_ON_ONCE(memcg == root_mem_cgroup)) {
+			VM_BUG_ON(1);
+			break;
+		}
+		memcg = parent_mem_cgroup(memcg);
+		if (!memcg)
+			memcg = root_mem_cgroup;
+	}
+	return memcg;
+}
+
 /**
  * mem_cgroup_swapout - transfer a memsw charge to swap
  * @page: page whose memsw charge to transfer
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-memcontrol-avoid-unused-function-warning.patch
compat-remove-compat_printk.patch

