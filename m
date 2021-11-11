Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8C2FC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:46:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF27361260
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:46:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234395AbhKKCtl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:49:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:54414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234393AbhKKCtl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:49:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3C9E6113B;
        Thu, 11 Nov 2021 02:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598812;
        bh=BJS/ixXS5aNuzLfiGupm/2uCOFCxoP91K8nMQPMAMRY=;
        h=Date:From:To:Subject:From;
        b=AD5znhNMWToH8jCs1UEWOFKRTmZ4Z3S3ATpuvNXEVYtKy8yR1ua+vbyWCM3JfqQOL
         nD9vrj+iSVS3WlQbuBL9msUU4Z1iSPaXH7sAot+/hWnMGYKz0VCp34RSili0Ymlbln
         7VV9oS+bxPSeFvO7vh0+weJ7UpQ0a9vFc5/UBHpM=
Date:   Wed, 10 Nov 2021 18:46:52 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com
Subject:  [merged] mm-nommu-kill-arch_get_unmapped_area.patch
 removed from -mm tree
Message-ID: <20211111024652.-d1oUUm2v%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: nommu: kill arch_get_unmapped_area()
has been removed from the -mm tree.  Its filename was
     mm-nommu-kill-arch_get_unmapped_area.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: nommu: kill arch_get_unmapped_area()

When nommu, the arch_get_unmapped_area() will not be called, just kill it.

Link: https://lkml.kernel.org/r/20210910061906.36299-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/mm/nommu.c~mm-nommu-kill-arch_get_unmapped_area
+++ a/mm/nommu.c
@@ -1639,12 +1639,6 @@ int remap_vmalloc_range(struct vm_area_s
 }
 EXPORT_SYMBOL(remap_vmalloc_range);
 
-unsigned long arch_get_unmapped_area(struct file *file, unsigned long addr,
-	unsigned long len, unsigned long pgoff, unsigned long flags)
-{
-	return -ENOMEM;
-}
-
 vm_fault_t filemap_fault(struct vm_fault *vmf)
 {
 	BUG();
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


