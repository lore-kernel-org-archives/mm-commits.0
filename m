From: akpm@linux-foundation.org
Subject: [folded] pps-add-parallel-port-pps-signal-generator-fix.patch removed from -mm tree
Date: Wed, 12 Jan 2011 16:27:22 -0800
Message-ID: <201101130027.p0D0RMGT012464@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32973 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755961Ab1AMA1h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Jan 2011 19:27:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, giometti@linux.it, johnstul@us.ibm.com, lasaine@lvk.cs.msu.su, mm-commits@vger.kernel.org


The patch titled
     pps-add-parallel-port-pps-signal-generator-fix
has been removed from the -mm tree.  Its filename was
     pps-add-parallel-port-pps-signal-generator-fix.patch

This patch was dropped because it was folded into pps-add-parallel-port-pps-signal-generator.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pps-add-parallel-port-pps-signal-generator-fix
From: Andrew Morton <akpm@linux-foundation.org>

drivers/pps/generators/pps_gen_parport.c: In function 'hrtimer_event':
drivers/pps/generators/pps_gen_parport.c:92: error: 'struct hrtimer' has no member named '_expires'

Cc: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: Rodolfo Giometti <giometti@linux.it>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/generators/pps_gen_parport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pps/generators/pps_gen_parport.c~pps-add-parallel-port-pps-signal-generator-fix drivers/pps/generators/pps_gen_parport.c
--- a/drivers/pps/generators/pps_gen_parport.c~pps-add-parallel-port-pps-signal-generator-fix
+++ a/drivers/pps/generators/pps_gen_parport.c
@@ -82,7 +82,7 @@ static enum hrtimer_restart hrtimer_even
 
 	/* first of all we get the time stamp... */
 	getnstimeofday(&ts1);
-	expire_time = ktime_to_timespec(timer->_expires);
+	expire_time = ktime_to_timespec(hrtimer_get_softexpires(timer));
 	dev = container_of(timer, struct pps_generator_pp, timer);
 	lim = NSEC_PER_SEC - send_delay - dev->port_write_time;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
leds-add-output-inversion-option-to-backlight-trigger.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit.patch
include-linux-unaligned-packed_structh-use-__packed.patch
ihex-fix-unused-return-value-compiler-warning.patch
kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users.patch
fs-select-fix-information-leak-to-userspace.patch
drivers-telephony-ixjc-fix-warning.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps.patch
sysctl-remove-obsolete-comments.patch
user_ns-improve-the-user_ns-on-the-slab-packaging.patch
pps-add-parallel-port-pps-signal-generator.patch
memstick-factor-out-transfer-initiating-functionality-in-mspro_blockc-fix.patch
scatterlist-new-helper-functions-fix.patch
aio-remove-unused-aio_run_iocbs-checkpatch-fixes.patch
cramfs-generate-unique-inode-number-for-better-inode-cache-usage-fix.patch
cramfs-generate-unique-inode-number-for-better-inode-cache-usage-checkpatch-fixes.patch
ramoops-fix-types-remove-typecasts.patch
fs-ext4-inodec-use-pr_warn_ratelimited.patch

