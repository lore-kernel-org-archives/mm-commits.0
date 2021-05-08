Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DD89C43460
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:42:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F42B61430
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:42:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbhEHWng (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:43:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:49374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229616AbhEHWn2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:43:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 868FE61415;
        Sat,  8 May 2021 22:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513746;
        bh=/HV3CPA2Pho817X2DOZ64HGFARQL2quvburVNty0wiY=;
        h=Date:From:To:Subject:From;
        b=Y+nHfDLfh1X4CrB4nAvPyeN9bmzgsruMnk2qnFhAgBrdJ0Pw7HYDVoQU8Ozo1k527
         z/4SnQVsDxaLDkNuTZi2Mkl26KWhJPL1MhDfBvHh8yt0et7sKG1SAhL+13fCExE5zF
         cu5ka5+CY/K4G2ZOn07jtxGMM55L82q+DxsHfOWM=
Date:   Sat, 08 May 2021 15:42:26 -0700
From:   akpm@linux-foundation.org
To:     hch@lst.de, kwankhede@nvidia.com, mm-commits@vger.kernel.org
Subject:  [merged] mm-unexport-remap_vmalloc_range_partial.patch
 removed from -mm tree
Message-ID: <20210508224226.LDeOP-d4g%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: unexport remap_vmalloc_range_partial
has been removed from the -mm tree.  Its filename was
     mm-unexport-remap_vmalloc_range_partial.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: unexport remap_vmalloc_range_partial

remap_vmalloc_range_partial is only used to implement remap_vmalloc_range
and by procfs.  Unexport it.

Link: https://lkml.kernel.org/r/20210301082235.932968-3-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Kirti Wankhede <kwankhede@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/vmalloc.c~mm-unexport-remap_vmalloc_range_partial
+++ a/mm/vmalloc.c
@@ -3072,7 +3072,6 @@ int remap_vmalloc_range_partial(struct v
 
 	return 0;
 }
-EXPORT_SYMBOL(remap_vmalloc_range_partial);
 
 /**
  * remap_vmalloc_range - map vmalloc pages to userspace
_

Patches currently in -mm which might be from hch@lst.de are


