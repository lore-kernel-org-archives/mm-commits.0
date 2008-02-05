From: akpm@linux-foundation.org
Subject: - tun-dev-impossible-to-deassert-iff_one_queue-or-iff_no_pi.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:39:30 -0800
Message-ID: <200802052239.m15MdB3H013026@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60022 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932191AbYBEWm4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:42:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nwfilardo@gmail.com, davem@davemloft.net, jeff@garzik.org, maxk@qualcomm.com, mm-commits@vger.kernel.org


The patch titled
     tun: impossible to deassert IFF_ONE_QUEUE or IFF_NO_PI
has been removed from the -mm tree.  Its filename was
     tun-dev-impossible-to-deassert-iff_one_queue-or-iff_no_pi.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Maxim Krasnyansky <maxk@qualcomm.com>
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

origin.patch
