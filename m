From: akpm@linux-foundation.org
Subject: + kfifo-add-kfifo_skip-testcase.patch added to -mm tree
Date: Thu, 12 Aug 2010 14:22:20 -0700
Message-ID: <201008122122.o7CLMKV9013453@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34004 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753114Ab0HLVWk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Aug 2010 17:22:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arighi@develer.com, greg@kroah.com, stefani@seibold.net


The patch titled
     kfifo: add kfifo_skip() testcase
has been added to the -mm tree.  Its filename is
     kfifo-add-kfifo_skip-testcase.patch

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
Subject: kfifo: add kfifo_skip() testcase
From: Andrea Righi <arighi@develer.com>

Add a testcase for kfifo_skip() to the byte stream fifo example.

Signed-off-by: Andrea Righi <arighi@develer.com>
Cc: Greg KH <greg@kroah.com>
Acked-by: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/kfifo/bytestream-example.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN samples/kfifo/bytestream-example.c~kfifo-add-kfifo_skip-testcase samples/kfifo/bytestream-example.c
--- a/samples/kfifo/bytestream-example.c~kfifo-add-kfifo_skip-testcase
+++ a/samples/kfifo/bytestream-example.c
@@ -73,6 +73,10 @@ static int __init testfunc(void)
 	ret = kfifo_in(&test, buf, ret);
 	printk(KERN_INFO "ret: %d\n", ret);
 
+	/* skip first element of the fifo */
+	printk(KERN_INFO "skip 1st element\n");
+	kfifo_skip(&test);
+
 	/* put values into the fifo until is full */
 	for (i = 20; kfifo_put(&test, &i); i++)
 		;
_

Patches currently in -mm which might be from arighi@develer.com are

origin.patch
kfifo-implement-missing-__kfifo_skip_r.patch
kfifo-add-kfifo_skip-testcase.patch

