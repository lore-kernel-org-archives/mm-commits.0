From: akpm@linux-foundation.org
Subject: - intel_rng-make-device-not-found-a-warning.patch removed from -mm tree
Date: Sun, 15 Jun 2008 23:03:47 -0700
Message-ID: <200806160603.m5G63lJv010623@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42626 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751525AbYFPGEC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jun 2008 02:04:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shemminger@vyatta.com, jbeulich@novell.com, mb@bu3sch.de, mm-commits@vger.kernel.org


The patch titled
     intel_rng: make device not found a warning
has been removed from the -mm tree.  Its filename was
     intel_rng-make-device-not-found-a-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: intel_rng: make device not found a warning
From: Stephen Hemminger <shemminger@vyatta.com>

Since many distros load this driver by default (throw it against the wall
and see what sticks method).  Change the error message severity level to
avoid alarming users.  Isn't it annoying when users actually read the
error logs...

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Cc: Michael Buesch <mb@bu3sch.de>
Acked-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hw_random/intel-rng.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/hw_random/intel-rng.c~intel_rng-make-device-not-found-a-warning drivers/char/hw_random/intel-rng.c
--- a/drivers/char/hw_random/intel-rng.c~intel_rng-make-device-not-found-a-warning
+++ a/drivers/char/hw_random/intel-rng.c
@@ -273,7 +273,7 @@ static int __init intel_rng_hw_init(void
 	if (mfc != INTEL_FWH_MANUFACTURER_CODE ||
 	    (dvc != INTEL_FWH_DEVICE_CODE_8M &&
 	     dvc != INTEL_FWH_DEVICE_CODE_4M)) {
-		printk(KERN_ERR PFX "FWH not detected\n");
+		printk(KERN_NOTICE PFX "FWH not detected\n");
 		return -ENODEV;
 	}
 
_

Patches currently in -mm which might be from shemminger@vyatta.com are

origin.patch
linux-next.patch
sysctl-allow-override-of-proc-sys-net-with-cap_net_admin.patch

