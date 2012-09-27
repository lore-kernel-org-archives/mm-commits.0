From: akpm@linux-foundation.org
Subject: + scatterlist-add-sg_nents-fix.patch added to -mm tree
Date: Thu, 27 Sep 2012 13:53:23 -0700
Message-ID: <20120927205325.A1CEB20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:38786 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404Ab2I0Uxb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 27 Sep 2012 16:53:31 -0400
Received: by wgbdt11 with SMTP id dt11so162236wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 27 Sep 2012 13:53:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: maximlevitsky@gmail.com, axboe@kernel.dk, oakad@yahoo.com, tj@kernel.org


The patch titled
     Subject: scatterlist: refactor the sg_nents
has been added to the -mm tree.  Its filename is
     scatterlist-add-sg_nents-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
