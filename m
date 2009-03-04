From: akpm@linux-foundation.org
Subject: + mtd_dataflash-fix-probing-of-at45db321c-chips.patch added to -mm tree
Date: Wed, 04 Mar 2009 14:22:28 -0800
Message-ID: <200903042222.n24MMSvG009744@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56617 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753267AbZCDWX1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2009 17:23:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: will.newton@gmail.com, dbrownell@users.sourceforge.net, dwmw2@infradead.org, stable@kernel.org


The patch titled
     mtd_dataflash: fix probing of AT45DB321C chips.
has been added to the -mm tree.  Its filename is
     mtd_dataflash-fix-probing-of-at45db321c-chips.patch

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
Subject: mtd_dataflash: fix probing of AT45DB321C chips.
From: Will Newton <will.newton@gmail.com>

Commit 771999b65f79264acde4b855e5d35696eca5e80c ("[MTD] DataFlash: bugfix,
binary page sizes now handled") broke support for probing AT45DB321C flash
chips.  These chips do not support the "page size" status bit, so if we
match the JEDEC id return early.

Signed-off-by: Will Newton <will.newton@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/devices/mtd_dataflash.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/mtd/devices/mtd_dataflash.c~mtd_dataflash-fix-probing-of-at45db321c-chips drivers/mtd/devices/mtd_dataflash.c
--- a/drivers/mtd/devices/mtd_dataflash.c~mtd_dataflash-fix-probing-of-at45db321c-chips
+++ a/drivers/mtd/devices/mtd_dataflash.c
@@ -818,6 +818,8 @@ static struct flash_info *__devinit jede
 						return info;
 				}
 			}
+			else
+				return info;
 		}
 	}
 
_

Patches currently in -mm which might be from will.newton@gmail.com are

mtd_dataflash-fix-probing-of-at45db321c-chips.patch

