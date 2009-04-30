From: akpm@linux-foundation.org
Subject: + dvb-core-fix-potential-mutex_unlock-without-mutex_lock-in-dvb_dvr_read.patch added to -mm tree
Date: Thu, 30 Apr 2009 13:18:46 -0700
Message-ID: <200904302018.n3UKIl1Y020864@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52121 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754045AbZD3UWT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Apr 2009 16:22:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: simon@fire.lp0.eu, mchehab@infradead.org


The patch titled
     dvb-core: fix potential mutex_unlock without mutex_lock in dvb_dvr_read
has been added to the -mm tree.  Its filename is
     dvb-core-fix-potential-mutex_unlock-without-mutex_lock-in-dvb_dvr_read.patch

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
Subject: dvb-core: fix potential mutex_unlock without mutex_lock in dvb_dvr_read
From: Simon Arlott <simon@fire.lp0.eu>

dvb_dvr_read may unlock the dmxdev mutex and return -ENODEV, except this
function is a file op and will never be called with the mutex held.

There's existing mutex_lock and mutex_unlock around the actual read but
it's commented out.  These should probably be uncommented but the read
blocks and this could block another non-blocking reader on the mutex
instead.

This change comments out the extra mutex_unlock.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/dvb-core/dmxdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/dvb/dvb-core/dmxdev.c~dvb-core-fix-potential-mutex_unlock-without-mutex_lock-in-dvb_dvr_read drivers/media/dvb/dvb-core/dmxdev.c
--- a/drivers/media/dvb/dvb-core/dmxdev.c~dvb-core-fix-potential-mutex_unlock-without-mutex_lock-in-dvb_dvr_read
+++ a/drivers/media/dvb/dvb-core/dmxdev.c
@@ -247,7 +247,7 @@ static ssize_t dvb_dvr_read(struct file 
 	int ret;
 
 	if (dmxdev->exit) {
-		mutex_unlock(&dmxdev->mutex);
+		//mutex_unlock(&dmxdev->mutex);
 		return -ENODEV;
 	}
 
_

Patches currently in -mm which might be from simon@fire.lp0.eu are

linux-next.patch
dvb-core-fix-potential-mutex_unlock-without-mutex_lock-in-dvb_dvr_read.patch
dvb-core-fix-potential-mutex_unlock-without-mutex_lock-in-dvb_dvr_read-fix.patch

