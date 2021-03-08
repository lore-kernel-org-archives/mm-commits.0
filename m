Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA8BCC433E6
	for <mm-commits@archiver.kernel.org>; Mon,  8 Mar 2021 22:42:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6D9565299
	for <mm-commits@archiver.kernel.org>; Mon,  8 Mar 2021 22:42:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbhCHWl5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Mar 2021 17:41:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:59586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229655AbhCHWlZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Mar 2021 17:41:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D402A60295;
        Mon,  8 Mar 2021 22:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615243285;
        bh=bv89EwR2GgyCnOhLplDn6gO2Hzw18cgTenKnJztGKVw=;
        h=Date:From:To:Subject:From;
        b=p2RNfkPLO0uJHqmFgpw+6T3YJL7cMjDa7QyQ9K141rvdv83tLnAQqcfcLjYm+q7e4
         pTdVg/2yJAC5z5i1e5+k3CGh5B+5OAur9W/YqEq4+hs9by9gps6S3fTVddedM1YvPf
         FTxCYUEX/0f+vVPltdrV0pjVVE6Q6AgZ+OKF+2BU=
Date:   Mon, 08 Mar 2021 14:41:24 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, joe@perches.com,
        mm-commits@vger.kernel.org
Subject:  + mm-reduce-mem_dump_obj-object-size.patch added to -mm
 tree
Message-ID: <20210308224124.UuKysvc25%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/util.c: reduce mem_dump_obj() object size
has been added to the -mm tree.  Its filename is
     mm-reduce-mem_dump_obj-object-size.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-reduce-mem_dump_obj-object-size.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-reduce-mem_dump_obj-object-size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -996,20 +996,24 @@ int __weak memcmp_pages(struct page *pag
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
_

Patches currently in -mm which might be from joe@perches.com are

mm-reduce-mem_dump_obj-object-size.patch

