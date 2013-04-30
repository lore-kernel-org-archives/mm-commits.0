From: akpm@linux-foundation.org
Subject: [merged] drbd-rename-random32-to-prandom_u32.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:02:35 -0700
Message-ID: <20130430190235.756405A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:63489 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933507Ab3D3TCg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:02:36 -0400
Received: by mail-vc0-f201.google.com with SMTP id gf12so87804vcb.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:02:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, axboe@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: drbd: rename random32() to prandom_u32()
has been removed from the -mm tree.  Its filename was
     drbd-rename-random32-to-prandom_u32.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: drbd: rename random32() to prandom_u32()

Use preferable function name which implies using a pseudo-random
number generator.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/drbd/drbd_receiver.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/block/drbd/drbd_receiver.c~drbd-rename-random32-to-prandom_u32 drivers/block/drbd/drbd_receiver.c
--- a/drivers/block/drbd/drbd_receiver.c~drbd-rename-random32-to-prandom_u32
+++ a/drivers/block/drbd/drbd_receiver.c
@@ -757,7 +757,8 @@ static struct socket *drbd_wait_for_conn
 	rcu_read_unlock();
 
 	timeo = connect_int * HZ;
-	timeo += (random32() & 1) ? timeo / 7 : -timeo / 7; /* 28.5% random jitter */
+	/* 28.5% random jitter */
+	timeo += (prandom_u32() & 1) ? timeo / 7 : -timeo / 7;
 
 	err = wait_for_completion_interruptible_timeout(&ad->door_bell, timeo);
 	if (err <= 0)
@@ -954,7 +955,7 @@ retry:
 				conn_warn(tconn, "Error receiving initial packet\n");
 				sock_release(s);
 randomize:
-				if (random32() & 1)
+				if (prandom_u32() & 1)
 					goto retry;
 			}
 		}
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
drivers-net-rename-random32-to-prandom_u32.patch
drivers-net-rename-random32-to-prandom_u32-fix.patch
drivers-net-rename-random32-to-prandom_u32-fix-fix.patch
remove-unused-random32-and-srandom32.patch
notifier-error-inject-fix-module-names-in-kconfig.patch

