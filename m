From: akpm@linux-foundation.org
Subject: [merged] scatterlist-dont-bug-when-we-can-trivially-return-a-proper-error.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:13:09 -0800
Message-ID: <20121218201309.B6523100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:62508 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678Ab2LRUNK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:13:10 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so126458yen.4
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:13:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nbowler@elliptictech.com, axboe@kernel.dk, maximlevitsky@gmail.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: scatterlist: don't BUG when we can trivially return a proper error.
has been removed from the -mm tree.  Its filename was
     scatterlist-dont-bug-when-we-can-trivially-return-a-proper-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nick Bowler <nbowler@elliptictech.com>
Subject: scatterlist: don't BUG when we can trivially return a proper error.

There is absolutely no reason to crash the kernel when we have a perfectly
good return value already available to use for conveying failure status.

Let's return an error code instead of crashing the kernel: that sounds
like a much better plan.

[akpm@linux-foundation.org: s/E2BIG/EINVAL/]
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
+		return -EINVAL;
 #endif
 
 	memset(table, 0, sizeof(*table));
_

Patches currently in -mm which might be from nbowler@elliptictech.com are

origin.patch

