From: akpm@linux-foundation.org
Subject: + macintosh-wrong-test-in-fan_readwrite_reg.patch added to -mm tree
Date: Mon, 03 Jan 2011 12:04:20 -0800
Message-ID: <201101032004.p03K4Kg2026005@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40884 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751257Ab1ACUEx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Jan 2011 15:04:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, benh@kernel.crashing.org


The patch titled
     macintosh: wrong test in fan_{read,write}_reg()
has been added to the -mm tree.  Its filename is
     macintosh-wrong-test-in-fan_readwrite_reg.patch

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
Subject: macintosh: wrong test in fan_{read,write}_reg()
From: roel kluin <roel.kluin@gmail.com>

Fix error test in fan_{read,write}_reg()

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/macintosh/therm_pm72.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/macintosh/therm_pm72.c~macintosh-wrong-test-in-fan_readwrite_reg drivers/macintosh/therm_pm72.c
--- a/drivers/macintosh/therm_pm72.c~macintosh-wrong-test-in-fan_readwrite_reg
+++ a/drivers/macintosh/therm_pm72.c
@@ -443,7 +443,7 @@ static int fan_read_reg(int reg, unsigne
 	tries = 0;
 	for (;;) {
 		nr = i2c_master_recv(fcu, buf, nb);
-		if (nr > 0 || (nr < 0 && nr != ENODEV) || tries >= 100)
+		if (nr > 0 || (nr < 0 && nr != -ENODEV) || tries >= 100)
 			break;
 		msleep(10);
 		++tries;
@@ -464,7 +464,7 @@ static int fan_write_reg(int reg, const 
 	tries = 0;
 	for (;;) {
 		nw = i2c_master_send(fcu, buf, nb);
-		if (nw > 0 || (nw < 0 && nw != EIO) || tries >= 100)
+		if (nw > 0 || (nw < 0 && nw != -EIO) || tries >= 100)
 			break;
 		msleep(10);
 		++tries;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

btrfs-dont-dereference-extent_mapping-if-null.patch
macintosh-wrong-test-in-fan_readwrite_reg.patch
regulator-missing-index-in-ptr_err-in-isl6271a_probe.patch
libertas-down_interruptible-can-return-eintr-not-eintr.patch
crypto-dont-return-ptr_err-of-wrong-pointer.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch

