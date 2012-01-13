From: akpm@linux-foundation.org
Subject: + mtd-use-for_each_clear_bit.patch added to -mm tree
Date: Fri, 13 Jan 2012 14:56:14 -0800
Message-ID: <20120113225615.C062E20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:34568 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932936Ab2AMW4R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 17:56:17 -0500
Received: by eaad12 with SMTP id d12so28630eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 14:56:16 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, dwmw2@infradead.org


The patch titled
     Subject: mtd: use for_each_clear_bit()
has been added to the -mm tree.  Its filename is
     mtd-use-for_each_clear_bit.patch

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
Subject: mtd: use for_each_clear_bit()

Use for_each_clear_bit() to iterate over all the cleared bit in a
memory region.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/chips/cfi_cmdset_0001.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/mtd/chips/cfi_cmdset_0001.c~mtd-use-for_each_clear_bit drivers/mtd/chips/cfi_cmdset_0001.c
--- a/drivers/mtd/chips/cfi_cmdset_0001.c~mtd-use-for_each_clear_bit
+++ a/drivers/mtd/chips/cfi_cmdset_0001.c
@@ -2526,12 +2526,10 @@ static void cfi_intelext_restore_locks(s
 		if (!region->lockmap)
 			continue;
 
-		for (block = 0; block < region->numblocks; block++) {
+		for_each_clear_bit(block, region->lockmap, region->numblocks) {
 			len = region->erasesize;
 			adr = region->offset + block * len;
