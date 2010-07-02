From: akpm@linux-foundation.org
Subject: + mtd-return-1-if-verify-failed.patch added to -mm tree
Date: Fri, 02 Jul 2010 16:11:52 -0700
Message-ID: <201007022311.o62NBqnG032075@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55443 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751704Ab0GBXMK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jul 2010 19:12:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, cbou@mail.ru, dwmw2@infradead.org


The patch titled
     mtd: return -1 if verify failed
has been added to the -mm tree.  Its filename is
     mtd-return-1-if-verify-failed.patch

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
Subject: mtd: return -1 if verify failed
From: Roel Kluin <roel.kluin@gmail.com>

It should return -1 if the verify failed.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Anton Vorontsov <cbou@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/tests/mtd_pagetest.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mtd/tests/mtd_pagetest.c~mtd-return-1-if-verify-failed drivers/mtd/tests/mtd_pagetest.c
--- a/drivers/mtd/tests/mtd_pagetest.c~mtd-return-1-if-verify-failed
+++ a/drivers/mtd/tests/mtd_pagetest.c
@@ -358,7 +358,7 @@ static int erasecrosstest(void)
 		printk(PRINT_PREF "verify failed!\n");
 		errcnt += 1;
 		ok = 0;
-		return err;
+		return -1;
 	}
 
 	printk(PRINT_PREF "erasing block %d\n", ebnum);
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
mtd-return-1-if-verify-failed.patch
score-fix-dereference-of-null-pointer-in-local_flush_tlb_page.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch
dc395x-decrease-iteration-for-tag_number-of-max_command-in-start_scsi.patch
scsi-bfa-correct-onstack-wait_queue_head-declaration.patch
bfa-wrong-fcport-h2i-message-tested-in-bfa_fcport_isr.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch

