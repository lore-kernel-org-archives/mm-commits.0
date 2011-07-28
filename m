From: akpm@linux-foundation.org
Subject: + drivers-base-regmap-regmapc-just-send-the-buffer-directly-for-single-register-writes.patch added to -mm tree
Date: Thu, 28 Jul 2011 14:51:53 -0700
Message-ID: <201107282151.p6SLprT5010547@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41314 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752154Ab1G1Vw0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Jul 2011 17:52:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, greg@kroah.com


The patch titled
     drivers/base/regmap/regmap.c: just send the buffer directly for single register writes
has been added to the -mm tree.  Its filename is
     drivers-base-regmap-regmapc-just-send-the-buffer-directly-for-single-register-writes.patch

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
Subject: drivers/base/regmap/regmap.c: just send the buffer directly for single register writes
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

When doing a single register write we use work_buf for both the register
and the value with the buffer formatted for sending directly to the device
so we can just do a write() directly.  This saves allocating a temporary
buffer if we can't do gather writes and is likely to be faster than doing
a gather write.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/regmap/regmap.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN drivers/base/regmap/regmap.c~drivers-base-regmap-regmapc-just-send-the-buffer-directly-for-single-register-writes drivers/base/regmap/regmap.c
--- a/drivers/base/regmap/regmap.c~drivers-base-regmap-regmapc-just-send-the-buffer-directly-for-single-register-writes
+++ a/drivers/base/regmap/regmap.c
@@ -202,13 +202,20 @@ static int _regmap_raw_write(struct regm
 
 	map->format.format_reg(map->work_buf, reg);
 
-	/* Try to do a gather write if we can */
-	if (map->bus->gather_write)
+	/* If we're doing a single register write we can probably just
+	 * send the work_buf directly, otherwise try to do a gather
+	 * write.
+	 */
+	if (val == map->work_buf + map->format.reg_bytes)
+		ret = map->bus->write(map->dev, map->work_buf,
+				      map->format.reg_bytes +
+				      map->format.val_bytes);
+	else if (map->bus->gather_write)
 		ret = map->bus->gather_write(map->dev, map->work_buf,
 					     map->format.reg_bytes,
 					     val, val_len);
 
-	/* Otherwise fall back on linearising by hand. */
+	/* If that didn't work fall back on linearising by hand. */
 	if (ret == -ENOTSUPP) {
 		len = map->format.reg_bytes + val_len;
 		buf = kmalloc(len, GFP_KERNEL);
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

origin.patch
linux-next.patch
drivers-base-regmap-regmapc-just-send-the-buffer-directly-for-single-register-writes.patch
genirq-fix-missing-parenthesises-in-generic-chip.patch

