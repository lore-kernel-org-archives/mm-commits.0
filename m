From: akpm@linux-foundation.org
Subject: [folded] ihex-fix-unused-return-value-compiler-warning-fix.patch removed from -mm tree
Date: Wed, 12 Jan 2011 16:19:24 -0800
Message-ID: <201101130019.p0D0JOvP012103@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40494 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754892Ab1AMATa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Jan 2011 19:19:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, broonie@opensource.wolfsonmicro.com, cmruffin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ihex-fix-unused-return-value-compiler-warning-fix
has been removed from the -mm tree.  Its filename was
     ihex-fix-unused-return-value-compiler-warning-fix.patch

This patch was dropped because it was folded into ihex-fix-unused-return-value-compiler-warning.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ihex-fix-unused-return-value-compiler-warning-fix
From: Andrew Morton <akpm@linux-foundation.org>

correctly handle short writes

Cc: Chris Ruffin <cmruffin@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 firmware/ihex2fw.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN firmware/ihex2fw.c~ihex-fix-unused-return-value-compiler-warning-fix firmware/ihex2fw.c
--- a/firmware/ihex2fw.c~ihex-fix-unused-return-value-compiler-warning-fix
+++ a/firmware/ihex2fw.c
@@ -269,12 +269,12 @@ static int output_records(int outfd)
 		p->addr = htonl(p->addr);
 		p->len = htons(p->len);
 		if (write(outfd, &p->addr, writelen) != writelen)
-			return errno;
+			return 1;
 		p = p->next;
 	}
 	/* EOF record is zero length, since we don't bother to represent
 	   the type field in the binary version */
 	if (write(outfd, zeroes, 6) != 6)
-		return errno;
+		return 1;
 	return 0;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
leds-add-output-inversion-option-to-backlight-trigger.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit.patch
include-linux-unaligned-packed_structh-use-__packed.patch
ihex-fix-unused-return-value-compiler-warning.patch
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

