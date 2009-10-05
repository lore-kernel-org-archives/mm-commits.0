From: akpm@linux-foundation.org
Subject: + drivers-block-dac960c-use-dac960_v2_controller.patch added to -mm tree
Date: Mon, 05 Oct 2009 15:41:51 -0700
Message-ID: <200910052241.n95MfpIj031384@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42003 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754157AbZJEWmi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2009 18:42:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, jens.axboe@oracle.com


The patch titled
     drivers/block/DAC960.c: use DAC960_V2_Controller
has been added to the -mm tree.  Its filename is
     drivers-block-dac960c-use-dac960_v2_controller.patch

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
Subject: drivers/block/DAC960.c: use DAC960_V2_Controller
From: Julia Lawall <julia@diku.dk>

DAC960_LP_Controller and DAC960_V2_Controller have the same value, but
elsewhere it is DAC960_V1_Controller or DAC960_V2_Controller that is used
in the FirmwareType field.

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/DAC960.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/DAC960.c~drivers-block-dac960c-use-dac960_v2_controller drivers/block/DAC960.c
--- a/drivers/block/DAC960.c~drivers-block-dac960c-use-dac960_v2_controller
+++ a/drivers/block/DAC960.c
@@ -7101,7 +7101,7 @@ static struct DAC960_privdata DAC960_BA_
 
 static struct DAC960_privdata DAC960_LP_privdata = {
 	.HardwareType =		DAC960_LP_Controller,
-	.FirmwareType 	=	DAC960_LP_Controller,
+	.FirmwareType 	=	DAC960_V2_Controller,
 	.InterruptHandler =	DAC960_LP_InterruptHandler,
 	.MemoryWindowSize =	DAC960_LP_RegisterWindowSize,
 };
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-md-introduce-missing-kfree.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-block-dac960c-use-dac960_v2_controller.patch
drivers-char-ipmi-use-kcs_idle_state.patch

