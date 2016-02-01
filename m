From: akpm@linux-foundation.org
Subject: + mm-fault-inject-take-over-bootstrap-kmem_cache-check-fix.patch
 added to -mm tree
Date: Mon, 01 Feb 2016 15:35:44 -0800
Message-ID: <56afebd0.tR/kKSwgC1V6TcTC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52403 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbcBAXfp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2016 18:35:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brouer@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fault-inject-take-over-bootstrap-kmem_cache-check-fix
has been added to the -mm tree.  Its filename is
     mm-fault-inject-take-over-bootstrap-kmem_cache-check-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fault-inject-take-over-bootstrap-kmem_cache-check-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fault-inject-take-over-bootstrap-kmem_cache-check-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: mm-fault-inject-take-over-bootstrap-kmem_cache-check-fix

First fix is for compiling with CONFIG_FAILSLAB. The linux-next commit
needing this fix is 074b6f53c320 ("mm: fault-inject take over
bootstrap kmem_cache check").

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/failslab.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/failslab.c~mm-fault-inject-take-over-bootstrap-kmem_cache-check-fix mm/failslab.c
--- a/mm/failslab.c~mm-fault-inject-take-over-bootstrap-kmem_cache-check-fix
+++ a/mm/failslab.c
@@ -1,5 +1,6 @@
 #include <linux/fault-inject.h>
 #include <linux/slab.h>
+#include <linux/mm.h>
 #include "slab.h"
 
 static struct {
diff -puN mm/slab.c~mm-fault-inject-take-over-bootstrap-kmem_cache-check-fix mm/slab.c
_

Patches currently in -mm which might be from brouer@redhat.com are

slub-cleanup-code-for-kmem-cgroup-support-to-kmem_cache_free_bulk.patch
mm-slab-move-slub-alloc-hooks-to-common-mm-slabh.patch
mm-fault-inject-take-over-bootstrap-kmem_cache-check.patch
mm-fault-inject-take-over-bootstrap-kmem_cache-check-fix.patch
slab-use-slab_pre_alloc_hook-in-slab-allocator-shared-with-slub.patch
mm-kmemcheck-skip-object-if-slab-allocation-failed.patch
slab-use-slab_post_alloc_hook-in-slab-allocator-shared-with-slub.patch
slab-implement-bulk-alloc-in-slab-allocator.patch
slab-avoid-running-debug-slab-code-with-irqs-disabled-for-alloc_bulk.patch
slab-implement-bulk-free-in-slab-allocator.patch
mm-new-api-kfree_bulk-for-slabslub-allocators.patch
mm-fix-some-spelling.patch
b.patch

