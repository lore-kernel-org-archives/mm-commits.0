From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrolc-cleaning-up-function-that-are-not-used-anywhere.patch
 removed from -mm tree
Date: Sat, 13 Dec 2014 20:08:31 -0800
Message-ID: <548d0d3f.VtUNWQKBFEo3XdOj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47728 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbaLNEIX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:08:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rickard_strandqvist@spectrumdigital.se, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcontrol.c:  remove unused mem_cgroup_lru_names_not_uptodate()
has been removed from the -mm tree.  Its filename was
     mm-memcontrolc-cleaning-up-function-that-are-not-used-anywhere.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: mm/memcontrol.c:  remove unused mem_cgroup_lru_names_not_uptodate()

Remove unused mem_cgroup_lru_names_not_uptodate() and move BUILD_BUG_ON()
to the beginning of memcg_stat_show().

This was partially found by using a static code analysis program called
cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrolc-cleaning-up-function-that-are-not-used-anywhere mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrolc-cleaning-up-function-that-are-not-used-anywhere
+++ a/mm/memcontrol.c
@@ -3692,11 +3692,6 @@ static int memcg_numa_stat_show(struct s
 }
 #endif /* CONFIG_NUMA */
 
-static inline void mem_cgroup_lru_names_not_uptodate(void)
-{
-	BUILD_BUG_ON(ARRAY_SIZE(mem_cgroup_lru_names) != NR_LRU_LISTS);
-}
