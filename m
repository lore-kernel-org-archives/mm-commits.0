From: akpm@linux-foundation.org
Subject: + mm-memcontrol-make-the-walk_page_range-limit-obvious.patch
 added to -mm tree
Date: Thu, 01 Sep 2016 15:05:55 -0700
Message-ID: <57c8a643.i5xzUCEl9+YFJ8F8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59502 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752043AbcIAWF4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Sep 2016 18:05:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: james.morse@arm.com, hannes@cmpxchg.org, mhocko@kernel.org, n-horiguchi@ah.jp.nec.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcontrol.c: make the walk_page_range() limit obvious
has been added to the -mm tree.  Its filename is
     mm-memcontrol-make-the-walk_page_range-limit-obvious.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-make-the-walk_page_range-limit-obvious.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-make-the-walk_page_range-limit-obvious.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: James Morse <james.morse@arm.com>
Subject: mm/memcontrol.c: make the walk_page_range() limit obvious

Trying to walk all of virtual memory requires architecture specific
knowledge.  On x86_64, addresses must be sign extended from bit 48,
whereas on arm64 the top VA_BITS of address space have their own set of
page tables.

mem_cgroup_count_precharge() and mem_cgroup_move_charge() both call
walk_page_range() on the range 0 to ~0UL, neither provide a pte_hole
callback, which causes the current implementation to skip non-vma regions.

As this call only expects to walk user address space, make it walk
0 to  'highest_vm_end'.

Link: http://lkml.kernel.org/r/1472655897-22532-1-git-send-email-james.morse@arm.com
Signed-off-by: James Morse <james.morse@arm.com>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-make-the-walk_page_range-limit-obvious mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-make-the-walk_page_range-limit-obvious
+++ a/mm/memcontrol.c
@@ -4668,7 +4668,8 @@ static unsigned long mem_cgroup_count_pr
 		.mm = mm,
 	};
 	down_read(&mm->mmap_sem);
-	walk_page_range(0, ~0UL, &mem_cgroup_count_precharge_walk);
+	walk_page_range(0, mm->highest_vm_end,
+			&mem_cgroup_count_precharge_walk);
 	up_read(&mm->mmap_sem);
 
 	precharge = mc.precharge;
@@ -4956,7 +4957,8 @@ retry:
 	 * When we have consumed all precharges and failed in doing
 	 * additional charge, the page walk just aborts.
 	 */
-	walk_page_range(0, ~0UL, &mem_cgroup_move_charge_walk);
+	walk_page_range(0, mc.mm->highest_vm_end, &mem_cgroup_move_charge_walk);
+
 	up_read(&mc.mm->mmap_sem);
 	atomic_dec(&mc.from->moving_account);
 }
_

Patches currently in -mm which might be from james.morse@arm.com are

mm-pagewalk-fix-the-comment-for-test_walk.patch
mm-proc-make-the-task_mmu-walk_page_range-limit-in-clear_refs_write-obvious.patch
mm-memcontrol-make-the-walk_page_range-limit-obvious.patch

