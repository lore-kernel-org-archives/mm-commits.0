From: akpm@linux-foundation.org
Subject: [merged] mtd_dataflash-fix-probing-of-at45db321c-chips.patch removed from -mm tree
Date: Wed, 11 Mar 2009 11:09:38 -0700
Message-ID: <200903111809.n2BI9c7C019963@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41688 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753878AbZCKSOP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Mar 2009 14:14:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: will.newton@gmail.com, dbrownell@users.sourceforge.net, dwmw2@infradead.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mtd_dataflash: fix probing of AT45DB321C chips.
has been removed from the -mm tree.  Its filename was
     mtd_dataflash-fix-probing-of-at45db321c-chips.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd_dataflash: fix probing of AT45DB321C chips.
From: Will Newton <will.newton@gmail.com>

Commit 771999b65f79264acde4b855e5d35696eca5e80c ("[MTD] DataFlash: bugfix,
binary page sizes now handled") broke support for probing AT45DB321C flash
chips.  These chips do not support the "page size" status bit, so if we
match the JEDEC id return early.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Will Newton <will.newton@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/devices/mtd_dataflash.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/mtd/devices/mtd_dataflash.c~mtd_dataflash-fix-probing-of-at45db321c-chips drivers/mtd/devices/mtd_dataflash.c
--- a/drivers/mtd/devices/mtd_dataflash.c~mtd_dataflash-fix-probing-of-at45db321c-chips
+++ a/drivers/mtd/devices/mtd_dataflash.c
@@ -821,7 +821,8 @@ static struct flash_info *__devinit jede
 					if (!(info->flags & IS_POW2PS))
 						return info;
 				}
-			}
+			} else
+				return info;
 		}
 	}
 
_

Patches currently in -mm which might be from will.newton@gmail.com are

origin.patch

