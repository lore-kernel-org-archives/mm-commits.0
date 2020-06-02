From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 076/128] mm, memcg: add workingset_restore in
 memory.stat
Date: Tue, 02 Jun 2020 13:14:20 -0700
Message-ID: <20200602201420.x6UBL8-iD%akpm@linux-foundation.org>
References: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbgFBUOW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 16:14:22 -0400
In-Reply-To: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chris@chrisdown.name, hannes@cmpxchg.org, laoar.shao@gmail.com, linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org, peterz@infradead.org, shakeelb@google.com, surenb@google.com, torvalds@linux-foundation.org

From: Yafang Shao <laoar.shao@gmail.com>
Subject: mm, memcg: add workingset_restore in memory.stat

There's a new workingset counter introduced in commit 1899ad18c607 ("mm:
workingset: tell cache transitions from workingset thrashing").  With the
help of this counter we can know the workingset is transitioning or
thrashing.  To leverage the benifit of this counter to memcg, we should
introduce it into memory.stat.  Then we could know the workingset of the
workload inside a memcg better.

Bellow is the verification of this new counter in memory.stat.  Read a
file into the memory and then read it again to make these pages be active.
The size of this file is 1G.  (memory.max is greater than file size) The
counters in memory.stat will be

	inactive_file 0
	active_file 1073639424

	workingset_refault 0 workingset_activate 0 workingset_restore 0
workingset_nodereclaim 0 Trigger the memcg reclaim by setting a lower
value to memory.high, and then some pages will be demoted into inactive
list, and then some pages in the inactive list will be evicted into the
storage.

	inactive_file 498094080
	active_file 310063104

	workingset_refault 0
	workingset_activate 0
	workingset_restore 0
	workingset_nodereclaim 0

Then recover the memory.high and read the file into memory again.  As a
result of it, the transitioning will occur.  Bellow is the result of this
transitioning,

	inactive_file 498094080
	active_file 575397888

	workingset_refault 64746
	workingset_activate 64746
	workingset_restore 64746
	workingset_nodereclaim 0

Link: http://lkml.kernel.org/r/20200504153522.11553-1-laoar.shao@gmail.com
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Chris Down <chris@chrisdown.name>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |    4 ++++
 mm/memcontrol.c                         |    2 ++
 2 files changed, 6 insertions(+)

--- a/Documentation/admin-guide/cgroup-v2.rst~mm-memcg-add-workingset_restore-in-memorystat
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1329,6 +1329,10 @@ PAGE_SIZE multiple when read back.
 	  workingset_activate
 		Number of refaulted pages that were immediately activated
 
+	  workingset_restore
+		Number of restored pages which have been detected as an active
+		workingset before they got reclaimed.
+
 	  workingset_nodereclaim
 		Number of times a shadow node has been reclaimed
 
--- a/mm/memcontrol.c~mm-memcg-add-workingset_restore-in-memorystat
+++ a/mm/memcontrol.c
@@ -1451,6 +1451,8 @@ static char *memory_stat_format(struct m
 		       memcg_page_state(memcg, WORKINGSET_REFAULT));
 	seq_buf_printf(&s, "workingset_activate %lu\n",
 		       memcg_page_state(memcg, WORKINGSET_ACTIVATE));
+	seq_buf_printf(&s, "workingset_restore %lu\n",
+		       memcg_page_state(memcg, WORKINGSET_RESTORE));
 	seq_buf_printf(&s, "workingset_nodereclaim %lu\n",
 		       memcg_page_state(memcg, WORKINGSET_NODERECLAIM));
 
_
