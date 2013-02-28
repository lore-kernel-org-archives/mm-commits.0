From: akpm@linux-foundation.org
Subject: [merged] kfifo-fix-kfifo_alloc-and-kfifo_init.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:17:55 -0800
Message-ID: <20130228201755.9ED2231C1F0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:34751 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759441Ab3B1UR4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:17:56 -0500
Received: by mail-qe0-f73.google.com with SMTP id a11so245626qen.0
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:17:56 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stefani@seibold.net, mm-commits@vger.kernel.org


The patch titled
     Subject: kfifo: fix kfifo_alloc() and kfifo_init()
has been removed from the -mm tree.  Its filename was
     kfifo-fix-kfifo_alloc-and-kfifo_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stefani Seibold <stefani@seibold.net>
Subject: kfifo: fix kfifo_alloc() and kfifo_init()

Fix kfifo_alloc() and kfifo_init() to alloc at least the requested number
of elements.  Since the kfifo operates on power of 2 the request size will
be rounded up to the next power of two.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kfifo.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN lib/kfifo.c~kfifo-fix-kfifo_alloc-and-kfifo_init lib/kfifo.c
--- a/lib/kfifo.c~kfifo-fix-kfifo_alloc-and-kfifo_init
+++ a/lib/kfifo.c
@@ -42,8 +42,7 @@ int __kfifo_alloc(struct __kfifo *fifo, 
 	 * round down to the next power of 2, since our 'let the indices
 	 * wrap' technique works only in this case.
 	 */
-	if (!is_power_of_2(size))
-		size = rounddown_pow_of_two(size);
+	size = roundup_pow_of_two(size);
 
 	fifo->in = 0;
 	fifo->out = 0;
@@ -83,8 +82,7 @@ int __kfifo_init(struct __kfifo *fifo, v
 {
 	size /= esize;
 
-	if (!is_power_of_2(size))
-		size = rounddown_pow_of_two(size);
+	size = roundup_pow_of_two(size);
 
 	fifo->in = 0;
 	fifo->out = 0;
_

Patches currently in -mm which might be from stefani@seibold.net are

origin.patch

