From: akpm@linux-foundation.org
Subject: [merged] scatterlist-add-sg_nents-fix.patch removed from -mm tree
Date: Mon, 01 Oct 2012 12:29:16 -0700
Message-ID: <20121001192916.B8E10100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:46134 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab2JAT3R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2012 15:29:17 -0400
Received: by ghbz15 with SMTP id z15so686083ghb.1
        for <mm-commits@vger.kernel.org>; Mon, 01 Oct 2012 12:29:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maximlevitsky@gmail.com, axboe@kernel.dk, oakad@yahoo.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: scatterlist: refactor the sg_nents
has been removed from the -mm tree.  Its filename was
     scatterlist-add-sg_nents-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: scatterlist: refactor the sg_nents

Replace 'while' with 'for' as suggested by Tejun Heo

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Alex Dubov <oakad@yahoo.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/scatterlist.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN lib/scatterlist.c~scatterlist-add-sg_nents-fix lib/scatterlist.c
--- a/lib/scatterlist.c~scatterlist-add-sg_nents-fix
+++ a/lib/scatterlist.c
@@ -49,12 +49,9 @@ EXPORT_SYMBOL(sg_next);
  **/
 int sg_nents(struct scatterlist *sg)
 {
-	int nents = 0;
-	while (sg) {
+	int nents;
+	for (nents = 0; sg; sg = sg_next(sg))
 		nents++;
-		sg = sg_next(sg);
-	}
