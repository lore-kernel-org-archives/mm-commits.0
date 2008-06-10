From: akpm@linux-foundation.org
Subject: + intel_rng-make-device-not-found-a-warning.patch added to -mm tree
Date: Tue, 10 Jun 2008 14:50:07 -0700
Message-ID: <200806102150.m5ALo78g031218@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50446 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754172AbYFJVuU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Jun 2008 17:50:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shemminger@vyatta.com, jbeulich@novell.com, mb@bu3sch.de


The patch titled
     intel_rng: make device not found a warning
has been added to the -mm tree.  Its filename is
     intel_rng-make-device-not-found-a-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: Jan Beulich <jbeulich@novell.com>
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

linux-next.patch
intel_rng-make-device-not-found-a-warning.patch
sysctl-allow-override-of-proc-sys-net-with-cap_net_admin.patch

