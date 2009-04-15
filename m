From: akpm@linux-foundation.org
Subject: + pata_legacy-fix-no-device-fail-path.patch added to -mm tree
Date: Wed, 15 Apr 2009 16:45:17 -0700
Message-ID: <200904152345.n3FNjHZK012413@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49915 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752581AbZDOXvi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Apr 2009 19:51:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: htejun@gmail.com, alan@lxorguk.ukuu.org.uk, jeff@garzik.org, peterz@infradead.org, tj@kernel.org


The patch titled
     pata_legacy: fix no device fail path
has been added to the -mm tree.  Its filename is
     pata_legacy-fix-no-device-fail-path.patch

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
Subject: pata_legacy: fix no device fail path
From: Tejun Heo <htejun@gmail.com>

When pata_legacy can't detect any device, it unregisters the
platform_device and fails detection.  However, it forgets to detach ata
host triggering weird failures as the host later gets freed by devres
while still attached.  Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Peter Zijlstra <peterz@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_legacy.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/ata/pata_legacy.c~pata_legacy-fix-no-device-fail-path drivers/ata/pata_legacy.c
--- a/drivers/ata/pata_legacy.c~pata_legacy-fix-no-device-fail-path
+++ a/drivers/ata/pata_legacy.c
@@ -1032,6 +1032,7 @@ static __init int legacy_init_one(struct
 			return 0;
 		}
 	}
+	ata_host_detach(host);
 fail:
 	platform_device_unregister(pdev);
 	return ret;
_

Patches currently in -mm which might be from htejun@gmail.com are

linux-next.patch
pata_legacy-fix-no-device-fail-path.patch

