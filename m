Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C45BEE4996
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:39:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbjHUUjj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231202AbjHUUj2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:39:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4BC131
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:39:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B62064B0B
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:39:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF483C433BC;
        Mon, 21 Aug 2023 20:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650364;
        bh=pYi8D486wYzkG4pDeE1ceiRIA7XdKgL/A6ZuIqK18U8=;
        h=Date:To:From:Subject:From;
        b=wcU6qu0a6Uk7Mj6Znas5szWyjIAEfzzlBK4dVxcnOxnBeZcoC1V2b9c6iYxCj631Z
         xsHqgpccoShFOCqnLFn/eN6Qw27sxsD1kGKcCBvkhQvjBZ7njUkM4qRVwumLgAVLWd
         wQ3tM0615vPyYBX53wytbHaymZI8wmJ8LnjWgqJA=
Date:   Mon, 21 Aug 2023 13:39:24 -0700
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com,
        stephen.smalley.work@gmail.com, peterz@infradead.org,
        paul@paul-moore.com, felix.kuehling@amd.com, eparis@parisplace.org,
        david@redhat.com, daniel@ffwll.ch, christian.koenig@amd.com,
        cgzones@googlemail.com, alexander.deucher@amd.com,
        airlied@gmail.com, acme@kernel.org, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selinux-use-vma_is_initial_stack-and-vma_is_initial_heap.patch removed from -mm tree
Message-Id: <20230821203924.BF483C433BC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selinux: use vma_is_initial_stack() and vma_is_initial_heap()
has been removed from the -mm tree.  Its filename was
     selinux-use-vma_is_initial_stack-and-vma_is_initial_heap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: selinux: use vma_is_initial_stack() and vma_is_initial_heap()
Date: Fri, 28 Jul 2023 13:00:42 +0800

Use the helpers to simplify code.

Link: https://lkml.kernel.org/r/20230728050043.59880-4-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Paul Moore <paul@paul-moore.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
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


