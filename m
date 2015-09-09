From: akpm@linux-foundation.org
Subject: [merged]
 mm-slab_common-allow-null-cache-pointer-in-kmem_cache_destroy.patch removed from -mm tree
Date: Wed, 09 Sep 2015 12:45:36 -0700
Message-ID: <55f08c60.zrcKOlmYoKwYwq+U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39014 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbbIITph (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:45:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, joe@perches.com, julia.lawall@lip6.fr, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab_common: allow NULL cache pointer in kmem_cache_destroy()
has been removed from the -mm tree.  Its filename was
     mm-slab_common-allow-null-cache-pointer-in-kmem_cache_destroy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: mm/slab_common: allow NULL cache pointer in kmem_cache_destroy()

kmem_cache_destroy() does not tolerate a NULL kmem_cache pointer argument
and performs a NULL-pointer dereference.  This requires additional
attention and effort from developers/reviewers and forces all
kmem_cache_destroy() callers (200+ as of 4.1) to do a NULL check

	if (cache)
		kmem_cache_destroy(cache);

Or, otherwise, be invalid kmem_cache_destroy() users.

Tweak kmem_cache_destroy() and NULL-check the pointer there.

Proposed by Andrew Morton.

Link: https://lkml.org/lkml/2015/6/8/583
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/slab_common.c~mm-slab_common-allow-null-cache-pointer-in-kmem_cache_destroy mm/slab_common.c
--- a/mm/slab_common.c~mm-slab_common-allow-null-cache-pointer-in-kmem_cache_destroy
+++ a/mm/slab_common.c
@@ -640,6 +640,9 @@ void kmem_cache_destroy(struct kmem_cach
 	bool need_rcu_barrier = false;
 	bool busy = false;
 
+	if (unlikely(!s))
+		return;
+
 	BUG_ON(!is_root_cache(s));
 
 	get_online_cpus();
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are


