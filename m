From: akpm@linux-foundation.org
Subject: [merged] drivers-scsi-hpsac-use-find_first_zero_bit.patch removed from -mm tree
Date: Mon, 27 Feb 2012 14:29:16 -0800
Message-ID: <20120227222916.6E333A02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:65502 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305Ab2B0W3R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2012 17:29:17 -0500
Received: by yhgm50 with SMTP id m50so328960yhg.1
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2012 14:29:16 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, JBottomley@parallels.com, scameron@beardog.cce.hp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/scsi/hpsa.c: use find_first_zero_bit()
has been removed from the -mm tree.  Its filename was
     drivers-scsi-hpsac-use-find_first_zero_bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: drivers/scsi/hpsa.c: use find_first_zero_bit()

Use find_first_zero_bit to find the first cleared bit in a memory region.

This also includes the following minor changes.
- Use bitmap_zero
- Reduce unnecessary atomic bitops usage

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
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

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
ocfs2-use-find_last_bit.patch
ocfs2-use-bitmap_weight.patch
bitops-rename-for_each_set_bit_cont-in-favor-of-analogous-listh-function.patch
bitops-remove-for_each_set_bit_cont.patch
bitops-introduce-for_each_clear_bit.patch
mtd-use-for_each_clear_bit.patch
s390-char-use-for_each_clear_bit.patch
uwb-use-for_each_clear_bit.patch
x86-use-for_each_clear_bit_from.patch
string-memchr_inv-speed-improvements.patch
sysctl-use-bitmap-library-functions.patch

