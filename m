From: akpm@linux-foundation.org
Subject: [folded] alpha-unbreak-osf_setsysinfossi_nvpairs-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 25 Aug 2011 15:40:14 -0700
Message-ID: <201108252240.p7PMeEig017273@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42750 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755722Ab1HYWkv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Aug 2011 18:40:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mcree@orcon.net.nz, mm-commits@vger.kernel.org


The patch titled
     alpha-unbreak-osf_setsysinfossi_nvpairs-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     alpha-unbreak-osf_setsysinfossi_nvpairs-checkpatch-fixes.patch

This patch was dropped because it was folded into alpha-unbreak-osf_setsysinfossi_nvpairs.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha-unbreak-osf_setsysinfossi_nvpairs-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#110: FILE: arch/alpha/kernel/osf_sys.c:637:
+ 		w = (current_thread_info()->flags >> ALPHA_UAC_SHIFT) & UAC_BITMASK;

ERROR: code indent should use tabs where possible
#110: FILE: arch/alpha/kernel/osf_sys.c:637:
+ ^I^Iw = (current_thread_info()->flags >> ALPHA_UAC_SHIFT) & UAC_BITMASK;$

WARNING: please, no space before tabs
#110: FILE: arch/alpha/kernel/osf_sys.c:637:
+ ^I^Iw = (current_thread_info()->flags >> ALPHA_UAC_SHIFT) & UAC_BITMASK;$

WARNING: please, no spaces at the start of a line
#110: FILE: arch/alpha/kernel/osf_sys.c:637:
+ ^I^Iw = (current_thread_info()->flags >> ALPHA_UAC_SHIFT) & UAC_BITMASK;$

WARNING: line over 80 characters
#121: FILE: arch/alpha/kernel/osf_sys.c:761:
+				new = new | (w & UAC_BITMASK) << ALPHA_UAC_SHIFT;

total: 1 errors, 4 warnings, 58 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/alpha-unbreak-osf_setsysinfossi_nvpairs.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Michael Cree <mcree@orcon.net.nz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/osf_sys.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN arch/alpha/kernel/osf_sys.c~alpha-unbreak-osf_setsysinfossi_nvpairs-checkpatch-fixes arch/alpha/kernel/osf_sys.c
--- a/arch/alpha/kernel/osf_sys.c~alpha-unbreak-osf_setsysinfossi_nvpairs-checkpatch-fixes
+++ a/arch/alpha/kernel/osf_sys.c
@@ -634,9 +634,10 @@ SYSCALL_DEFINE5(osf_getsysinfo, unsigned
  	case GSI_UACPROC:
 		if (nbytes < sizeof(unsigned int))
 			return -EINVAL;
- 		w = (current_thread_info()->flags >> ALPHA_UAC_SHIFT) & UAC_BITMASK;
- 		if (put_user(w, (unsigned int __user *)buffer))
- 			return -EFAULT;
+		w = (current_thread_info()->flags >> ALPHA_UAC_SHIFT) &
+			UAC_BITMASK;
+		if (put_user(w, (unsigned int __user *)buffer))
+			return -EFAULT;
  		return 1;
 
 	case GSI_PROC_TYPE:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
headers_check-is-broken.patch
samples-hidraw-is-busted.patch
alpha-unbreak-osf_setsysinfossi_nvpairs.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
leds-new-pcengines-alix-system-driver-enables-leds-via-gpio-interface-fix.patch
kernel-rtmutexc-fix-warning-improve-coding-style.patch
mm.patch
mm-vmscan-fix-force-scanning-small-targets-without-swap-fix.patch
mm-add-comments-to-explain-mm_struct-fields-fix.patch
vmscan-use-atomic-long-for-shrinker-batching-fix.patch
mm-avoid-null-pointer-access-in-vm_struct-via-proc-vmallocinfo.patch
thp-mremap-support-and-tlb-optimization-fix.patch
thp-mremap-support-and-tlb-optimization-fix-fix.patch
drivers-base-inodec-let-vmstat_text-be-optional-fix.patch
include-linux-securityh-fix-security_inode_init_security-arg.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
printk-add-module-parameter-ignore_loglevel-to-control-ignore_loglevel-fix-fix.patch
fs-nameic-remove-unused-getname_flags.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
nbd-replace-some-printk-with-dev_warn-and-dev_info-checkpatch-fixes.patch
pps-new-client-driver-using-gpio-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
kexec-remove-kmsg_dump_kexec.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

