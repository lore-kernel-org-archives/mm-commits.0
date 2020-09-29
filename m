Return-Path: <SRS0=qjDH=DG=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBF1AC2D0A8
	for <mm-commits@archiver.kernel.org>; Tue, 29 Sep 2020 00:51:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 990B721734
	for <mm-commits@archiver.kernel.org>; Tue, 29 Sep 2020 00:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601340671;
	bh=6FF8C7L1fh820e5TxV8dr1i9ajeNYPVEgOCWmds5QIc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Inx2jg9sqUOmYuuCCB2VEzCkElOBWtKzQ49KBnB1MHk5qvL/QjvQgfIVbVswXZQbv
	 id8AoWM/X0dNWKGnZy8xsFHHbbPwDNY3pmi0HP8UsqTLyto/t61sAIC0skY2LjjXJ6
	 ykY8vy1djTux3X/nkmrjrokoVtRYTkK5Gi3I15jo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbgI2AvL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Sep 2020 20:51:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:54398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727007AbgI2AvL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Sep 2020 20:51:11 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 597F120773;
        Tue, 29 Sep 2020 00:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601340668;
        bh=6FF8C7L1fh820e5TxV8dr1i9ajeNYPVEgOCWmds5QIc=;
        h=Date:From:To:Subject:From;
        b=alQsgbCWCGznBP+OiU1k61H0fnIlniOmiwO8ZPwmA/IDaD+bicyE11abHVgy7u/iT
         9T2ZsG90Z5MvhYdPv+qYqZUqATxq/8upL5w37aMakwwkTrRy6GHsz8+boOSAVhb+oS
         zr6e1bW7Vb9sXcxFkmhw8t9HiCLcQ6oo+302nUjo=
Date:   Mon, 28 Sep 2020 17:51:07 -0700
From:   akpm@linux-foundation.org
To:     dan.carpenter@oracle.com, dan.j.williams@intel.com, jgg@ziepe.ca,
        jglisse@redhat.com, joao.m.martins@oracle.com,
        Julia.Lawall@lip6.fr, Markus.Elfring@web.de,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com,
        vishal.l.verma@intel.com, weiyongjun1@huawei.com
Subject:  + mm-memremap_pages-convert-to-struct-range-fix.patch
 added to -mm tree
Message-ID: <20200929005107.rqK-aHaId%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hmm/test: use after free in dmirror_allocate_chunk()
has been added to the -mm tree.  Its filename is
     mm-memremap_pages-convert-to-struct-range-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memremap_pages-convert-to-struct-range-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memremap_pages-convert-to-struct-range-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Markus Elfring <Markus.Elfring@web.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
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

mm-memremap_pages-convert-to-struct-range-fix.patch

