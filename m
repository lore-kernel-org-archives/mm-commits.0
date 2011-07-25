From: akpm@linux-foundation.org
Subject: [merged] arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch removed from -mm tree
Date: Mon, 25 Jul 2011 12:04:43 -0700
Message-ID: <201107251903.p6PJ3qq0022508__49119.9767253876$1311620689$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52068 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752155Ab1GYTEj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jul 2011 15:04:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hpa@zytor.com, linux-arch@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     arch/x86/include/asm/delay.h: fix udelay() and ndelay() for 8-bit args
has been removed from the -mm tree.  Its filename was
     arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/x86/include/asm/delay.h: fix udelay() and ndelay() for 8-bit args
From: Andrew Morton <akpm@linux-foundation.org>

With a non-constant 8-bit argument, a call to udelay() generates a warning:

drivers/gpu/drm/radeon/atom.c: In function 'atom_op_delay':
drivers/gpu/drm/radeon/atom.c:654: warning: comparison is always false due to limited range of data type

The code looks like it works OK with an 8-bit arg, and the calling code is
doing nothing wrong, so udelay() needs fixing.

Fixing it was rather tricky.  Simply typecasting `n' in the comparison with
20000 didn't change anything.  Hence the divide-by-20000 trick.

Using a do{}while loop didn't work because udelay() is used in ?: statements,
hence the ({...}) construct.

While I was there I replaced the brain-bending ?:?:?: mess with nice if/else
code.

Probably other architectures are generating the same warning and can use a
similar change.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/delay.h |   33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

diff -puN include/asm-generic/delay.h~arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args include/asm-generic/delay.h
--- a/include/asm-generic/delay.h~arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args
+++ a/include/asm-generic/delay.h
@@ -10,14 +10,35 @@ extern void __ndelay(unsigned long nsecs
 extern void __const_udelay(unsigned long xloops);
 extern void __delay(unsigned long loops);
 
+/*
+ * The weird n/20000 thing suppresses a "comparison is always false due to
+ * limited range of data type" warning with non-const 8-bit arguments.
+ */
+
 /* 0x10c7 is 2**32 / 1000000 (rounded up) */
-#define udelay(n) (__builtin_constant_p(n) ? \
-	((n) > 20000 ? __bad_udelay() : __const_udelay((n) * 0x10c7ul)) : \
-	__udelay(n))
+#define udelay(n)							\
+	({								\
+		if (__builtin_constant_p(n)) {				\
+			if ((n) / 20000 >= 1)				\
+				 __bad_udelay();			\
+			else						\
+				__const_udelay((n) * 0x10c7ul);		\
+		} else {						\
+			__udelay(n);					\
+		}							\
+	})
 
 /* 0x5 is 2**32 / 1000000000 (rounded up) */
-#define ndelay(n) (__builtin_constant_p(n) ? \
-	((n) > 20000 ? __bad_ndelay() : __const_udelay((n) * 5ul)) : \
-	__ndelay(n))
+#define ndelay(n)							\
+	({								\
+		if (__builtin_constant_p(n)) {				\
+			if ((n) / 20000 >= 1)				\
+				__bad_ndelay();				\
+			else						\
+				__const_udelay((n) * 5ul);		\
+		} else {						\
+			__ndelay(n);					\
+		}							\
+	})
 
 #endif /* __ASM_GENERIC_DELAY_H */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
headers_check-is-broken.patch
samples-hidraw-is-busted.patch
hugetlb-add-phys-addr-to-struct-huge_bootmem_page-fix.patch
mm-use-const-struct-page-for-r-o-page-flag-accessor-methods-checkpatch-fixes.patch
xtensa-prevent-arbitrary-read-in-ptrace-fix.patch
linux-next.patch
linux-next-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes.patch
kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver-fix.patch
drivers-video-backlight-aat2870_blc-make-it-buildable-as-a-module.patch
pci-enumerate-the-pci-device-only-removed-out-pci-hierarchy-of-os-when-re-scanning-pci-fix.patch
drivers-cdrom-cdromc-relax-check-on-dvd-manufacturer-value.patch
drivers-staging-speakup-devsynthc-fix-buffer-size-is-not-provably-correct-error.patch
drivers-staging-dt3155v4l-dt3155v4lc-needs-slabh.patch
drivers-staging-solo6x10-corec-needs-slabh.patch
drivers-staging-solo6x10-p2mc-needs-slabh.patch
staging-more-missing-slabh-inclusions.patch
slab-use-numa_no_node.patch
mm.patch
mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines-fix.patch
pagewalk-add-locking-rule-comments-fix.patch
mm-memoryc-remove-zap_block_size.patch
mm-memblockc-avoid-abuse-of-red_inactive.patch
mm-preallocate-page-before-lock_page-at-filemap-cow.patch
mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young-checkpatch-fixes.patch
mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
drivers-misc-add-support-the-fsa9480-usb-switch-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
lib-make-_tolower-public-checkpatch-fixes.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch
checkpatch-add-a-prefer-__aligned-check.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
init-skip-calibration-delay-if-previously-done-fix.patch
init-skip-calibration-delay-if-previously-done-fix-fix.patch
init-skip-calibration-delay-if-previously-done-4.patch
drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix.patch
memcg-consolidates-memory-cgroup-lru-stat-functions-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
h8300-m68k-xtensa-__fd_isset-should-return-0-1.patch
proc-pid-fdinfo-add-cloexec-information-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-fix-2.patch
ipc-introduce-shm_rmid_forced-sysctl-cleanup.patch
ipc-introduce-shm_rmid_forced-sysctl-comments-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec.patch
vmware-balloon-switch-to-using-sysem-wide-freezable-workqueue-fix.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

