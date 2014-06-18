From: akpm@linux-foundation.org
Subject: + dma-cma-support-arbitrary-bitmap-granularity-fix.patch added to -mm tree
Date: Wed, 18 Jun 2014 13:53:13 -0700
Message-ID: <53a1fc39.2cGjmY8af8kib2vS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41732 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755625AbaFRUxO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jun 2014 16:53:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, pbonzini@redhat.com, paulus@samba.org, minchan@kernel.org, mina86@mina86.com, m.szyprowski@samsung.com, iamjoonsoo.kim@lge.com, gleb@kernel.org, benh@kernel.crashing.org, aneesh.kumar@linux.vnet.ibm.com, agraf@suse.de, akpm@linux-foundation.org


The patch titled
     Subject: dma-cma-support-arbitrary-bitmap-granularity-fix
has been added to the -mm tree.  Its filename is
     dma-cma-support-arbitrary-bitmap-granularity-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dma-cma-support-arbitrary-bitmap-granularity-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dma-cma-support-arbitrary-bitmap-granularity-fix.patch

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
Subject: dma-cma-support-arbitrary-bitmap-granularity-fix

s/1/1UL/

Cc: Alexander Graf <agraf@suse.de>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Gleb Natapov <gleb@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/dma-contiguous.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/base/dma-contiguous.c~dma-cma-support-arbitrary-bitmap-granularity-fix drivers/base/dma-contiguous.c
--- a/drivers/base/dma-contiguous.c~dma-cma-support-arbitrary-bitmap-granularity-fix
+++ a/drivers/base/dma-contiguous.c
@@ -160,7 +160,7 @@ static DEFINE_MUTEX(cma_mutex);
 
 static unsigned long cma_bitmap_aligned_mask(struct cma *cma, int align_order)
 {
-	return (1 << (align_order >> cma->order_per_bit)) - 1;
+	return (1UL << (align_order >> cma->order_per_bit)) - 1;
 }
 
 static unsigned long cma_bitmap_maxno(struct cma *cma)
@@ -171,7 +171,7 @@ static unsigned long cma_bitmap_maxno(st
 static unsigned long cma_bitmap_pages_to_bits(struct cma *cma,
 						unsigned long pages)
 {
-	return ALIGN(pages, 1 << cma->order_per_bit) >> cma->order_per_bit;
+	return ALIGN(pages, 1UL << cma->order_per_bit) >> cma->order_per_bit;
 }
 
 static void cma_clear_bitmap(struct cma *cma, unsigned long pfn, int count)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
hugetlb-fix-copy_hugetlb_page_range-to-handle-migration-hwpoisoned-entry-checkpatch-fixes.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
mm-thp-fix-debug_pagealloc-oops-in-copy_page_rep-checkpatch-fixes.patch
shmem-fix-faulting-into-a-hole-while-its-punched-checkpatch-fixes.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes.patch
mm.patch
slub-use-new-node-functions-checkpatch-fixes.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
fs-isofs-logging-clean-up-fix.patch
initramfs-support-initramfs-that-is-more-than-2g-checkpatch-fixes.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

