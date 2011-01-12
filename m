From: akpm@linux-foundation.org
Subject: + fs-ext4-inodec-use-pr_warn_ratelimited.patch added to -mm tree
Date: Wed, 12 Jan 2011 14:53:25 -0800
Message-ID: <201101122327.p0CNR2cW009841@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48216 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755462Ab1ALX1i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Jan 2011 18:27:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, tytso@mit.edu


The patch titled
     fs/ext4/inode.c: use pr_warn_ratelimited()
has been added to the -mm tree.  Its filename is
     fs-ext4-inodec-use-pr_warn_ratelimited.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/ext4/inode.c: use pr_warn_ratelimited()
From: Andrew Morton <akpm@linux-foundation.org>

pr_warning_ratelimited() doesn't exist.

Also include printk.h, which defines these things.

Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/ext4/inode.c~fs-ext4-inodec-use-pr_warn_ratelimited fs/ext4/inode.c
--- a/fs/ext4/inode.c~fs-ext4-inodec-use-pr_warn_ratelimited
+++ a/fs/ext4/inode.c
@@ -39,6 +39,7 @@
 #include <linux/bio.h>
 #include <linux/workqueue.h>
 #include <linux/kernel.h>
+#include <linux/printk.h>
 #include <linux/slab.h>
 #include <linux/ratelimit.h>
 
@@ -3737,7 +3738,7 @@ static int ext4_set_bh_endio(struct buff
 retry:
 	io_end = ext4_init_io_end(inode, GFP_ATOMIC);
 	if (!io_end) {
-		pr_warning_ratelimited("%s: allocation fail\n", __func__);
+		pr_warn_ratelimited("%s: allocation fail\n", __func__);
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

