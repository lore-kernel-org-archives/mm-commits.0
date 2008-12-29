From: akpm@linux-foundation.org
Subject: - net-ppp_asynctty_ioctl-remove-dead-code.patch removed from -mm tree
Date: Mon, 29 Dec 2008 11:19:12 -0800
Message-ID: <200812291919.mBTJJCj2031430@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46283 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752254AbYL2TXT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Dec 2008 14:23:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     net: ppp_asynctty_ioctl - remove dead code
has been removed from the -mm tree.  Its filename was
     net-ppp_asynctty_ioctl-remove-dead-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
fs-fix-name-overwrite-in-__register_chrdev_region.patch
memcg-add-inactive_anon_is_low.patch

