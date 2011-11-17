From: akpm@linux-foundation.org
Subject: [merged] loop-prevent-information-leak-after-failed-read.patch removed from -mm tree
Date: Thu, 17 Nov 2011 12:21:30 -0800
Message-ID: <201111172021.pAHKLU8p023294@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:33919 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755266Ab1KQUVd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Nov 2011 15:21:33 -0500
Received: by vcbfl13 with SMTP id fl13so353488vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2011 12:21:32 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dmonakhov@openvz.org, axboe@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: loop: prevent information leak after failed read
has been removed from the -mm tree.  Its filename was
     loop-prevent-information-leak-after-failed-read.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: loop: prevent information leak after failed read

If read was not fully successful we have to fail whole bio to prevent
information leak of old pages

##Testcase_begin
dd if=/dev/zero of=./file bs=1M count=1
losetup /dev/loop0 ./file -o 4096
truncate -s 0 ./file
# OOps loop offset is now beyond i_size, so read will silently fail.
# So bio's pages would not be cleared, may which result in information leak.
hexdump -C /dev/loop0
##testcase_end

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/loop.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/block/loop.c~loop-prevent-information-leak-after-failed-read drivers/block/loop.c
--- a/drivers/block/loop.c~loop-prevent-information-leak-after-failed-read
+++ a/drivers/block/loop.c
@@ -372,7 +372,8 @@ do_lo_receive(struct loop_device *lo,
 
 	if (retval < 0)
 		return retval;
