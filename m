From: akpm@linux-foundation.org
Subject: [merged] alpha-fix-32-64-bit-bug-in-futex-support.patch removed from -mm tree
Date: Tue, 06 Mar 2012 11:35:19 -0800
Message-ID: <20120306193519.898D2A02EB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:50858 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758719Ab2CFTfU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Mar 2012 14:35:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ext-phil.2.carmody@nokia.com, ink@jurassic.park.msu.ru, mattst88@gmail.com, mcree@orcon.net.nz, rth@twiddle.net, stable@vger.kernel.org, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: alpha: fix 32/64-bit bug in futex support
has been removed from the -mm tree.  Its filename was
     alpha-fix-32-64-bit-bug-in-futex-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: alpha: fix 32/64-bit bug in futex support

Michael Cree said:

: : I have noticed some user space problems (pulseaudio crashes in pthread
: : code, glibc/nptl test suite failures, java compiler freezes on SMP alpha
: : systems) that arise when using a 2.6.39 or later kernel on Alpha.
: : Bisecting between 2.6.38 and 2.6.39 (using glibc/nptl test suite as
: : criterion for good/bad kernel) eventually leads to:
: : 
: : 8d7718aa082aaf30a0b4989e1f04858952f941bc is the first bad commit
: : commit 8d7718aa082aaf30a0b4989e1f04858952f941bc
: : Author: Michel Lespinasse <walken@google.com>
: : Date:   Thu Mar 10 18:50:58 2011 -0800
: : 
: :     futex: Sanitize futex ops argument types
: : 
: :     Change futex_atomic_op_inuser and futex_atomic_cmpxchg_inatomic
: :     prototypes to use u32 types for the futex as this is the data type the
: :     futex core code uses all over the place.
: : 
: : Looking at the commit I see there is a change of the uaddr argument in
: : the Alpha architecture specific code for futexes from int to u32, but I
: : don't see why this should cause a problem.

Richard Henderson said:

: futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
:                               u32 oldval, u32 newval)
: ...
:         :       "r"(uaddr), "r"((long)oldval), "r"(newval)
: 
: 
: There is no 32-bit compare instruction.  These are implemented by
: consistently extending the values to a 64-bit type.  Since the
: load instruction sign-extends, we want to sign-extend the other
: quantity as well (despite the fact it's logically unsigned).
: 
: So:
: 
: -        :       "r"(uaddr), "r"((long)oldval), "r"(newval)
: +        :       "r"(uaddr), "r"((long)(int)oldval), "r"(newval)
: 
: should do the trick.

Michael said:

: This fixes the glibc test suite failures and the pulseaudio related
: crashes, but it does not fix the java compiiler lockups that I was (and
: are still) observing.  That is some other problem.

Reported-by: Michael Cree <mcree@orcon.net.nz>
Tested-by: Michael Cree <mcree@orcon.net.nz>
Acked-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Michel Lespinasse <walken@google.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Reviewed-by: Matt Turner <mattst88@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/futex.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/alpha/include/asm/futex.h~alpha-fix-32-64-bit-bug-in-futex-support arch/alpha/include/asm/futex.h
--- a/arch/alpha/include/asm/futex.h~alpha-fix-32-64-bit-bug-in-futex-support
+++ a/arch/alpha/include/asm/futex.h
@@ -108,7 +108,7 @@ futex_atomic_cmpxchg_inatomic(u32 *uval,
 	"	lda	$31,3b-2b(%0)\n"
 	"	.previous\n"
 	:	"+r"(ret), "=&r"(prev), "=&r"(cmp)
-	:	"r"(uaddr), "r"((long)oldval), "r"(newval)
+	:	"r"(uaddr), "r"((long)(int)oldval), "r"(newval)
 	:	"memory");
 
 	*uval = prev;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-mfd-twl-corec-wtf-isnt-this-fixed-yet.patch
drivers-mfd-twl-corec-unbork.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
x86-pci-increase-the-number-of-iommus-supported-to-be-max_io_apics.patch
drivers-media-video-uvc-uvc_driverc-use-linux-atomich.patch
thermal-thermal_sys-fix-build-warning.patch
thermal-add-support-for-thermal-sensor-present-on-spear13xx-machines.patch
net-netfilter-nfnetlink_acctc-use-linux-atomich.patch
slab-introduce-kmalloc_array.patch
mm.patch
make-swapin-readahead-skip-over-holes-fix.patch
vmscan-kswapd-carefully-call-compaction-fix.patch
mm-compaction-make-compact_control-order-signed-fix.patch
hugetlb-try-to-search-again-if-it-is-really-needed-fix.patch
thp-optimize-away-unnecessary-page-table-locking-fix-checkpatch-fixes.patch
mm-vmscan-forcibly-scan-highmem-if-there-are-too-many-buffer_heads-pinning-highmem-fix-fix.patch
procfs-mark-thread-stack-correctly-in-proc-pid-maps.patch
mm-fix-move-migrate_pages-race-on-task-struct-checkpatch-fixes.patch
bootmem-sparsemem-remove-limit-constraint-in-alloc_bootmem_section-fix.patch
ksm-cleanup-introduce-ksm_check_mm-fix.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch
memcg-simplify-move_account-check-fix.patch
memcg-use-new-logic-for-page-stat-accounting-fix.patch
memcg-fix-performance-of-mem_cgroup_begin_update_page_stat-fix.patch
mm-memcontrolc-s-stealed-stolen.patch
percpu-remove-percpu_xxx-functions-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch
smp-start-up-non-boot-cpus-asynchronously-fix.patch
brlocks-lglocks-cleanups.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions-fix.patch
backlight-add-driver-for-bachmanns-ot200-fix.patch
leds-lp5521-support-led-pattern-data-checkpatch-fixes.patch
drivers-leds-leds-lp5523c-constify-some-data.patch
drivers-leds-add-driver-for-pca9663-i2c-chip-fix.patch
leds-lm3530-replace-i2c_client-with-led_classdev-fix.patch
drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place-fix.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
rtc-rtc-driver-for-da9052-53-pmic-v1-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call-fix.patch
procfs-add-num_to_str-to-speed-up-proc-stat-fix.patch
procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes.patch
seq_file-add-seq_set_overflow-seq_overflow-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-update-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-v9.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-v9-fix.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-checkpatch-fixes.patch
fs-proc-namespacesc-prevent-crash-when-ns_entries-is-empty.patch
selftests-makefile-make-run_tests-depend-on-all.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

