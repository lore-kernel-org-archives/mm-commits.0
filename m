From: akpm@linux-foundation.org
Subject: + net-ppp_asynctty_ioctl-remove-dead-code.patch added to -mm tree
Date: Tue, 02 Dec 2008 12:00:26 -0800
Message-ID: <200812022000.mB2K0Qo1020306@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54032 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750918AbYLBUAa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 15:00:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, paulus@samba.org


The patch titled
     net: ppp_asynctty_ioctl - remove dead code
has been added to the -mm tree.  Its filename is
     net-ppp_asynctty_ioctl-remove-dead-code.patch

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
Subject: net: ppp_asynctty_ioctl - remove dead code
From: Cyrill Gorcunov <gorcunov@gmail.com>

ap already checked to be not null. remove useless checks.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ppp_async.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN drivers/net/ppp_async.c~net-ppp_asynctty_ioctl-remove-dead-code drivers/net/ppp_async.c
--- a/drivers/net/ppp_async.c~net-ppp_asynctty_ioctl-remove-dead-code
+++ a/drivers/net/ppp_async.c
@@ -293,9 +293,6 @@ ppp_asynctty_ioctl(struct tty_struct *tt
 	err = -EFAULT;
 	switch (cmd) {
 	case PPPIOCGCHAN:
-		err = -ENXIO;
-		if (!ap)
-			break;
 		err = -EFAULT;
 		if (put_user(ppp_channel_index(&ap->chan), p))
 			break;
@@ -303,9 +300,6 @@ ppp_asynctty_ioctl(struct tty_struct *tt
 		break;
 
 	case PPPIOCGUNIT:
-		err = -ENXIO;
-		if (!ap)
-			break;
 		err = -EFAULT;
 		if (put_user(ppp_unit_number(&ap->chan), p))
 			break;
_

Patches currently in -mm which might be from gorcunov@gmail.com are

linux-next.patch
net-ppp_asynctty_ioctl-remove-dead-code.patch

