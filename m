From: akpm@linux-foundation.org
Subject: [merged] drivers-misc-bh1770glcc-error-handling-in-bh1770_power_state_store.patch removed from -mm tree
Date: Tue, 16 Nov 2010 11:30:13 -0800
Message-ID: <201011161933.oAGJXPGS003104@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53143 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756309Ab0KPTdg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Nov 2010 14:33:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: error27@gmail.com, jic23@cam.ac.uk, samu.p.onkalo@nokia.com, mm-commits@vger.kernel.org


The patch titled
     drivers/misc/bh1770glc.c: error handling in bh1770_power_state_store()
has been removed from the -mm tree.  Its filename was
     drivers-misc-bh1770glcc-error-handling-in-bh1770_power_state_store.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/misc/bh1770glc.c: error handling in bh1770_power_state_store()
From: Dan Carpenter <error27@gmail.com>

There was a signedness bug so "ret" was never less than zero and that
breaks the error handling.  Also in the original code it would overwrite
ret and the result is still negative but it's bogus number instead of the
correct error code.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/bh1770glc.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/misc/bh1770glc.c~drivers-misc-bh1770glcc-error-handling-in-bh1770_power_state_store drivers/misc/bh1770glc.c
--- a/drivers/misc/bh1770glc.c~drivers-misc-bh1770glcc-error-handling-in-bh1770_power_state_store
+++ a/drivers/misc/bh1770glc.c
@@ -649,7 +649,7 @@ static ssize_t bh1770_power_state_store(
 {
 	struct bh1770_chip *chip =  dev_get_drvdata(dev);
 	unsigned long value;
-	size_t ret;
+	ssize_t ret;
 
 	if (strict_strtoul(buf, 0, &value))
 		return -EINVAL;
@@ -659,8 +659,12 @@ static ssize_t bh1770_power_state_store(
 		pm_runtime_get_sync(dev);
 
 		ret = bh1770_lux_rate(chip, chip->lux_rate_index);
-		ret |= bh1770_lux_interrupt_control(chip, BH1770_ENABLE);
+		if (ret < 0) {
+			pm_runtime_put(dev);
+			goto leave;
+		}
 
+		ret = bh1770_lux_interrupt_control(chip, BH1770_ENABLE);
 		if (ret < 0) {
 			pm_runtime_put(dev);
 			goto leave;
_

Patches currently in -mm which might be from error27@gmail.com are

linux-next.patch

