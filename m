From: akpm@linux-foundation.org
Subject: + ide-use-printk_once.patch added to -mm tree
Date: Mon, 24 Aug 2009 14:25:35 -0700
Message-ID: <200908242125.n7OLPZGu030447@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44594 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753499AbZHXVZh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Aug 2009 17:25:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, bzolnier@gmail.com, davem@davemloft.net


The patch titled
     ide: use printk_once
has been added to the -mm tree.  Its filename is
     ide-use-printk_once.patch

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
@@ -230,14 +230,8 @@ static const struct ide_proc_devset ide_
 
 static void proc_ide_settings_warn(void)
 {
-	static int warned;
-
-	if (warned)
-		return;
