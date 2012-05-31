From: akpm@linux-foundation.org
Subject: [folded] syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix.patch removed from -mm tree
Date: Thu, 31 May 2012 16:20:27 -0700
Message-ID: <20120531232027.9747FA009B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:33366 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758622Ab2EaXU3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 19:20:29 -0400
Received: by wibhn6 with SMTP id hn6so2961wib.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 16:20:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gorcunov@openvz.org, hpa@zytor.com, mm-commits@vger.kernel.org


The patch titled
     Subject: syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix
has been removed from the -mm tree.  Its filename was
     syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix.patch

This patch was dropped because it was folded into syscalls-x86-add-__nr_kcmp-syscall-v8.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
isdn-add-missing-kern_cont.patch
kernel-irq-managec-use-the-pr_foo-infrastructure-to-prefix-printks.patch
vsprintf-correctly-handle-width-when-flag-used-in-%p-format.patch
vsprintf-further-optimize-decimal-conversion.patch
proc-clean-up-proc-pid-environ-handling.patch
kernel-cpuc-document-clear_tasks_mm_cpumask.patch
ipc-mqueue-improve-performance-of-send-recv.patch
ipc-mqueue-correct-mq_attr_ok-test.patch
ipc-mqueue-strengthen-checks-on-mqueue-creation.patch
tools-selftests-add-mq_perf_tests.patch
ipc-mqueue-add-rbtree-node-caching-support.patch
pidns-make-killed-children-autoreap.patch
fs-nls-add-apple-nls.patch
eventfd-change-int-to-__u64-in-eventfd_signal.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch

