From: akpm@linux-foundation.org
Subject: [folded] syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch removed from -mm tree
Date: Thu, 16 Feb 2012 11:48:29 -0800
Message-ID: <20120216194830.1B039A0128@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:45705 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab2BPTsc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Feb 2012 14:48:32 -0500
Received: by eaaf13 with SMTP id f13so84653eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 16 Feb 2012 11:48:31 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ebiederm@xmission.com, fweisbec@gmail.com, gorcunov@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Subject: syscalls-x86-add-__nr_kcmp-syscall-v8-fix
has been removed from the -mm tree.  Its filename was
     syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch

This patch was dropped because it was folded into syscalls-x86-add-__nr_kcmp-syscall-v8.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: syscalls-x86-add-__nr_kcmp-syscall-v8-fix

fix up selftests

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/Makefile      |    2 +-
 tools/testing/selftests/kcmp/Makefile |   22 +++++++---------------
 2 files changed, 8 insertions(+), 16 deletions(-)

diff -puN tools/testing/selftests/Makefile~syscalls-x86-add-__nr_kcmp-syscall-v8-fix tools/testing/selftests/Makefile
--- a/tools/testing/selftests/Makefile~syscalls-x86-add-__nr_kcmp-syscall-v8-fix
+++ a/tools/testing/selftests/Makefile
@@ -1,4 +1,4 @@
-TARGETS = breakpoints vm
+TARGETS = breakpoints vm kcmp
 
 all:
 	for TARGET in $(TARGETS); do \
diff -puN tools/testing/selftests/kcmp/Makefile~syscalls-x86-add-__nr_kcmp-syscall-v8-fix tools/testing/selftests/kcmp/Makefile
--- a/tools/testing/selftests/kcmp/Makefile~syscalls-x86-add-__nr_kcmp-syscall-v8-fix
+++ a/tools/testing/selftests/kcmp/Makefile
@@ -1,12 +1,3 @@
-ifeq ($(strip $(V)),)
-	E = @echo
-	Q = @
-else
-	E = @\#
-	Q =
-endif
-export E Q
-
 uname_M := $(shell uname -m 2>/dev/null || echo not)
 ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/)
 ifeq ($(ARCH),i386)
@@ -24,13 +15,14 @@ CFLAGS += -I../../../../usr/include/
 
 all:
 ifeq ($(ARCH),X86)
-	$(E) "  CC run_test"
-	$(Q) gcc $(CFLAGS) kcmp_test.c -o run_test
+	gcc $(CFLAGS) kcmp_test.c -o run_test
 else
-	$(E) "Not an x86 target, can't build kcmp selftest"
+	echo "Not an x86 target, can't build kcmp selftest"
 endif
 
+run-tests: all
+	./kcmp_test
+
 clean:
-	$(E) "  CLEAN"
-	$(Q) rm -fr ./run_test
-	$(Q) rm -fr ./test-file
+	rm -fr ./run_test
+	rm -fr ./test-file
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
ata-unbork.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
fs-btrfs-inode-mapc-fix-warnings.patch
hpet-factor-timer-allocate-from-open.patch
thermal-thermal_sys-fix-build-warning.patch
drivers-scsi-mpt2sas-mpt2sas_scsihc-spell-primitive-correctly.patch
slab-introduce-kmalloc_array.patch
mm.patch
make-swapin-readahead-skip-over-holes-fix.patch
vmscan-kswapd-carefully-call-compaction-fix.patch
mm-compaction-make-compact_control-order-signed-fix.patch
hugetlb-try-to-search-again-if-it-is-really-needed-fix.patch
mm-replace-compaction_build-with-is_enabledconfig_compaction-fix.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch
smp-start-up-non-boot-cpus-asynchronously-fix.patch
posix_types-remove-fd_set-macros-checkpatch-fixes.patch
brlocks-lglocks-cleanups-checkpatch-fixes.patch
backlight-add-driver-for-bachmanns-ot200-fix.patch
leds-lp5521-support-led-pattern-data-checkpatch-fixes.patch
drivers-leds-leds-lp5523c-constify-some-data.patch
drivers-leds-add-driver-for-pca9663-i2c-chip-fix.patch
leds-lm3530-replace-i2c_client-with-led_classdev-fix.patch
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
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-fix-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

