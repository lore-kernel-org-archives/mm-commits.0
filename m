From: akpm@linux-foundation.org
Subject: [folded-merged] dma-debug-fix-locking-bug-in-check_unmap-fix.patch removed from -mm tree
Date: Fri, 22 Mar 2013 14:59:33 -0700
Message-ID: <20130322215934.3E2BB5A402F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:37980 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423324Ab3CVV7f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Mar 2013 17:59:35 -0400
Received: by mail-ye0-f202.google.com with SMTP id q11so294061yen.3
        for <mm-commits@vger.kernel.org>; Fri, 22 Mar 2013 14:59:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alexander.h.duyck@intel.com, joro@8bytes.org, konrad.wilk@oracle.com, kubakici@wp.pl, shuah.khan@hp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dma-debug-fix-locking-bug-in-check_unmap-fix
has been removed from the -mm tree.  Its filename was
     dma-debug-fix-locking-bug-in-check_unmap-fix.patch

This patch was dropped because it was folded into dma-debug-fix-locking-bug-in-check_unmap.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: dma-debug-fix-locking-bug-in-check_unmap-fix

restore 80-col trickery to be consistent with the rest of the file

Cc: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: Jakub Kicinski <kubakici@wp.pl>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Shuah Khan <shuah.khan@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dma-debug.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN lib/dma-debug.c~dma-debug-fix-locking-bug-in-check_unmap-fix lib/dma-debug.c
--- a/lib/dma-debug.c~dma-debug-fix-locking-bug-in-check_unmap-fix
+++ a/lib/dma-debug.c
@@ -867,10 +867,13 @@ static void check_unmap(struct dma_debug
 
 		if (dma_mapping_error(ref->dev, ref->dev_addr)) {
 			err_printk(ref->dev, NULL,
-				   "DMA-API: device driver tries to free an invalid DMA memory address\n");
+				   "DMA-API: device driver tries to free an "
+				   "invalid DMA memory address\n");
 		} else {
 			err_printk(ref->dev, NULL,
-				   "DMA-API: device driver tries to free DMA memory it has not allocated [device address=0x%016llx] [size=%llu bytes]\n",
+				   "DMA-API: device driver tries to free DMA "
+				   "memory it has not allocated [device "
+				   "address=0x%016llx] [size=%llu bytes]\n",
 				   ref->dev_addr, ref->size);
 		}
 		return;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

printk-provide-a-wake_up_klogd-off-case.patch
mm-hugetlb-fix-total-hugetlbfs-pages-count-when-memory-overcommit-accouting.patch
dma-debug-fix-locking-bug-in-check_unmap.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mips-define-kvm_user_mem_slots.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v3-fix.patch
loop-cleanup-partitions-when-detaching-loop-device-checkpatch-fixes.patch
loop-cleanup-partitions-when-detaching-loop-device-fix.patch
loop-cleanup-partitions-when-detaching-loop-device-fix-fix.patch
mm.patch
mm-shmemc-remove-an-ifdef.patch
xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module-fix.patch
memcg-relax-memcg-iter-caching-checkpatch-fixes.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix-fix.patch
kexec-vmalloc-export-additional-vmalloc-layer-information-fix.patch
mm-hugetlb-include-hugepages-in-meminfo-checkpatch-fixes.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
kernel-smpc-cleanups.patch
early_printk-consolidate-random-copies-of-identical-code-v3-fix.patch
include-linux-printkh-include-stdargh.patch
get_maintainer-use-filename-only-regex-match-for-tegra-fix.patch
argv_split-teach-it-to-handle-mutable-strings-fix.patch
epoll-trim-epitem-by-one-cache-line-on-x86_64-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix.patch
hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid-fix.patch
usermodehelper-export-_exec-and-_setup-functions-fix.patch
kexec-use-min_t-to-simplify-logic-fix.patch
ipc-introduce-obtaining-a-lockless-ipc-object-fix.patch
ipcsem-open-code-and-rename-sem_lock-fix.patch
kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap-fix.patch
pid_namespacec-h-simplify-defines-fix.patch
drivers-net-rename-random32-to-prandom_u32-fix.patch
gadget-remove-only-user-of-aio-retry-checkpatch-fixes.patch
aio-remove-retry-based-aio-checkpatch-fixes.patch
aio-add-kiocb_cancel.patch
aio-make-aio_put_req-lockless-checkpatch-fixes.patch
aio-refcounting-cleanup-checkpatch-fixes.patch
wait-add-wait_event_hrtimeout.patch
aio-make-aio_read_evt-more-efficient-convert-to-hrtimers-checkpatch-fixes.patch
aio-use-cancellation-list-lazily.patch
aio-give-shared-kioctx-fields-their-own-cachelines.patch
generic-dynamic-per-cpu-refcounting.patch
generic-dynamic-per-cpu-refcounting-checkpatch-fixes.patch
aio-dont-include-aioh-in-schedh.patch
aio-kill-ki_retry.patch
aio-kill-ki_retry-checkpatch-fixes.patch
block-prep-work-for-batch-completion-checkpatch-fixes.patch
block-aio-batch-completion-for-bios-kiocbs.patch
block-aio-batch-completion-for-bios-kiocbs-checkpatch-fixes.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

