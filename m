From: akpm@linux-foundation.org
Subject: + tun-dev-impossible-to-deassert-iff_one_queue-or-iff_no_pi.patch added to -mm tree
Date: Thu, 31 Jan 2008 15:10:33 -0800
Message-ID: <200801312310.m0VNAqKQ016153@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39537 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754345AbYAaXLl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Jan 2008 18:11:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nwfilardo@gmail.com, davem@davemloft.net, jeff@garzik.org, maxk@qualcomm.com


The patch titled
     tun: impossible to deassert IFF_ONE_QUEUE or IFF_NO_PI
has been added to the -mm tree.  Its filename is
     tun-dev-impossible-to-deassert-iff_one_queue-or-iff_no_pi.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tun: impossible to deassert IFF_ONE_QUEUE or IFF_NO_PI
From: "Nathaniel Filardo" <nwfilardo@gmail.com>

Taken from http://bugzilla.kernel.org/show_bug.cgi?id=9806

The TUN/TAP driver only permits one-way transitions of IFF_NO_PI or
IFF_ONE_QUEUE during the lifetime of a tap/tun interface.  Note that
tun_set_iff contains

 541         if (ifr->ifr_flags & IFF_NO_PI)
 542                 tun->flags |= TUN_NO_PI;
 543 
 544         if (ifr->ifr_flags & IFF_ONE_QUEUE)
 545                 tun->flags |= TUN_ONE_QUEUE;

This is easily fixed by adding else branches which clear these bits.

Steps to reproduce:

This is easily reproduced by setting an interface persistant using tunctl then
attempting to open it as IFF_TAP or IFF_TUN, without asserting the IFF_NO_PI
flag.  The ioctl() will succeed and the ifr.flags word is not modified, but the
interface remains in IFF_NO_PI mode (as it was set by tunctl).

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Maxim Krasnyansky <maxk@qualcomm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/tun.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/net/tun.c~tun-dev-impossible-to-deassert-iff_one_queue-or-iff_no_pi drivers/net/tun.c
--- a/drivers/net/tun.c~tun-dev-impossible-to-deassert-iff_one_queue-or-iff_no_pi
+++ a/drivers/net/tun.c
@@ -529,9 +529,13 @@ static int tun_set_iff(struct file *file
 
 	if (ifr->ifr_flags & IFF_NO_PI)
 		tun->flags |= TUN_NO_PI;
+	else
+		tun->flags &= ~TUN_NO_PI;
 
 	if (ifr->ifr_flags & IFF_ONE_QUEUE)
 		tun->flags |= TUN_ONE_QUEUE;
+	else
+		tun->flags &= ~TUN_ONE_QUEUE;
 
 	file->private_data = tun;
 	tun->attached = 1;
_

Patches currently in -mm which might be from nwfilardo@gmail.com are

tun-dev-impossible-to-deassert-iff_one_queue-or-iff_no_pi.patch
