Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE72AEB64DA
	for <mm-commits@archiver.kernel.org>; Wed, 12 Jul 2023 18:25:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232011AbjGLSZX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Jul 2023 14:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232266AbjGLSZX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2023 14:25:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456E91FE3
        for <mm-commits@vger.kernel.org>; Wed, 12 Jul 2023 11:25:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8AB216182C
        for <mm-commits@vger.kernel.org>; Wed, 12 Jul 2023 18:25:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC0C8C433C8;
        Wed, 12 Jul 2023 18:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689186320;
        bh=igSgzSAcjzD6aEKr41TTnnNQH7xiIQUMVBaGrL0JYDo=;
        h=Date:To:From:Subject:From;
        b=M/4T3sWZDyLYihcyTh4j0bsMBWAommCTl83A8f3DMbs+RuZOr2zUVJo5YlzRwDv+q
         FnXH5ciE1h47+sRs1QSVzfHWspVHu70lUAcg7hf+mnuVL49s4k6wFAg8g+XTnr7xRF
         JTQZA50WvoB2PI3K5vokMgsO0CuFcu5Yaw1/mwSE=
Date:   Wed, 12 Jul 2023 11:25:19 -0700
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com,
        stephen.smalley.work@gmail.com, peterz@infradead.org,
        paul@paul-moore.com, Felix.Kuehling@amd.com, eparis@parisplace.org,
        daniel@ffwll.ch, christian.koenig@amd.com,
        alexander.deucher@amd.com, airlied@gmail.com, acme@kernel.org,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-vma_is_stack-and-vma_is_heap.patch added to mm-unstable branch
Message-Id: <20230712182519.DC0C8C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce vma_is_stack() and vma_is_heap()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-introduce-vma_is_stack-and-vma_is_heap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-vma_is_stack-and-vma_is_heap.patch

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
Subject: mm: introduce vma_is_stack() and vma_is_heap()
Date: Wed, 12 Jul 2023 22:38:27 +0800

Patch series "mm: convert to vma_is_heap/stack()".

Add vma_is_stack() and vma_is_heap() helper and use them to simplify code.


This patch (of 5):

Introduce the two helpers for general use.

Link: https://lkml.kernel.org/r/20230712143831.120701-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20230712143831.120701-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: David Airlie <airlied@gmail.com>
Cc: Eric Paris <eparis@parisplace.org>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/include/linux/mm.h~mm-introduce-vma_is_stack-and-vma_is_heap
+++ a/include/linux/mm.h
@@ -842,6 +842,18 @@ static inline bool vma_is_anonymous(stru
 	return !vma->vm_ops;
 }
 
+static inline bool vma_is_heap(struct vm_area_struct *vma)
+{
+       return vma->vm_start <= vma->vm_mm->brk &&
+		vma->vm_end >= vma->vm_mm->start_brk;
+}
+
+static inline bool vma_is_stack(struct vm_area_struct *vma)
+{
+       return vma->vm_start <= vma->vm_mm->start_stack &&
+	       vma->vm_end >= vma->vm_mm->start_stack;
+}
+
 static inline bool vma_is_temporary_stack(struct vm_area_struct *vma)
 {
 	int maybe_stack = vma->vm_flags & (VM_GROWSDOWN | VM_GROWSUP);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-remove-arguments-of-show_mem.patch
mm-make-show_free_areas-static.patch
mm-introduce-vma_is_stack-and-vma_is_heap.patch
mm-use-vma_is_stack-and-vma_is_heap.patch
drm-amdkfd-use-vma_is_stack-and-vma_is_heap.patch
selinux-use-vma_is_stack-and-vma_is_heap.patch
perf-core-use-vma_is_stack-and-vma_is_heap.patch

