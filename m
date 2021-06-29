Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 994F7C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:39:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8042D611AE
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:39:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231805AbhF2Cl5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:41:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:34256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231753AbhF2Cly (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:41:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B09FF611AE;
        Tue, 29 Jun 2021 02:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934367;
        bh=Dyd9/Nhc3m3DAKSguaNRbchrnYghDyF5usfG0Y3MA4s=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=WgziNQnU6o1WLIu3f2JEuaU+f7F5nucxizMqwx0ZRKSm4LS+N7ZW32tlk75msqGQY
         AqsmNUCDTr1eJaT/255WSLU+q50X4GqEcTZiCRJV7+ZXw15YLCxziatE+AUHt4w1s+
         rjB2nDCY1EX1gKbFTlmY0iKKLLBuo3+9eSgd5ewM=
Date:   Mon, 28 Jun 2021 19:39:26 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexander.deucher@amd.com,
        david@redhat.com, dbueso@suse.de, geert@linux-m68k.org,
        ldufour@linux.ibm.com, Liam.Howlett@Oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 117/192] drm/amdgpu: use vma_lookup() in
 amdgpu_ttm_tt_get_user_pages()
Message-ID: <20210629023926.E8C85SCul%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
