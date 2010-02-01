From: akpm@linux-foundation.org
Subject: + atm-use-for_each_set_bit.patch added to -mm tree
Date: Mon, 01 Feb 2010 14:26:21 -0800
Message-ID: <201002012226.o11MQLbg016328@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43228 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754462Ab0BAW1G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2010 17:27:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, chas@cmf.nrl.navy.mil


The patch titled
     atm: use for_each_set_bit()
has been added to the -mm tree.  Its filename is
     atm-use-for_each_set_bit.patch

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
Subject: atm: use for_each_set_bit()
From: Akinobu Mita <akinobu.mita@gmail.com>

Replace open-coded loop with for_each_set_bit().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Chas Williams <chas@cmf.nrl.navy.mil>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/atm/lanai.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/atm/lanai.c~atm-use-for_each_set_bit drivers/atm/lanai.c
--- a/drivers/atm/lanai.c~atm-use-for_each_set_bit
+++ a/drivers/atm/lanai.c
@@ -306,11 +306,10 @@ static void vci_bitfield_iterate(struct 
 	const unsigned long *lp,
 	void (*func)(struct lanai_dev *,vci_t vci))
 {
-	vci_t vci = find_first_bit(lp, NUM_VCI);
-	while (vci < NUM_VCI) {
+	vci_t vci;
+
+	for_each_set_bit(vci, lp, NUM_VCI)
 		func(lanai, vci);
-		vci = find_next_bit(lp, NUM_VCI, vci + 1);
-	}
 }
 
 /* -------------------- BUFFER  UTILITIES: */
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
fault-injection-correct-function-names-in-documentation.patch
bitops-rename-for_each_bit-to-for_each_set_bit.patch
bitmap-use-for_each_set_bit.patch
hpet-use-for_each_set_bit.patch
intel-iommu-use-for_each_set_bit.patch
infiniband-use-for_each_set_bit.patch
ntfs-use-bitmap_weight.patch
phonet-use-for_each_set_bit.patch
atm-use-for_each_set_bit.patch
sched-use-for_each_set_bit.patch
sgi-gru-use-for_each_set_bit.patch

