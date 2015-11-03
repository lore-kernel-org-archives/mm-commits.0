From: akpm@linux-foundation.org
Subject: + memcg-fix-thresholds-for-32b-architectures-fix.patch added to
 -mm tree
Date: Tue, 03 Nov 2015 15:28:43 -0800
Message-ID: <5639432b.SlYwtK+Q/R5dJumV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53451 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745AbbKCX2o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Nov 2015 18:28:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@kernel.org, ben@decadent.org.uk, hannes@cmpxchg.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg-fix-thresholds-for-32b-architectures-fix
has been added to the -mm tree.  Its filename is
     memcg-fix-thresholds-for-32b-architectures-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-fix-thresholds-for-32b-architectures-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-fix-thresholds-for-32b-architectures-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@kernel.org>
Subject: memcg-fix-thresholds-for-32b-architectures-fix

Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-fix-thresholds-for-32b-architectures-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-thresholds-for-32b-architectures-fix
+++ a/mm/memcontrol.c
@@ -2803,7 +2803,7 @@ static unsigned long tree_stat(struct me
 
 static inline unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
 {
-	u64 val;
+	unsigned long val;
 
 	if (mem_cgroup_is_root(memcg)) {
 		val = tree_stat(memcg, MEM_CGROUP_STAT_CACHE);
_

Patches currently in -mm which might be from mhocko@kernel.org are

memcg-fix-thresholds-for-32b-architectures-fix.patch

