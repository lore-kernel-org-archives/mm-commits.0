From: akpm@linux-foundation.org
Subject: [patch 36/78] scatterlist: reorder compound boolean expression
Date: Mon, 27 Feb 2017 14:28:27 -0800
Message-ID: <58b4a80b.bPbUlOqI4s2yW6b5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45678 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751565AbdB0Wnv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 17:43:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, gilad@benyossef.com, axboe@kernel.dk, ofir.drang@arm.com

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
