From: akpm@linux-foundation.org
Subject: + drivers-scsi-hpsac-use-find_first_zero_bit.patch added to -mm tree
Date: Fri, 20 Jan 2012 15:09:13 -0800
Message-ID: <20120120230913.A06C71E0058@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:49747 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756233Ab2ATXJO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2012 18:09:14 -0500
Received: by yenr8 with SMTP id r8so95460yen.1
        for <mm-commits@vger.kernel.org>; Fri, 20 Jan 2012 15:09:14 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, JBottomley@parallels.com, scameron@beardog.cce.hp.com


The patch titled
     Subject: drivers/scsi/hpsa.c: use find_first_zero_bit()
has been added to the -mm tree.  Its filename is
     drivers-scsi-hpsac-use-find_first_zero_bit.patch

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
Subject: drivers/scsi/hpsa.c: use find_first_zero_bit()

Use find_first_zero_bit to find the first cleared bit in a memory region.

This also includes the following minor changes.
- Use bitmap_zero
- Reduce unnecessary atomic bitops usage

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hpsa.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff -puN drivers/scsi/hpsa.c~drivers-scsi-hpsac-use-find_first_zero_bit drivers/scsi/hpsa.c
--- a/drivers/scsi/hpsa.c~drivers-scsi-hpsac-use-find_first_zero_bit
+++ a/drivers/scsi/hpsa.c
@@ -577,21 +577,19 @@ static int hpsa_find_target_lun(struct c
 	int i, found = 0;
 	DECLARE_BITMAP(lun_taken, HPSA_MAX_DEVICES);
 
-	memset(&lun_taken[0], 0, HPSA_MAX_DEVICES >> 3);
+	bitmap_zero(lun_taken, HPSA_MAX_DEVICES);
 
 	for (i = 0; i < h->ndevices; i++) {
 		if (h->dev[i]->bus == bus && h->dev[i]->target != -1)
-			set_bit(h->dev[i]->target, lun_taken);
+			__set_bit(h->dev[i]->target, lun_taken);
 	}
 
-	for (i = 0; i < HPSA_MAX_DEVICES; i++) {
-		if (!test_bit(i, lun_taken)) {
-			/* *bus = 1; */
-			*target = i;
-			*lun = 0;
-			found = 1;
-			break;
-		}
+	i = find_first_zero_bit(lun_taken, HPSA_MAX_DEVICES);
+	if (i < HPSA_MAX_DEVICES) {
+		/* *bus = 1; */
+		*target = i;
+		*lun = 0;
+		found = 1;
 	}
 	return !found;
 }
_
Subject: Subject: drivers/scsi/hpsa.c: use find_first_zero_bit()

Patches currently in -mm which might be from akinobu.mita@gmail.com are

drivers-scsi-hpsac-use-find_first_zero_bit.patch
bitops-rename-for_each_set_bit_cont-in-favor-of-analogous-listh-function.patch
bitops-remove-for_each_set_bit_cont.patch
bitops-introduce-for_each_clear_bit.patch
mtd-use-for_each_clear_bit.patch
s390-char-use-for_each_clear_bit.patch
uwb-use-for_each_clear_bit.patch
x86-use-for_each_clear_bit_from.patch
sysctl-use-bitmap-library-functions.patch

