From: akpm@linux-foundation.org
Subject: [folded-merged]
 initramfs-support-initramfs-that-is-more-than-2g-fix-2.patch removed from
 -mm tree
Date: Fri, 20 Jun 2014 13:28:02 -0700
Message-ID: <53a49952.f6sse/w6Ft4+Rm2A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60828 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932816AbaFTU2D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jun 2014 16:28:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, fengguang.wu@intel.com, akpm@linux-foundation.org


The patch titled
     Subject: initramfs-support-initramfs-that-is-more-than-2g-fix-2
has been removed from the -mm tree.  Its filename was
     initramfs-support-initramfs-that-is-more-than-2g-fix-2.patch

This patch was dropped because it was folded into initramfs-support-initramfs-that-is-more-than-2g.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: initramfs-support-initramfs-that-is-more-than-2g-fix-2

   In file included from arch/powerpc/boot/ops.h:15:0,
                    from arch/powerpc/boot/gunzip_util.c:14:
   arch/powerpc/boot/gunzip_util.c: In function 'gunzip_partial':
>> arch/powerpc/boot/types.h:18:14: warning: comparison of distinct pointer types lacks a cast [enabled by default]

Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/boot/gunzip_util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/powerpc/boot/gunzip_util.c~initramfs-support-initramfs-that-is-more-than-2g-fix-2 arch/powerpc/boot/gunzip_util.c
--- a/arch/powerpc/boot/gunzip_util.c~initramfs-support-initramfs-that-is-more-than-2g-fix-2
+++ a/arch/powerpc/boot/gunzip_util.c
@@ -115,7 +115,7 @@ int gunzip_partial(struct gunzip_state *
 		len = state->s.next_out - (unsigned char *)dst;
 	} else {
 		/* uncompressed image */
-		len = min(state->s.avail_in, (unsigned)dstlen);
+		len = min_t(unsigned long, state->s.avail_in, dstlen);
 		memcpy(dst, state->s.next_in, len);
 		state->s.next_in += len;
 		state->s.avail_in -= len;
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
ia64-arch-ia64-include-uapi-asm-fcntlh-needs-personalityh.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes.patch
mm.patch
slub-use-new-node-functions-checkpatch-fixes.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
mm-memcontrol-rewrite-charge-api-fix.patch
mm-memcontrol-rewrite-uncharge-api-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
add-lib-globc-fix.patch
fs-isofs-logging-clean-up-fix.patch
initramfs-support-initramfs-that-is-more-than-2g.patch
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

