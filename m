From: akpm@linux-foundation.org
Subject: + memcg-get-put-parents-at-create-free-fix.patch added to -mm tree
Date: Fri, 16 Jan 2009 14:11:44 -0800
Message-ID: <200901162211.n0GMBihQ000582@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52281 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763652AbZAPWL7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 17:11:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, xemul@openvz.org


The patch titled
     memcg-get-put-parents-at-create-free fix
has been added to the -mm tree.  Its filename is
     memcg-get-put-parents-at-create-free-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg-get-put-parents-at-create-free fix
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

Andrew suggested that it's strange to add a little helper function for get(),
while put() is open-code.

This patch also adds a few comments.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Reviewed-by; KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN mm/memcontrol.c~memcg-get-put-parents-at-create-free-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-get-put-parents-at-create-free-fix
+++ a/mm/memcontrol.c
@@ -203,7 +203,6 @@ pcg_default_flags[NR_CHARGE_TYPE] = {
 static void mem_cgroup_get(struct mem_cgroup *mem);
 static void mem_cgroup_put(struct mem_cgroup *mem);
 static struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *mem);
-static void mem_cgroup_get_parent(struct mem_cgroup *mem);
 
 static void mem_cgroup_charge_statistics(struct mem_cgroup *mem,
 					 struct page_cgroup *pc,
@@ -2203,6 +2202,9 @@ static void mem_cgroup_put(struct mem_cg
 	}
 }
 
+/*
+ * Returns the parent mem_cgroup in memcgroup hierarchy with hierarchy enabled.
+ */
 static struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *mem)
 {
 	if (!mem->res.parent)
@@ -2210,14 +2212,6 @@ static struct mem_cgroup *parent_mem_cgr
 	return mem_cgroup_from_res_counter(mem->res.parent, res);
 }
 
-static void mem_cgroup_get_parent(struct mem_cgroup *mem)
-{
-	struct mem_cgroup *parent = parent_mem_cgroup(mem);
-
-	if (parent)
-		mem_cgroup_get(parent);
-}
-
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
 static void __init enable_swap_cgroup(void)
 {
@@ -2255,6 +2249,13 @@ mem_cgroup_create(struct cgroup_subsys *
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
@@ -2265,7 +2266,6 @@ mem_cgroup_create(struct cgroup_subsys *
 	if (parent)
 		mem->swappiness = get_swappiness(parent);
 	atomic_set(&mem->refcnt, 1);
-	mem_cgroup_get_parent(mem);
 	return &mem->css;
 free_out:
 	__mem_cgroup_free(mem);
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

origin.patch
memcg-get-put-parents-at-create-free.patch
memcg-get-put-parents-at-create-free-fix.patch

