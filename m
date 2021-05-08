Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8D81C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:50:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97EE961421
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:50:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbhEHWvW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:51:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:37072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229609AbhEHWvV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:51:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E1A56101D;
        Sat,  8 May 2021 22:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514219;
        bh=9jV47vRm8HZyFc9Mo8fvumFe4rfd7jPHBRDe/c46zQ0=;
        h=Date:From:To:Subject:From;
        b=D8gQpY7T8Fie2jhUsBHuVKOunj76q4yJrQx3+k29iQDFhq5pERWjDsTtQifWe9j9q
         9L+OpoKqQnucBMmsbYqWMZgmeQ7foxfqXjxGFguBL2m40p0VFiGIzolShwRBA5DpmW
         7dFJk+YvpozjSNr+tv1sHujA6jEFM93Xe8t16/JU=
Date:   Sat, 08 May 2021 15:50:19 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, joe@perches.com,
        mm-commits@vger.kernel.org
Subject:  [merged] mm-reduce-mem_dump_obj-object-size.patch removed
 from -mm tree
Message-ID: <20210508225019.RRdJ5yMUu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/util.c: reduce mem_dump_obj() object size
has been removed from the -mm tree.  Its filename was
     mm-reduce-mem_dump_obj-object-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from joe@perches.com are


