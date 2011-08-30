From: akpm@linux-foundation.org
Subject: + dio-merge-direct_io_walker-into-__blockdev_direct_io-checkpatch-fixes.patch added to -mm tree
Date: Tue, 30 Aug 2011 16:50:48 -0700
Message-ID: <201108302350.p7UNon9E026382@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45785 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753704Ab1H3XvS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Aug 2011 19:51:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ak@linux.intel.com


The patch titled
     dio-merge-direct_io_walker-into-__blockdev_direct_io-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     dio-merge-direct_io_walker-into-__blockdev_direct_io-checkpatch-fixes.patch

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
Subject: dio-merge-direct_io_walker-into-__blockdev_direct_io-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

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
@@ -1100,7 +1100,7 @@ __blockdev_direct_IO(int rw, struct kioc
 	loff_t end = offset;
 	struct dio *dio;
 	struct dio_submit sdio = { 0, };
-	unsigned long user_addr; 
+	unsigned long user_addr;
 	size_t bytes;
 	struct buffer_head map_bh = { 0, };
 
@@ -1210,7 +1210,7 @@ __blockdev_direct_IO(int rw, struct kioc
 	for (seg = 0; seg < nr_segs; seg++) {
 		user_addr = (unsigned long)iov[seg].iov_base;
 		sdio.pages_in_io +=
-			((user_addr+iov[seg].iov_len +PAGE_SIZE-1)/PAGE_SIZE
+			((user_addr+iov[seg].iov_len + PAGE_SIZE - 1)/PAGE_SIZE
 				- user_addr/PAGE_SIZE);
 	}
 
@@ -1234,7 +1234,7 @@ __blockdev_direct_IO(int rw, struct kioc
 		}
 		sdio.total_pages += (bytes + PAGE_SIZE - 1) / PAGE_SIZE;
 		sdio.curr_user_address = user_addr;
-	
+
 		retval = do_direct_IO(dio, &sdio, &map_bh);
 
 		dio->result += iov[seg].iov_len -
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

headers_check-is-broken.patch
samples-hidraw-is-busted.patch
numa-fix-numa-compile-error-when-sysfs-and-procfs-are-disabled-fix.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
leds-new-pcengines-alix-system-driver-enables-leds-via-gpio-interface-fix.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements-checkpatch-fixes.patch
block-document-blk-plug-fix.patch
mm.patch
mm-vmscan-fix-force-scanning-small-targets-without-swap-fix.patch
mm-add-comments-to-explain-mm_struct-fields-fix.patch
vmscan-use-atomic-long-for-shrinker-batching-fix.patch
mm-avoid-null-pointer-access-in-vm_struct-via-proc-vmallocinfo.patch
thp-mremap-support-and-tlb-optimization-fix.patch
thp-mremap-support-and-tlb-optimization-fix-fix.patch
mm-neaten-warn_alloc_failed-fix.patch
debug-pagealloc-add-support-for-highmem-pages-fix.patch
mm-compaction-compact-unevictable-pages-checkpatch-fixes.patch
include-linux-securityh-fix-security_inode_init_security-arg.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
treewide-use-__printf-not-__attribute__formatprintf-checkpatch-fixes.patch
fs-nameic-remove-unused-getname_flags.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
sysctl-add-support-for-poll-fix.patch
nbd-replace-some-printk-with-dev_warn-and-dev_info-checkpatch-fixes.patch
pps-new-client-driver-using-gpio-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
kexec-remove-kmsg_dump_kexec.patch
dio-separate-fields-only-used-in-the-submission-path-from-struct-dio-checkpatch-fixes.patch
dio-inline-the-complete-submission-path-v2-checkpatch-fixes.patch
dio-merge-direct_io_walker-into-__blockdev_direct_io-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

