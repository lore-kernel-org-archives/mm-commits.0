From: akpm@linux-foundation.org
Subject: + mm-memcontrol-fix-defined-but-not-used-compiler-warning.patch
 added to -mm tree
Date: Wed, 03 Dec 2014 15:27:46 -0800
Message-ID: <547f9c72.6t+99qVfyiJusV7+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57523 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaLCX1r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2014 18:27:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michele.curti@gmail.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcontrol.c: fix defined but not used compiler warning
has been added to the -mm tree.  Its filename is
     mm-memcontrol-fix-defined-but-not-used-compiler-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-fix-defined-but-not-used-compiler-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-fix-defined-but-not-used-compiler-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michele Curti <michele.curti@gmail.com>
Subject: mm/memcontrol.c: fix defined but not used compiler warning

test_mem_cgroup_node_reclaimable() is used only when MAX_NUMNODES > 1, so
move it into the compiler if statement

Signed-off-by: Michele Curti <michele.curti@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~mm-memcontrol-fix-defined-but-not-used-compiler-warning mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-fix-defined-but-not-used-compiler-warning
+++ a/mm/memcontrol.c
@@ -1615,6 +1615,7 @@ static void mem_cgroup_out_of_memory(str
 	oom_kill_process(chosen, gfp_mask, order, points, totalpages, memcg,
 			 NULL, "Memory cgroup out of memory");
 }
+#if MAX_NUMNODES > 1
 
 /**
  * test_mem_cgroup_node_reclaimable
@@ -1638,7 +1639,6 @@ static bool test_mem_cgroup_node_reclaim
 	return false;
 
 }
-#if MAX_NUMNODES > 1
 
 /*
  * Always updating the nodemask is not very good - even if we have an empty
_

Patches currently in -mm which might be from michele.curti@gmail.com are

mm-memcontrol-fix-defined-but-not-used-compiler-warning.patch

