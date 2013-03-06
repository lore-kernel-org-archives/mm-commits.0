From: akpm@linux-foundation.org
Subject: + drbd-rename-random32-to-prandom_u32.patch added to -mm tree
Date: Tue, 05 Mar 2013 17:02:03 -0800
Message-ID: <20130306010203.C55C85A41EB@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:56240 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753Ab3CFBCE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Mar 2013 20:02:04 -0500
Received: by mail-qa0-f74.google.com with SMTP id o13so428060qaj.1
        for <mm-commits@vger.kernel.org>; Tue, 05 Mar 2013 17:02:04 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, axboe@kernel.dk


The patch titled
     Subject: drbd: rename random32() to prandom_u32()
has been added to the -mm tree.  Its filename is
     drbd-rename-random32-to-prandom_u32.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -953,7 +954,7 @@ retry:
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

linux-next.patch
raid6test-use-prandom_bytes.patch
uuid-use-prandom_bytes.patch
x86-pageattr-test-remove-srandom32-call.patch
x86-rename-random32-to-prandom_u32.patch
lib-rename-random32-to-prandom_u32.patch
mm-rename-random32-to-prandom_u32.patch
kernel-rename-random32-to-prandom_u32.patch
drbd-rename-random32-to-prandom_u32.patch
infiniband-rename-random32-to-prandom_u32.patch
mmc-rename-random32-to-prandom_u32.patch
video-uvesafb-rename-random32-to-prandom_u32.patch
xfs-rename-random32-to-prandom_u32.patch
uwb-rename-random32-to-prandom_u32.patch
lguest-rename-random32-to-prandom_u32.patch
scsi-rename-random32-to-prandom_u32.patch
drivers-net-rename-random32-to-prandom_u32.patch
net-sunrpc-rename-random32-to-prandom_u32.patch
net-sched-rename-random32-to-prandom_u32.patch
net-netfilter-rename-random32-to-prandom_u32.patch
net-core-rename-random32-to-prandom_u32.patch
net-core-remove-duplicate-statements-by-do-while-loop.patch
net-rename-random32-to-prandom.patch
remove-unused-random32-and-srandom32.patch

