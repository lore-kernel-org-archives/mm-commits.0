From: akpm@linux-foundation.org
Subject: [merged] memcg-bugfix-check-mem_cgroup_disabled-at-split-fixup.patch removed from -mm tree
Date: Wed, 26 Jan 2011 12:32:48 -0800
Message-ID: <201101262032.p0QKWmVX003223@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56803 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754112Ab1AZUc5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Jan 2011 15:32:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, hannes@cmpxchg.org, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: bugfix check mem_cgroup_disabled() at split fixup
has been removed from the -mm tree.  Its filename was
     memcg-bugfix-check-mem_cgroup_disabled-at-split-fixup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: bugfix check mem_cgroup_disabled() at split fixup
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

mem_cgroup_disabled() should be checked at splitting.  If disabled, no
heavy work is necesary.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/memcontrol.c~memcg-bugfix-check-mem_cgroup_disabled-at-split-fixup mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-bugfix-check-mem_cgroup_disabled-at-split-fixup
+++ a/mm/memcontrol.c
@@ -2145,6 +2145,8 @@ void mem_cgroup_split_huge_fixup(struct 
 	struct page_cgroup *tail_pc = lookup_page_cgroup(tail);
 	unsigned long flags;
 
+	if (mem_cgroup_disabled())
+		return;
 	/*
 	 * We have no races with charge/uncharge but will have races with
 	 * page state accounting.
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-oom-kill.patch
oom-suppress-show_mem-for-many-nodes-in-irq-context-on-page-alloc-failure.patch
oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-page-alloc-failure.patch
mm-add-replace_page_cache_page-function.patch

