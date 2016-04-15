From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-let-v2-cgroups-follow-changes-in-system-swappiness.patch
 added to -mm tree
Date: Fri, 15 Apr 2016 12:57:00 -0700
Message-ID: <5711478c.DxLpawOyQ/drvQpk%akpm__39864.1805550598$1460750240$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60197 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbcDOT5B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Apr 2016 15:57:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, stable@vger.kernel.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: let v2 cgroups follow changes in system swappiness
has been added to the -mm tree.  Its filename is
     mm-memcontrol-let-v2-cgroups-follow-changes-in-system-swappiness.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-let-v2-cgroups-follow-changes-in-system-swappiness.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-let-v2-cgroups-follow-changes-in-system-swappiness.patch

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
Subject: mm: memcontrol: let v2 cgroups follow changes in system swappiness

Cgroup2 currently doesn't have a per-cgroup swappiness setting.  We might
want to add one later - that's a different discussion - but until we do,
the cgroups should always follow the system setting.  Otherwise it will be
unchangeably set to whatever the ancestor inherited from the system
setting at the time of cgroup creation.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: <stable@vger.kernel.org>	[4.5]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN include/linux/swap.h~mm-memcontrol-let-v2-cgroups-follow-changes-in-system-swappiness include/linux/swap.h
--- a/include/linux/swap.h~mm-memcontrol-let-v2-cgroups-follow-changes-in-system-swappiness
+++ a/include/linux/swap.h
@@ -533,6 +533,10 @@ static inline swp_entry_t get_swap_page(
 #ifdef CONFIG_MEMCG
 static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
 {
+	/* Cgroup2 doesn't have per-cgroup swappiness */
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		return vm_swappiness;
+
 	/* root ? */
 	if (mem_cgroup_disabled() || !memcg->css.parent)
 		return vm_swappiness;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-memcontrol-let-v2-cgroups-follow-changes-in-system-swappiness.patch
mm-filemap-only-do-access-activations-on-reads.patch

