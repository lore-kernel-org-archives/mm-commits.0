From: akpm@linux-foundation.org
Subject: + memcg-add-build_bug_on-for-string-tables.patch added to -mm
 tree
Date: Mon, 12 Jan 2015 12:43:52 -0800
Message-ID: <54b43208.+EvYoGUhEnAXGJy2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34662 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbbALUnx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jan 2015 15:43:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gthelen@google.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: add BUILD_BUG_ON() for string tables
has been added to the -mm tree.  Its filename is
     memcg-add-build_bug_on-for-string-tables.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-add-build_bug_on-for-string-tables.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-add-build_bug_on-for-string-tables.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Greg Thelen <gthelen@google.com>
Subject: memcg: add BUILD_BUG_ON() for string tables

Use BUILD_BUG_ON() to compile assert that memcg string tables are in sync
with corresponding enums.  There aren't currently any issues with these
tables.  This is just defensive.

Signed-off-by: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/memcontrol.c~memcg-add-build_bug_on-for-string-tables mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-build_bug_on-for-string-tables
+++ a/mm/memcontrol.c
@@ -3596,6 +3596,10 @@ static int memcg_stat_show(struct seq_fi
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

list_lru-introduce-list_lru_shrink_countwalk.patch
fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch
vmscan-per-memory-cgroup-slab-shrinkers.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch
memcg-add-build_bug_on-for-string-tables.patch

