Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49CEEC433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:05:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F136E22202
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602630307;
	bh=O/qFMGZW5PKuOgzHUp1qFBUMi3u480P+mhBtYgtvOoY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=1vojtpTZdKZloxhHpL6M1layS5KpoGjYG6IahGZbeTCZdzhT5AhsUyvFeaYSrweCl
	 r7kAbfBLL/qXvrHSaiBTpk+mmAzuqYnYtGA1X6GTiooh07ej25L8hiHy1PbAHJZdDx
	 Rlt+iXVVzAMeW1d9Ae6iSxJdL9OwVsJtPdO0kvHo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727555AbgJMXFG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:05:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:42410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726894AbgJMXFG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:05:06 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7F99221FF;
        Tue, 13 Oct 2020 23:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602630306;
        bh=O/qFMGZW5PKuOgzHUp1qFBUMi3u480P+mhBtYgtvOoY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=GtBsWcoKnf1apMs+myWjrJQ5SBwxXjQpndGAApF+mFC4fJUzPLhs8OrlnyWJgQuCk
         QqQGFn48I7wvrXaJf04RVDSrXEjgXV8Diq1wFufqNhTkijmDyumxQ8n8tXepvSYeKp
         vyBEY8b6hPJJipoFSH0gvR1S8yjPpujOfpXYAy8c=
Date:   Tue, 13 Oct 2020 16:05:05 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     dan.carpenter@oracle.com, dan.j.williams@intel.com, jgg@nvidia.com,
        jglisse@redhat.com, joao.m.martins@oracle.com,
        Julia.Lawall@lip6.fr, Markus.Elfring@web.de,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com,
        vishal.l.verma@intel.com, weiyongjun1@huawei.com
Subject:  [folded-merged]
 mm-memremap_pages-convert-to-struct-range-fix.patch removed from -mm tree
Message-ID: <20201013230505.ijCypJ5Ag%akpm@linux-foundation.org>
In-Reply-To: <20201010231559.e148a66f744d0b4870301450@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hmm/test: use after free in dmirror_allocate_chunk()
has been removed from the -mm tree.  Its filename was
     mm-memremap_pages-convert-to-struct-range-fix.patch

This patch was dropped because it was folded into mm-memremap_pages-convert-to-struct-range.patch

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: mm/hmm/test: use after free in dmirror_allocate_chunk()

The error handling code does this:

err_free:
	kfree(devmem);
        ^^^^^^^^^^^^^
err_release:
	release_mem_region(devmem->pagemap.range.start, range_len(&devmem->pagemap.range));
                           ^^^^^^^^
The problem is that when we use "devmem->pagemap.range.start" the
"devmem" pointer is either NULL or freed.

Neither the allocation nor the call to request_free_mem_region() has to
be done under the lock so I moved those to the start of the function.

Link: https://lkml.kernel.org/r/20200926121402.GA7467@kadam
Fixes: 1f9c4bb986d9 ("mm/memremap_pages: convert to 'struct range'")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Ralph Campbell <rcampbell@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Cc: Markus Elfring <Markus.Elfring@web.de>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Wei Yongjun <weiyongjun1@huawei.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hmm.c |   42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

--- a/lib/test_hmm.c~mm-memremap_pages-convert-to-struct-range-fix
+++ a/lib/test_hmm.c
@@ -460,6 +460,21 @@ static bool dmirror_allocate_chunk(struc
 	unsigned long pfn_last;
 	void *ptr;
 
+	devmem = kzalloc(sizeof(*devmem), GFP_KERNEL);
+	if (!devmem)
+		return -ENOMEM;
+
+	res = request_free_mem_region(&iomem_resource, DEVMEM_CHUNK_SIZE,
+				      "hmm_dmirror");
+	if (IS_ERR(res))
+		goto err_devmem;
+
+	devmem->pagemap.type = MEMORY_DEVICE_PRIVATE;
+	devmem->pagemap.range.start = res->start;
+	devmem->pagemap.range.end = res->end;
+	devmem->pagemap.ops = &dmirror_devmem_ops;
+	devmem->pagemap.owner = mdevice;
+
 	mutex_lock(&mdevice->devmem_lock);
 
 	if (mdevice->devmem_count == mdevice->devmem_capacity) {
@@ -472,29 +487,14 @@ static bool dmirror_allocate_chunk(struc
 				sizeof(new_chunks[0]) * new_capacity,
 				GFP_KERNEL);
 		if (!new_chunks)
-			goto err;
+			goto err_release;
 		mdevice->devmem_capacity = new_capacity;
 		mdevice->devmem_chunks = new_chunks;
 	}
 
-	res = request_free_mem_region(&iomem_resource, DEVMEM_CHUNK_SIZE,
-					"hmm_dmirror");
-	if (IS_ERR(res))
-		goto err;
-
-	devmem = kzalloc(sizeof(*devmem), GFP_KERNEL);
-	if (!devmem)
-		goto err_release;
-
-	devmem->pagemap.type = MEMORY_DEVICE_PRIVATE;
-	devmem->pagemap.range.start = res->start;
-	devmem->pagemap.range.end = res->end;
-	devmem->pagemap.ops = &dmirror_devmem_ops;
-	devmem->pagemap.owner = mdevice;
-
 	ptr = memremap_pages(&devmem->pagemap, numa_node_id());
 	if (IS_ERR(ptr))
-		goto err_free;
+		goto err_release;
 
 	devmem->mdevice = mdevice;
 	pfn_first = devmem->pagemap.range.start >> PAGE_SHIFT;
@@ -525,12 +525,12 @@ static bool dmirror_allocate_chunk(struc
 
 	return true;
 
-err_free:
-	kfree(devmem);
 err_release:
-	release_mem_region(devmem->pagemap.range.start, range_len(&devmem->pagemap.range));
-err:
 	mutex_unlock(&mdevice->devmem_lock);
+	release_mem_region(devmem->pagemap.range.start, range_len(&devmem->pagemap.range));
+err_devmem:
+	kfree(devmem);
+
 	return false;
 }
 
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

mm-memremap_pages-convert-to-struct-range.patch
mm-hmm-test-fix-an-error-code-in-dmirror_allocate_chunk.patch

