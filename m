Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6753DC433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:42:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 446DA61424
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:42:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbhEHWnf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:43:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:49174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229699AbhEHWn1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:43:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C017613C5;
        Sat,  8 May 2021 22:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513744;
        bh=u9NUj5EAyiCNpzFZsSzlnUMOuMyGdQ8RFGvgvwFIA6k=;
        h=Date:From:To:Subject:From;
        b=Xmj2ss8YEQf7ZbdXoSuGloZ5kc6uZV0A39fyC3aHgzhFO7QUJ/s6vNFVqwfc/nNBB
         5VN+eqE+6f2V27/C4VVPwI3daF0NKIVWko8QU3rY2UQawdymZZUtDCHL8FuwacvKlD
         ZLZD4WaTbFLkAHTN2uxaIuIjUbwn7uWj8zAopVOQ=
Date:   Sat, 08 May 2021 15:42:24 -0700
From:   akpm@linux-foundation.org
To:     hch@lst.de, kwankhede@nvidia.com, mm-commits@vger.kernel.org
Subject:  [merged]
 samples-vfio-mdev-mdpy-use-remap_vmalloc_range.patch removed from -mm tree
Message-ID: <20210508224224.0yT9s3df8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: samples/vfio-mdev/mdpy: use remap_vmalloc_range
has been removed from the -mm tree.  Its filename was
     samples-vfio-mdev-mdpy-use-remap_vmalloc_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: samples/vfio-mdev/mdpy: use remap_vmalloc_range

Patch series "remap_vmalloc_range cleanups".

This series removes an open coded instance of remap_vmalloc_range and
removes the unused remap_vmalloc_range_partial export.


This patch (of 2):

Use remap_vmalloc_range instead of open coding it using
remap_vmalloc_range_partial.

Link: https://lkml.kernel.org/r/20210301082235.932968-1-hch@lst.de
Link: https://lkml.kernel.org/r/20210301082235.932968-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Kirti Wankhede <kwankhede@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/vfio-mdev/mdpy.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/samples/vfio-mdev/mdpy.c~samples-vfio-mdev-mdpy-use-remap_vmalloc_range
+++ a/samples/vfio-mdev/mdpy.c
@@ -406,9 +406,7 @@ static int mdpy_mmap(struct mdev_device
 	if ((vma->vm_flags & VM_SHARED) == 0)
 		return -EINVAL;
 
-	return remap_vmalloc_range_partial(vma, vma->vm_start,
-					   mdev_state->memblk, 0,
-					   vma->vm_end - vma->vm_start);
+	return remap_vmalloc_range(vma, mdev_state->memblk, 0);
 }
 
 static int mdpy_get_region_info(struct mdev_device *mdev,
_

Patches currently in -mm which might be from hch@lst.de are


