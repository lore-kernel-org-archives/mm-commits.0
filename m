From: akpm@linux-foundation.org
Subject: + mxcmmc-fixed-max_seg_size-value-on-initialization.patch added to -mm tree
Date: Wed, 24 Feb 2010 12:59:21 -0800
Message-ID: <201002242059.o1OKxLsI020031__4086.03715845874$1267045215$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58897 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758041Ab0BXVAC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 16:00:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vzapolskiy@gmail.com, linux-mmc@vger.kernel.org, pierre@ossman.eu, s.hauer@pengutronix.de


The patch titled
     mxcmmc: fixed max_seg_size value on initialization.
has been added to the -mm tree.  Its filename is
     mxcmmc-fixed-max_seg_size-value-on-initialization.patch

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
Subject: mxcmmc: fixed max_seg_size value on initialization.
From: Vladimir Zapolskiy <vzapolskiy@gmail.com>

-ENOCHANGELOG

Signed-off-by: Vladimir Zapolskiy <vzapolskiy@gmail.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Pierre Ossman <pierre@ossman.eu>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/mxcmmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mmc/host/mxcmmc.c~mxcmmc-fixed-max_seg_size-value-on-initialization drivers/mmc/host/mxcmmc.c
--- a/drivers/mmc/host/mxcmmc.c~mxcmmc-fixed-max_seg_size-value-on-initialization
+++ a/drivers/mmc/host/mxcmmc.c
@@ -708,7 +708,7 @@ static int mxcmci_probe(struct platform_
 	mmc->max_blk_size = 2048;
 	mmc->max_blk_count = 65535;
 	mmc->max_req_size = mmc->max_blk_size * mmc->max_blk_count;
-	mmc->max_seg_size = mmc->max_seg_size;
+	mmc->max_seg_size = mmc->max_req_size;
 
 	host = mmc_priv(mmc);
 	host->base = ioremap(r->start, resource_size(r));
_

Patches currently in -mm which might be from vzapolskiy@gmail.com are

linux-next.patch
mxcmmc-fixed-max_seg_size-value-on-initialization.patch

