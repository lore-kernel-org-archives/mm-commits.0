From: akpm@linux-foundation.org
Subject: + memcg-bugfix-check-mem_cgroup_disabled-at-split-fixup.patch added to -mm tree
Date: Tue, 25 Jan 2011 12:40:13 -0800
Message-ID: <201101252040.p0PKeD6n006683@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38013 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753617Ab1AYUk4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Jan 2011 15:40:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, hannes@cmpxchg.org, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: bugfix check mem_cgroup_disabled() at split fixup
has been added to the -mm tree.  Its filename is
     memcg-bugfix-check-mem_cgroup_disabled-at-split-fixup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

mm-fix-deferred-congestion-timeout-if-preferred-zone-is-not-allowed.patch
mm-clear-pages_scanned-only-if-draining-a-pcp-adds-pages-to-the-buddy-allocator.patch
mm-memcontrolc-fix-uninitialized-variable-use-in-mem_cgroup_move_parent.patch
memcg-fix-account-leak-at-failure-of-memsw-acconting.patch
memcg-bugfix-check-mem_cgroup_disabled-at-split-fixup.patch
memcg-fix-race-at-move_parent-around-compound_order.patch
oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-oom-kill.patch
oom-suppress-show_mem-for-many-nodes-in-irq-context-on-page-alloc-failure.patch
oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-page-alloc-failure.patch
mm-add-replace_page_cache_page-function.patch

