From: akpm@linux-foundation.org
Subject: - char-moxa-add-firmware-loading-fix.patch removed from -mm tree
Date: Thu, 01 May 2008 02:29:34 -0700
Message-ID: <200805010929.m419TYO6030691@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57844 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757486AbYEAJ3i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:29:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, Oyvind.Aabling@uni-c.dk, mm-commits@vger.kernel.org


The patch titled
     Char: moxa, add firmware loading fix
has been removed from the -mm tree.  Its filename was
     char-moxa-add-firmware-loading-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: moxa, add firmware loading fix
From: Jiri Slaby <jirislaby@gmail.com>

Be more verbose on fw load fail as noted by Oyvind.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Oyvind Aabling <Oyvind.Aabling@uni-c.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/char/moxa.c~char-moxa-add-firmware-loading-fix drivers/char/moxa.c
--- a/drivers/char/moxa.c~char-moxa-add-firmware-loading-fix
+++ a/drivers/char/moxa.c
@@ -846,7 +846,10 @@ static int moxa_init_board(struct moxa_b
 
 	ret = request_firmware(&fw, file, dev);
 	if (ret) {
-		printk(KERN_ERR "request_firmware failed\n");
+		printk(KERN_ERR "MOXA: request_firmware failed. Make sure "
+				"you've placed '%s' file into your firmware "
+				"loader directory (e.g. /lib/firmware)\n",
+				file);
 		goto err_free;
 	}
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

