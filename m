From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 =?US-ASCII?Q?mmap-locking-api-convert-mmap=5Fsem-call-sites-missed-by-?=
 =?US-ASCII?Q?coccinelle-fix-fix-fix.patch?= added to -mm tree
Date: Thu, 21 May 2020 20:01:25 -0700
Message-ID: <20200522030125.5p0fwkx-m%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727024AbgEVDB0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 21 May 2020 23:01:26 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, walken@google.com


The patch titled
     Subject: mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix-fix
has been added to the -mm tree.  Its filename is
     mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix-fix

more linux-next leftovers

Cc: Michel Lespinasse <walken@google.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/vfio/pci/vfio_pci.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/vfio/pci/vfio_pci.c~mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix-fix
+++ a/drivers/vfio/pci/vfio_pci.c
@@ -1425,17 +1425,17 @@ static int vfio_pci_zap_and_vma_lock(str
 		mutex_unlock(&vdev->vma_lock);
 
 		if (try) {
-			if (!down_read_trylock(&mm->mmap_sem)) {
+			if (!mmap_read_trylock(mm)) {
 				mmput(mm);
 				return 0;
 			}
 		} else {
-			down_read(&mm->mmap_sem);
+			mmap_read_lock(mm);
 		}
 		if (mmget_still_valid(mm)) {
 			if (try) {
 				if (!mutex_trylock(&vdev->vma_lock)) {
-					up_read(&mm->mmap_sem);
+					mmap_read_unlock(mm);
 					mmput(mm);
 					return 0;
 				}
@@ -1457,7 +1457,7 @@ static int vfio_pci_zap_and_vma_lock(str
 			}
 			mutex_unlock(&vdev->vma_lock);
 		}
-		up_read(&mm->mmap_sem);
+		mmap_read_unlock(mm);
 		mmput(mm);
 	}
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

squashfs-migrate-from-ll_rw_block-usage-to-bio-fix.patch
arch-parisc-include-asm-pgtableh-remove-unused-old_pte.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-slub-fix-corrupted-freechain-in-deactivate_slab-fix.patch
mm-slub-add-panic_on_error-to-the-debug-facilities-fix.patch
mm-migratec-call-detach_page_private-to-cleanup-code-fix.patch
mm-gupc-updating-the-documentation-fix.patch
mm-swapfilec-classify-swap_map_xxx-to-make-it-more-readable-fix.patch
mm-remove-__vmalloc_node_flags_caller-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix-fix.patch
mm-remove-vmalloc_user_node_flags-fix.patch
mm-vmalloc-track-which-page-table-levels-were-modified-fix.patch
mm-free_area_init-allow-defining-max_zone_pfn-in-descending-order-fix-2-fix.patch
mm-page_alloc-skip-waternark_boost-for-atomic-order-0-allocations-fix.patch
padata-initialize-earlier-fix.patch
arch-kunmap-remove-duplicate-kunmap-implementations-fix.patch
arch-kmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch
arch-kunmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch
kmap-consolidate-kmap_prot-definitions-checkpatch-fixes.patch
mm-add-debug_wx-support-fix.patch
riscv-support-debug_wx-fix.patch
mm-replace-zero-length-array-with-flexible-array-member-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
seq_file-introduce-define_seq_attribute-helper-macro-checkpatch-fixes.patch
ipc-convert-ipcs_idr-to-xarray-update-fix.patch
linux-next-pre.patch
linux-next-rejects.patch
linux-next-post.patch
kernel-add-panic_on_taint-fix.patch
mm-consolidate-pgd_index-and-pgd_offset_k-definitions-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix-fix.patch
mm-pass-task-and-mm-to-do_madvise.patch
mm-introduce-external-memory-hinting-api-fix-2-fix.patch
mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix-fix.patch
doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
