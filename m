Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 762DDC001E0
	for <mm-commits@archiver.kernel.org>; Fri, 28 Jul 2023 18:46:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbjG1SqC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Jul 2023 14:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231391AbjG1SqB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Jul 2023 14:46:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB1F211F
        for <mm-commits@vger.kernel.org>; Fri, 28 Jul 2023 11:46:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32B8B621DA
        for <mm-commits@vger.kernel.org>; Fri, 28 Jul 2023 18:46:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8055AC433C9;
        Fri, 28 Jul 2023 18:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690569959;
        bh=RWAjDEIKPc3SWgg+ynRhqThDttg4SoZjt2jB6htQvmI=;
        h=Date:To:From:Subject:From;
        b=wpmj7MpHMJ0Nsz2Z0J7QKraDTcvZKZLlukGglbKxlB/ZgRacyXdkto5XrA1wQq0OT
         GlrjHgYMSTMEfc0eQIK2hZ8hZLFHwOJimoH/h368fsoxSh7whw6bVz0s5YPDot+bUM
         6XJrZZP1413jhaZzYla1c/nxLopGMad5ybkZchIY=
Date:   Fri, 28 Jul 2023 11:45:58 -0700
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com,
        stephen.smalley.work@gmail.com, peterz@infradead.org,
        paul@paul-moore.com, felix.kuehling@amd.com, eparis@parisplace.org,
        david@redhat.com, daniel@ffwll.ch, christian.koenig@amd.com,
        cgzones@googlemail.com, alexander.deucher@amd.com,
        airlied@gmail.com, acme@kernel.org, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selinux-use-vma_is_initial_stack-and-vma_is_initial_heap.patch added to mm-unstable branch
Message-Id: <20230728184559.8055AC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selinux: use vma_is_initial_stack() and vma_is_initial_heap()
has been added to the -mm mm-unstable branch.  Its filename is
     selinux-use-vma_is_initial_stack-and-vma_is_initial_heap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selinux-use-vma_is_initial_stack-and-vma_is_initial_heap.patch

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
Subject: selinux: use vma_is_initial_stack() and vma_is_initial_heap()
Date: Fri, 28 Jul 2023 13:00:42 +0800

Use the helpers to simplify code.

Link: https://lkml.kernel.org/r/20230728050043.59880-4-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Paul Moore <paul@paul-moore.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Eric Paris <eparis@parisplace.org>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Christian Göttsche <cgzones@googlemail.com>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: David Airlie <airlied@gmail.com>
Cc: Felix Kuehling <felix.kuehling@amd.com>
Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/selinux/hooks.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/security/selinux/hooks.c~selinux-use-vma_is_initial_stack-and-vma_is_initial_heap
+++ a/security/selinux/hooks.c
@@ -3762,13 +3762,10 @@ static int selinux_file_mprotect(struct
 	if (default_noexec &&
 	    (prot & PROT_EXEC) && !(vma->vm_flags & VM_EXEC)) {
 		int rc = 0;
-		if (vma->vm_start >= vma->vm_mm->start_brk &&
-		    vma->vm_end <= vma->vm_mm->brk) {
+		if (vma_is_initial_heap(vma)) {
 			rc = avc_has_perm(sid, sid, SECCLASS_PROCESS,
 					  PROCESS__EXECHEAP, NULL);
-		} else if (!vma->vm_file &&
-			   ((vma->vm_start <= vma->vm_mm->start_stack &&
-			     vma->vm_end >= vma->vm_mm->start_stack) ||
+		} else if (!vma->vm_file && (vma_is_initial_stack(vma) ||
 			    vma_is_stack_for_current(vma))) {
 			rc = avc_has_perm(sid, sid, SECCLASS_PROCESS,
 					  PROCESS__EXECSTACK, NULL);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-remove-arguments-of-show_mem.patch
mm-make-show_free_areas-static.patch
mm-factor-out-vma-stack-and-heap-checks.patch
drm-amdkfd-use-vma_is_initial_stack-and-vma_is_initial_heap.patch
selinux-use-vma_is_initial_stack-and-vma_is_initial_heap.patch
perf-core-use-vma_is_initial_stack-and-vma_is_initial_heap.patch

