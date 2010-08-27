From: akpm@linux-foundation.org
Subject: + mmc-use-snprintf-not-sprintf.patch added to -mm tree
Date: Fri, 27 Aug 2010 13:06:34 -0700
Message-ID: <201008272006.o7RK6YPN013308@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49778 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752040Ab0H0UHJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Aug 2010 16:07:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jiebing.li@intel.com, alan@linux.intel.com, cjb@laptop.org, linux-mmc@vger.kernel.org


The patch titled
     drivers/mmc/card/block.c: use snprintf not sprintf
has been added to the -mm tree.  Its filename is
     mmc-use-snprintf-not-sprintf.patch

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
Subject: drivers/mmc/card/block.c: use snprintf not sprintf
From: JiebingLi <jiebing.li@intel.com>

Fix an issue found by klockwork. Just paranoia.

Signed-off-by: JiebingLi <jiebing.li@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Chris Ball <cjb@laptop.org>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/card/block.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/mmc/card/block.c~mmc-use-snprintf-not-sprintf drivers/mmc/card/block.c
--- a/drivers/mmc/card/block.c~mmc-use-snprintf-not-sprintf
+++ a/drivers/mmc/card/block.c
@@ -620,7 +620,8 @@ static struct mmc_blk_data *mmc_blk_allo
 	 * messages to tell when the card is present.
 	 */
 
-	sprintf(md->disk->disk_name, "mmcblk%d", devidx);
+	snprintf(md->disk->disk_name, sizeof(md->disk->disk_name),
+		"mmcblk%d", devidx);
 
 	blk_queue_logical_block_size(md->queue.queue, 512);
 
_

Patches currently in -mm which might be from jiebing.li@intel.com are

mmc-use-snprintf-not-sprintf.patch

