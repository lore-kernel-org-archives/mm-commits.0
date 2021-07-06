Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13975C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:07:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF64161C6F
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:07:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231752AbhGFTJy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:09:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:45368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231489AbhGFTJy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:09:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 770E961C6C;
        Tue,  6 Jul 2021 19:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598434;
        bh=0QXlZD380Yq6dGf55X7hWHlxQdqjfgV1F62xX2kN6JI=;
        h=Date:From:To:Subject:From;
        b=ZxL+1XM+FlOfBO+9kdkZzaz4bJ9rQWyiePsDgHuSu8Zo6Ek08s+j6bdhbPGWV9AM7
         Gyh8JuHtSCXQb5popjVIaMDIldruOjyMoupXm83hknCEwzTuAxI17hZNgu50vcdWNX
         hyQbf3niba6c9gB/jravHqnMlp8VF9BztoVvTSJU=
Date:   Tue, 06 Jul 2021 12:07:14 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-pre.patch removed from -mm tree
Message-ID: <20210706190714.KBjHejEX4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-pre
has been removed from the -mm tree.  Its filename was
     linux-next-pre.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-pre

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c~linux-next-pre
+++ a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -709,8 +709,8 @@ int amdgpu_ttm_tt_get_user_pages(struct
 	}
 
 	mmap_read_lock(mm);
-	vma = vma_lookup(mm, start);
-	if (unlikely(!vma)) {
+	vma = find_vma(mm, start);
+	if (unlikely(!vma || start < vma->vm_start)) {
 		r = -EFAULT;
 		goto out_unlock;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
linux-next-rejects.patch
kernel-cgroup-cgroupc-dont-export-cgroup_get_e_css-twice.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

