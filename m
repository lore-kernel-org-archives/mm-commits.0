From: akpm@linux-foundation.org
Subject: + lib-string_helpersc-make-arrays-static.patch added to -mm tree
Date: Wed, 18 Apr 2012 15:36:53 -0700
Message-ID: <20120418223653.75A4BA018B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:46431 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab2DRWgy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Apr 2012 18:36:54 -0400
Received: by yhgm50 with SMTP id m50so908218yhg.1
        for <mm-commits@vger.kernel.org>; Wed, 18 Apr 2012 15:36:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com, aneesh.kumar@linux.vnet.ibm.com


The patch titled
     Subject: lib/string_helpers.c: make arrays static
has been added to the -mm tree.  Its filename is
     lib-string_helpersc-make-arrays-static.patch

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
Subject: lib/string_helpers.c: make arrays static

Moving these arrays into static storage shrinks the kernel a bit:

   text    data     bss     dec     hex filename
    723     112      64     899     383 lib/string_helpers.o
    516     272      64     852     354 lib/string_helpers.o

Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/string_helpers.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN lib/string_helpers.c~lib-string_helpersc-make-arrays-static lib/string_helpers.c
--- a/lib/string_helpers.c~lib-string_helpersc-make-arrays-static
+++ a/lib/string_helpers.c
@@ -23,15 +23,15 @@
 int string_get_size(u64 size, const enum string_size_units units,
 		    char *buf, int len)
 {
-	const char *units_10[] = { "B", "kB", "MB", "GB", "TB", "PB",
+	static const char *units_10[] = { "B", "kB", "MB", "GB", "TB", "PB",
 				   "EB", "ZB", "YB", NULL};
-	const char *units_2[] = {"B", "KiB", "MiB", "GiB", "TiB", "PiB",
+	static const char *units_2[] = {"B", "KiB", "MiB", "GiB", "TiB", "PiB",
 				 "EiB", "ZiB", "YiB", NULL };
-	const char **units_str[] = {
+	static const char **units_str[] = {
 		[STRING_UNITS_10] =  units_10,
 		[STRING_UNITS_2] = units_2,
 	};
-	const unsigned int divisor[] = {
+	static const unsigned int divisor[] = {
 		[STRING_UNITS_10] = 1000,
 		[STRING_UNITS_2] = 1024,
 	};
_
Subject: Subject: lib/string_helpers.c: make arrays static

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
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad-fix.patch
vsprintf-correctly-handle-width-when-flag-used-in-%p-format-checkpatch-fixes.patch
vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch
leds-led-module-for-da9052-53-pmic-v2-fix.patch
leds-add-led-driver-for-lm3556-chip-checkpatch-fixes.patch
leds-ledtrig-timer-trigger_data-allocation-fix-fix.patch
lib-string_helpersc-make-arrays-static.patch
rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call.patch
proc-clean-up-proc-pid-environ-handling-checkpatch-fixes.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
c-r-ipc-selftest-tor-new-msg_peek_all-flag-for-msgrcv-checkpatch-fixes.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

