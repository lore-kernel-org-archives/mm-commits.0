From: akpm@linux-foundation.org
Subject: + uwb-use-for_each_clear_bit.patch added to -mm tree
Date: Fri, 13 Jan 2012 14:56:22 -0800
Message-ID: <20120113225622.82977100052@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:65188 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932966Ab2AMW4X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 17:56:23 -0500
Received: by ghbg20 with SMTP id g20so1101ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 14:56:22 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, david.vrabel@csr.com, stefano.panella@csr.com


The patch titled
     Subject: uwb: use for_each_clear_bit()
has been added to the -mm tree.  Its filename is
     uwb-use-for_each_clear_bit.patch

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
Subject: uwb: use for_each_clear_bit()

Use for_each_clear_bit() to iterate over all the cleared bit in a
memory region.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Stefano Panella <stefano.panella@csr.com>
Cc: David Vrabel <david.vrabel@csr.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/uwb/allocator.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/uwb/allocator.c~uwb-use-for_each_clear_bit drivers/uwb/allocator.c
--- a/drivers/uwb/allocator.c~uwb-use-for_each_clear_bit
+++ a/drivers/uwb/allocator.c
@@ -334,10 +334,8 @@ int uwb_rsv_find_best_allocation(struct 
 
 
 	/* fill the not available vector from the available bm */
-	for (bit_index = 0; bit_index < UWB_NUM_MAS; bit_index++) {
-		if (!test_bit(bit_index, available->bm))
-			ai->bm[bit_index] = UWB_RSV_MAS_NOT_AVAIL;
-	}
+	for_each_clear_bit(bit_index, available->bm, UWB_NUM_MAS)
+		ai->bm[bit_index] = UWB_RSV_MAS_NOT_AVAIL;
 
 	if (ai->max_interval == 1) {
 		get_row_descriptors(ai);
_
Subject: Subject: uwb: use for_each_clear_bit()

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
bitops-rename-for_each_set_bit_cont-in-favor-of-analogous-listh-function.patch
bitops-remove-for_each_set_bit_cont.patch
bitops-introduce-for_each_clear_bit.patch
mtd-use-for_each_clear_bit.patch
s390-char-use-for_each_clear_bit.patch
uwb-use-for_each_clear_bit.patch
x86-use-for_each_clear_bit_from.patch

