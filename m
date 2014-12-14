From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-fix-defined-but-not-used-compiler-warning.patch removed from
 -mm tree
Date: Sat, 13 Dec 2014 20:08:26 -0800
Message-ID: <548d0d3a.pY9kEyZ9Y7g6rZK7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47715 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbaLNEIS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:08:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michele.curti@gmail.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcontrol.c: fix defined but not used compiler warning
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-fix-defined-but-not-used-compiler-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michele Curti <michele.curti@gmail.com>
Subject: mm/memcontrol.c: fix defined but not used compiler warning

test_mem_cgroup_node_reclaimable() is used only when MAX_NUMNODES > 1, so
move it into the compiler if statement

[akpm@linux-foundation.org: clean up layout]
Signed-off-by: Michele Curti <michele.curti@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~mm-memcontrol-fix-defined-but-not-used-compiler-warning mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-fix-defined-but-not-used-compiler-warning
+++ a/mm/memcontrol.c
@@ -1616,6 +1616,8 @@ static void mem_cgroup_out_of_memory(str
 			 NULL, "Memory cgroup out of memory");
 }
 
+#if MAX_NUMNODES > 1
+
 /**
  * test_mem_cgroup_node_reclaimable
  * @memcg: the target memcg
@@ -1638,7 +1640,6 @@ static bool test_mem_cgroup_node_reclaim
 	return false;
 
 }
-#if MAX_NUMNODES > 1
 
 /*
  * Always updating the nodemask is not very good - even if we have an empty
_

Patches currently in -mm which might be from michele.curti@gmail.com are

origin.patch
linux-next.patch

