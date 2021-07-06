Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A2E9C07E9C
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:12:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EB9C61107
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:12:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231917AbhGFTPV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:15:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:49754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231757AbhGFTPV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:15:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6622A60C3D;
        Tue,  6 Jul 2021 19:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598762;
        bh=jP0BaoS/3KHZeGQIcxUWY46X6wZfPOiTIqbn5ql3gpE=;
        h=Date:From:To:Subject:From;
        b=qkKkfO+KsiOR3B837SFcwpWk6P8Ih4t51JiPvFXJM8vAHWtRDYdOalyvcOJMvbntj
         G8R3geCUOfo7QhFNrxb9pfRoqwclS5rOfMzY38yqHYW7dVyQAFsUJGsjfn5uOGCbdy
         LasYY6mX9VYFM99bIns1bxKidG7J64lFSBAJMx2E=
Date:   Tue, 06 Jul 2021 12:12:42 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, dbueso@suse.de, geert@linux-m68k.org,
        ldufour@linux.ibm.com, Liam.Howlett@Oracle.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 vfio-use-vma_lookup-instead-of-find_vma_intersection.patch removed from -mm
 tree
Message-ID: <20210706191242.kw0UYO1PS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: vfio: use vma_lookup() instead of find_vma_intersection()
has been removed from the -mm tree.  Its filename was
     vfio-use-vma_lookup-instead-of-find_vma_intersection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from liam.howlett@oracle.com are


