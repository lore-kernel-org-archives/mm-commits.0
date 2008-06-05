From: akpm@linux-foundation.org
Subject: + mtd-m25p80c-missed-mutex_unlock-on-error-path.patch added to -mm tree
Date: Thu, 05 Jun 2008 09:11:23 -0700
Message-ID: <200806051611.m55GBNmH018356@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40636 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751871AbYFEQMI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2008 12:12:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: g.chen@freescale.com, dwmw2@infradead.org


The patch titled
     mtd: m25p80.c: missed mutex_unlock on error path
has been added to the -mm tree.  Its filename is
     mtd-m25p80c-missed-mutex_unlock-on-error-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd: m25p80.c: missed mutex_unlock on error path
From: Chen Gong <g.chen@freescale.com>

Fix a mutex release bug in function m25p80_write().

Signed-off-by: Chen Gong <g.chen@freescale.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/devices/m25p80.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/mtd/devices/m25p80.c~mtd-m25p80c-missed-mutex_unlock-on-error-path drivers/mtd/devices/m25p80.c
--- a/drivers/mtd/devices/m25p80.c~mtd-m25p80c-missed-mutex_unlock-on-error-path
+++ a/drivers/mtd/devices/m25p80.c
@@ -358,8 +358,10 @@ static int m25p80_write(struct mtd_info 
 	mutex_lock(&flash->lock);
 
 	/* Wait until finished previous write command. */
-	if (wait_till_ready(flash))
+	if (wait_till_ready(flash)) {
+		mutex_unlock(&flash->lock);
 		return 1;
+	}
 
 	write_enable(flash);
 
_

Patches currently in -mm which might be from g.chen@freescale.com are

mtd-m25p80c-missed-mutex_unlock-on-error-path.patch

