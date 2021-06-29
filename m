Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86E0BC11F65
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:39:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70C8961166
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:39:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbhF2Clt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:41:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:34132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231753AbhF2Cls (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:41:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A840C61D0B;
        Tue, 29 Jun 2021 02:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934361;
        bh=Nae39WXZ+EEI1jygsjTuK+eLFeoTFqO+MVsWkrBJt3A=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Wrmu5lWAg+3fbr2r5RtFhHEtKi5SD/xgPIHFPrGeG9d3s217QZSVLKksUD31W/zRY
         U7HggFzIx2qOeksgH2lUNDyc0j4ZCQE1f5a/aKmypL9bqULxK1uwTVipahAO81jDdw
         iJdk1Ue9WeTTvOG1WfaJLirJnsm9QWbvL1ZkUf2M=
Date:   Mon, 28 Jun 2021 19:39:20 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, dbueso@suse.de,
        geert@linux-m68k.org, ldufour@linux.ibm.com,
        Liam.Howlett@Oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 115/192] vfio: use vma_lookup() instead of
 find_vma_intersection()
Message-ID: <20210629023920.WXSWCSVZo%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Liam Howlett <liam.howlett@oracle.com>
Subject: vfio: use vma_lookup() instead of find_vma_intersection()

vma_lookup() finds the vma of a specific address with a cleaner interface
and is more readable.

Link: https://lkml.kernel.org/r/20210521174745.2219620-12-Liam.Howlett@Oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Laurent Dufour <ldufour@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/vfio/vfio_iommu_type1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/vfio/vfio_iommu_type1.c~vfio-use-vma_lookup-instead-of-find_vma_intersection
+++ a/drivers/vfio/vfio_iommu_type1.c
@@ -567,7 +567,7 @@ static int vaddr_get_pfns(struct mm_stru
 	vaddr = untagged_addr(vaddr);
 
 retry:
-	vma = find_vma_intersection(mm, vaddr, vaddr + 1);
+	vma = vma_lookup(mm, vaddr);
 
 	if (vma && vma->vm_flags & VM_PFNMAP) {
 		ret = follow_fault_pfn(vma, mm, vaddr, pfn, prot & IOMMU_WRITE);
_
