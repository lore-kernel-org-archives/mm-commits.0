Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 377DDC433E9
	for <mm-commits@archiver.kernel.org>; Wed,  3 Mar 2021 13:33:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DED4864E87
	for <mm-commits@archiver.kernel.org>; Wed,  3 Mar 2021 13:33:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381416AbhCCNaV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 08:30:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:60348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233381AbhCCANI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Mar 2021 19:13:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F13C564F1C;
        Wed,  3 Mar 2021 00:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614730296;
        bh=ZheNazK0gXBxkhycgBsDfN2TOpwohnzazLB5KbHXJ+o=;
        h=Date:From:To:Subject:From;
        b=bLfsha5tKIwWuv4loVneaonQFTpSbb6h/ye+kWY5Q7DaUosp0/TLbgmKLLrWpgK7h
         37Hpk6/EK8gW9PSY5e23jpOzDUmouwWbRFSfAbT1jJzW/B1SgF1yt0a2NtjYoC89kM
         th52SwzpjUqG2PakFVh5CkkziUePU280XzJWKu+4=
Date:   Tue, 02 Mar 2021 16:11:35 -0800
From:   akpm@linux-foundation.org
To:     hch@lst.de, kwankhede@nvidia.com, mm-commits@vger.kernel.org
Subject:  + samples-vfio-mdev-mdpy-use-remap_vmalloc_range.patch
 added to -mm tree
Message-ID: <20210303001135.poYLLBLXH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: samples/vfio-mdev/mdpy: use remap_vmalloc_range
has been added to the -mm tree.  Its filename is
     samples-vfio-mdev-mdpy-use-remap_vmalloc_range.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/samples-vfio-mdev-mdpy-use-remap_vmalloc_range.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/samples-vfio-mdev-mdpy-use-remap_vmalloc_range.patch

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
@@ -417,9 +417,7 @@ static int mdpy_mmap(struct mdev_device
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

samples-vfio-mdev-mdpy-use-remap_vmalloc_range.patch
mm-unexport-remap_vmalloc_range_partial.patch

