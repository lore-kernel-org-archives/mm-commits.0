From: akpm@linux-foundation.org
Subject: +
 mm-memcontrolc-cleaning-up-function-that-are-not-used-anywhere.patch added
 to -mm tree
Date: Mon, 08 Dec 2014 15:52:48 -0800
Message-ID: <548639d0.7UjTDZu5pKBxTkV9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57758 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaLHXwt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Dec 2014 18:52:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rickard_strandqvist@spectrumdigital.se, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcontrol.c:  remove unused mem_cgroup_lru_names_not_uptodate()
has been added to the -mm tree.  Its filename is
     mm-memcontrolc-cleaning-up-function-that-are-not-used-anywhere.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrolc-cleaning-up-function-that-are-not-used-anywhere.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrolc-cleaning-up-function-that-are-not-used-anywhere.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
