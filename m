From: akpm@linux-foundation.org
Subject: [merged] dio-merge-direct_io_walker-into-__blockdev_direct_io-checkpatch-fixes.patch removed from -mm tree
Date: Fri, 28 Oct 2011 15:11:01 -0700
Message-ID: <201110282211.p9SMB1Kv020727@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:33117 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806Ab1J1WLF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2011 18:11:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dio-merge-direct_io_walker-into-__blockdev_direct_io-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     dio-merge-direct_io_walker-into-__blockdev_direct_io-checkpatch-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: dio-merge-direct_io_walker-into-__blockdev_direct_io-checkpatch-fixes

ERROR: trailing whitespace
#180: FILE: fs/direct-io.c:1103:
+^Iunsigned long user_addr; $

ERROR: need consistent spacing around '+' (ctx:WxV)
#223: FILE: fs/direct-io.c:1213:
+			((user_addr+iov[seg].iov_len +PAGE_SIZE-1)/PAGE_SIZE
 			                             ^

ERROR: trailing whitespace
#247: FILE: fs/direct-io.c:1237:
+^I$

total: 3 errors, 0 warnings, 297 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/dio-merge-direct_io_walker-into-__blockdev_direct_io.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/direct-io.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/direct-io.c~dio-merge-direct_io_walker-into-__blockdev_direct_io-checkpatch-fixes fs/direct-io.c
--- a/fs/direct-io.c~dio-merge-direct_io_walker-into-__blockdev_direct_io-checkpatch-fixes
+++ a/fs/direct-io.c
@@ -1096,7 +1096,7 @@ __blockdev_direct_IO(int rw, struct kioc
 	loff_t end = offset;
 	struct dio *dio;
 	struct dio_submit sdio = { 0, };
-	unsigned long user_addr; 
+	unsigned long user_addr;
 	size_t bytes;
 	struct buffer_head map_bh = { 0, };
 
@@ -1206,7 +1206,7 @@ __blockdev_direct_IO(int rw, struct kioc
 	for (seg = 0; seg < nr_segs; seg++) {
 		user_addr = (unsigned long)iov[seg].iov_base;
 		sdio.pages_in_io +=
-			((user_addr+iov[seg].iov_len +PAGE_SIZE-1)/PAGE_SIZE
+			((user_addr+iov[seg].iov_len + PAGE_SIZE - 1)/PAGE_SIZE
 				- user_addr/PAGE_SIZE);
 	}
 
@@ -1230,7 +1230,7 @@ __blockdev_direct_IO(int rw, struct kioc
 		}
 		sdio.total_pages += (bytes + PAGE_SIZE - 1) / PAGE_SIZE;
 		sdio.curr_user_address = user_addr;
-	
+
 		retval = do_direct_IO(dio, &sdio, &map_bh);
 
 		dio->result += iov[seg].iov_len -
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
dma-mapping-fix-sync_single_range_-dma-debugging-checkpatch-fixes.patch
proc-self-numa_maps-restore-huge-tag-for-hugetlb-vmas.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
include-linux-dmarh-forward-declare-struct-acpi_dmar_header.patch
readlinkat-ensure-we-return-enoent-for-the-empty-pathname-for-normal-lookups.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
mrst-battery-fixes-fix.patch
x86-reduce-clock-calibration-time-during-slave-cpu-startup-fix.patch
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
mm-munlock-use-mapcount-to-avoid-terrible-overhead-fix.patch
include-linux-securityh-fix-security_inode_init_security-arg.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
kernel-sysctlc-add-cap_last_cap-to-proc-sys-kernel-fix.patch
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
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

