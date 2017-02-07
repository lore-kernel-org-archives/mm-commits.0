From: akpm@linux-foundation.org
Subject: + scatterlist-reorder-compound-boolean-expression.patch added to
 -mm tree
Date: Mon, 06 Feb 2017 16:28:53 -0800
Message-ID: <589914c5.W0Q8FNk7kTwH91YT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36522 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751414AbdBGA2y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2017 19:28:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gilad@benyossef.com, axboe@kernel.dk, ofir.drang@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scatterlist: reorder compound boolean expression
has been added to the -mm tree.  Its filename is
     scatterlist-reorder-compound-boolean-expression.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scatterlist-reorder-compound-boolean-expression.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scatterlist-reorder-compound-boolean-expression.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: scatterlist: reorder compound boolean expression

Test the cheaper boolean expression with no side effects first.

Link: http://lkml.kernel.org/r/1486040150-14109-2-git-send-email-gilad@benyossef.com
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: <ofir.drang@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/scatterlist.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/scatterlist.c~scatterlist-reorder-compound-boolean-expression lib/scatterlist.c
--- a/lib/scatterlist.c~scatterlist-reorder-compound-boolean-expression
+++ a/lib/scatterlist.c
@@ -680,7 +680,7 @@ size_t sg_copy_buffer(struct scatterlist
 
 	local_irq_save(flags);
 
-	while (sg_miter_next(&miter) && offset < buflen) {
+	while ((offset < buflen) && sg_miter_next(&miter)) {
 		unsigned int len;
 
 		len = min(miter.length, buflen - offset);
_

Patches currently in -mm which might be from gilad@benyossef.com are

scatterlist-reorder-compound-boolean-expression.patch
scatterlist-do-not-disable-irqs-in-sg_copy_buffer.patch

