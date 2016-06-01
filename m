From: akpm@linux-foundation.org
Subject: + revert-mm-memcontrol-fix-possible-css-ref-leak-on-oom.patch
 added to -mm tree
Date: Wed, 01 Jun 2016 15:56:56 -0700
Message-ID: <574f6838.NJv3EoXBO8yQ3Bt/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44526 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbcFAW45 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jun 2016 18:56:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: revert "mm: memcontrol: fix possible css ref leak on oom"
has been added to the -mm tree.  Its filename is
     revert-mm-memcontrol-fix-possible-css-ref-leak-on-oom.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/revert-mm-memcontrol-fix-possible-css-ref-leak-on-oom.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/revert-mm-memcontrol-fix-possible-css-ref-leak-on-oom.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: revert "mm: memcontrol: fix possible css ref leak on oom"

Revert 1383399d7be02 ("mm: memcontrol: fix possible css ref leak on oom").
Johannes points out "There is a task_in_memcg_oom() check before calling
mem_cgroup_oom()".

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~revert-mm-memcontrol-fix-possible-css-ref-leak-on-oom mm/memcontrol.c
--- a/mm/memcontrol.c~revert-mm-memcontrol-fix-possible-css-ref-leak-on-oom
+++ a/mm/memcontrol.c
@@ -1608,7 +1608,7 @@ static void memcg_oom_recover(struct mem
 
 static void mem_cgroup_oom(struct mem_cgroup *memcg, gfp_t mask, int order)
 {
-	if (!current->memcg_may_oom || current->memcg_in_oom)
+	if (!current->memcg_may_oom)
 		return;
 	/*
 	 * We are in the middle of the charge context here, so we
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-fix-overflow-in-vm_map_ram-fix.patch
revert-mm-memcontrol-fix-possible-css-ref-leak-on-oom.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
linux-next-git-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

