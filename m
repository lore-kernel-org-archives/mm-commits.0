From: akpm@linux-foundation.org
Subject: + syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix.patch added to -mm tree
Date: Wed, 11 Apr 2012 16:32:29 -0700
Message-ID: <20120411233229.CD8F9A03B2@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:35624 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965075Ab2DKXcc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Apr 2012 19:32:32 -0400
Received: by wibhj13 with SMTP id hj13so68922wib.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Apr 2012 16:32:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, gorcunov@openvz.org, hpa@zytor.com


The patch titled
     Subject: syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix
has been added to the -mm tree.  Its filename is
     syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix.patch

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
Subject: syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix

tweak comment text

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcmp.c |   24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff -puN kernel/kcmp.c~syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix kernel/kcmp.c
--- a/kernel/kcmp.c~syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix
+++ a/kernel/kcmp.c
@@ -14,21 +14,19 @@
 #include <asm/unistd.h>
 
 /*
- * We don't expose real in-memory order of objects for security
- * reasons, still the comparison results should be suitable for
- * sorting. Thus, we obfuscate kernel pointers values and compare
- * the production instead.
+ * We don't expose the real in-memory order of objects for security reasons.
+ * But still the comparison results should be suitable for sorting. So we
+ * obfuscate kernel pointers values and compare the production instead.
  *
- * The obfuscation is done in two steps. First -- we use xor on
- * kernel pointer with random value, which puts pointer into
- * a new position in reordered space. Second -- we multiply
- * the xor production with big odd random number to permute
- * bits even more (the odd multiplier guarantees that the product
- * is unique ever after the high bits are truncated, since any odd
- * number is relative prime to 2^n).
+ * The obfuscation is done in two steps. First we xor the kernel pointer with
+ * a random value, which puts pointer into a new position in a reordered space.
+ * Secondly we multiply the xor production with a large odd random number to
+ * permute its bits even more (the odd multiplier guarantees that the product
+ * is unique ever after the high bits are truncated, since any odd number is
+ * relative prime to 2^n).
  *
- * Note also the obfuscation itself is invisible to user-space
- * and if needed it can be changed to any suitable scheme.
+ * Note also that the obfuscation itself is invisible to userspace and if needed
+ * it can be changed to an alternate scheme.
  */
 static unsigned long cookies[KCMP_TYPES][2] __read_mostly;
 
_
Subject: Subject: syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
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
leds-led-module-for-da9052-53-pmic-v2-fix.patch
leds-add-led-driver-for-lm3556-chip-checkpatch-fixes.patch
rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

