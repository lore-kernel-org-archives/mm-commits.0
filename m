From: akpm@linux-foundation.org
Subject: + mtd-sst25l-fix-lock-imbalance.patch added to -mm tree
Date: Wed, 15 Jul 2009 15:33:26 -0700
Message-ID: <200907152233.n6FMXQRu008033@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53182 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755933AbZGOWds (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Jul 2009 18:33:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, dwmw2@infradead.org


The patch titled
     mtd: sst25l, fix lock imbalance
has been added to the -mm tree.  Its filename is
     mtd-sst25l-fix-lock-imbalance.patch

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
toshiba_acpi-return-on-a-fail-path.patch
isdn-hisax-fix-lock-imbalance.patch
icom-converting-space-to-tabs.patch
char-nozomi-fix-tty-refcounting-bug.patch
reiser4.patch
mtd-sst25l-fix-lock-imbalance.patch

