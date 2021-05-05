Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D47FC433B4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:38:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1DFA611AB
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:38:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbhEEBj3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:39:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:42712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231440AbhEEBj3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:39:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D64A761182;
        Wed,  5 May 2021 01:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178713;
        bh=NP9dFcv823jOkYYAC3hbqyvnkJ624i1QnEhYBOhdMWc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=i0kdKX/iLVwhZwzYbb2NdENTmPL8GwB6+99cscJRFU7ml+wspmSwTq58VZgSqL3iY
         s8vk0aXtgURlJXx3uDkhJJQhZcg4afySn/Cbs0yfXJ3felblDMmyZ8xqBuGeqQhr1P
         JgTwAmYPsl9zw2rSBIeBePNR6oXAK1lGMyUqmHwM=
Date:   Tue, 04 May 2021 18:38:32 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, joe@perches.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 108/143] mm/util.c: reduce mem_dump_obj() object
 size
Message-ID: <20210505013832.YjDN3dU7O%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Joe Perches <joe@perches.com>
Subject: mm/util.c: reduce mem_dump_obj() object size

Simplify the code by using a temporary and reduce the object size by using
a single call to pr_cont().  Reverse a test and unindent a block too.

$ size mm/util.o* (defconfig x86-64)
   text	   data	    bss	    dec	    hex	filename
   7419	    372	     40	   7831	   1e97	mm/util.o.new
   7477	    372	     40	   7889	   1ed1	mm/util.o.old

Link: https://lkml.kernel.org/r/a6e105886338f68afd35f7a13d73bcf06b0cc732.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

--- a/mm/util.c~mm-reduce-mem_dump_obj-object-size
+++ a/mm/util.c
@@ -987,22 +987,26 @@ int __weak memcmp_pages(struct page *pag
  */
 void mem_dump_obj(void *object)
 {
+	const char *type;
+
 	if (kmem_valid_obj(object)) {
 		kmem_dump_obj(object);
 		return;
 	}
+
 	if (vmalloc_dump_obj(object))
 		return;
-	if (!virt_addr_valid(object)) {
-		if (object == NULL)
-			pr_cont(" NULL pointer.\n");
-		else if (object == ZERO_SIZE_PTR)
-			pr_cont(" zero-size pointer.\n");
-		else
-			pr_cont(" non-paged memory.\n");
-		return;
-	}
-	pr_cont(" non-slab/vmalloc memory.\n");
+
+	if (virt_addr_valid(object))
+		type = "non-slab/vmalloc memory";
+	else if (object == NULL)
+		type = "NULL pointer";
+	else if (object == ZERO_SIZE_PTR)
+		type = "zero-size pointer";
+	else
+		type = "non-paged memory";
+
+	pr_cont(" %s\n", type);
 }
 EXPORT_SYMBOL_GPL(mem_dump_obj);
 #endif
_
