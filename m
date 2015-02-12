From: akpm@linux-foundation.org
Subject: [merged] memcg-add-build_bug_on-for-string-tables.patch removed
 from -mm tree
Date: Thu, 12 Feb 2015 11:36:50 -0800
Message-ID: <54dd00d2.qoXHUIqUe8OFx7pa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58136 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbbBLTgv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:36:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gthelen@google.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: add BUILD_BUG_ON() for string tables
has been removed from the -mm tree.  Its filename was
     memcg-add-build_bug_on-for-string-tables.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Greg Thelen <gthelen@google.com>
Subject: memcg: add BUILD_BUG_ON() for string tables

Use BUILD_BUG_ON() to compile assert that memcg string tables are in sync
with corresponding enums.  There aren't currently any issues with these
tables.  This is just defensive.

Signed-off-by: Greg Thelen <gthelen@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/memcontrol.c~memcg-add-build_bug_on-for-string-tables mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-build_bug_on-for-string-tables
+++ a/mm/memcontrol.c
@@ -3568,6 +3568,10 @@ static int memcg_stat_show(struct seq_fi
 	struct mem_cgroup *mi;
 	unsigned int i;
 
+	BUILD_BUG_ON(ARRAY_SIZE(mem_cgroup_stat_names) !=
+		     MEM_CGROUP_STAT_NSTATS);
+	BUILD_BUG_ON(ARRAY_SIZE(mem_cgroup_events_names) !=
+		     MEM_CGROUP_EVENTS_NSTATS);
 	BUILD_BUG_ON(ARRAY_SIZE(mem_cgroup_lru_names) != NR_LRU_LISTS);
 
 	for (i = 0; i < MEM_CGROUP_STAT_NSTATS; i++) {
_

Patches currently in -mm which might be from gthelen@google.com are

origin.patch
list_lru-introduce-list_lru_shrink_countwalk.patch
fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch
vmscan-per-memory-cgroup-slab-shrinkers.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch

