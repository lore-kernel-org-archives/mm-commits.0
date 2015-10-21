From: akpm@linux-foundation.org
Subject: + mm-memcontrol-eliminate-root-memorycurrent.patch added to -mm
 tree
Date: Wed, 21 Oct 2015 13:56:24 -0700
Message-ID: <5627fbf8.dnh7gAwZUqUo1yAM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44880 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715AbbJUU4Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Oct 2015 16:56:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: eliminate root memory.current
has been added to the -mm tree.  Its filename is
     mm-memcontrol-eliminate-root-memorycurrent.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-eliminate-root-memorycurrent.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-eliminate-root-memorycurrent.patch

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
Subject: mm: memcontrol: eliminate root memory.current

memory.current on the root level doesn't add anything that wouldn't be
more accurate and detailed using system statistics.  It already doesn't
include slabs, and it'll be a pain to keep in sync when further memory
types are accounted in the memory controller.  Remove it.

Note that this applies to the new unified hierarchy interface only.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~mm-memcontrol-eliminate-root-memorycurrent mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-eliminate-root-memorycurrent
+++ a/mm/memcontrol.c
@@ -5027,7 +5027,7 @@ static void mem_cgroup_bind(struct cgrou
 static u64 memory_current_read(struct cgroup_subsys_state *css,
 			       struct cftype *cft)
 {
-	return mem_cgroup_usage(mem_cgroup_from_css(css), false);
+	return page_counter_read(&mem_cgroup_from_css(css)->memory);
 }
 
 static int memory_low_show(struct seq_file *m, void *v)
@@ -5139,6 +5139,7 @@ static int memory_events_show(struct seq
 static struct cftype memory_files[] = {
 	{
 		.name = "current",
+		.flags = CFTYPE_NOT_ON_ROOT,
 		.read_u64 = memory_current_read,
 	},
 	{
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

memcg-unify-slab-and-other-kmem-pages-charging-fix.patch
mm-memcontrol-eliminate-root-memorycurrent.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix.patch

