From: akpm@linux-foundation.org
Subject: + gfp-add-__gfp_noaccount-v2.patch added to -mm tree
Date: Wed, 06 May 2015 13:09:32 -0700
Message-ID: <554a74fc./suZVTc0Jfc8NRyY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53321 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbbEFUJd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 May 2015 16:09:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, hannes@cmpxchg.org, mhocko@suse.cz, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: gfp: add __GFP_NOACCOUNT
has been added to the -mm tree.  Its filename is
     gfp-add-__gfp_noaccount-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/gfp-add-__gfp_noaccount-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/gfp-add-__gfp_noaccount-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: gfp: add __GFP_NOACCOUNT

 - explain drawbacks of per kmem cache flag disabling accounting as a possible
   alternative to a GFP flag in commit message (Michal)
 - warn if __GFP_NOACCOUNT is passed to mem_cgroup_try_charge (Michal)

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    2 +-
 mm/memcontrol.c     |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN include/linux/gfp.h~gfp-add-__gfp_noaccount-v2 include/linux/gfp.h
--- a/include/linux/gfp.h~gfp-add-__gfp_noaccount-v2
+++ a/include/linux/gfp.h
@@ -88,7 +88,7 @@ struct vm_area_struct;
 #define __GFP_HARDWALL   ((__force gfp_t)___GFP_HARDWALL) /* Enforce hardwall cpuset memory allocs */
 #define __GFP_THISNODE	((__force gfp_t)___GFP_THISNODE)/* No fallback, no policies */
 #define __GFP_RECLAIMABLE ((__force gfp_t)___GFP_RECLAIMABLE) /* Page is reclaimable */
-#define __GFP_NOACCOUNT	((__force gfp_t)___GFP_NOACCOUNT) /* Don't account to memcg */
+#define __GFP_NOACCOUNT	((__force gfp_t)___GFP_NOACCOUNT) /* Don't account to kmemcg */
 #define __GFP_NOTRACK	((__force gfp_t)___GFP_NOTRACK)  /* Don't track with kmemcheck */
 
 #define __GFP_NO_KSWAPD	((__force gfp_t)___GFP_NO_KSWAPD)
diff -puN mm/memcontrol.c~gfp-add-__gfp_noaccount-v2 mm/memcontrol.c
--- a/mm/memcontrol.c~gfp-add-__gfp_noaccount-v2
+++ a/mm/memcontrol.c
@@ -5462,6 +5462,8 @@ int mem_cgroup_try_charge(struct page *p
 	unsigned int nr_pages = 1;
 	int ret = 0;
 
+	WARN_ON_ONCE(gfp_mask & __GFP_NOACCOUNT);
+
 	if (mem_cgroup_disabled())
 		goto out;
 
_

Patches currently in -mm which might be from vdavydov@parallels.com are

gfp-add-__gfp_noaccount.patch
gfp-add-__gfp_noaccount-v2.patch
gfp-add-__gfp_noaccount-v2-fix.patch
kernfs-do-not-account-ino_ida-allocations-to-memcg.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
fix-a-misaligned-load-inside-ptrace_attach.patch
change-wait_on_bit-to-take-an-unsigned-long-not-a-void.patch
change-all-uses-of-jobctl_-from-int-to-long.patch

