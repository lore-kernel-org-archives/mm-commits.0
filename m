From: akpm@google.com
Subject: + loop-prevent-information-leak-after-failed-read.patch added to -mm tree
Date: Fri, 23 Sep 2011 13:56:57 -0700
Message-ID: <201109232056.p8NKuwBS006284@hpaq6.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:10033 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab1IWU5E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Sep 2011 16:57:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmonakhov@openvz.org, axboe@kernel.dk


The patch titled
     Subject: loop: prevent information leak after failed read
has been added to the -mm tree.  Its filename is
     loop-prevent-information-leak-after-failed-read.patch

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
Signed-off-by: Andrew Morton <akpm@google.com>
---

 drivers/block/loop.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/block/loop.c~loop-prevent-information-leak-after-failed-read drivers/block/loop.c
--- a/drivers/block/loop.c~loop-prevent-information-leak-after-failed-read
+++ a/drivers/block/loop.c
@@ -449,7 +449,8 @@ do_lo_receive(struct loop_device *lo,
 
 	if (retval < 0)
 		return retval;
