From: akpm@linux-foundation.org
Subject: +
 memcg-check-for-proper-lock-held-in-mem_cgroup_update_page_stat.patch added to -mm tree
Date: Thu, 22 Aug 2013 15:43:32 -0700
Message-ID: <52169414.bL8Pzlte11BBw/pk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47266 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301Ab3HVWnd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Aug 2013 18:43:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, gthelen@google.com, fengguang.wu@intel.com, handai.szj@taobao.com

Subject: + memcg-check-for-proper-lock-held-in-mem_cgroup_update_page_stat.patch added to -mm tree
To: handai.szj@taobao.com,fengguang.wu@intel.com,gthelen@google.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz
From: akpm@linux-foundation.org
Date: Thu, 22 Aug 2013 15:43:32 -0700


The patch titled
     Subject: memcg: check for proper lock held in mem_cgroup_update_page_stat
has been added to the -mm tree.  Its filename is
     memcg-check-for-proper-lock-held-in-mem_cgroup_update_page_stat.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-check-for-proper-lock-held-in-mem_cgroup_update_page_stat.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-check-for-proper-lock-held-in-mem_cgroup_update_page_stat.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sha Zhengju <handai.szj@taobao.com>
Subject: memcg: check for proper lock held in mem_cgroup_update_page_stat

We should call mem_cgroup_begin_update_page_stat() before
mem_cgroup_update_page_stat() to get proper locks, however the latter
doesn't do any checking that we use proper locking, which would be hard. 
Suggested by Michal Hock we could at least test for rcu_read_lock_held()
because RCU is held if !mem_cgroup_disabled().

Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Greg Thelen <gthelen@google.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/memcontrol.c~memcg-check-for-proper-lock-held-in-mem_cgroup_update_page_stat mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-check-for-proper-lock-held-in-mem_cgroup_update_page_stat
+++ a/mm/memcontrol.c
@@ -2225,6 +2225,7 @@ void mem_cgroup_update_page_stat(struct
 	if (mem_cgroup_disabled())
 		return;
 
+	VM_BUG_ON(!rcu_read_lock_held());
 	memcg = pc->mem_cgroup;
 	if (unlikely(!memcg || !PageCgroupUsed(pc)))
 		return;
_

Patches currently in -mm which might be from handai.szj@taobao.com are

memcg-correct-resource_max-to-ullong_max.patch
memcg-rename-resource_max-to-res_counter_max.patch
memcg-avoid-overflow-caused-by-page_align.patch
memcg-reduce-function-dereference.patch
memcg-remove-memcg_nr_file_mapped.patch
memcg-check-for-proper-lock-held-in-mem_cgroup_update_page_stat.patch
memcg-add-per-cgroup-writeback-pages-accounting.patch
memcg-document-cgroup-dirty-writeback-memory-statistics.patch

