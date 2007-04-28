From: akpm@linux-foundation.org
Subject: - use-stop_machine_run-in-the-intel-rng-driver-fix.patch removed from -mm tree
Date: Sat, 28 Apr 2007 00:17:11 -0700
Message-ID: <200704280717.l3S7HBMN017046@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45102 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161478AbXD1HRx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 03:17:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haruo.tomita@toshiba.co.jp, jbeulich@novell.com, prarit@redhat.com, mm-commits@vger.kernel.org


The patch titled
     use-stop_machine_run-in-the-intel-rng-driver fix
has been removed from the -mm tree.  Its filename was
     use-stop_machine_run-in-the-intel-rng-driver-fix.patch

This patch was dropped because it was folded into use-stop_machine_run-in-the-intel-rng-driver.patch

------------------------------------------------------
Subject: use-stop_machine_run-in-the-intel-rng-driver fix
From: "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>

This patch fixes a typo in mod_init().  fwh_done is performed when Intel fwh
is found.

Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hw_random/intel-rng.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/char/hw_random/intel-rng.c~use-stop_machine_run-in-the-intel-rng-driver-fix drivers/char/hw_random/intel-rng.c
--- a/drivers/char/hw_random/intel-rng.c~use-stop_machine_run-in-the-intel-rng-driver-fix
+++ a/drivers/char/hw_random/intel-rng.c
@@ -365,7 +365,8 @@ static int __init mod_init(void)
 	pci_dev_put(dev);
 	iounmap(intel_rng_hw->mem);
 	kfree(intel_rng_hw);
-	goto out;
+	if (err)
+		goto out;
 
 fwh_done:
 	err = -ENOMEM;
_

Patches currently in -mm which might be from haruo.tomita@toshiba.co.jp are

use-stop_machine_run-in-the-intel-rng-driver.patch
use-stop_machine_run-in-the-intel-rng-driver-fix.patch
use-stop_machine_run-in-the-intel-rng-driver-fix-the-memory-leak-intel-rng-driver.patch
