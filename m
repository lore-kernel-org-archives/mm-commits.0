From: akpm@linux-foundation.org
Subject: + memcg-remove-pcp_counter_lock.patch added to -mm tree
Date: Wed, 23 Sep 2015 14:48:06 -0700
Message-ID: <56031e16.+o9Mp7S9qKx4XKcT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45346 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbbIWVsH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Sep 2015 17:48:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gthelen@google.com, hannes@cmpxchg.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: remove pcp_counter_lock
has been added to the -mm tree.  Its filename is
     memcg-remove-pcp_counter_lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-remove-pcp_counter_lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-remove-pcp_counter_lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Greg Thelen <gthelen@google.com>
Subject: memcg: remove pcp_counter_lock

Commit 733a572e66d2 ("memcg: make mem_cgroup_read_{stat|event}() iterate
possible cpus instead of online") removed the last use of the per memcg
pcp_counter_lock but forgot to remove the variable.

Kill the vestigial variable.

Signed-off-by: Greg Thelen <gthelen@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    1 -
 mm/memcontrol.c            |    1 -
 2 files changed, 2 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-remove-pcp_counter_lock include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-remove-pcp_counter_lock
+++ a/include/linux/memcontrol.h
@@ -242,7 +242,6 @@ struct mem_cgroup {
 	 * percpu counter.
 	 */
 	struct mem_cgroup_stat_cpu __percpu *stat;
-	spinlock_t pcp_counter_lock;
 
 #if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_INET)
 	struct cg_proto tcp_mem;
diff -puN mm/memcontrol.c~memcg-remove-pcp_counter_lock mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-pcp_counter_lock
+++ a/mm/memcontrol.c
@@ -4185,7 +4185,6 @@ static struct mem_cgroup *mem_cgroup_all
 	if (memcg_wb_domain_init(memcg, GFP_KERNEL))
 		goto out_free_stat;
 
-	spin_lock_init(&memcg->pcp_counter_lock);
 	return memcg;
 
 out_free_stat:
_

Patches currently in -mm which might be from gthelen@google.com are

memcg-fix-dirty-page-migration.patch
memcg-make-mem_cgroup_read_stat-unsigned.patch
memcg-remove-pcp_counter_lock.patch

