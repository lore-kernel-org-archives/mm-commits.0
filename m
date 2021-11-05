Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C397FC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:43:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADA246136A
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:43:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233692AbhKEUqb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:46:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:41430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233055AbhKEUqb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:46:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17CA961360;
        Fri,  5 Nov 2021 20:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145031;
        bh=W5xUEmp0/AmZRI/AUD9aU2KG3gvz5TSEBKt6VoBvGcQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=2SvDvKEuGg6DvyT2JzWawYZOubDXe37ZeF6X2LLjFs0v1uLgJnYEedF40n9KkpiYJ
         iIaAO3RXp6o/cdWi+T2qTxBMSQ2/tW84ZqnFUlbe9C+0Md71EFiTEiY7OA4dx5Ojr5
         nNzSvHffXX0QM4X2/E2/yh4BOioOfgeH2BKM3ghQ=
Date:   Fri, 05 Nov 2021 13:43:50 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        wangkefeng.wang@huawei.com
Subject:  [patch 176/262] mm: nommu: kill arch_get_unmapped_area()
Message-ID: <20211105204350.YecbdIUJT%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
