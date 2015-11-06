From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memcontrol-eliminate-root-memorycurrent-fix-2.patch removed from -mm
 tree
Date: Thu, 05 Nov 2015 18:29:44 -0800
Message-ID: <563c1098.uDj42aDxN66lCJ3a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52508 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031154AbbKFC3o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Nov 2015 21:29:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcontrol-eliminate-root-memorycurrent-fix-2
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-eliminate-root-memorycurrent-fix-2.patch

This patch was dropped because it was folded into mm-memcontrol-eliminate-root-memorycurrent.patch

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
@@ -5026,7 +5026,9 @@ static void mem_cgroup_bind(struct cgrou
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

mm-memcontrol-eliminate-root-memorycurrent.patch
mm-page_counter-let-page_counter_try_charge-return-bool.patch

