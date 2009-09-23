From: akpm@linux-foundation.org
Subject: [merged] mtd-sst25l-fix-lock-imbalance.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:04:58 -0700
Message-ID: <200909232004.n8NK4w1l022380@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37656 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753953AbZIWUFa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:05:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     mtd: sst25l, fix lock imbalance
has been removed from the -mm tree.  Its filename was
     mtd-sst25l-fix-lock-imbalance.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd: sst25l, fix lock imbalance
From: Jiri Slaby <jirislaby@gmail.com>

Add an omitted unlock to one sst25l_erase fail path.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/devices/sst25l.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/mtd/devices/sst25l.c~mtd-sst25l-fix-lock-imbalance drivers/mtd/devices/sst25l.c
--- a/drivers/mtd/devices/sst25l.c~mtd-sst25l-fix-lock-imbalance
+++ a/drivers/mtd/devices/sst25l.c
@@ -180,8 +180,10 @@ static int sst25l_erase(struct mtd_info 
 	mutex_lock(&flash->lock);
 
 	err = sst25l_wait_till_ready(flash);
-	if (err)
+	if (err) {
+		mutex_unlock(&flash->lock);
 		return err;
+	}
 
 	while (addr < end) {
 		err = sst25l_erase_sector(flash, addr);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
linux-next.patch
md-dm-log-fix-cn_ulog_callback-declaration.patch
isdn-hisax-fix-lock-imbalance.patch
isdn-eicon-use-offsetof.patch
isdn-eicon-return-on-error.patch
icom-converting-space-to-tabs.patch
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
cyclades-allow-overriding-isa-defaults-also-when-the-driver-is-built-in.patch
drivers-char-rio-rioctrlc-off-by-one-error-in-rioctrlc.patch
memstick-move-dev_dbg.patch
reiser4.patch
fs-reiser4-add-parenths-around-x-y.patch

