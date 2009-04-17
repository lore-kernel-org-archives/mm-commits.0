From: akpm@linux-foundation.org
Subject: [merged] pata_legacy-fix-no-device-fail-path.patch removed from -mm tree
Date: Fri, 17 Apr 2009 11:14:25 -0700
Message-ID: <200904171814.n3HIEPHL019164@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34005 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760419AbZDQSU0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Apr 2009 14:20:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: htejun@gmail.com, alan@lxorguk.ukuu.org.uk, jeff@garzik.org, peterz@infradead.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     pata_legacy: fix no device fail path
has been removed from the -mm tree.  Its filename was
     pata_legacy-fix-no-device-fail-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

