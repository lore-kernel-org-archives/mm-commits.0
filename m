From: akpm@linux-foundation.org
Subject: + eventfd-change-int-to-__u64-in-eventfd_signal-fix.patch added to -mm tree
Date: Wed, 18 Apr 2012 16:53:57 -0700
Message-ID: <20120418235358.0D397A01F8@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:52948 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741Ab2DRXyA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Apr 2012 19:54:00 -0400
Received: by eaaq10 with SMTP id q10so380807eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 18 Apr 2012 16:53:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, davidel@xmailserver.org, handai.szj@taobao.com


The patch titled
     Subject: eventfd-change-int-to-__u64-in-eventfd_signal-fix
has been added to the -mm tree.  Its filename is
     eventfd-change-int-to-__u64-in-eventfd_signal-fix.patch

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
Subject: eventfd-change-int-to-__u64-in-eventfd_signal-fix

update interface documentation

Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Sha Zhengju <handai.szj@taobao.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventfd.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/eventfd.c~eventfd-change-int-to-__u64-in-eventfd_signal-fix fs/eventfd.c
--- a/fs/eventfd.c~eventfd-change-int-to-__u64-in-eventfd_signal-fix
+++ a/fs/eventfd.c
@@ -46,10 +46,8 @@ struct eventfd_ctx {
  * value, and we signal this as overflow condition by returining a POLLERR
  * to poll(2).
  *
- * Returns @n in case of success, a non-negative number lower than @n in case
- * of overflow, or the following error codes:
- *
- * -EINVAL    : The value of @n is negative.
+ * Returns the amount by which the counter was incrememnted.  This will be less
+ * than @n if the counter has overflowed.
  */
 __u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n)
 {
_
Subject: Subject: eventfd-change-int-to-__u64-in-eventfd_signal-fix

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
memcg-add-mlock-statistic-in-memorystat-fix.patch
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

