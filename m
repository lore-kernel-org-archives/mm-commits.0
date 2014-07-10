From: akpm@linux-foundation.org
Subject: [alternative-merged]
 drivers-staging-emxx_udc-emxx_udcc-replace-strict_strto-with-kstrto.patch
 removed from -mm tree
Date: Thu, 10 Jul 2014 12:22:28 -0700
Message-ID: <53bee7f4.BNNfZE5lFnsGXSQk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:64909 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbaGJTWa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Jul 2014 15:22:30 -0400
Received: by mail-vc0-f201.google.com with SMTP id ij19so7754vcb.2
        for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2014 12:22:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dwalter@google.com, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/staging/emxx_udc/emxx_udc.c: replace strict_strto() with kstrto()
has been removed from the -mm tree.  Its filename was
     drivers-staging-emxx_udc-emxx_udcc-replace-strict_strto-with-kstrto.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/staging/emxx_udc/emxx_udc.c: replace strict_strto() with kstrto()

Cc: Daniel Walter <dwalter@google.com>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/emxx_udc/emxx_udc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/staging/emxx_udc/emxx_udc.c~drivers-staging-emxx_udc-emxx_udcc-replace-strict_strto-with-kstrto drivers/staging/emxx_udc/emxx_udc.c
--- a/drivers/staging/emxx_udc/emxx_udc.c~drivers-staging-emxx_udc-emxx_udcc-replace-strict_strto-with-kstrto
+++ a/drivers/staging/emxx_udc/emxx_udc.c
@@ -3278,14 +3278,13 @@ static void __init nbu2ss_drv_set_ep_inf
 	ep->ep.ops = &nbu2ss_ep_ops;
 
 	if (isdigit(name[2])) {
-
-		long	num;
+		u32	num;
 		int	res;
 		char	tempbuf[2];
 
 		tempbuf[0] = name[2];
 		tempbuf[1] = '\0';
-		res = strict_strtol(tempbuf, 16, &num);
+		res = kstrtou32(tempbuf, 16, &num);
 
 		if (num == 0)
 			ep->ep.maxpacket = EP0_PACKETSIZE;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
revert-fs-seq_file-fallback-to-vmalloc-allocation.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
kbuild-explain-stack-protector-strong-config-logic.patch
ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes.patch
mm.patch
slub-use-new-node-functions-checkpatch-fixes.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix.patch
slab-change-int-to-size_t-for-representing-allocation-size.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc-fix.patch
include-linux-mmdebugh-add-vm_warn_once.patch
mm-catch-memory-commitment-underflow-fix.patch
mm-hugetlb-generalize-writes-to-nr_hugepages-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc-fix.patch
mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used-checkpatch-fixes.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
add-lib-globc-fix.patch
lib-list_sortc-convert-to-pr_foo.patch
lib-list_sortc-convert-to-pr_foo-fix.patch
checkpatch-add-test-for-commit-id-formatting-style-in-commit-log.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting-fix.patch
fs-isofs-logging-clean-up-fix.patch
proc-remove-proc_tty_ldisc-variable-fix.patch
kexec-implementation-of-new-syscall-kexec_file_load-checkpatch-fixes.patch
kexec-support-kexec-kdump-on-efi-systems-fix.patch
panic-add-taint_softlockup-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

