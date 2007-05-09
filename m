From: akpm@linux-foundation.org
Subject: - drivers-scsi-megaraidc-replacing-yield-with-a.patch removed from -mm tree
Date: Tue, 08 May 2007 20:03:55 -0700
Message-ID: <200705090303.l4933tXY010994@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45177 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031559AbXEIDED (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:04:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amol@verismonetworks.com, Sumant.Patro@lsi.com, mm-commits@vger.kernel.org


The patch titled
     drivers/scsi/megaraid.c: Replacing yield() with a better alternative
has been removed from the -mm tree.  Its filename was
     drivers-scsi-megaraidc-replacing-yield-with-a.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/scsi/megaraid.c: Replacing yield() with a better alternative
From: Amol Lad <amol@verismonetworks.com>

For this driver cond_resched() seems to be a better alternative

Signed-off-by: Amol Lad <amol@verismonetworks.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/megaraid.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/megaraid.c~drivers-scsi-megaraidc-replacing-yield-with-a drivers/scsi/megaraid.c
--- a/drivers/scsi/megaraid.c~drivers-scsi-megaraidc-replacing-yield-with-a
+++ a/drivers/scsi/megaraid.c
@@ -1754,7 +1754,8 @@ __mega_busywait_mbox (adapter_t *adapter
 	for (counter = 0; counter < 10000; counter++) {
 		if (!mbox->m_in.busy)
 			return 0;
-		udelay(100); yield();
+		udelay(100);
+		cond_resched();
 	}
 	return -1;		/* give up after 1 second */
 }
_

Patches currently in -mm which might be from amol@verismonetworks.com are

git-scsi-misc.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
