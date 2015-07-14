From: akpm@linux-foundation.org
Subject: + mm-improve-__gfp_noretry-comment-based-on-implementation.patch
 added to -mm tree
Date: Tue, 14 Jul 2015 14:44:24 -0700
Message-ID: <55a582b8.0bRN9IW8LQxRlnCJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42773 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbbGNVoZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jul 2015 17:44:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: improve __GFP_NORETRY comment based on implementation
has been added to the -mm tree.  Its filename is
     mm-improve-__gfp_noretry-comment-based-on-implementation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-improve-__gfp_noretry-comment-based-on-implementation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-improve-__gfp_noretry-comment-based-on-implementation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm: improve __GFP_NORETRY comment based on implementation

Explicitly state that __GFP_NORETRY will attempt direct reclaim and memory
compaction before returning NULL and that the oom killer is not called in
the current implementation of the page allocator.

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN include/linux/gfp.h~mm-improve-__gfp_noretry-comment-based-on-implementation include/linux/gfp.h
--- a/include/linux/gfp.h~mm-improve-__gfp_noretry-comment-based-on-implementation
+++ a/include/linux/gfp.h
@@ -63,7 +63,10 @@ struct vm_area_struct;
  * but it is definitely preferable to use the flag rather than opencode endless
  * loop around allocator.
  *
- * __GFP_NORETRY: The VM implementation must not retry indefinitely.
+ * __GFP_NORETRY: The VM implementation must not retry indefinitely and will
+ * return NULL when direct reclaim and memory compaction has failed to allow the
+ * allocation to succeed.  The OOM killer is not called with the current
+ * implementation.
  *
  * __GFP_MOVABLE: Flag that this page will be movable by the page migration
  * mechanism or reclaimed
_

Patches currently in -mm which might be from rientjes@google.com are

slub-fix-spelling-succedd-to-succeed.patch
slab-infrastructure-for-bulk-object-allocation-and-freeing.patch
slub-bulk-alloc-extract-objects-from-the-per-cpu-slab.patch
slub-improve-bulk-alloc-strategy.patch
slub-initial-bulk-free-implementation.patch
slub-add-support-for-kmem_cache_debug-in-bulk-calls.patch
mm-slub-move-slab-initialization-into-irq-enabled-region.patch
mm-slub-fix-slab-double-free-in-case-of-duplicate-sysfs-filename.patch
mm-memblock-warn_on-when-nid-differs-from-overlap-region.patch
hugetlb-make-the-function-vma_shareable-bool.patch
mremap-dont-leak-new_vma-if-f_op-mremap-fails.patch
mm-move-mremap-from-file_operations-to-vm_operations_struct.patch
mremap-dont-do-mm_populatenew_addr-on-failure.patch
mremap-dont-do-uneccesary-checks-if-new_len-==-old_len.patch
mremap-simplify-the-overlap-check-in-mremap_to.patch
mm-improve-__gfp_noretry-comment-based-on-implementation.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
mm-utilc-add-kstrimdup.patch

