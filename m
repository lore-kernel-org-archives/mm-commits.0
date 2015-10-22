From: akpm@linux-foundation.org
Subject: + mm-memcontrol-eliminate-root-memorycurrent-fix-2.patch added to -mm tree
Date: Thu, 22 Oct 2015 13:24:44 -0700
Message-ID: <5629460c.QefzInS2o31J+bhY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40523 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758043AbbJVUYo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Oct 2015 16:24:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcontrol-eliminate-root-memorycurrent-fix-2
has been added to the -mm tree.  Its filename is
     mm-memcontrol-eliminate-root-memorycurrent-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-eliminate-root-memorycurrent-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-eliminate-root-memorycurrent-fix-2.patch

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
Subject: mm-memcontrol-eliminate-root-memorycurrent-fix-2

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~mm-memcontrol-eliminate-root-memorycurrent-fix-2 mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-eliminate-root-memorycurrent-fix-2
+++ a/mm/memcontrol.c
@@ -5027,7 +5027,9 @@ static void mem_cgroup_bind(struct cgrou
 static u64 memory_current_read(struct cgroup_subsys_state *css,
 			       struct cftype *cft)
 {
-	return page_counter_read(&mem_cgroup_from_css(css)->memory);
+	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
+
+	return (u64)page_counter_read(&memcg->memory) * PAGE_SIZE;
 }
 
 static int memory_low_show(struct seq_file *m, void *v)
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

memcg-unify-slab-and-other-kmem-pages-charging-fix.patch
mm-memcontrol-eliminate-root-memorycurrent.patch
mm-memcontrol-eliminate-root-memorycurrent-fix-2.patch
mm-page_counter-let-page_counter_try_charge-return-bool.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix.patch

