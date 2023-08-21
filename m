Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98D5AEE49B1
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:39:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbjHUUje (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231200AbjHUUj1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:39:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BEBE129
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:39:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31D7C6462E
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:39:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7817EC433C8;
        Mon, 21 Aug 2023 20:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650363;
        bh=zaHuGcXpI5odXHas4m/5D8TShKKrT5eBlBPiPI2m+rQ=;
        h=Date:To:From:Subject:From;
        b=VPs+nuXkiIDQxRQJX5jBSOLUfjEdttAvFgOFuwxu08v25LDpjBNNj2q4dH8zeeSfe
         v5+6RpoTsbd2duKHKHgV/Y+4/bAaUj1XMtqwuatDCQA6O9/DTU/neURIKxClTxylXt
         nkbpx1qUSoohcS+qSIogYckal9BIoeiaiBrutQUE=
Date:   Mon, 21 Aug 2023 13:39:21 -0700
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com,
        stephen.smalley.work@gmail.com, peterz@infradead.org,
        paul@paul-moore.com, Felix.Kuehling@amd.com, eparis@parisplace.org,
        david@redhat.com, daniel@ffwll.ch, christian.koenig@amd.com,
        cgzones@googlemail.com, alexander.deucher@amd.com,
        airlied@gmail.com, acme@kernel.org, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] drm-amdkfd-use-vma_is_initial_stack-and-vma_is_initial_heap.patch removed from -mm tree
Message-Id: <20230821203923.7817EC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: drm/amdkfd: use vma_is_initial_stack() and vma_is_initial_heap()
has been removed from the -mm tree.  Its filename was
     drm-amdkfd-use-vma_is_initial_stack-and-vma_is_initial_heap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: drm/amdkfd: use vma_is_initial_stack() and vma_is_initial_heap()
Date: Fri, 28 Jul 2023 13:00:41 +0800

Use the helpers to simplify code.

Link: https://lkml.kernel.org/r/20230728050043.59880-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
Cc: David Airlie <airlied@gmail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Christian Göttsche <cgzones@googlemail.com>
Cc: Eric Paris <eparis@parisplace.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/amd/amdkfd/kfd_svm.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c~drm-amdkfd-use-vma_is_initial_stack-and-vma_is_initial_heap
+++ a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -2621,10 +2621,7 @@ svm_range_get_range_boundaries(struct kf
 		return -EFAULT;
 	}
 
-	*is_heap_stack = (vma->vm_start <= vma->vm_mm->brk &&
-			  vma->vm_end >= vma->vm_mm->start_brk) ||
-			 (vma->vm_start <= vma->vm_mm->start_stack &&
-			  vma->vm_end >= vma->vm_mm->start_stack);
+	*is_heap_stack = vma_is_initial_heap(vma) || vma_is_initial_stack(vma);
 
 	start_limit = max(vma->vm_start >> PAGE_SHIFT,
 		      (unsigned long)ALIGN_DOWN(addr, 2UL << 8));
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


