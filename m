From: akpm@linux-foundation.org
Subject: [to-be-updated] memcg-move-initialization-to-memcg-creation.patch removed from -mm tree
Date: Thu, 06 Jun 2013 12:35:25 -0700
Message-ID: <51b0e47d.RLsGJykPaTQSl7xy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52007 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab3FFTfZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jun 2013 15:35:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dchinner@redhat.com, glommer@openvz.org

Subject: [to-be-updated] memcg-move-initialization-to-memcg-creation.patch removed from -mm tree
To: glommer@openvz.org,dchinner@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 06 Jun 2013 12:35:25 -0700


The patch titled
     Subject: memcg: move initialization to memcg creation
has been removed from the -mm tree.  Its filename was
     memcg-move-initialization-to-memcg-creation.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Glauber Costa <glommer@openvz.org>
Subject: memcg: move initialization to memcg creation

Those structures are only used for memcgs that are effectively using
kmemcg.  However, in a later patch I intend to use scan that list
inconditionally (list empty meaning no kmem caches present), which
simplifies the code a lot.

So move the initialization to early kmem creation.

Cc: Glauber Costa <glommer@openvz.org>
Cc: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-move-initialization-to-memcg-creation mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-move-initialization-to-memcg-creation
+++ a/mm/memcontrol.c
@@ -3352,9 +3352,7 @@ int memcg_update_cache_sizes(struct mem_
 
 	memcg_update_array_size(num + 1);
 
-	INIT_LIST_HEAD(&memcg->memcg_slab_caches);
 	INIT_WORK(&memcg->kmemcg_shrink_work, kmemcg_shrink_work_fn);
-	mutex_init(&memcg->slab_caches_mutex);
 
 	return 0;
 out:
@@ -6345,6 +6343,8 @@ static int memcg_init_kmem(struct mem_cg
 {
 	int ret;
 
+	INIT_LIST_HEAD(&memcg->memcg_slab_caches);
+	mutex_init(&memcg->slab_caches_mutex);
 	memcg->kmemcg_id = -1;
 	ret = memcg_propagate_kmem(memcg);
 	if (ret)
_

Patches currently in -mm which might be from glommer@openvz.org are

vmpressure-in-kernel-notifications.patch
memcg-reap-dead-memcgs-upon-global-memory-pressure.patch

