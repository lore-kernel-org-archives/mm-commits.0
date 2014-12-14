From: akpm@linux-foundation.org
Subject: [merged] slub-fix-cpuset-check-in-get_any_partial.patch removed
 from -mm tree
Date: Sat, 13 Dec 2014 20:10:22 -0800
Message-ID: <548d0dae.1kv99sWfNAFF6aVj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47923 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963AbaLNEKP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:10:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, iamjoonsoo.kim@lge.com, lizefan@huawei.com, penberg@kernel.org, rientjes@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: fix cpuset check in get_any_partial
has been removed from the -mm tree.  Its filename was
     slub-fix-cpuset-check-in-get_any_partial.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: slub: fix cpuset check in get_any_partial

If we fail to allocate from the current node's stock, we look for free
objects on other nodes before calling the page allocator (see
get_any_partial).  While checking other nodes we respect cpuset
constraints by calling cpuset_zone_allowed.  We enforce hardwall check. 
As a result, we will fallback to the page allocator even if there are some
pages cached on other nodes, but the current cpuset doesn't have them set.
 However, the page allocator uses softwall check for kernel allocations,
so it may allocate from one of the other nodes in this case.

Therefore we should use softwall cpuset check in get_any_partial to
conform with the cpuset check in the page allocator.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Zefan Li <lizefan@huawei.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/slub.c~slub-fix-cpuset-check-in-get_any_partial mm/slub.c
--- a/mm/slub.c~slub-fix-cpuset-check-in-get_any_partial
+++ a/mm/slub.c
@@ -1670,8 +1670,7 @@ static void *get_any_partial(struct kmem
 
 			n = get_node(s, zone_to_nid(zone));
 
-			if (n && cpuset_zone_allowed(zone,
-						     flags | __GFP_HARDWALL) &&
+			if (n && cpuset_zone_allowed(zone, flags) &&
 					n->nr_partial > s->min_partial) {
 				object = get_partial_node(s, n, c, flags);
 				if (object) {
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
linux-next.patch

