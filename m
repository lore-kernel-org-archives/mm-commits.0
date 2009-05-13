From: akpm@linux-foundation.org
Subject: + davinci_nand-cmdlinepart-uses-mtd-ids.patch added to -mm tree
Date: Wed, 13 May 2009 11:46:04 -0700
Message-ID: <200905131846.n4DIk4Dq028262@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39848 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755735AbZEMStP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 May 2009 14:49:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, dwmw2@infradead.org, nsnehaprabha@ti.com


The patch titled
     davinci_nand: cmdlinepart uses MTD IDs
has been added to the -mm tree.  Its filename is
     davinci_nand-cmdlinepart-uses-mtd-ids.patch

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
Subject: davinci_nand: cmdlinepart uses MTD IDs
From: David Brownell <dbrownell@users.sourceforge.net>

Remove some legacy code from the davinci_nand driver, which made
cmdlinepart ignore the the MTD ID passed to it.  Boards can have multiple
NAND chips, and some do (like the DM357 EVM), so this dated hack is
undesirable.

Correct labels a"re like davinci_nand.0" (for chipselect 0).

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Snehaprabha Narnakaje <nsnehaprabha@ti.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/davinci_nand.c |   11 -----------
 1 file changed, 11 deletions(-)

diff -puN drivers/mtd/nand/davinci_nand.c~davinci_nand-cmdlinepart-uses-mtd-ids drivers/mtd/nand/davinci_nand.c
--- a/drivers/mtd/nand/davinci_nand.c~davinci_nand-cmdlinepart-uses-mtd-ids
+++ a/drivers/mtd/nand/davinci_nand.c
@@ -717,19 +717,8 @@ syndrome_done:
 			static const char *probes[] __initconst =
 				{ "cmdlinepart", NULL };
 
-			const char		*master_name;
-
-			/* Set info->mtd.name = 0 temporarily */
-			master_name		= info->mtd.name;
-			info->mtd.name		= (char *)0;
-
-			/* info->mtd.name == 0, means: don't bother checking
-			   <mtd-id> */
 			mtd_parts_nb = parse_mtd_partitions(&info->mtd, probes,
 							    &mtd_parts, 0);
