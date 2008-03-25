From: akpm@linux-foundation.org
Subject: - mtd-memory-corruption-in-block2mtdc.patch removed from -mm tree
Date: Tue, 25 Mar 2008 15:29:28 -0700
Message-ID: <200803252229.m2PMTS42016812@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46018 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753987AbYCYWaw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Mar 2008 18:30:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: inguin@gmx.de, akpm@linux-foundation.org, dwmw2@infradead.org, joern@lazybastard.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mtd: memory corruption in block2mtd.c
has been removed from the -mm tree.  Its filename was
     mtd-memory-corruption-in-block2mtdc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd: memory corruption in block2mtd.c
From: Ingo van Lil <inguin@gmx.de>

The block2mtd driver (drivers/mtd/devices/block2mtd.c) will kfree an on-stack
pointer when handling an invalid argument line (e.g. 
block2mtd=/dev/loop0,xxx).

The kfree was added some time ago when "name" was dynamically allocated.

Signed-off-by: Ingo van Lil <inguin@gmx.de>
Acked-by: Joern Engel <joern@lazybastard.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: <stable@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/devices/block2mtd.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/mtd/devices/block2mtd.c~mtd-memory-corruption-in-block2mtdc drivers/mtd/devices/block2mtd.c
--- a/drivers/mtd/devices/block2mtd.c~mtd-memory-corruption-in-block2mtdc
+++ a/drivers/mtd/devices/block2mtd.c
@@ -408,7 +408,6 @@ static int block2mtd_setup2(const char *
 	if (token[1]) {
 		ret = parse_num(&erase_size, token[1]);
 		if (ret) {
-			kfree(name);
 			parse_err("illegal erase size");
 		}
 	}
_

Patches currently in -mm which might be from inguin@gmx.de are

origin.patch
usb-gadget-dummy_hcdc-fix-nested-switch-statements.patch

