From: akpm@linux-foundation.org
Subject: + fs-xfs-xfs_trans_ailc-fix-build.patch added to -mm tree
Date: Tue, 18 Oct 2011 15:49:03 -0700
Message-ID: <201110182329.p9INTJqR001161@hpaq13.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:50316 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137Ab1JRX3g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2011 19:29:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, aelder@sgi.com


The patch titled
     Subject: fs/xfs/xfs_trans_ail.c: fix build
has been added to the -mm tree.  Its filename is
     fs-xfs-xfs_trans_ailc-fix-build.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs/xfs/xfs_trans_ail.c: fix build

fs/xfs/xfs_trans_ail.c: In function 'xfsaild_push':
fs/xfs/xfs_trans_ail.c:437: error: 'flush_log' undeclared (first use in this function)                                                                          fs/xfs/xfs_trans_ail.c:437: error: (Each undeclared identifier is reported only once

Not sure what's happening here - some mainline-vs-next snafu?

Cc: Alex Elder <aelder@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/xfs_trans_ail.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/xfs/xfs_trans_ail.c~fs-xfs-xfs_trans_ailc-fix-build fs/xfs/xfs_trans_ail.c
--- a/fs/xfs/xfs_trans_ail.c~fs-xfs-xfs_trans_ailc-fix-build
+++ a/fs/xfs/xfs_trans_ail.c
@@ -432,12 +432,10 @@ xfsaild_push(
 		case XFS_ITEM_PUSHBUF:
 			XFS_STATS_INC(xs_push_ail_pushbuf);
 
-			if (!IOP_PUSHBUF(lip)) {
+			if (!IOP_PUSHBUF(lip))
 				stuck++;
-				flush_log = 1;
-			} else {
+			else
 				ailp->xa_last_pushed_lsn = lsn;
-			}
 			push_xfsbufd = 1;
 			break;
 
_
Subject: Subject: fs/xfs/xfs_trans_ail.c: fix build

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
dma-mapping-fix-sync_single_range_-dma-debugging-checkpatch-fixes.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
include-linux-dmarh-forward-declare-struct-acpi_dmar_header.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
mrst-battery-fixes-fix.patch
drivers-net-ethernet-oki-semi-pch_gbe-pch_gbeh-remove-unused-macro-pr_fmt.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements.patch
mm.patch
mm-add-comments-to-explain-mm_struct-fields-fix.patch
vmscan-use-atomic-long-for-shrinker-batching-fix.patch
mm-avoid-null-pointer-access-in-vm_struct-via-proc-vmallocinfo.patch
thp-mremap-support-and-tlb-optimization-fix.patch
thp-mremap-support-and-tlb-optimization-fix-fix.patch
mm-neaten-warn_alloc_failed-fix.patch
debug-pagealloc-add-support-for-highmem-pages-fix.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-add-comment-explaining-task-state-setting-in-bdi_forker_thread-fix.patch
mm-mmapc-eliminate-the-ret-variable-from-mm_take_all_locks-fix.patch
include-linux-securityh-fix-security_inode_init_security-arg.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
kernel-sysctlc-add-cap_last_cap-to-proc-sys-kernel-fix.patch
dynamic_debug-consolidate-repetitive-struct-_ddebug-descriptor-definitions.patch
dynamic_debug-use-a-single-printk-to-emit-messages.patch
fs-nameic-remove-unused-getname_flags.patch
drivers-leds-leds-lp5521c-check-if-reset-is-successful-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
lib-bitmapc-quiet-sparse-noise-about-address-space-fix.patch
llist-return-whether-list-is-empty-before-adding-in-llist_add-fix.patch
checkpatch-add-a-strict-check-for-utf-8-in-commit-logs.patch
lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch
sysctl-add-support-for-poll-fix.patch
include-linux-dma-mappingh-add-dma_zalloc_coherent.patch
pps-new-client-driver-using-gpio-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
kexec-remove-kmsg_dump_kexec.patch
dio-separate-fields-only-used-in-the-submission-path-from-struct-dio-checkpatch-fixes.patch
dio-inline-the-complete-submission-path-v2-checkpatch-fixes.patch
dio-merge-direct_io_walker-into-__blockdev_direct_io-checkpatch-fixes.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch
fs-xfs-xfs_trans_ailc-fix-build.patch

