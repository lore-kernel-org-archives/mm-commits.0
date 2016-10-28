From: akpm@linux-foundation.org
Subject: [patch 01/20] mm/slab: fix kmemcg cache creation delayed issue
Date: Thu, 27 Oct 2016 17:46:18 -0700
Message-ID: <58129fda.IxjtQgJCUscJhk+I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57758 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751207AbcJ1AqT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2016 20:46:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, cl@linux.com, dsmythies@telus.net, penberg@kernel.org, rientjes@google.com, stable@vger.kernel.org

From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/slab: fix kmemcg cache creation delayed issue

There is a bug report that SLAB makes extreme load average due to over
2000 kworker thread.

https://bugzilla.kernel.org/show_bug.cgi?id=172981

This issue is caused by kmemcg feature that try to create new set of
kmem_caches for each memcg.  Recently, kmem_cache creation is slowed by
synchronize_sched() and futher kmem_cache creation is also delayed since
kmem_cache creation is synchronized by a global slab_mutex lock.  So, the
number of kworker that try to create kmem_cache increases quitely. 
synchronize_sched() is for lockless access to node's shared array but it's
not needed when a new kmem_cache is created.  So, this patch rules out
that case.

Fixes: 801faf0db894 ("mm/slab: lockless decision to grow cache")
Link: http://lkml.kernel.org/r/1475734855-4837-1-git-send-email-iamjoonsoo.kim@lge.com
Reported-by: Doug Smythies <dsmythies@telus.net>
Tested-by: Doug Smythies <dsmythies@telus.net>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slab.c~mm-slab-fix-kmemcg-cache-creation-delayed-issue mm/slab.c
--- a/mm/slab.c~mm-slab-fix-kmemcg-cache-creation-delayed-issue
+++ a/mm/slab.c
@@ -966,7 +966,7 @@ static int setup_kmem_cache_node(struct
 	 * guaranteed to be valid until irq is re-enabled, because it will be
 	 * freed after synchronize_sched().
 	 */
-	if (force_change)
+	if (old_shared && force_change)
 		synchronize_sched();
 
 fail:
_
