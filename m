From: akpm@linux-foundation.org
Subject: [merged] slab-do-not-panic-if-we-fail-to-create-memcg-cache.patch removed from -mm tree
Date: Fri, 24 Jan 2014 10:58:49 -0800
Message-ID: <52e2b7e9.W8Lccs9Sw52KrI1p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43222 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaAXS6u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 13:58:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, penberg@kernel.org, mhocko@suse.cz, hannes@cmpxchg.org, glommer@gmail.com, cl@linux.com, vdavydov@parallels.com

Subject: [merged] slab-do-not-panic-if-we-fail-to-create-memcg-cache.patch removed from -mm tree
To: vdavydov@parallels.com,cl@linux.com,glommer@gmail.com,hannes@cmpxchg.org,mhocko@suse.cz,penberg@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 10:58:49 -0800


The patch titled
     Subject: slab: do not panic if we fail to create memcg cache
has been removed from the -mm tree.  Its filename was
     slab-do-not-panic-if-we-fail-to-create-memcg-cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: slab: do not panic if we fail to create memcg cache

There is no point in flooding logs with warnings or especially crashing
the system if we fail to create a cache for a memcg.  In this case we will
be accounting the memcg allocation to the root cgroup until we succeed to
create its own cache, but it isn't that critical.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN mm/slab_common.c~slab-do-not-panic-if-we-fail-to-create-memcg-cache mm/slab_common.c
--- a/mm/slab_common.c~slab-do-not-panic-if-we-fail-to-create-memcg-cache
+++ a/mm/slab_common.c
@@ -233,7 +233,14 @@ out_unlock:
 	mutex_unlock(&slab_mutex);
 	put_online_cpus();
 
-	if (err) {
+	/*
+	 * There is no point in flooding logs with warnings or especially
+	 * crashing the system if we fail to create a cache for a memcg. In
+	 * this case we will be accounting the memcg allocation to the root
+	 * cgroup until we succeed to create its own cache, but it isn't that
+	 * critical.
+	 */
+	if (err && !memcg) {
 		if (flags & SLAB_PANIC)
 			panic("kmem_cache_create: Failed to create slab '%s'. Error %d\n",
 				name, err);
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch

