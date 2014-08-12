From: akpm@linux-foundation.org
Subject: [merged] kfifo-use-bug_on.patch removed from -mm tree
Date: Tue, 12 Aug 2014 12:40:58 -0700
Message-ID: <53ea6dca.1SEYli+CKrv+ViFl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:37529 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120AbaHLTk7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:40:59 -0400
Received: by mail-yh0-f73.google.com with SMTP id f73so1307319yha.4
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:40:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: himangi774@gmail.com, julia.lawall@lip6.fr, stefani@seibold.net, mm-commits@vger.kernel.org


The patch titled
     Subject: kfifo: use BUG_ON
has been removed from the -mm tree.  Its filename was
     kfifo-use-bug_on.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Himangi Saraogi <himangi774@gmail.com>
Subject: kfifo: use BUG_ON

Use BUG_ON(x) rather than if(x) BUG();

The semantic patch that fixes this problem is as follows:

// <smpl>
@@ identifier x; @@
-if (!x) BUG();
+BUG_ON(!x);
// </smpl>

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
Cc: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kfifo.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN lib/kfifo.c~kfifo-use-bug_on lib/kfifo.c
--- a/lib/kfifo.c~kfifo-use-bug_on
+++ a/lib/kfifo.c
@@ -561,8 +561,7 @@ EXPORT_SYMBOL(__kfifo_to_user_r);
 unsigned int __kfifo_dma_in_prepare_r(struct __kfifo *fifo,
 	struct scatterlist *sgl, int nents, unsigned int len, size_t recsize)
 {
-	if (!nents)
-		BUG();
+	BUG_ON(!nents);
 
 	len = __kfifo_max_r(len, recsize);
 
@@ -585,8 +584,7 @@ EXPORT_SYMBOL(__kfifo_dma_in_finish_r);
 unsigned int __kfifo_dma_out_prepare_r(struct __kfifo *fifo,
 	struct scatterlist *sgl, int nents, unsigned int len, size_t recsize)
 {
-	if (!nents)
-		BUG();
+	BUG_ON(!nents);
 
 	len = __kfifo_max_r(len, recsize);
 
_

Patches currently in -mm which might be from himangi774@gmail.com are

origin.patch
linux-next.patch

