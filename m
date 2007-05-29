From: akpm@linux-foundation.org
Subject: - drivers-scsi-ncr5380c-replacing-yield-with-a.patch removed from -mm tree
Date: Tue, 29 May 2007 11:55:06 -0700
Message-ID: <200705291855.l4TIt5ID008577@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:36838 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764753AbXE2Szs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:55:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amol@verismonetworks.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     drivers/scsi/NCR5380.c: Replacing yield() with a better alternative
has been removed from the -mm tree.  Its filename was
     drivers-scsi-ncr5380c-replacing-yield-with-a.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/scsi/NCR5380.c: Replacing yield() with a better alternative
From: Amol Lad <amol@verismonetworks.com>

Replaced yield() with cond_resched()

Signed-off-by: Amol Lad <amol@verismonetworks.com>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/NCR5380.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/NCR5380.c~drivers-scsi-ncr5380c-replacing-yield-with-a drivers/scsi/NCR5380.c
--- a/drivers/scsi/NCR5380.c~drivers-scsi-ncr5380c-replacing-yield-with-a
+++ a/drivers/scsi/NCR5380.c
@@ -347,7 +347,7 @@ static int NCR5380_poll_politely(struct 
 		if((r & bit) == val)
 			return 0;
 		if(!in_interrupt())
-			yield();
+			cond_resched();
 		else
 			cpu_relax();
 	}
_

Patches currently in -mm which might be from amol@verismonetworks.com are

git-scsi-misc.patch
