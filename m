From: akpm@linux-foundation.org
Subject: [merged] scatterlist-reorder-compound-boolean-expression.patch
 removed from -mm tree
Date: Tue, 28 Feb 2017 12:50:53 -0800
Message-ID: <58b5e2ad.SoaFIWy5+kiw1RUI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52514 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751836AbdB1Uve (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 15:51:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gilad@benyossef.com, axboe@kernel.dk, ofir.drang@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scatterlist: reorder compound boolean expression
has been removed from the -mm tree.  Its filename was
     scatterlist-reorder-compound-boolean-expression.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -666,7 +666,7 @@ size_t sg_copy_buffer(struct scatterlist
 
 	local_irq_save(flags);
 
-	while (sg_miter_next(&miter) && offset < buflen) {
+	while ((offset < buflen) && sg_miter_next(&miter)) {
 		unsigned int len;
 
 		len = min(miter.length, buflen - offset);
_

Patches currently in -mm which might be from gilad@benyossef.com are


