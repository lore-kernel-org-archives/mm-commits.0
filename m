Return-Path: <SRS0=Y9qB=DS=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 104F0C433E7
	for <mm-commits@archiver.kernel.org>; Sun, 11 Oct 2020 03:29:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A663C20874
	for <mm-commits@archiver.kernel.org>; Sun, 11 Oct 2020 03:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602386964;
	bh=dXafyTf34Cg6lSAzclSPdg+wn9qVslawmJi+nY+bUp8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=cbyAtZOYax1ZjWMeZjBS3BiVo2gqERp3ktgj/JV/FpU6qTqND17gsUH66pJXDCgqT
	 7q9b829F+ozTCkox0uUvLeC6o4DZ22yDz1+FK9zqo9h/4pZHhqY+BddJ47tnHjkZw9
	 WBJKIZAjgwaytFdw9v5b7KUkeJr4kfyXArKF7A9o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728798AbgJKD3Y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 10 Oct 2020 23:29:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:49430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728715AbgJKD3Y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 10 Oct 2020 23:29:24 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDA2E20773;
        Sun, 11 Oct 2020 03:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602386962;
        bh=dXafyTf34Cg6lSAzclSPdg+wn9qVslawmJi+nY+bUp8=;
        h=Date:From:To:Subject:From;
        b=BLeULMAHwLZIBjKO4siQliPiDQzTx2mwMVMAv5mkmE4axrgdr+W+psAKtwXQL8f2D
         Q3I6AF3Z7VXeLrlA+SD05uSY54xWDh5OCSqUX6BGoeIgN3Qq/7n2YX7ZTTyJIqmldk
         RQuJD/IyPHeTkFqLwChB+tdqCZMkoP2x5ykjLjdQ=
Date:   Sat, 10 Oct 2020 20:29:21 -0700
From:   akpm@linux-foundation.org
To:     dan.carpenter@oracle.com, dan.j.williams@intel.com, jgg@ziepe.ca,
        jglisse@redhat.com, mm-commits@vger.kernel.org,
        rcampbell@nvidia.com, sfr@canb.auug.org.au
Subject:  +
 mm-hmm-test-fix-an-error-code-in-dmirror_allocate_chunk.patch added to -mm
 tree
Message-ID: <20201011032921.oo1Z-rzzJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_hmm.c: fix an error code in dmirror_allocate_chunk()
has been added to the -mm tree.  Its filename is
     mm-hmm-test-fix-an-error-code-in-dmirror_allocate_chunk.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hmm-test-fix-an-error-code-in-dmirror_allocate_chunk.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hmm-test-fix-an-error-code-in-dmirror_allocate_chunk.patch

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
Subject: lib/test_hmm.c: fix an error code in dmirror_allocate_chunk()

This is supposed to return false on failure, not a negative error code.

Link: https://lkml.kernel.org/r/20201010200812.GA1886610@mwanda
Fixes: 170e38548b81 ("mm/hmm/test: use after free in dmirror_allocate_chunk()")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hmm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_hmm.c~mm-hmm-test-fix-an-error-code-in-dmirror_allocate_chunk
+++ a/lib/test_hmm.c
@@ -461,7 +461,7 @@ static bool dmirror_allocate_chunk(struc
 
 	devmem = kzalloc(sizeof(*devmem), GFP_KERNEL);
 	if (!devmem)
-		return -ENOMEM;
+		return false;
 
 	res = request_free_mem_region(&iomem_resource, DEVMEM_CHUNK_SIZE,
 				      "hmm_dmirror");
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

mm-memremap_pages-convert-to-struct-range-fix.patch
mm-hmm-test-fix-an-error-code-in-dmirror_allocate_chunk.patch

