From: akpm@linux-foundation.org
Subject: + mm-slub-remove-a-redundant-assignment-in-___slab_alloc.patch
 added to -mm tree
Date: Tue, 09 May 2017 13:59:27 -0700
Message-ID: <59122daf.TYQltRJGvYwRq2/2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55702 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750707AbdEIU72 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 May 2017 16:59:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard.weiyang@gmail.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub.c: remove a redundant assignment in ___slab_alloc()
has been added to the -mm tree.  Its filename is
     mm-slub-remove-a-redundant-assignment-in-___slab_alloc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slub-remove-a-redundant-assignment-in-___slab_alloc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-remove-a-redundant-assignment-in-___slab_alloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-slub-remove-a-redundant-assignment-in-___slab_alloc.patch
mm-slub-reset-cpu_slabs-pointer-in-deactivate_slab.patch
mm-page_alloc-return-0-in-case-this-node-has-no-page-within-the-zone.patch

