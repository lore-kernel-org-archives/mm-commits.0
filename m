From: akpm@linux-foundation.org
Subject: + cciss-cleanup-bitops-usage.patch added to -mm tree
Date: Tue, 14 Aug 2012 15:49:31 -0700
Message-ID: <20120814224931.BE2661E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:51083 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab2HNWtd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Aug 2012 18:49:33 -0400
Received: by obbwc20 with SMTP id wc20so719791obb.1
        for <mm-commits@vger.kernel.org>; Tue, 14 Aug 2012 15:49:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, axboe@kernel.dk, mike.miller@hp.com, scameron@beardog.cce.hp.com


The patch titled
     Subject: cciss: cleanup bitops usage
has been added to the -mm tree.  Its filename is
     cciss-cleanup-bitops-usage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: cciss: cleanup bitops usage

- Remove unnecessary correction of bit and address
- Use BITS_TO_LONGS macro to calculate bitmap size
- Use bitmap_zero()

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Mike Miller <mike.miller@hp.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff -puN drivers/block/cciss.c~cciss-cleanup-bitops-usage drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-cleanup-bitops-usage
+++ a/drivers/block/cciss.c
@@ -41,6 +41,7 @@
 #include <linux/spinlock.h>
 #include <linux/compat.h>
 #include <linux/mutex.h>
+#include <linux/bitmap.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
@@ -978,8 +979,7 @@ static CommandList_struct *cmd_alloc(ctl
 		i = find_first_zero_bit(h->cmd_pool_bits, h->nr_cmds);
 		if (i == h->nr_cmds)
 			return NULL;
-	} while (test_and_set_bit(i & (BITS_PER_LONG - 1),
-		  h->cmd_pool_bits + (i / BITS_PER_LONG)) != 0);
+	} while (test_and_set_bit(i, h->cmd_pool_bits) != 0);
 	c = h->cmd_pool + i;
 	memset(c, 0, sizeof(CommandList_struct));
 	cmd_dma_handle = h->cmd_pool_dhandle + i * sizeof(CommandList_struct);
@@ -1046,8 +1046,7 @@ static void cmd_free(ctlr_info_t *h, Com
 	int i;
 
 	i = c - h->cmd_pool;
-	clear_bit(i & (BITS_PER_LONG - 1),
-		  h->cmd_pool_bits + (i / BITS_PER_LONG));
+	clear_bit(i, h->cmd_pool_bits);
 	h->nr_frees++;
 }
 
@@ -4812,8 +4811,7 @@ static __devinit int cciss_init_reset_de
 
 static __devinit int cciss_allocate_cmd_pool(ctlr_info_t *h)
 {
-	h->cmd_pool_bits = kmalloc(
-		DIV_ROUND_UP(h->nr_cmds, BITS_PER_LONG) *
+	h->cmd_pool_bits = kmalloc(BITS_TO_LONGS(h->nr_cmds) *
 		sizeof(unsigned long), GFP_KERNEL);
 	h->cmd_pool = pci_alloc_consistent(h->pdev,
 		h->nr_cmds * sizeof(CommandList_struct),
@@ -5068,9 +5066,7 @@ reinit_after_soft_reset:
 	pci_set_drvdata(pdev, h);
 	/* command and error info recs zeroed out before
 	   they are used */
-	memset(h->cmd_pool_bits, 0,
-	       DIV_ROUND_UP(h->nr_cmds, BITS_PER_LONG)
-			* sizeof(unsigned long));
+	bitmap_zero(h->cmd_pool_bits, h->nr_cmds);
 
 	h->num_luns = 0;
 	h->highest_lun = -1;
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
ocfs2-use-find_last_bit.patch
ocfs2-use-bitmap_weight.patch
cciss-cleanup-bitops-usage.patch
cciss-use-check_signature.patch

