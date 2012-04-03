From: akpm@linux-foundation.org
Subject: + x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix.patch added to -mm tree
Date: Tue, 03 Apr 2012 14:03:35 -0700
Message-ID: <20120403214747.7B30A1E0058@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:43639 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866Ab2DCVrs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Apr 2012 17:47:48 -0400
Received: by qcsp5 with SMTP id p5so27777qcs.1
        for <mm-commits@vger.kernel.org>; Tue, 03 Apr 2012 14:47:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, alex.shi@intel.com


The patch titled
     Subject: x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix
has been added to the -mm tree.  Its filename is
     x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix

Cc: Alex Shi <alex.shi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/process.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/kernel/process.c~x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix arch/x86/kernel/process.c
--- a/arch/x86/kernel/process.c~x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix
+++ a/arch/x86/kernel/process.c
@@ -377,7 +377,7 @@ static inline void play_dead(void)
 #ifdef CONFIG_X86_64
 void enter_idle(void)
 {
-	percpu_write(is_idle, 1);
+	__this_cpu_write(is_idle, 1);
 	atomic_notifier_call_chain(&idle_notifier, IDLE_START, NULL);
 }
 
_
Subject: Subject: x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
fs-xattrc-listxattr-fall-back-to-vmalloc-if-kmalloc-failed.patch
fs-xattrc-setxattr-improve-handling-of-allocation-failures.patch
simple_open-automatically-convert-to-simple_open-checkpatch-fixes.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
drivers-xen-kconfig-fix-kconfig-layout.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix.patch
percpu-remove-percpu_xxx-functions-fix.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
brlocks-lglocks-cleanups.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad-fix.patch
vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch
leds-add-led-driver-for-lm3556-chip-fix-2.patch
leds-add-led-driver-for-lm3556-chip-checkpatch-fixes.patch
leds-add-led-driver-for-lm3556-chip-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2.patch
c-r-prctl-add-ability-to-get-clear_tid_address-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

