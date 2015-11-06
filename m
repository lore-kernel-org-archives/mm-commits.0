From: akpm@linux-foundation.org
Subject: [merged] mm-memcontrol-eliminate-root-memorycurrent.patch removed from -mm tree
Date: Fri, 06 Nov 2015 12:17:12 -0800
Message-ID: <563d0ac8./Z8hEOiElIIbmo3e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49072 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162922AbbKFURM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:17:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: eliminate root memory.current
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-eliminate-root-memorycurrent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: eliminate root memory.current

memory.current on the root level doesn't add anything that wouldn't be
more accurate and detailed using system statistics.  It already doesn't
include slabs, and it'll be a pain to keep in sync when further memory
types are accounted in the memory controller.  Remove it.

Note that this applies to the new unified hierarchy interface only.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~mm-memcontrol-eliminate-root-memorycurrent mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-eliminate-root-memorycurrent
+++ a/mm/memcontrol.c
@@ -5026,7 +5026,9 @@ static void mem_cgroup_bind(struct cgrou
 static u64 memory_current_read(struct cgroup_subsys_state *css,
 			       struct cftype *cft)
 {
-	return mem_cgroup_usage(mem_cgroup_from_css(css), false);
+	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
+
+	return (u64)page_counter_read(&memcg->memory) * PAGE_SIZE;
 }
 
 static int memory_low_show(struct seq_file *m, void *v)
@@ -5138,6 +5140,7 @@ static int memory_events_show(struct seq
 static struct cftype memory_files[] = {
 	{
 		.name = "current",
+		.flags = CFTYPE_NOT_ON_ROOT,
 		.read_u64 = memory_current_read,
 	},
 	{
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix.patch

