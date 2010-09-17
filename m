From: akpm@linux-foundation.org
Subject: + zram-free-percpu-data-on-module-exit.patch added to -mm tree
Date: Fri, 17 Sep 2010 13:59:52 -0700
Message-ID: <201009172059.o8HKxqtr009763@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754362Ab0IQU74 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Sep 2010 16:59:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anton@samba.org, greg@kroah.com, ngupta@vflare.org


The patch titled
     zram: free percpu data on module exit
has been added to the -mm tree.  Its filename is
     zram-free-percpu-data-on-module-exit.patch

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
Subject: zram: free percpu data on module exit
From: Anton Blanchard <anton@samba.org>

Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/zram/zram_drv.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/staging/zram/zram_drv.c~zram-free-percpu-data-on-module-exit drivers/staging/zram/zram_drv.c
--- a/drivers/staging/zram/zram_drv.c~zram-free-percpu-data-on-module-exit
+++ a/drivers/staging/zram/zram_drv.c
@@ -491,8 +491,7 @@ void zram_reset_device(struct zram *zram
 	xv_destroy_pool(zram->mem_pool);
 	zram->mem_pool = NULL;
 
-	/* Reset stats */
-	memset(&zram->stats, 0, sizeof(zram->stats));
+	free_percpu(zram->stats);
 
 	zram->disksize = 0;
 	mutex_unlock(&zram->init_lock);
_

Patches currently in -mm which might be from anton@samba.org are

linux-next.patch
zram-free-percpu-data-on-module-exit.patch
zram-work-around-oops-due-to-startup-ordering-snafu.patch

