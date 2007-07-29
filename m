From: akpm@linux-foundation.org
Subject: - lguest-fix-bzimage-loading-with-config_relocatable=y.patch removed from -mm tree
Date: Sat, 28 Jul 2007 23:12:54 -0700
Message-ID: <200707290612.l6T6Csi0011151@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46367 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757943AbXG2GXi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:23:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     lguest: fix bzImage loading with CONFIG_RELOCATABLE=y
has been removed from the -mm tree.  Its filename was
     lguest-fix-bzimage-loading-with-config_relocatable=y.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lguest: fix bzImage loading with CONFIG_RELOCATABLE=y
From: Rusty Russell <rusty@rustcorp.com.au>

Jason Yeh sent his crashing .config: bzImages made with
CONFIG_RELOCATABLE=y put the relocs where the BSS is expected, and we crash
with unusual results such as:

	lguest: unhandled trap 14 at 0xc0122ae1 (0xa9)

Relying on BSS being zero was merely laziness on my part.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/lguest.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/lguest/lguest.c~lguest-fix-bzimage-loading-with-config_relocatable=y drivers/lguest/lguest.c
--- a/drivers/lguest/lguest.c~lguest-fix-bzimage-loading-with-config_relocatable=y
+++ a/drivers/lguest/lguest.c
@@ -1019,6 +1019,11 @@ __init void lguest_init(void *boot)
 	 * the normal data segment to get through booting. */
 	asm volatile ("mov %0, %%fs" : : "r" (__KERNEL_DS) : "memory");
 
+	/* Clear the part of the kernel data which is expected to be zero.
+	 * Normally it will be anyway, but if we're loading from a bzImage with
+	 * CONFIG_RELOCATALE=y, the relocations will be sitting here. */
+	memset(__bss_start, 0, __bss_stop - __bss_start);
+
 	/* The Host uses the top of the Guest's virtual address space for the
 	 * Host<->Guest Switcher, and it tells us how much it needs in
 	 * lguest_data.reserve_mem, set up on the LGUEST_INIT hypercall. */
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
git-kvm.patch
git-newsetup-fixup.patch
readahead-compacting-file_ra_state.patch
readahead-mmap-read-around-simplification.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
radixtree-introduce-radix_tree_next_hole.patch
readahead-basic-support-of-interleaved-reads.patch
readahead-remove-the-local-copy-of-ra-in-do_generic_mapping_read.patch
readahead-remove-several-readahead-macros.patch
readahead-remove-the-limit-max_sectors_kb-imposed-on-max_readahead_kb.patch
filemap-trivial-code-cleanups.patch
filemap-convert-some-unsigned-long-to-pgoff_t.patch
mmaps2-vma-out-of-mem_size_stats.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
remove-unsafe-from-module-struct.patch
cpu-hotplug-cpu-deliver-cpu_up_canceled-only-to-notify_oked-callbacks-with-cpu_up_prepare.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
