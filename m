From: akpm@linux-foundation.org
Subject: + memcg-fix-endless-loop-in-__mem_cgroup_iter_next.patch added to -mm tree
Date: Thu, 13 Feb 2014 14:49:32 -0800
Message-ID: <52fd4bfc.P9pBpdNDxv4uOJVF%akpm__46803.6253158518$1392331784$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36906 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbaBMWtd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Feb 2014 17:49:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, mhocko@suse.cz, hannes@cmpxchg.org, gthelen@google.com, hughd@google.com

Subject: + memcg-fix-endless-loop-in-__mem_cgroup_iter_next.patch added to -mm tree
To: hughd@google.com,gthelen@google.com,hannes@cmpxchg.org,mhocko@suse.cz,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 13 Feb 2014 14:49:32 -0800


The patch titled
     Subject: memcg: fix endless loop in __mem_cgroup_iter_next()
has been added to the -mm tree.  Its filename is
     memcg-fix-endless-loop-in-__mem_cgroup_iter_next.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-fix-endless-loop-in-__mem_cgroup_iter_next.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-fix-endless-loop-in-__mem_cgroup_iter_next.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: memcg: fix endless loop in __mem_cgroup_iter_next()

0eef615665ed ("memcg: fix css reference leak and endless loop in
mem_cgroup_iter") got the interaction with the commit a few before it
d8ad30559715 ("mm/memcg: iteration skip memcgs not yet fully initialized")
slightly wrong, and we didn't notice at the time.

It's elusive, and harder to get than the original, but for a couple of
days before rc1, I several times saw a endless loop similar to that
supposedly being fixed.

This time it was a tighter loop in __mem_cgroup_iter_next(): because we
can get here when our root has already been offlined, and the ordering of
conditions was such that we then just cycled around forever.

Fixes 0eef615665ed ("memcg: fix css reference leak and endless loop in
mem_cgroup_iter").

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Greg Thelen <gthelen@google.com>
Cc: <stable@vger.kernel.org>	[3.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-endless-loop-in-__mem_cgroup_iter_next mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-endless-loop-in-__mem_cgroup_iter_next
+++ a/mm/memcontrol.c
@@ -1127,8 +1127,8 @@ skip_node:
 	 * skipping css reference should be safe.
 	 */
 	if (next_css) {
-		if ((next_css->flags & CSS_ONLINE) &&
-				(next_css == &root->css || css_tryget(next_css)))
+		if ((next_css == &root->css) ||
+		    ((next_css->flags & CSS_ONLINE) && css_tryget(next_css)))
 			return mem_cgroup_from_css(next_css);
 
 		prev_css = next_css;
_

Patches currently in -mm which might be from hughd@google.com are

swapoff-tmpfs-radix_tree-remember-to-rcu_read_unlock.patch
memcg-fix-endless-loop-in-__mem_cgroup_iter_next.patch
mm-vmstat-fix-up-zone-state-accounting.patch
fs-cachefiles-use-add_to_page_cache_lru.patch
lib-radix-tree-radix_tree_delete_item.patch
mm-shmem-save-one-radix-tree-lookup-when-truncating-swapped-pages.patch
mm-filemap-move-radix-tree-hole-searching-here.patch
mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees.patch
mm-fs-store-shadow-entries-in-page-cache.patch
mm-thrash-detection-based-file-cache-sizing.patch
lib-radix_tree-tree-node-interface.patch
mm-keep-page-cache-radix-tree-nodes-in-check.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
mm-compaction-avoid-isolating-pinned-pages.patch
linux-next.patch

