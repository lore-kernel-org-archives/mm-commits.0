Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7F44EB64DD
	for <mm-commits@archiver.kernel.org>; Wed, 12 Jul 2023 18:25:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbjGLSZf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Jul 2023 14:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232356AbjGLSZd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2023 14:25:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2046E1FE1
        for <mm-commits@vger.kernel.org>; Wed, 12 Jul 2023 11:25:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17F43618C9
        for <mm-commits@vger.kernel.org>; Wed, 12 Jul 2023 18:25:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AFE6C433C8;
        Wed, 12 Jul 2023 18:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689186325;
        bh=MqJO9QVgcvb2ssfIC9iHMWSBOGny2J98ONOjT8PB7Xs=;
        h=Date:To:From:Subject:From;
        b=KRoQBzxMo/Mdrf0wZoQ2qrlUlWnSuu3tfSZTDZqeLXk5fMNoU4g2/apPBmlUGAfPP
         19wMHTZlu6jXglqXbwTQ6HKFbzZq3QR8oSKgfOQ4h7A58iNhf1aEWKDkohl9M2uhri
         DJVrlDyDKaD702QzSmis+vr3eci+KwRewph6oaSs=
Date:   Wed, 12 Jul 2023 11:25:24 -0700
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com,
        Felix.Kuehling@amd.com, daniel@ffwll.ch, christian.koenig@amd.com,
        alexander.deucher@amd.com, airlied@gmail.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + drm-amdkfd-use-vma_is_stack-and-vma_is_heap.patch added to mm-unstable branch
Message-Id: <20230712182525.6AFE6C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drm/amdkfd: use vma_is_stack() and vma_is_heap()
has been added to the -mm mm-unstable branch.  Its filename is
     drm-amdkfd-use-vma_is_stack-and-vma_is_heap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drm-amdkfd-use-vma_is_stack-and-vma_is_heap.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: drm/amdkfd: use vma_is_stack() and vma_is_heap()
Date: Wed, 12 Jul 2023 22:38:29 +0800

Use the helpers to simplify code.

Link: https://lkml.kernel.org/r/20230712143831.120701-4-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
Cc: David Airlie <airlied@gmail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/amd/amdkfd/kfd_svm.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c~drm-amdkfd-use-vma_is_stack-and-vma_is_heap
+++ a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -2621,10 +2621,7 @@ svm_range_get_range_boundaries(struct kf
 		return -EFAULT;
 	}
 
-	*is_heap_stack = (vma->vm_start <= vma->vm_mm->brk &&
-			  vma->vm_end >= vma->vm_mm->start_brk) ||
-			 (vma->vm_start <= vma->vm_mm->start_stack &&
-			  vma->vm_end >= vma->vm_mm->start_stack);
+	*is_heap_stack = vma_is_heap(vma) || vma_is_stack(vma);
 
 	start_limit = max(vma->vm_start >> PAGE_SHIFT,
 		      (unsigned long)ALIGN_DOWN(addr, 2UL << 8));
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-remove-arguments-of-show_mem.patch
mm-make-show_free_areas-static.patch
mm-introduce-vma_is_stack-and-vma_is_heap.patch
mm-use-vma_is_stack-and-vma_is_heap.patch
drm-amdkfd-use-vma_is_stack-and-vma_is_heap.patch
selinux-use-vma_is_stack-and-vma_is_heap.patch
perf-core-use-vma_is_stack-and-vma_is_heap.patch

