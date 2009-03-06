From: akpm@linux-foundation.org
Subject: + mtd-cfi-fix-bug-bonnie-error-on-bf548-nor-flash.patch added to -mm tree
Date: Fri, 06 Mar 2009 14:09:09 -0800
Message-ID: <200903062209.n26M99ex004523@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59240 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754182AbZCFWKo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Mar 2009 17:10:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: graf.yang@analog.com, cooloney@kernel.org, dwmw2@infradead.org


The patch titled
     mtd: CFI: fix bug - bonnie++ error on BF548 NOR flash
has been added to the -mm tree.  Its filename is
     mtd-cfi-fix-bug-bonnie-error-on-bf548-nor-flash.patch

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

linux-next.patch
mtd-cfi-fix-bug-bonnie-error-on-bf548-nor-flash.patch

