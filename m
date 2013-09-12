From: akpm@linux-foundation.org
Subject: [folded-merged]
 memcg-enhance-memcg-iterator-to-support-predicates-fix.patch removed from
 -mm tree
Date: Thu, 12 Sep 2013 15:03:08 -0700
Message-ID: <52323a1c.9j5BcOi+rfLc8G6d%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59419 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497Ab3ILWDJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 18:03:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, hughd@google.com

Subject: [folded-merged] memcg-enhance-memcg-iterator-to-support-predicates-fix.patch removed from -mm tree
To: hughd@google.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,kosaki.motohiro@jp.fujitsu.com,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 15:03:08 -0700


The patch titled
     Subject: mm: fix memcg-less page reclaim
has been removed from the -mm tree.  Its filename was
     memcg-enhance-memcg-iterator-to-support-predicates-fix.patch

This patch was dropped because it was folded into memcg-enhance-memcg-iterator-to-support-predicates.patch

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: fix memcg-less page reclaim

Now that everybody loves memcg, configures it on, and would not dream
of booting with cgroup_disable=memory, it can pass unnoticed for weeks
that memcg-less page reclaim is completely broken.

mmotm's "memcg: enhance memcg iterator to support predicates" replaces
__shrink_zone()'s "do { } while (memcg);" loop by a "while (memcg) {}"
loop: which is nicer for memcg, but does nothing for !CONFIG_MEMCG or
cgroup_disable=memory.  Page reclaim hangs, making no progress.

Adding mem_cgroup_disabled() and once++ test there is ugly.  Ideally,
even a !CONFIG_MEMCG build might in future have a stub root_mem_cgroup,
which would get around this: but that's not so at present.

However, it appears that nothing actually dereferences the memcg pointer
in the mem_cgroup_disabled() case, here or anywhere else that case can
reach mem_cgroup_iter() (mem_cgroup_iter_break() is not called in
global reclaim).

So, simply pass back an ordinarily-oopsing non-NULL address the first
time, and we shall hear about it if I'm wrong.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    3 ++-
 mm/memcontrol.c            |    6 ++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-enhance-memcg-iterator-to-support-predicates-fix include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-enhance-memcg-iterator-to-support-predicates-fix
+++ a/include/linux/memcontrol.h
@@ -328,7 +328,8 @@ mem_cgroup_iter_cond(struct mem_cgroup *
 		struct mem_cgroup_reclaim_cookie *reclaim,
 		mem_cgroup_iter_filter cond)
 {
-	return NULL;
+	/* first call must return non-NULL, second return NULL */
+	return (struct mem_cgroup *)(unsigned long)!prev;
 }
 
 static inline struct mem_cgroup *
diff -puN mm/memcontrol.c~memcg-enhance-memcg-iterator-to-support-predicates-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-enhance-memcg-iterator-to-support-predicates-fix
+++ a/mm/memcontrol.c
@@ -1018,8 +1018,10 @@ struct mem_cgroup *mem_cgroup_iter_cond(
 	struct mem_cgroup *memcg = NULL;
 	struct mem_cgroup *last_visited = NULL;
 
-	if (mem_cgroup_disabled())
-		return NULL;
+	if (mem_cgroup_disabled()) {
+		/* first call must return non-NULL, second return NULL */
+		return (struct mem_cgroup *)(unsigned long)!prev;
+	}
 
 	if (!root)
 		root = root_mem_cgroup;
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch
memcg-get-rid-of-soft-limit-tree-infrastructure.patch
vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch
memcg-enhance-memcg-iterator-to-support-predicates.patch
memcg-track-children-in-soft-limit-excess-to-improve-soft-limit.patch
memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything.patch
memcg-track-all-children-over-limit-in-the-root.patch
memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch
thp-account-anon-transparent-huge-pages-into-nr_anon_pages.patch
mm-cleanup-add_to_page_cache_locked.patch
thp-move-maybe_pmd_mkwrite-out-of-mk_huge_pmd.patch
thp-do_huge_pmd_anonymous_page-cleanup.patch
thp-consolidate-code-between-handle_mm_fault-and-do_huge_pmd_anonymous_page.patch

