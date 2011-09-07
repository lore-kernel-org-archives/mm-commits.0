From: akpm@linux-foundation.org
Subject: + lib-bitmapc-quiet-sparse-noise-about-address-space-fix.patch added to -mm tree
Date: Tue, 06 Sep 2011 18:16:55 -0700
Message-ID: <201109070112.p871Cg7v020768@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51514 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751399Ab1IGBMo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Sep 2011 21:12:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ak@linux.intel.com, andy.shevchenko@gmail.com, hartleys@visionengravers.com, hsweeten@visionengravers.com, len.brown@intel.com, ying.huang@intel.com


The patch titled
     lib-bitmapc-quiet-sparse-noise-about-address-space-fix
has been added to the -mm tree.  Its filename is
     lib-bitmapc-quiet-sparse-noise-about-address-space-fix.patch

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
Subject: lib-bitmapc-quiet-sparse-noise-about-address-space-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Len Brown <len.brown@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/bitmap.c~lib-bitmapc-quiet-sparse-noise-about-address-space-fix lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmapc-quiet-sparse-noise-about-address-space-fix
+++ a/lib/bitmap.c
@@ -419,7 +419,7 @@ int __bitmap_parse(const char *buf, unsi
 {
 	int c, old_c, totaldigits, ndigits, nchunks, nbits;
 	u32 chunk;
-	const char __user __force *ubuf = buf;
+	const char __user __force *ubuf = (const char __user __force *)buf;
 
 	bitmap_zero(maskp, nmaskbits);
 
@@ -596,7 +596,7 @@ static int __bitmap_parselist(const char
 {
 	unsigned a, b;
 	int c, old_c, totaldigits;
-	const char __user __force *ubuf = buf;
+	const char __user __force *ubuf = (const char __user __force *)buf;
 	int exp_digit, in_range;
 
 	totaldigits = c = 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
headers_check-is-broken.patch
samples-hidraw-is-busted.patch
numa-fix-numa-compile-error-when-sysfs-and-procfs-are-disabled-fix.patch
mm-vmscan-fix-force-scanning-small-targets-without-swap-fix.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
leds-new-pcengines-alix-system-driver-enables-leds-via-gpio-interface-fix.patch
sound-core-pcm_libc-fix-race-condition-in-wait_for_avail-fix.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements-checkpatch-fixes.patch
block-document-blk-plug.patch
block-document-blk-plug-v3-fix.patch
mm.patch
mm-add-comments-to-explain-mm_struct-fields-fix.patch
vmscan-use-atomic-long-for-shrinker-batching-fix.patch
mm-avoid-null-pointer-access-in-vm_struct-via-proc-vmallocinfo.patch
thp-mremap-support-and-tlb-optimization-fix.patch
thp-mremap-support-and-tlb-optimization-fix-fix.patch
mm-neaten-warn_alloc_failed-fix.patch
debug-pagealloc-add-support-for-highmem-pages-fix.patch
mm-compaction-compact-unevictable-pages-checkpatch-fixes.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
include-linux-securityh-fix-security_inode_init_security-arg.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
treewide-use-__printf-not-__attribute__formatprintf-checkpatch-fixes.patch
fs-nameic-remove-unused-getname_flags.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
lib-bitmapc-quiet-sparse-noise-about-address-space-fix.patch
lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
cgroups-new-cancel_attach_task-subsystem-callback-fix.patch
cgroups-add-res-counter-common-ancestor-searching-fix.patch
cgroups-add-a-task-counter-subsystem.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
sysctl-add-support-for-poll-fix.patch
pps-new-client-driver-using-gpio-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
kexec-remove-kmsg_dump_kexec.patch
aio-allocate-kiocbs-in-batches-fix.patch
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

