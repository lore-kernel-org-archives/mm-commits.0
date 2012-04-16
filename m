From: akpm@linux-foundation.org
Subject: + vsprintf-correctly-handle-width-when-flag-used-in-%p-format-checkpatch-fixes.patch added to -mm tree
Date: Mon, 16 Apr 2012 14:49:58 -0700
Message-ID: <20120416214958.45FEDA0333@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:59512 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755383Ab2DPVt7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Apr 2012 17:49:59 -0400
Received: by qabg24 with SMTP id g24so679888qab.1
        for <mm-commits@vger.kernel.org>; Mon, 16 Apr 2012 14:49:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, grant.likely@secretlab.ca


The patch titled
     Subject: vsprintf-correctly-handle-width-when-flag-used-in-%p-format-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     vsprintf-correctly-handle-width-when-flag-used-in-%p-format-checkpatch-fixes.patch

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
Subject: vsprintf-correctly-handle-width-when-flag-used-in-%p-format-checkpatch-fixes

ERROR: "(foo*)" should be "(foo *)"
#20: FILE: lib/vsprintf.c:869:
+	int default_width = 2 * sizeof(void*) + (spec.flags & SPECIAL ? 2 : 0);

total: 1 errors, 0 warnings, 32 lines checked

./patches/vsprintf-correctly-handle-width-when-flag-used-in-%p-format.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/vsprintf.c~vsprintf-correctly-handle-width-when-flag-used-in-%p-format-checkpatch-fixes lib/vsprintf.c
--- a/lib/vsprintf.c~vsprintf-correctly-handle-width-when-flag-used-in-%p-format-checkpatch-fixes
+++ a/lib/vsprintf.c
@@ -866,7 +866,7 @@ static noinline_for_stack
 char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 	      struct printf_spec spec)
 {
-	int default_width = 2 * sizeof(void*) + (spec.flags & SPECIAL ? 2 : 0);
+	int default_width = 2 * sizeof(void *) + (spec.flags & SPECIAL ? 2 : 0);
 
 	if (!ptr && *fmt != 'K') {
 		/*
_
Subject: Subject: vsprintf-correctly-handle-width-when-flag-used-in-%p-format-checkpatch-fixes

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
mm-correctly-synchronize-rss-counters-at-exit-exec-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-kernel-apic-io_apicc-move-io_apic_level_ack_pending-inside-config_generic_pending_irq.patch
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
vsprintf-correctly-handle-width-when-flag-used-in-%p-format-checkpatch-fixes.patch
vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch
leds-led-module-for-da9052-53-pmic-v2-fix.patch
leds-add-led-driver-for-lm3556-chip-checkpatch-fixes.patch
rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call.patch
proc-clean-up-proc-pid-environ-handling-checkpatch-fixes.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

