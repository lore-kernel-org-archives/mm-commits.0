From: akpm@linux-foundation.org
Subject: [to-be-updated] ext4-dont-use-pr_warning_ratelimited.patch removed from -mm tree
Date: Wed, 12 Jan 2011 14:53:40 -0800
Message-ID: <201101122327.p0CNRHGX009852@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50796 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754698Ab1ALX1t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Jan 2011 18:27:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     ext4: don't use pr_warning_ratelimited()
has been removed from the -mm tree.  Its filename was
     ext4-dont-use-pr_warning_ratelimited.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext4: don't use pr_warning_ratelimited()
From: Andrew Morton <akpm@linux-foundation.org>

fs/ext4/inode.c: In function 'ext4_set_bh_endio':
fs/ext4/inode.c:3733: error: implicit declaration of function 'pr_warning_ratelimited'                                                                          

Don't use printk_ratelimit(), either.  It shares state with all other
printk_ratelimit() sites, which can lead to bogus message suppression.  

Fix it by using printk_ratelimited().

Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/ext4/inode.c~ext4-dont-use-pr_warning_ratelimited fs/ext4/inode.c
--- a/fs/ext4/inode.c~ext4-dont-use-pr_warning_ratelimited
+++ a/fs/ext4/inode.c
@@ -3730,7 +3730,8 @@ static int ext4_set_bh_endio(struct buff
 retry:
 	io_end = ext4_init_io_end(inode, GFP_ATOMIC);
 	if (!io_end) {
-		pr_warning_ratelimited("%s: allocation fail\n", __func__);
+		printk_ratelimited(KERN_WARNING "%s: allocation fail\n",
+				   __func__);
 		schedule();
 		goto retry;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
leds-add-output-inversion-option-to-backlight-trigger.patch
leds-add-output-inversion-option-to-backlight-trigger-fix.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit-fix.patch
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

