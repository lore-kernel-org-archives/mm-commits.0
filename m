From: akpm@linux-foundation.org
Subject: [merged] ide-use-printk_once.patch removed from -mm tree
Date: Tue, 06 Oct 2009 13:23:00 -0700
Message-ID: <200910062023.n96KN0Iq017817@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39118 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933006AbZJFUYL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Oct 2009 16:24:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin.slusarz@gmail.com, bzolnier@gmail.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     ide: use printk_once
has been removed from the -mm tree.  Its filename was
     ide-use-printk_once.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ide: use printk_once
From: Marcin Slusarz <marcin.slusarz@gmail.com>

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/ide-proc.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -puN drivers/ide/ide-proc.c~ide-use-printk_once drivers/ide/ide-proc.c
--- a/drivers/ide/ide-proc.c~ide-use-printk_once
+++ a/drivers/ide/ide-proc.c
@@ -273,14 +273,8 @@ static const struct ide_proc_devset ide_
 
 static void proc_ide_settings_warn(void)
 {
-	static int warned;
-
-	if (warned)
-		return;
