From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-micro-optimize-mem_cgroup_split_huge_fixup.patch removed from -mm tree
Date: Thu, 11 Dec 2014 10:56:59 -0800
Message-ID: <5489e8fb.FcCn01W4K3an9J1x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45321 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756095AbaLKS5A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:57:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, hannes@cmpxchg.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: micro-optimize mem_cgroup_split_huge_fixup()
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-micro-optimize-mem_cgroup_split_huge_fixup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: mm: memcontrol: micro-optimize mem_cgroup_split_huge_fixup()

Don't call lookup_page_cgroup() when memcg is disabled.

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~mm-memcontrol-micro-optimize-mem_cgroup_split_huge_fixup mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-micro-optimize-mem_cgroup_split_huge_fixup
+++ a/mm/memcontrol.c
@@ -3174,7 +3174,7 @@ static inline void memcg_unregister_all_
  */
 void mem_cgroup_split_huge_fixup(struct page *head)
 {
-	struct page_cgroup *head_pc = lookup_page_cgroup(head);
+	struct page_cgroup *head_pc;
 	struct page_cgroup *pc;
 	struct mem_cgroup *memcg;
 	int i;
@@ -3182,6 +3182,8 @@ void mem_cgroup_split_huge_fixup(struct
 	if (mem_cgroup_disabled())
 		return;
 
+	head_pc = lookup_page_cgroup(head);
+
 	memcg = head_pc->mem_cgroup;
 	for (i = 1; i < HPAGE_PMD_NR; i++) {
 		pc = head_pc + i;
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
memcg-__mem_cgroup_free-remove-stale-disarm_static_keys-comment.patch
memcg-dont-check-mm-in-__memcg_kmem_get_cachenewpage_charge.patch
memcg-do-not-abuse-memcg_kmem_skip_account.patch
mm-page_isolation-check-pfn-validity-before-access.patch
memcg-zap-kmem_account_flags.patch
memcg-only-check-memcg_kmem_skip_account-in-__memcg_kmem_get_cache.patch
memcg-turn-memcg_kmem_skip_account-into-a-bit-field.patch
mm-support-madvisemadv_free.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch
mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2-fix.patch
oom-kill-the-insufficient-and-no-longer-needed-pt_trace_exit-check.patch
mm-memcontrol-fix-defined-but-not-used-compiler-warning.patch
memcg-fix-possible-use-after-free-in-memcg_kmem_get_cache.patch
mm-memcontrolc-cleaning-up-function-that-are-not-used-anywhere.patch

