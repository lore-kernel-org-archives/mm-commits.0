From: akpm@linux-foundation.org
Subject: [merged]
 lib-genallocc-convert-kmalloc_nodegfp_zero-to-kzalloc_node.patch removed
 from -mm tree
Date: Thu, 12 Sep 2013 12:45:49 -0700
Message-ID: <523219ed.HP8ZTBGraUu1WQ1v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58631 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756333Ab3ILTpt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:45:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: [merged] lib-genallocc-convert-kmalloc_nodegfp_zero-to-kzalloc_node.patch removed from -mm tree
To: joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:45:49 -0700


The patch titled
     Subject: lib/genalloc.c: convert kmalloc_node(...GFP_ZERO...) to kzalloc_node(...)
has been removed from the -mm tree.  Its filename was
     lib-genallocc-convert-kmalloc_nodegfp_zero-to-kzalloc_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: lib/genalloc.c: convert kmalloc_node(...GFP_ZERO...) to kzalloc_node(...)

Use the helper function instead of __GFP_ZERO.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/genalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/genalloc.c~lib-genallocc-convert-kmalloc_nodegfp_zero-to-kzalloc_node lib/genalloc.c
--- a/lib/genalloc.c~lib-genallocc-convert-kmalloc_nodegfp_zero-to-kzalloc_node
+++ a/lib/genalloc.c
@@ -187,7 +187,7 @@ int gen_pool_add_virt(struct gen_pool *p
 	int nbytes = sizeof(struct gen_pool_chunk) +
 				BITS_TO_LONGS(nbits) * sizeof(long);
 
-	chunk = kmalloc_node(nbytes, GFP_KERNEL | __GFP_ZERO, nid);
+	chunk = kzalloc_node(nbytes, GFP_KERNEL, nid);
 	if (unlikely(chunk == NULL))
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
kernel-timerc-convert-kmalloc_nodegfp_zero-to-kzalloc_node.patch

