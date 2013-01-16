From: akpm@linux-foundation.org
Subject: + kfifo-fix-kfifo_alloc-and-kfifo_init.patch added to -mm tree
Date: Wed, 16 Jan 2013 15:10:34 -0800
Message-ID: <20130116231034.E53205A42D7@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:45395 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711Ab3APXKf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Jan 2013 18:10:35 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so235805ghb.3
        for <mm-commits@vger.kernel.org>; Wed, 16 Jan 2013 15:10:35 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stefani@seibold.net


The patch titled
     Subject: kfifo: fix kfifo_alloc() and kfifo_init()
has been added to the -mm tree.  Its filename is
     kfifo-fix-kfifo_alloc-and-kfifo_init.patch

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

kfifo-move-kfifoc-from-kernel-to-lib.patch
kfifo-fix-kfifo_alloc-and-kfifo_init.patch

