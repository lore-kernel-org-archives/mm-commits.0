From: akpm@linux-foundation.org
Subject: + sdio-driver-for-marvell-socs-update.patch added to -mm tree
Date: Thu, 19 Feb 2009 14:58:26 -0800
Message-ID: <200902192258.n1JMwQU5028890@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55615 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753728AbZBSW7B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 17:59:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: maen@marvell.com, drzeus-mmc@drzeus.cx, nico@marvell.com


The patch titled
     sdio-driver-for-marvell-socs update
has been added to the -mm tree.  Its filename is
     sdio-driver-for-marvell-socs-update.patch

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
Subject: sdio-driver-for-marvell-socs update
From: Maen Suleiman <maen@marvell.com>

fix leak

Signed-off-by: Nicolas Pitre <nico@marvell.com>
Cc: Maen Suleiman <maen@marvell.com>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/mvsdio.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/mmc/host/mvsdio.c~sdio-driver-for-marvell-socs-update drivers/mmc/host/mvsdio.c
--- a/drivers/mmc/host/mvsdio.c~sdio-driver-for-marvell-socs-update
+++ a/drivers/mmc/host/mvsdio.c
@@ -688,6 +688,7 @@ static int __init mvsd_probe(struct plat
 
 	mmc = mmc_alloc_host(sizeof(struct mvsd_host), &pdev->dev);
 	if (!mmc) {
+		release_resource(r);
 		ret = -ENOMEM;
 		goto out;
 	}
_

Patches currently in -mm which might be from maen@marvell.com are

sdio-driver-for-marvell-socs.patch
sdio-driver-for-marvell-socs-update.patch

