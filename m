From: akpm@linux-foundation.org
Subject: +
 fs-block_devc-bdev_write_page-use-blk_queue_enter-gfp_noio.patch added to
 -mm tree
Date: Mon, 23 Nov 2015 15:44:44 -0800
Message-ID: <5653a4ec.JglbiMaOWpo5NSVI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57121 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbbKWXop (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Nov 2015 18:44:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, axboe@fb.com, dan.j.williams@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/block_dev.c:bdev_write_page(): use blk_queue_enter(..., GFP_NOIO)
has been added to the -mm tree.  Its filename is
     fs-block_devc-bdev_write_page-use-blk_queue_enter-gfp_noio.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-block_devc-bdev_write_page-use-blk_queue_enter-gfp_noio.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-block_devc-bdev_write_page-use-blk_queue_enter-gfp_noio.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs/block_dev.c:bdev_write_page(): use blk_queue_enter(..., GFP_NOIO)

bdev_write_page() is used by swapout and by writepage where we cannot use
__GFP_FS or __GFP_IO.  So it is misleading to mention GFP_KERNEL here.

blk_queue_enter() only actually looks at __GFP_DIRECT_RECLAIM, so no bugs
were harmed in the making of this patch.

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jens Axboe <axboe@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/block_dev.c~fs-block_devc-bdev_write_page-use-blk_queue_enter-gfp_noio fs/block_dev.c
--- a/fs/block_dev.c~fs-block_devc-bdev_write_page-use-blk_queue_enter-gfp_noio
+++ a/fs/block_dev.c
@@ -432,7 +432,7 @@ int bdev_write_page(struct block_device
 
 	if (!ops->rw_page || bdev_get_integrity(bdev))
 		return -EOPNOTSUPP;
-	result = blk_queue_enter(bdev->bd_queue, GFP_KERNEL);
+	result = blk_queue_enter(bdev->bd_queue, GFP_NOIO);
 	if (result)
 		return result;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm.patch
account-certain-kmem-allocations-to-memcg-checkpatch-fixes.patch
mm-mmapc-remove-redundant-local-variables-for-may_expand_vm-fix.patch
include-define-__phys_to_pfn-as-phys_pfn-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix-2.patch
mm-zonelist-enumerate-zonelists-array-index-checkpatch-fixes.patch
mm-zonelist-enumerate-zonelists-array-index-fix.patch
mm-get-rid-of-__alloc_pages_high_priority-checkpatch-fixes.patch
fs-block_devc-bdev_write_page-use-blk_queue_enter-gfp_noio.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix-fix.patch
ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task-fix.patch
fs-adfs-adfsh-tidy-up-comments.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

