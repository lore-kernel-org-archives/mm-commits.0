From: akpm@linux-foundation.org
Subject: [merged]
 memcg-fix-css-reference-leak-and-endless-loop-in-mem_cgroup_iter.patch
 removed from -mm tree
Date: Fri, 24 Jan 2014 10:59:41 -0800
Message-ID: <52e2b81d.ZZ4Xj0q+eG5DQm4l%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43362 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaAXS7m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 13:59:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, hughd@google.com, hannes@cmpxchg.org, gthelen@google.com, mhocko@suse.cz

Subject: [merged] memcg-fix-css-reference-leak-and-endless-loop-in-mem_cgroup_iter.patch removed from -mm tree
To: mhocko@suse.cz,gthelen@google.com,hannes@cmpxchg.org,hughd@google.com,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 10:59:41 -0800


The patch titled
     Subject: memcg: fix css reference leak and endless loop in mem_cgroup_iter
has been removed from the -mm tree.  Its filename was
     memcg-fix-css-reference-leak-and-endless-loop-in-mem_cgroup_iter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg: fix css reference leak and endless loop in mem_cgroup_iter

19f39402864e ("memcg: simplify mem_cgroup_iter") has reorganized
mem_cgroup_iter code in order to simplify it.  A part of that change was
dropping an optimization which didn't call css_tryget on the root of the
walked tree.  The patch however didn't change the css_put part in
mem_cgroup_iter which excludes root.

This wasn't an issue at the time because __mem_cgroup_iter_next bailed out
for root early without taking a reference as cgroup iterators
(css_next_descendant_pre) didn't visit root themselves.

Nevertheless cgroup iterators have been reworked to visit root by
bd8815a6d802 ("cgroup: make css_for_each_descendant() and friends include
the origin css in the iteration") when the root bypass have been dropped
in __mem_cgroup_iter_next.  This means that css_put is not called for root
and so css along with mem_cgroup and other cgroup internal object tied by
css lifetime are never freed.

Fix the issue by reintroducing root check in __mem_cgroup_iter_next and do
not take css reference for it.

This reference counting magic protects us also from another issue, an
endless loop reported by Hugh Dickins when reclaim races with root removal
and css_tryget called by iterator internally would fail.  There would be
no other nodes to visit so __mem_cgroup_iter_next would return NULL and
mem_cgroup_iter would interpret it as "start looping from root again" and
so mem_cgroup_iter would loop forever internally.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reported-by: Hugh Dickins <hughd@google.com>
Tested-by: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Greg Thelen <gthelen@google.com>
Cc: <stable@vger.kernel.org>	[3.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-css-reference-leak-and-endless-loop-in-mem_cgroup_iter mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-css-reference-leak-and-endless-loop-in-mem_cgroup_iter
+++ a/mm/memcontrol.c
@@ -1117,14 +1117,22 @@ skip_node:
 	 * skipped and we should continue the tree walk.
 	 * last_visited css is safe to use because it is
 	 * protected by css_get and the tree walk is rcu safe.
+	 *
+	 * We do not take a reference on the root of the tree walk
+	 * because we might race with the root removal when it would
+	 * be the only node in the iterated hierarchy and mem_cgroup_iter
+	 * would end up in an endless loop because it expects that at
+	 * least one valid node will be returned. Root cannot disappear
+	 * because caller of the iterator should hold it already so
+	 * skipping css reference should be safe.
 	 */
 	if (next_css) {
-		if ((next_css->flags & CSS_ONLINE) && css_tryget(next_css))
+		if ((next_css->flags & CSS_ONLINE) &&
+				(next_css == &root->css || css_tryget(next_css)))
 			return mem_cgroup_from_css(next_css);
-		else {
-			prev_css = next_css;
-			goto skip_node;
-		}
+
+		prev_css = next_css;
+		goto skip_node;
 	}
 
 	return NULL;
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
mm-page_alloc-allow-__gfp_nofail-to-allocate-below-watermarks-after-reclaim.patch
memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves.patch
mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch

