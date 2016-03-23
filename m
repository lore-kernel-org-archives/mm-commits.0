From: akpm@linux-foundation.org
Subject: [merged] kfifo-fix-sparse-complains.patch removed from -mm tree
Date: Wed, 23 Mar 2016 10:42:37 -0700
Message-ID: <56f2d58d.FmGg+GfaUIIJof8o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59379 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756491AbcCWRmh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:42:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stefani@seibold.net, mm-commits@vger.kernel.org


The patch titled
     Subject: kfifo: fix sparse complaints
has been removed from the -mm tree.  Its filename was
     kfifo-fix-sparse-complains.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


