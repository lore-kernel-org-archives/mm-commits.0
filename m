From: akpm@linux-foundation.org
Subject: [folded] include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit-fix.patch removed from -mm tree
Date: Wed, 12 Jan 2011 16:18:10 -0800
Message-ID: <201101130018.p0D0IBKO012079@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42788 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756294Ab1AMASf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Jan 2011 19:18:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, eike-kernel@sf-tec.de, geert@linux-m68k.org, michalj@gmail.com, mm-commits@vger.kernel.org


The patch titled
     include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit-fix
has been removed from the -mm tree.  Its filename was
     include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit-fix.patch

This patch was dropped because it was folded into include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Michal Januszewski <michalj@gmail.com>
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN include/linux/kernel.h~include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit-fix include/linux/kernel.h
--- a/include/linux/kernel.h~include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit-fix
+++ a/include/linux/kernel.h
@@ -143,6 +143,12 @@ extern int _cond_resched(void);
 
 #define might_sleep_if(cond) do { if (cond) might_sleep(); } while (0)
 
+/*
+ * abs() handles unsigned and signed longs, ints, shorts and chars.  For all
+ * input types abs() returns a signed long.
+ * abs() should not be used for 64-bit types (s64, u64, long long) - use abs64()
+ * for those.
+ */
 #define abs(x) ({						\
 		long ret;					\
 		if (sizeof(x) == sizeof(long)) {		\
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
leds-add-output-inversion-option-to-backlight-trigger.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit.patch
include-linux-unaligned-packed_structh-use-__packed.patch
ihex-fix-unused-return-value-compiler-warning-fix.patch
kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users.patch
kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users-fix.patch
kptr_restrict-for-hiding-kernel-pointers-v7-fix.patch
fs-select-fix-information-leak-to-userspace-fix.patch
gpio-ml_ioh_gpio-ml7213-gpio-driver-fix.patch
drivers-telephony-ixjc-fix-warning.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes.patch
sysctl-remove-obsolete-comments-fix.patch
user_ns-improve-the-user_ns-on-the-slab-packaging-fix.patch
pps-add-parallel-port-pps-signal-generator-fix.patch
memstick-factor-out-transfer-initiating-functionality-in-mspro_blockc-fix.patch
scatterlist-new-helper-functions-fix.patch
aio-remove-unused-aio_run_iocbs-checkpatch-fixes.patch
cramfs-generate-unique-inode-number-for-better-inode-cache-usage-fix.patch
cramfs-generate-unique-inode-number-for-better-inode-cache-usage-checkpatch-fixes.patch
ramoops-fix-types-remove-typecasts.patch
fs-ext4-inodec-use-pr_warn_ratelimited.patch

