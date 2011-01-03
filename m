From: akpm@linux-foundation.org
Subject: + regulator-missing-index-in-ptr_err-in-isl6271a_probe.patch added to -mm tree
Date: Mon, 03 Jan 2011 12:01:51 -0800
Message-ID: <201101032001.p03K1pNW025902@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57693 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751353Ab1ACUCZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Jan 2011 15:02:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk


The patch titled
     regulator: missing index in PTR_ERR() in isl6271a_probe()
has been added to the -mm tree.  Its filename is
     regulator-missing-index-in-ptr_err-in-isl6271a_probe.patch

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
Subject: regulator: missing index in PTR_ERR() in isl6271a_probe()
From: roel kluin <roel.kluin@gmail.com>

The index is missing so the return is wrong.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/regulator/isl6271a-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/regulator/isl6271a-regulator.c~regulator-missing-index-in-ptr_err-in-isl6271a_probe drivers/regulator/isl6271a-regulator.c
--- a/drivers/regulator/isl6271a-regulator.c~regulator-missing-index-in-ptr_err-in-isl6271a_probe
+++ a/drivers/regulator/isl6271a-regulator.c
@@ -173,7 +173,7 @@ static int __devinit isl6271a_probe(stru
 						init_data, pmic);
 		if (IS_ERR(pmic->rdev[i])) {
 			dev_err(&i2c->dev, "failed to register %s\n", id->name);
-			err = PTR_ERR(pmic->rdev);
+			err = PTR_ERR(pmic->rdev[i]);
 			goto error;
 		}
 	}
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

btrfs-dont-dereference-extent_mapping-if-null.patch
regulator-missing-index-in-ptr_err-in-isl6271a_probe.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch

