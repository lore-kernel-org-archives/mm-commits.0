From: akpm@linux-foundation.org
Subject: - mtd-fix-broken-state-in-cfi-driver-caused-by-fl_shutdown.patch removed from -mm tree
Date: Mon, 07 Apr 2008 13:01:48 -0700
Message-ID: <200804072001.m37K1m2l022774@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44591 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753072AbYDGUCX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2008 16:02:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akorolev@infradead.org, dwmw2@infradead.org, joern@logfs.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mtd: fix broken state in CFI driver caused by FL_SHUTDOWN
has been removed from the -mm tree.  Its filename was
     mtd-fix-broken-state-in-cfi-driver-caused-by-fl_shutdown.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd: fix broken state in CFI driver caused by FL_SHUTDOWN
From: Alexey Korolev <akorolev@infradead.org>

THe CFI driver in 2.6.24 kernel is broken.  Not so intensive read/write
operations cause incomplete writes which lead to kernel panics in JFFS2.

We investigated the issue - it is caused by bug in FL_SHUTDOWN parsing code. 
Sometimes chip returns -EIO as if it is in FL_SHUTDOWN state when it should
wait in FL_PONT (error in order of conditions).

The following patch fixes the bug in state parsing code of CFI.  Also I've
added comments to notify developers if they want to add new case in future. 

Signed-off-by: Alexey Korolev <akorolev@infradead.org>
Reviewed-by: Joern Engel <joern@logfs.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/chips/cfi_cmdset_0001.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/mtd/chips/cfi_cmdset_0001.c~mtd-fix-broken-state-in-cfi-driver-caused-by-fl_shutdown drivers/mtd/chips/cfi_cmdset_0001.c
--- a/drivers/mtd/chips/cfi_cmdset_0001.c~mtd-fix-broken-state-in-cfi-driver-caused-by-fl_shutdown
+++ a/drivers/mtd/chips/cfi_cmdset_0001.c
@@ -718,7 +718,7 @@ static int chip_ready (struct map_info *
 			/* Someone else might have been playing with it. */
 			return -EAGAIN;
 		}
-
+		/* Fall through */
 	case FL_READY:
 	case FL_CFI_QUERY:
 	case FL_JEDEC_QUERY:
@@ -778,14 +778,14 @@ static int chip_ready (struct map_info *
 		chip->state = FL_READY;
 		return 0;
 
+	case FL_SHUTDOWN:
+		/* The machine is rebooting now,so no one can get chip anymore */
+		return -EIO;
 	case FL_POINT:
 		/* Only if there's no operation suspended... */
 		if (mode == FL_READY && chip->oldstate == FL_READY)
 			return 0;
