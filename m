From: akpm@linux-foundation.org
Subject: + use-stop_machine_run-in-the-intel-rng-driver-fix-the-memory-leak-intel-rng-driver.patch added to -mm tree
Date: Sat, 28 Apr 2007 00:16:18 -0700
Message-ID: <200704280716.l3S7GIcK017021@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49997 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161468AbXD1HRF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 03:17:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haruo.tomita@toshiba.co.jp, jbeulich@novell.com, prarit@redhat.com


The patch titled
     Fix the memory leak Intel RNG driver
has been added to the -mm tree.  Its filename is
     use-stop_machine_run-in-the-intel-rng-driver-fix-the-memory-leak-intel-rng-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix the memory leak Intel RNG driver
From: "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>

This patch fixes a memory leak in mod_init().
In the error, intel_rng_hw was freed.

Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hw_random/intel-rng.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/char/hw_random/intel-rng.c~use-stop_machine_run-in-the-intel-rng-driver-fix-the-memory-leak-intel-rng-driver drivers/char/hw_random/intel-rng.c
--- a/drivers/char/hw_random/intel-rng.c~use-stop_machine_run-in-the-intel-rng-driver-fix-the-memory-leak-intel-rng-driver
+++ a/drivers/char/hw_random/intel-rng.c
@@ -345,11 +345,11 @@ static int __init mod_init(void)
 	}
 
 	err = intel_init_hw_struct(intel_rng_hw, dev);
-	if (err == -ENODEV) {
-		pci_dev_put(dev);
-		goto fwh_done;
-	} else if (err < 0) {
+	if (err) {
 		pci_dev_put(dev);
+		kfree(intel_rng_hw);
+		if (err == -ENODEV)
+			goto fwh_done;
 		goto out;
 	}
 
_

Patches currently in -mm which might be from haruo.tomita@toshiba.co.jp are

use-stop_machine_run-in-the-intel-rng-driver-fix.patch
use-stop_machine_run-in-the-intel-rng-driver-fix-the-memory-leak-intel-rng-driver.patch
