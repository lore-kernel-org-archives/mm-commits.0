Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 163CDC433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:58:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF83861482
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:58:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbhD3F6v (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:58:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:51992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229712AbhD3F6u (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:58:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE7F161481;
        Fri, 30 Apr 2021 05:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762281;
        bh=fksONrOBP8MmQtf4k5ABubJxyfnLfelmztDXr1M1bRI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=McHDebhs8DNG+uTglCOPMQ3FVkQREMdmptJFQxi1sAHTNpEnYm3N0NBfLY3fryk54
         4tm2WKnpfGU3uN1uJoBsjO4JNfUKkTh0mW7NejIA1LLFNTropdM6FG6DjZwf5oelJs
         Zz6Zsw4fe8GX7IRX87nIvuPdJKq/qYSqpFXT7Wyw=
Date:   Thu, 29 Apr 2021 22:58:01 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hch@lst.de, kwankhede@nvidia.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 094/178] samples/vfio-mdev/mdpy: use
 remap_vmalloc_range
Message-ID: <20210430055801.--rBzkBgW%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
