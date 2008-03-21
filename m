From: akpm@linux-foundation.org
Subject: + mtd-memory-corruption-in-block2mtdc.patch added to -mm tree
Date: Thu, 20 Mar 2008 21:53:04 -0700
Message-ID: <200803210453.m2L4r4Fh008201@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51422 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753242AbYCUExm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 00:53:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: inguin@gmx.de, akpm@linux-foundation.org, dwmw2@infradead.org, joern@lazybastard.org, stable@kernel.org


The patch titled
     mtd: memory corruption in block2mtd.c
has been added to the -mm tree.  Its filename is
     mtd-memory-corruption-in-block2mtdc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

mtd-memory-corruption-in-block2mtdc.patch
usb-gadget-dummy_hcdc-fix-nested-switch-statements.patch

