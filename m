From: akpm@linux-foundation.org
Subject: + block-request_module-use-format-string.patch added to -mm tree
Date: Mon, 30 Jun 2008 15:15:32 -0700
Message-ID: <200806302215.m5UMFWJi028356@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47936 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933047AbYF3WPt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jun 2008 18:15:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: max@stro.at, jens.axboe@oracle.com


The patch titled
     block: request_module(): use format string
has been added to the -mm tree.  Its filename is
     block-request_module-use-format-string.patch

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
Subject: block: request_module(): use format string
From: maximilian attems <max@stro.at>

Avoid bad things happening if the module has a printk control string in
its name.

Signed-off-by: maximilian attems <max@stro.at>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/elevator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN block/elevator.c~block-request_module-use-format-string block/elevator.c
--- a/block/elevator.c~block-request_module-use-format-string
+++ a/block/elevator.c
@@ -144,7 +144,7 @@ static struct elevator_type *elevator_ge
 		else
 			sprintf(elv, "%s-iosched", name);
 
-		request_module(elv);
+		request_module("%s", elv);
 		spin_lock(&elv_list_lock);
 		e = elevator_find(name);
 	}
_

Patches currently in -mm which might be from max@stro.at are

block-request_module-use-format-string.patch

