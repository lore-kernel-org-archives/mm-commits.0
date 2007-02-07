From: akpm@linux-foundation.org
Subject: + kthread-api-conversion-for-dvb_frontend-and-av7110-fix.patch added to -mm tree
Date: Wed, 07 Feb 2007 09:14:42 -0800
Message-ID: <200702071714.l17HEgZ4020358@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55947 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965689AbXBGRPi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 12:15:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, clg@fr.ibm.com, ebiederm@xmission.com, herbert@13thfloor.at, mchehab@infradead.org, o.endriss@gmx.de


The patch titled
     kthread-api-conversion-for-dvb_frontend-and-av7110-fix
has been added to the -mm tree.  Its filename is
     kthread-api-conversion-for-dvb_frontend-and-av7110-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kthread-api-conversion-for-dvb_frontend-and-av7110-fix
From: Andrew Morton <akpm@linux-foundation.org>

avoid double-up(), pointed out by Oliver.

Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oliver Endriss <o.endriss@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/dvb-core/dvb_frontend.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/media/dvb/dvb-core/dvb_frontend.c~kthread-api-conversion-for-dvb_frontend-and-av7110-fix drivers/media/dvb/dvb-core/dvb_frontend.c
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c~kthread-api-conversion-for-dvb_frontend-and-av7110-fix
+++ a/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -525,7 +525,7 @@ static int dvb_frontend_thread(void *dat
 
 	while (1) {
 		up(&fepriv->sem);	    /* is locked when we enter the thread... */
-
+restart:
 		timeout = wait_event_interruptible_timeout(fepriv->wait_queue,
 			dvb_frontend_should_wakeup(fe) || kthread_should_stop(),
 			fepriv->delay);
@@ -536,7 +536,7 @@ static int dvb_frontend_thread(void *dat
 		}
 
 		if (try_to_freeze())
-			continue;
+			goto restart;
 
 		if (down_interruptible(&fepriv->sem))
 			break;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kthread-api-conversion-for-dvb_frontend-and-av7110-fix.patch
git-libata-all-forward-declare-struct-device.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
mm-vm_insert_pfn-tidy.patch
workqueue-dont-save-interrupts-in-run_workqueue-update.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy.patch
