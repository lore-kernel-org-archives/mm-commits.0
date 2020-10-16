Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 243B2C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:48:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6F522087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816509;
	bh=tkkofZ7qD82CsOvPieJHBNYt4OyOhg5WwZnbkEnr6T8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=iCeIv0y+bnvBPKDdZX5kUdr4utNIYPGhgOEC9Vjb+HPe/yqdq/qvC57rLzTIRGJBV
	 TdP+si1AhZ1uUeaIJPlxt2d2dfblrXH6RT7AI2JO12wu5Nr/6h9GnwXmyHUKoG6JYS
	 JhT274hk95yLXOkmVgI6DoGzIjoPGTt8F/q5YZdc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404375AbgJPCs3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:48:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:36134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404364AbgJPCs2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:48:28 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FD9E216C4;
        Fri, 16 Oct 2020 02:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816507;
        bh=tkkofZ7qD82CsOvPieJHBNYt4OyOhg5WwZnbkEnr6T8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Bd2210KJUHtCtsk3uxFhiNBLTIl/ta11PhBdWGU9g1Bwz+7adxBr+4v68h/xnjKY3
         G7E40+5wkyPR61uNrpvy4QNA4apJFW78Cp2jHeSins2gZPDGPSPAiHPQzTbPPpPUn2
         g6UiuUHYkc71PF/dR3Lsj3Gm8Y5UJSKCzPM9P1oI=
Date:   Thu, 15 Oct 2020 19:48:26 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dan.carpenter@oracle.com,
        dan.j.williams@intel.com, jgg@ziepe.ca, jglisse@redhat.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rcampbell@nvidia.com, sfr@canb.auug.org.au,
        torvalds@linux-foundation.org
Subject:  [patch 117/156] lib/test_hmm.c: fix an error code in
 dmirror_allocate_chunk()
Message-ID: <20201016024826.10tNs0-zo%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: lib/test_hmm.c: fix an error code in dmirror_allocate_chunk()

This is supposed to return false on failure, not a negative error code.

Link: https://lkml.kernel.org/r/20201010200812.GA1886610@mwanda
Fixes: 170e38548b81 ("mm/hmm/test: use after free in dmirror_allocate_chunk()")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Ralph Campbell <rcampbell@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
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
