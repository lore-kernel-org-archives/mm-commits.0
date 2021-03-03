Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41D45C43381
	for <mm-commits@archiver.kernel.org>; Wed,  3 Mar 2021 13:33:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1510464EC3
	for <mm-commits@archiver.kernel.org>; Wed,  3 Mar 2021 13:33:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381541AbhCCNab (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 08:30:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:60346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233370AbhCCANR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Mar 2021 19:13:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC52164F31;
        Wed,  3 Mar 2021 00:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614730299;
        bh=K3fi2kUAjLjay5dKmaHDjEcO9NcJaBw3BWfxd8IegwY=;
        h=Date:From:To:Subject:From;
        b=cn23ghCn2QIUWk8aAZ5PyTnA30WtfO5QjWIfIQHAjM7sBYebN+JJnpSmMRR+VDrKA
         0HP+/+DKkSf5727kxZYpbEcbDOx6oZRAgDtAGe2YNbF33RcOjVfA0SAKsUgSQRwK7f
         8w8+0oLf7znnRmQOW/STh21TOUyRcDLLlFMr39K0=
Date:   Tue, 02 Mar 2021 16:11:38 -0800
From:   akpm@linux-foundation.org
To:     hch@lst.de, kwankhede@nvidia.com, mm-commits@vger.kernel.org
Subject:  + mm-unexport-remap_vmalloc_range_partial.patch added to
 -mm tree
Message-ID: <20210303001138.g7HqN3wRc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: unexport remap_vmalloc_range_partial
has been added to the -mm tree.  Its filename is
     mm-unexport-remap_vmalloc_range_partial.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-unexport-remap_vmalloc_range_partial.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-unexport-remap_vmalloc_range_partial.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

samples-vfio-mdev-mdpy-use-remap_vmalloc_range.patch
mm-unexport-remap_vmalloc_range_partial.patch

