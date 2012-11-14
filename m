From: akpm@linux-foundation.org
Subject: + scatterlist-dont-bug-when-we-can-trivially-return-a-proper-error.patch added to -mm tree
Date: Wed, 14 Nov 2012 13:05:11 -0800
Message-ID: <20121114210512.37C51100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:44517 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505Ab2KNVFN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Nov 2012 16:05:13 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so93193vbi.1
        for <mm-commits@vger.kernel.org>; Wed, 14 Nov 2012 13:05:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nbowler@elliptictech.com, axboe@kernel.dk, maximlevitsky@gmail.com, tj@kernel.org


The patch titled
     Subject: scatterlist: don't BUG when we can trivially return a proper error.
has been added to the -mm tree.  Its filename is
     scatterlist-dont-bug-when-we-can-trivially-return-a-proper-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nick Bowler <nbowler@elliptictech.com>
Subject: scatterlist: don't BUG when we can trivially return a proper error.

There is absolutely no reason to crash the kernel when we have a perfectly
good return value already available to use for conveying failure status.

Let's return an error code instead of crashing the kernel: that sounds
like a much better plan.

Signed-off-by: Nick Bowler <nbowler@elliptictech.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/scatterlist.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN lib/scatterlist.c~scatterlist-dont-bug-when-we-can-trivially-return-a-proper-error lib/scatterlist.c
--- a/lib/scatterlist.c~scatterlist-dont-bug-when-we-can-trivially-return-a-proper-error
+++ a/lib/scatterlist.c
@@ -248,7 +248,8 @@ int __sg_alloc_table(struct sg_table *ta
 	unsigned int left;
 
 #ifndef ARCH_HAS_SG_CHAIN
-	BUG_ON(nents > max_ents);
+	if (WARN_ON_ONCE(nents > max_ents))
+		return -E2BIG;
 #endif
 
 	memset(table, 0, sizeof(*table));
_

Patches currently in -mm which might be from nbowler@elliptictech.com are

linux-next.patch
scatterlist-dont-bug-when-we-can-trivially-return-a-proper-error.patch
scatterlist-dont-bug-when-we-can-trivially-return-a-proper-error-fix.patch

