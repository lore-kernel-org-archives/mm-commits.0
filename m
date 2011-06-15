From: akpm@linux-foundation.org
Subject: [folded] vmscanmemcg-memcg-aware-swap-token-fix.patch removed from -mm tree
Date: Wed, 15 Jun 2011 15:01:57 -0700
Message-ID: <201106152201.p5FM1vPE022023@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47184 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752483Ab1FOWCf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Jun 2011 18:02:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscanmemcg-memcg-aware-swap-token-fix
has been removed from the -mm tree.  Its filename was
     vmscanmemcg-memcg-aware-swap-token-fix.patch

This patch was dropped because it was folded into vmscanmemcg-memcg-aware-swap-token.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscanmemcg-memcg-aware-swap-token-fix
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

> CONFIG_CGROUPS=n:
>
> mm/thrash.c: In function 'grab_swap_token':
> mm/thrash.c:73: error: implicit declaration of function 'css_put'
>
> I don't think that adding a null stub for css_put() is the right fix
> here...

My bad. Following patch fixes this issue.

Thanks.

From 6a824b46219cb2f11b125e9a33f65e0f01899d09 Mon Sep 17 00:00:00 2001
Date: Mon, 30 May 2011 15:47:32 +0900
Subject: [PATCH] swap-token: fix compilation error when CONFIG_CGROUPS=n

Andrew Morton pointed out css_put() is not defined when
CONFIG_CGROUPS=n.

: CONFIG_CGROUPS=n:
:
: mm/thrash.c: In function 'grab_swap_token':
: mm/thrash.c:73: error: implicit declaration of function 'css_put'

Thus, this patch move the whole logic into CONFIG_CGROUP_MEM_RES_CTLR
condtion.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Rik van Riel<riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/thrash.c |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff -puN mm/thrash.c~vmscanmemcg-memcg-aware-swap-token-fix mm/thrash.c
--- a/mm/thrash.c~vmscanmemcg-memcg-aware-swap-token-fix
+++ a/mm/thrash.c
@@ -28,10 +28,27 @@ struct mm_struct *swap_token_mm;
 struct mem_cgroup *swap_token_memcg;
 static unsigned int global_faults;
 
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+static struct mem_cgroup* swap_token_memcg_from_mm(struct mm_struct *mm)
+{
+	struct mem_cgroup *memcg;
+
+	memcg = try_get_mem_cgroup_from_mm(mm);
+	if (memcg)
+		css_put(mem_cgroup_css(memcg));
+
+	return memcg;
+}
+#else
+static struct mem_cgroup* swap_token_memcg_from_mm(struct mm_struct *mm)
+{
+	return NULL;
+}
+#endif
+
 void grab_swap_token(struct mm_struct *mm)
 {
 	int current_interval;
-	struct mem_cgroup *memcg;
 
 	global_faults++;
 
@@ -68,11 +85,8 @@ out:
 
 replace_token:
 	mm->token_priority += 2;
-	memcg = try_get_mem_cgroup_from_mm(mm);
-	if (memcg)
-		css_put(mem_cgroup_css(memcg));
 	swap_token_mm = mm;
-	swap_token_memcg = memcg;
+	swap_token_memcg = swap_token_memcg_from_mm(mm);
 	goto out;
 }
 
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

vmscanmemcg-memcg-aware-swap-token.patch
vmscanmemcg-memcg-aware-swap-token-fix-checkpatch-fixes.patch
vmscan-implement-swap-token-trace.patch
vmscan-implement-swap-token-priority-aging.patch
memcg-add-documentation-for-the-memorynumastat-api.patch
memcg-add-documentation-for-the-memorynumastat-api-fix.patch
mm-increase-reclaim_distance-to-30.patch
mm-migratec-dont-account-swapcache-as-shmem.patch
build_bug_on_zero-fix-sparse-breakage.patch
slab-use-numa_no_node.patch
mm-swap-token-fix-dead-link.patch
mm-swap-token-makes-global-variables-to-function-local.patch
mm-swap-token-add-a-comment-for-priority-aging.patch
pagewalk-fix-walk_page_range-dont-check-find_vma-result-properly.patch
pagewalk-dont-look-up-vma-if-walk-hugetlb_entry-is-unused.patch
pagewalk-add-locking-rule-comments.patch
pagewalk-add-locking-rule-comments-fix.patch
pagewalk-fix-code-comment-for-thp.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
cpumask-convert-for_each_cpumask-with-for_each_cpu.patch
cpumask-alloc_cpumask_var-use-numa_no_node.patch
cpumask-add-cpumask_var_t-documentation.patch
kexec-remove-kmsg_dump_kexec.patch

