From: akpm@linux-foundation.org
Subject: [merged] mtd-cfi-fix-bug-bonnie-error-on-bf548-nor-flash.patch removed from -mm tree
Date: Mon, 30 Mar 2009 12:06:13 -0700
Message-ID: <200903301906.n2UJ6DpT019009@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36762 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755864AbZC3TLA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 15:11:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: graf.yang@analog.com, cooloney@kernel.org, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     mtd: CFI: fix bug - bonnie++ error on BF548 NOR flash
has been removed from the -mm tree.  Its filename was
     mtd-cfi-fix-bug-bonnie-error-on-bf548-nor-flash.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd: CFI: fix bug - bonnie++ error on BF548 NOR flash
From: Graf Yang <graf.yang@analog.com>

The function inval_cache_and_wait_for_operation() is called both
by write and erase operation. If erase call it and stayed there, then write
call it and male-cleared chip->erase_suspended, the time out error may arise.

Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/chips/cfi_cmdset_0001.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/mtd/chips/cfi_cmdset_0001.c~mtd-cfi-fix-bug-bonnie-error-on-bf548-nor-flash drivers/mtd/chips/cfi_cmdset_0001.c
--- a/drivers/mtd/chips/cfi_cmdset_0001.c~mtd-cfi-fix-bug-bonnie-error-on-bf548-nor-flash
+++ a/drivers/mtd/chips/cfi_cmdset_0001.c
@@ -1236,10 +1236,14 @@ static int inval_cache_and_wait_for_oper
 			remove_wait_queue(&chip->wq, &wait);
 			spin_lock(chip->mutex);
 		}
-		if (chip->erase_suspended || chip->write_suspended)  {
-			/* Suspend has occured while sleep: reset timeout */
+		if (chip->erase_suspended && chip_state == FL_ERASING)  {
+			/* Erase suspend has occured while sleep: reset timeout */
 			timeo = reset_timeo;
 			chip->erase_suspended = 0;
+		}
+		if (chip->write_suspended && chip_state == FL_WRITING)  {
+			/* Write suspend has occured while sleep: reset timeout */
+			timeo = reset_timeo;
 			chip->write_suspended = 0;
 		}
 	}
_

Patches currently in -mm which might be from graf.yang@analog.com are

origin.patch
linux-next.patch
blackfin-serial-driver-add-a-debug-function-to-serial-driver.patch

