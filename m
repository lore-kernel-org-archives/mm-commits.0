From: akpm@linux-foundation.org
Subject: [merged]
 mm-slub-remove-a-redundant-assignment-in-___slab_alloc.patch removed from
 -mm tree
Date: Fri, 07 Jul 2017 12:07:48 -0700
Message-ID: <20170707190748.Jo0IO-_e9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60700 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751916AbdGGTHt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2017 15:07:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org, penberg@kernel.org, richard.weiyang@gmail.com, rientjes@google.com


The patch titled
     Subject: mm/slub.c: remove a redundant assignment in ___slab_alloc()
has been removed from the -mm tree.  Its filename was
     mm-slub-remove-a-redundant-assignment-in-___slab_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/slub.c: remove a redundant assignment in ___slab_alloc()

When the code comes to this point, there are two cases:
1. cpu_slab is deactivated
2. cpu_slab is empty

In both cased, cpu_slab->freelist is NULL at this moment.

This patch removes the redundant assignment of cpu_slab->freelist.

Link: http://lkml.kernel.org/r/20170507031215.3130-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/slub.c~mm-slub-remove-a-redundant-assignment-in-___slab_alloc mm/slub.c
--- a/mm/slub.c~mm-slub-remove-a-redundant-assignment-in-___slab_alloc
+++ a/mm/slub.c
@@ -2572,7 +2572,6 @@ new_slab:
 		page = c->page = c->partial;
 		c->partial = page->next;
 		stat(s, CPU_PARTIAL_ALLOC);
-		c->freelist = NULL;
 		goto redo;
 	}
 
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-memory_hotplug-just-build-zonelist-for-new-added-node.patch
mm-page_alloc-return-0-in-case-this-node-has-no-page-within-the-zone.patch

