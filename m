Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B82D1C43457
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:53:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64B2E2145D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881615;
	bh=h5w6G5k/71K25w7SZqMBi0ESY5M/L5dXXVKnoR1mFFI=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=bEbMu6Hq7RcHWXWlnhA0JSLz2Do+m2cAzI9z1HvpaCPFZftrN/VYfbtPz5FQFNdTx
	 QUE286fMPshi6OL8sWieXOc/NjIooZA7ksWZmHGzWHwz+6EVJvyQHc5VSWvDVy0b2q
	 JCqKa5u5W5nWstKfEyli5oZfPjMfSKUYhwkV/TLI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409132AbgJPUxf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:53:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:41626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409125AbgJPUxe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:53:34 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC23E205CB;
        Fri, 16 Oct 2020 20:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881613;
        bh=h5w6G5k/71K25w7SZqMBi0ESY5M/L5dXXVKnoR1mFFI=;
        h=Date:From:To:Subject:From;
        b=ohAKoDvfP9oyCokyVLcSBvTWklQ90hjxvXoqyGH7Cu6T0j1Uj+Icwrh/yx4HB8iwg
         qNnzZtp8YLpsc1KrmLXoYl5HmaIisAhXd5meJQ9EZ/mGlvf0S/xLIh8YJv6iC1eUPB
         A7dcdgVD3I/4BQQ/0yu15LR34AFcu+Nr2w6j5lIk=
Date:   Fri, 16 Oct 2020 13:53:32 -0700
From:   akpm@linux-foundation.org
To:     dan.carpenter@oracle.com, dan.j.williams@intel.com, jgg@ziepe.ca,
        jglisse@redhat.com, mm-commits@vger.kernel.org,
        rcampbell@nvidia.com, sfr@canb.auug.org.au
Subject:  [merged]
 mm-hmm-test-fix-an-error-code-in-dmirror_allocate_chunk.patch removed from
 -mm tree
Message-ID: <20201016205332.FM1N-uuEl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_hmm.c: fix an error code in dmirror_allocate_chunk()
has been removed from the -mm tree.  Its filename was
     mm-hmm-test-fix-an-error-code-in-dmirror_allocate_chunk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from dan.carpenter@oracle.com are


