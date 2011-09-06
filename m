From: akpm@linux-foundation.org
Subject: + rapidio-fix-potential-null-deref-in-rio_setup_device.patch added to -mm tree
Date: Tue, 06 Sep 2011 12:33:10 -0700
Message-ID: <201109061933.p86JXAGN024073@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55349 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754656Ab1IFTd3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Sep 2011 15:33:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexandre.bounine@idt.com, chul.kim@idt.com, error27@gmail.com, galak@kernel.crashing.org, mporter@kernel.crashing.org


The patch titled
     RapidIO: fix potential null deref in rio_setup_device()
has been added to the -mm tree.  Its filename is
     rapidio-fix-potential-null-deref-in-rio_setup_device.patch

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
Subject: RapidIO: fix potential null deref in rio_setup_device()
From: Alexandre Bounine <alexandre.bounine@idt.com>

The "goto cleanup" path can deference "rswitch" when it is NULL.

Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Chul Kim <chul.kim@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-scan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rapidio/rio-scan.c~rapidio-fix-potential-null-deref-in-rio_setup_device drivers/rapidio/rio-scan.c
--- a/drivers/rapidio/rio-scan.c~rapidio-fix-potential-null-deref-in-rio_setup_device
+++ a/drivers/rapidio/rio-scan.c
@@ -516,7 +516,7 @@ static struct rio_dev __devinit *rio_set
 	return rdev;
 
 cleanup:
-	if (rio_is_switch(rdev))
+	if (rswitch)
 		kfree(rswitch->route_table);
 
 	kfree(rdev);
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

drivers-rapidio-rio-scanc-use-discovered-bit-to-test-if-enumeration-is-complete.patch
arch-powerpc-sysdev-fsl_rioc-release-rapidio-port-i-o-region-resource-if-port-failed-to-initialize.patch
rapidio-add-mport-driver-for-tsi721-bridge.patch
rapidio-add-mport-driver-for-tsi721-bridge-update.patch
rapidio-fix-potential-null-deref-in-rio_setup_device.patch
rapidio-rionet-fix-ethernet-address-macros-for-le-platforms.patch

