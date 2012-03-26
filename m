From: akpm@linux-foundation.org
Subject: [merged] drivers-leds-leds-lp5523c-constify-some-data.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:29:40 -0700
Message-ID: <20120326192940.55AC9A0560@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:40916 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab2CZT3m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:29:42 -0400
Received: by mail-lb0-f202.google.com with SMTP id gj3so288108lbb.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:29:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/leds/leds-lp5523.c: constify some data
has been removed from the -mm tree.  Its filename was
     drivers-leds-leds-lp5523c-constify-some-data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/leds/leds-lp5523.c: constify some data

Saves ~50 bytes text and speeds things up.

Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lp5523.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/leds/leds-lp5523.c~drivers-leds-leds-lp5523c-constify-some-data drivers/leds/leds-lp5523.c
--- a/drivers/leds/leds-lp5523.c~drivers-leds-leds-lp5523c-constify-some-data
+++ a/drivers/leds/leds-lp5523.c
@@ -152,7 +152,7 @@ static inline struct lp5523_chip *led_to
 
 static int lp5523_set_mode(struct lp5523_engine *engine, u8 mode);
 static int lp5523_set_engine_mode(struct lp5523_engine *engine, u8 mode);
-static int lp5523_load_program(struct lp5523_engine *engine, u8 *pattern);
+static int lp5523_load_program(struct lp5523_engine *engine, const u8 *pattern);
 
 static void lp5523_led_brightness_work(struct work_struct *work);
 
@@ -196,7 +196,7 @@ static int lp5523_configure(struct i2c_c
 	u8 status;
 
 	/* one pattern per engine setting led mux start and stop addresses */
-	u8 pattern[][LP5523_PROGRAM_LENGTH] =  {
+	static const u8 pattern[][LP5523_PROGRAM_LENGTH] =  {
 		{ 0x9c, 0x30, 0x9c, 0xb0, 0x9d, 0x80, 0xd8, 0x00, 0},
 		{ 0x9c, 0x40, 0x9c, 0xc0, 0x9d, 0x80, 0xd8, 0x00, 0},
 		{ 0x9c, 0x50, 0x9c, 0xd0, 0x9d, 0x80, 0xd8, 0x00, 0},
@@ -301,7 +301,7 @@ static int lp5523_load_mux(struct lp5523
 	return ret;
 }
 
-static int lp5523_load_program(struct lp5523_engine *engine, u8 *pattern)
+static int lp5523_load_program(struct lp5523_engine *engine, const u8 *pattern)
 {
 	struct lp5523_chip *chip = engine_to_lp5523(engine);
 	struct i2c_client *client = chip->client;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
percpu-remove-percpu_xxx-functions-fix.patch
net-netfilter-nfnetlink_acctc-use-linux-atomich.patch
brlocks-lglocks-cleanups.patch
simple_open-automatically-convert-to-simple_open-checkpatch-fixes.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions-fix.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
memcg-change-behavior-of-moving-charges-at-task-move-fix.patch
cpuidle-add-a-sysfs-entry-to-disable-specific-c-state-for-debug-purpose-fix.patch
arch-powerpc-platforms-pseries-eeh_eventc-slightly-fix-set_current_state-wart.patch
drivers-xen-kconfig-fix-kconfig-layout.patch
kmod-avoid-deadlock-by-recursive-kmod-call.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-update-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-v9.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-v9-fix.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-checkpatch-fixes.patch
fs-proc-namespacesc-prevent-crash-when-ns_entries-is-empty.patch
radix-tree-introduce-bit-optimized-iterator-v3-fix.patch
selftests-makefile-make-run_tests-depend-on-all.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2.patch
c-r-prctl-add-ability-to-get-clear_tid_address-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

