From: akpm@linux-foundation.org
Subject: - mtd-m25p80c-missed-mutex_unlock-on-error-path.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:49:41 -0700
Message-ID: <200806081949.m58Jnfru017701@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59026 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754597AbYFHTuG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:50:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: g.chen@freescale.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     mtd: m25p80.c: missed mutex_unlock on error path
has been removed from the -mm tree.  Its filename was
     mtd-m25p80c-missed-mutex_unlock-on-error-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

