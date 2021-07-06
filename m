Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDA11C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:12:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A362060FEE
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:12:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231919AbhGFTP0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:15:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:49834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231815AbhGFTPZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:15:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 678A16023F;
        Tue,  6 Jul 2021 19:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598766;
        bh=MZfc5Uwh8YtB3Fas8ixlWOblfg5H8nc28E2t9uqWEVo=;
        h=Date:From:To:Subject:From;
        b=Jiutd6Ncx5fCoAmlbBVZW59NZ/YolrwNsgfXBwnXIGUcfNVj9o3klFcH7Is0K7mav
         p/OKX1aNaCKrFxhFwUFHLZRsWASeBwb0z+txZ2i5ImwxUIIk37KRkUcrU/GsVAl5co
         FF8hruiVZI45G8sJ1vKzNAZamlRwJBjLmgm3wacI=
Date:   Tue, 06 Jul 2021 12:12:46 -0700
From:   akpm@linux-foundation.org
To:     alexander.deucher@amd.com, david@redhat.com, dbueso@suse.de,
        geert@linux-m68k.org, ldufour@linux.ibm.com,
        Liam.Howlett@Oracle.com, mm-commits@vger.kernel.org
Subject:  [merged]
 drm-amdgpu-use-vma_lookup-in-amdgpu_ttm_tt_get_user_pages.patch removed
 from -mm tree
Message-ID: <20210706191246.XneqjXAcj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drm/amdgpu: use vma_lookup() in amdgpu_ttm_tt_get_user_pages()
has been removed from the -mm tree.  Its filename was
     drm-amdgpu-use-vma_lookup-in-amdgpu_ttm_tt_get_user_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Liam Howlett <liam.howlett@oracle.com>
Subject: drm/amdgpu: use vma_lookup() in amdgpu_ttm_tt_get_user_pages()

Use vma_lookup() to find the VMA at a specific address.  As vma_lookup()
will return NULL if the address is not within any VMA, the start address
no longer needs to be validated.

Link: https://lkml.kernel.org/r/20210521174745.2219620-14-Liam.Howlett@Oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Laurent Dufour <ldufour@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Davidlohr Bueso <dbueso@suse.de>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c~drm-amdgpu-use-vma_lookup-in-amdgpu_ttm_tt_get_user_pages
+++ a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -709,8 +709,8 @@ int amdgpu_ttm_tt_get_user_pages(struct
 	}
 
 	mmap_read_lock(mm);
-	vma = find_vma(mm, start);
-	if (unlikely(!vma || start < vma->vm_start)) {
+	vma = vma_lookup(mm, start);
+	if (unlikely(!vma)) {
 		r = -EFAULT;
 		goto out_unlock;
 	}
_

Patches currently in -mm which might be from liam.howlett@oracle.com are


