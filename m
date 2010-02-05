From: akpm@linux-foundation.org
Subject: + dmaengine-correct-onstack-wait_queue_head-declaration.patch added to -mm tree
Date: Fri, 05 Feb 2010 14:23:13 -0800
Message-ID: <201002052223.o15MNDWF024760@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54872 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933852Ab0BEWXn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Feb 2010 17:23:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yong.zhang0@gmail.com, dan.j.williams@intel.com


The patch titled
     dmaengine: correct onstack wait_queue_head declaration
has been added to the -mm tree.  Its filename is
     dmaengine-correct-onstack-wait_queue_head-declaration.patch

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
Subject: dmaengine: correct onstack wait_queue_head declaration
From: Yong Zhang <yong.zhang0@gmail.com>

Use DECLARE_WAIT_QUEUE_HEAD_ONSTACK() to make lockdep happy.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/dmatest.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/dma/dmatest.c~dmaengine-correct-onstack-wait_queue_head-declaration drivers/dma/dmatest.c
--- a/drivers/dma/dmatest.c~dmaengine-correct-onstack-wait_queue_head-declaration
+++ a/drivers/dma/dmatest.c
@@ -467,7 +467,7 @@ err_srcs:
 
 	if (iterations > 0)
 		while (!kthread_should_stop()) {
-			DECLARE_WAIT_QUEUE_HEAD(wait_dmatest_exit);
+			DECLARE_WAIT_QUEUE_HEAD_ONSTACK(wait_dmatest_exit);
 			interruptible_sleep_on(&wait_dmatest_exit);
 		}
 
_

Patches currently in -mm which might be from yong.zhang0@gmail.com are

origin.patch
linux-next.patch
dmaengine-correct-onstack-wait_queue_head-declaration.patch

