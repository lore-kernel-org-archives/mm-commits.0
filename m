From: akpm@linux-foundation.org
Subject: + lib-bitmapc-fix-documentation-for-scnprintf-functions.patch added to -mm tree
Date: Fri, 20 Apr 2012 13:06:29 -0700
Message-ID: <20120420200629.3B467A0186@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:39530 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab2DTUGb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Apr 2012 16:06:31 -0400
Received: by faaa19 with SMTP id a19so54683faa.1
        for <mm-commits@vger.kernel.org>; Fri, 20 Apr 2012 13:06:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ozaki.ryota@gmail.com


The patch titled
     Subject: lib/bitmap.c: fix documentation for scnprintf() functions
has been added to the -mm tree.  Its filename is
     lib-bitmapc-fix-documentation-for-scnprintf-functions.patch

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
Subject: lib/bitmap.c: fix documentation for scnprintf() functions

The code comments for bscnl_emit() and bitmap_scnlistprintf() are
describing snprintf() return semantics, but these functions use
scnprintf() return semantics.  Fix that, and document the
bitmap_scnprintf() return value as well.

Cc: Ryota Ozaki <ozaki.ryota@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN lib/bitmap.c~lib-bitmapc-fix-documentation-for-scnprintf-functions lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmapc-fix-documentation-for-scnprintf-functions
+++ a/lib/bitmap.c
@@ -369,7 +369,8 @@ EXPORT_SYMBOL(bitmap_find_next_zero_area
  * @nmaskbits: size of bitmap, in bits
  *
  * Exactly @nmaskbits bits are displayed.  Hex digits are grouped into
- * comma-separated sets of eight digits per set.
+ * comma-separated sets of eight digits per set.  Returns the number of
+ * characters which were written to *buf, excluding the trailing \0.
  */
 int bitmap_scnprintf(char *buf, unsigned int buflen,
 	const unsigned long *maskp, int nmaskbits)
@@ -517,8 +518,8 @@ EXPORT_SYMBOL(bitmap_parse_user);
  *
  * Helper routine for bitmap_scnlistprintf().  Write decimal number
  * or range to buf, suppressing output past buf+buflen, with optional
- * comma-prefix.  Return len of what would be written to buf, if it
- * all fit.
+ * comma-prefix.  Return len of what was written to *buf, excluding the
+ * trailing \0.
  */
 static inline int bscnl_emit(char *buf, int buflen, int rbot, int rtop, int len)
 {
@@ -544,9 +545,8 @@ static inline int bscnl_emit(char *buf, 
  * the range.  Output format is compatible with the format
  * accepted as input by bitmap_parselist().
  *
- * The return value is the number of characters which would be
- * generated for the given input, excluding the trailing '\0', as
- * per ISO C99.
+ * The return value is the number of characters which were written to *buf
+ * excluding the trailing '\0', as per ISO C99's scnprintf.
  */
 int bitmap_scnlistprintf(char *buf, unsigned int buflen,
 	const unsigned long *maskp, int nmaskbits)
_
Subject: Subject: lib/bitmap.c: fix documentation for scnprintf() functions

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
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
lib-bitmapc-fix-documentation-for-scnprintf-functions.patch
rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call.patch
proc-clean-up-proc-pid-environ-handling-checkpatch-fixes.patch
eventfd-change-int-to-__u64-in-eventfd_signal-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
c-r-ipc-selftest-tor-new-msg_peek_all-flag-for-msgrcv-checkpatch-fixes.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

