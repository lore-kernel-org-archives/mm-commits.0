From: akpm@linux-foundation.org
Subject: +
 drivers-block-ccissc-return-0-from-driver-probe-function-on-success-not-1.patch added to -mm tree
Date: Thu, 31 Oct 2013 14:40:14 -0700
Message-ID: <5272ce3e.KeSRbDdl8oaATy3x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33827 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab3JaVkP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 Oct 2013 17:40:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, axboe@kernel.dk, scameron@beardog.cce.hp.com

Subject: + drivers-block-ccissc-return-0-from-driver-probe-function-on-success-not-1.patch added to -mm tree
To: scameron@beardog.cce.hp.com,axboe@kernel.dk
From: akpm@linux-foundation.org
Date: Thu, 31 Oct 2013 14:40:14 -0700


The patch titled
     Subject: drivers/block/cciss.c: return 0 from driver probe function on success, not 1
has been added to the -mm tree.  Its filename is
     drivers-block-ccissc-return-0-from-driver-probe-function-on-success-not-1.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-block-ccissc-return-0-from-driver-probe-function-on-success-not-1.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-block-ccissc-return-0-from-driver-probe-function-on-success-not-1.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Subject: drivers/block/cciss.c: return 0 from driver probe function on success, not 1

A return value of 1 is interpreted as an error.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/cciss.c~drivers-block-ccissc-return-0-from-driver-probe-function-on-success-not-1 drivers/block/cciss.c
--- a/drivers/block/cciss.c~drivers-block-ccissc-return-0-from-driver-probe-function-on-success-not-1
+++ a/drivers/block/cciss.c
@@ -5183,7 +5183,7 @@ reinit_after_soft_reset:
 	rebuild_lun_table(h, 1, 0);
 	cciss_engage_scsi(h);
 	h->busy_initializing = 0;
-	return 1;
+	return 0;
 
 clean4:
 	cciss_free_cmd_pool(h);
_

Patches currently in -mm which might be from scameron@beardog.cce.hp.com are

drivers-block-ccissc-return-0-from-driver-probe-function-on-success-not-1.patch

