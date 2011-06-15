From: akpm@linux-foundation.org
Subject: + drivers-block-brdc-make-brd_make_request-return-error-code.patch added to -mm tree
Date: Tue, 14 Jun 2011 18:27:23 -0700
Message-ID: <201106150124.p5F1OeSd031980@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52695 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753709Ab1FOBZM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Jun 2011 21:25:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eric.miao@linaro.org, axboe@kernel.dk


The patch titled
     drivers/block/brd.c: make brd_make_request() return error code
has been added to the -mm tree.  Its filename is
     drivers-block-brdc-make-brd_make_request-return-error-code.patch

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
Subject: drivers/block/brd.c: make brd_make_request() return error code
From: Eric Miao <eric.miao@linaro.org>

brd_make_request() always returns 0, which doesn't make much sense.

Signed-off-by: Eric Miao <eric.miao@linaro.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <>
---

 drivers/block/brd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/brd.c~drivers-block-brdc-make-brd_make_request-return-error-code drivers/block/brd.c
--- a/drivers/block/brd.c~drivers-block-brdc-make-brd_make_request-return-error-code
+++ a/drivers/block/brd.c
@@ -360,7 +360,7 @@ static int brd_make_request(struct reque
 out:
 	bio_endio(bio, err);
 
-	return 0;
+	return err;
 }
 
 #ifdef CONFIG_BLK_DEV_XIP
_

Patches currently in -mm which might be from eric.miao@linaro.org are

drivers-block-brdc-make-brd_make_request-return-error-code.patch

