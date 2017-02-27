From: akpm@linux-foundation.org
Subject: [patch 37/78] scatterlist: do not disable IRQs in sg_copy_buffer
Date: Mon, 27 Feb 2017 14:28:29 -0800
Message-ID: <58b4a80d.pMpZDngtAZqjgK/q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45656 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751529AbdB0Wp1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 17:45:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, gilad@benyossef.com, axboe@kernel.dk, ofir.drang@arm.com

From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: scatterlist: do not disable IRQs in sg_copy_buffer

Commit 50bed2e2862a ("sg: disable interrupts inside sg_copy_buffer")
introduced disabling interrupts in sg_copy_buffer() since atomic uses of
miter required it due to use of kmap_atomic().

However, as commit 8290e2d2dcbf ("scatterlist: atomic sg_mapping_iter() no
longer needs disabled IRQs") acknowledges disabling interrupts is no
longer needed for calls to kmap_atomic() and therefore unneeded for miter
ops either, so remove it from sg_copy_buffer().

Link: http://lkml.kernel.org/r/1486040150-14109-3-git-send-email-gilad@benyossef.com
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: <ofir.drang@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/scatterlist.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN lib/scatterlist.c~scatterlist-do-not-disable-irqs-in-sg_copy_buffer lib/scatterlist.c
--- a/lib/scatterlist.c~scatterlist-do-not-disable-irqs-in-sg_copy_buffer
+++ a/lib/scatterlist.c
@@ -651,7 +651,6 @@ size_t sg_copy_buffer(struct scatterlist
 {
 	unsigned int offset = 0;
 	struct sg_mapping_iter miter;
-	unsigned long flags;
 	unsigned int sg_flags = SG_MITER_ATOMIC;
 
 	if (to_buffer)
@@ -664,8 +663,6 @@ size_t sg_copy_buffer(struct scatterlist
 	if (!sg_miter_skip(&miter, skip))
 		return false;
 
-	local_irq_save(flags);
