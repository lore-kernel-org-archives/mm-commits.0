From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged]
 mm-memcg-prevent-missed-memorylow-load-tears.patch removed from -mm tree
Date: Fri, 26 Jun 2020 20:33:51 -0700
Message-ID: <20200627033351.zo_L08tBf%akpm@linux-foundation.org>
References: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725913AbgF0Ddw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Jun 2020 23:33:52 -0400
In-Reply-To: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chris@chrisdown.name, mhocko@suse.com, mkoutny@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcontrol.c: prevent missed memory.low load tears
has been removed from the -mm tree.  Its filename was
     mm-memcg-prevent-missed-memorylow-load-tears.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chris Down <chris@chrisdown.name>
Subject: mm/memcontrol.c: prevent missed memory.low load tears

Looks like one of these got missed when massaging in f86b810c2610 ("mm,
memcg: prevent memory.low load/store tearing") with other linux-mm
changes.

Link: http://lkml.kernel.org/r/20200612174437.GA391453@chrisdown.name
Signed-off-by: Chris Down <chris@chrisdown.name>
Reported-by: Michal Koutny <mkoutny@suse.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-prevent-missed-memorylow-load-tears
+++ a/mm/memcontrol.c
@@ -6423,7 +6423,7 @@ enum mem_cgroup_protection mem_cgroup_pr
 
 	if (parent == root) {
 		memcg->memory.emin = READ_ONCE(memcg->memory.min);
-		memcg->memory.elow = memcg->memory.low;
+		memcg->memory.elow = READ_ONCE(memcg->memory.low);
 		goto out;
 	}
 
@@ -6435,7 +6435,8 @@ enum mem_cgroup_protection mem_cgroup_pr
 			atomic_long_read(&parent->memory.children_min_usage)));
 
 	WRITE_ONCE(memcg->memory.elow, effective_protection(usage, parent_usage,
-			memcg->memory.low, READ_ONCE(parent->memory.elow),
+			READ_ONCE(memcg->memory.low),
+			READ_ONCE(parent->memory.elow),
 			atomic_long_read(&parent->memory.children_low_usage)));
 
 out:
_

Patches currently in -mm which might be from chris@chrisdown.name are
