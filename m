From: akpm@linux-foundation.org
Subject: [merged] memcg-get-put-parents-at-create-free.patch removed from -mm tree
Date: Fri, 30 Jan 2009 11:13:45 -0800
Message-ID: <200901301913.n0UJDjci026566@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753113AbZA3TO2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 14:14:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     memcg: get/put parents at create/free
has been removed from the -mm tree.  Its filename was
     memcg-get-put-parents-at-create-free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: get/put parents at create/free
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

The lifetime of struct cgroup and struct mem_cgroup is different and
mem_cgroup has its own reference count for handling references from
swap_cgroup.

This causes strange problem that the parent mem_cgroup dies while child
mem_cgroup alive, and this problem causes a bug in case of
use_hierarchy==1 because res_counter_uncharge climbs up the tree.

This patch is for avoiding it by getting the parent at create, and putting
it at freeing.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Reviewed-by; KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-get-put-parents-at-create-free mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-get-put-parents-at-create-free
+++ a/mm/memcontrol.c
@@ -202,6 +202,7 @@ pcg_default_flags[NR_CHARGE_TYPE] = {
 
 static void mem_cgroup_get(struct mem_cgroup *mem);
 static void mem_cgroup_put(struct mem_cgroup *mem);
+static struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *mem);
 
 static void mem_cgroup_charge_statistics(struct mem_cgroup *mem,
 					 struct page_cgroup *pc,
@@ -2193,10 +2194,23 @@ static void mem_cgroup_get(struct mem_cg
 
 static void mem_cgroup_put(struct mem_cgroup *mem)
 {
-	if (atomic_dec_and_test(&mem->refcnt))
+	if (atomic_dec_and_test(&mem->refcnt)) {
+		struct mem_cgroup *parent = parent_mem_cgroup(mem);
 		__mem_cgroup_free(mem);
+		if (parent)
+			mem_cgroup_put(parent);
+	}
 }
 
+/*
+ * Returns the parent mem_cgroup in memcgroup hierarchy with hierarchy enabled.
+ */
+static struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *mem)
+{
+	if (!mem->res.parent)
+		return NULL;
+	return mem_cgroup_from_res_counter(mem->res.parent, res);
+}
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
 static void __init enable_swap_cgroup(void)
@@ -2235,6 +2249,13 @@ mem_cgroup_create(struct cgroup_subsys *
 	if (parent && parent->use_hierarchy) {
 		res_counter_init(&mem->res, &parent->res);
 		res_counter_init(&mem->memsw, &parent->memsw);
+		/*
+		 * We increment refcnt of the parent to ensure that we can
+		 * safely access it on res_counter_charge/uncharge.
+		 * This refcnt will be decremented when freeing this
+		 * mem_cgroup(see mem_cgroup_put).
+		 */
+		mem_cgroup_get(parent);
 	} else {
 		res_counter_init(&mem->res, NULL);
 		res_counter_init(&mem->memsw, NULL);
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

origin.patch
migration-migrate_vmas-should-check-vma.patch

