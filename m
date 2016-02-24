From: akpm@linux-foundation.org
Subject: + kfifo-fix-sparse-complains.patch added to -mm tree
Date: Tue, 23 Feb 2016 16:27:54 -0800
Message-ID: <56ccf90a.mulG2z/Z+w6UKV9s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37751 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131AbcBXA1y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Feb 2016 19:27:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stefani@seibold.net, mm-commits@vger.kernel.org


The patch titled
     Subject: kfifo: fix sparse complaints
has been added to the -mm tree.  Its filename is
     kfifo-fix-sparse-complains.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kfifo-fix-sparse-complains.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kfifo-fix-sparse-complains.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stefani Seibold <stefani@seibold.net>
Subject: kfifo: fix sparse complaints

This patch fix complaints by the sparse tool when using kfifo_put() with
non scalar types like structures (i.e.  drivers/iio/industrialio-event.c).

Casting a pointer to the value and read this pointer instead of directly
casting the value will fix this.

The generated code is equal.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kfifo.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/kfifo.h~kfifo-fix-sparse-complains include/linux/kfifo.h
--- a/include/linux/kfifo.h~kfifo-fix-sparse-complains
+++ a/include/linux/kfifo.h
@@ -401,7 +401,7 @@ __kfifo_int_must_check_helper( \
 			((typeof(__tmp->type))__kfifo->data) : \
 			(__tmp->buf) \
 			)[__kfifo->in & __tmp->kfifo.mask] = \
-				(typeof(*__tmp->type))__val; \
+				*(typeof(__tmp->type))&__val; \
 			smp_wmb(); \
 			__kfifo->in++; \
 		} \
_

Patches currently in -mm which might be from stefani@seibold.net are

kfifo-fix-sparse-complains.patch

