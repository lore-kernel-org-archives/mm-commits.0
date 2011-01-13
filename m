From: akpm@linux-foundation.org
Subject: [folded] fs-select-fix-information-leak-to-userspace-fix.patch removed from -mm tree
Date: Wed, 12 Jan 2011 16:22:31 -0800
Message-ID: <201101130022.p0D0MVig012306@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48916 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754892Ab1AMAWe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Jan 2011 19:22:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, segooon@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fs-select-fix-information-leak-to-userspace-fix
has been removed from the -mm tree.  Its filename was
     fs-select-fix-information-leak-to-userspace-fix.patch

This patch was dropped because it was folded into fs-select-fix-information-leak-to-userspace.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs-select-fix-information-leak-to-userspace-fix
From: Andrew Morton <akpm@linux-foundation.org>

avoid the memset on architectures which don't need it

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Vasiliy Kulikov <segooon@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/select.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/select.c~fs-select-fix-information-leak-to-userspace-fix fs/select.c
--- a/fs/select.c~fs-select-fix-information-leak-to-userspace-fix
+++ a/fs/select.c
@@ -306,7 +306,8 @@ static int poll_select_copy_remaining(st
 		rts.tv_sec = rts.tv_nsec = 0;
 
 	if (timeval) {
-		memset(&rtv, 0, sizeof(rtv));
+		if (sizeof(rtv) > sizeof(rtv.tv_sec) + sizeof(rtv.tv_usec))
+			memset(&rtv, 0, sizeof(rtv));
 		rtv.tv_sec = rts.tv_sec;
 		rtv.tv_usec = rts.tv_nsec / NSEC_PER_USEC;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
leds-add-output-inversion-option-to-backlight-trigger.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit.patch
include-linux-unaligned-packed_structh-use-__packed.patch
ihex-fix-unused-return-value-compiler-warning.patch
kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users.patch
fs-select-fix-information-leak-to-userspace.patch
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

