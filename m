Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3693C001DE
	for <mm-commits@archiver.kernel.org>; Fri, 28 Jul 2023 18:46:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231887AbjG1SqH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Jul 2023 14:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231997AbjG1SqE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Jul 2023 14:46:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC59211F
        for <mm-commits@vger.kernel.org>; Fri, 28 Jul 2023 11:46:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31B8D621DB
        for <mm-commits@vger.kernel.org>; Fri, 28 Jul 2023 18:46:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 809B3C433C8;
        Fri, 28 Jul 2023 18:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690569961;
        bh=GqGKLDFGgdrGAB/JYNn5q5qthU7aF9ja/lWv1PXxasE=;
        h=Date:To:From:Subject:From;
        b=sEgmH32UkMP/kTZVUhGRYz4Pt1DLydALni+RdMvS4rYP4InL4Z0q5hmejlMOR8PS/
         4kHns8gQAwpGLTXkP4G5QRkUxgMWJC1tTLdknZ5M/E/4NQ0cRVMdRm7LEvLhoxoVRQ
         t6H3HoUVDIgQIyjPmLf071tWdcq/i+LC+9PhOlso=
Date:   Fri, 28 Jul 2023 11:46:00 -0700
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com,
        stephen.smalley.work@gmail.com, peterz@infradead.org,
        paul@paul-moore.com, felix.kuehling@amd.com, eparis@parisplace.org,
        david@redhat.com, daniel@ffwll.ch, christian.koenig@amd.com,
        cgzones@googlemail.com, alexander.deucher@amd.com,
        airlied@gmail.com, acme@kernel.org, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + perf-core-use-vma_is_initial_stack-and-vma_is_initial_heap.patch added to mm-unstable branch
Message-Id: <20230728184601.809B3C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: perf/core: use vma_is_initial_stack() and vma_is_initial_heap()
has been added to the -mm mm-unstable branch.  Its filename is
     perf-core-use-vma_is_initial_stack-and-vma_is_initial_heap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/perf-core-use-vma_is_initial_stack-and-vma_is_initial_heap.patch

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
Subject: perf/core: use vma_is_initial_stack() and vma_is_initial_heap()
Date: Fri, 28 Jul 2023 13:00:43 +0800

Use the helpers to simplify code, also kill unneeded goto cpy_name.

Link: https://lkml.kernel.org/r/20230728050043.59880-5-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Christian Göttsche <cgzones@googlemail.com>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: David Airlie <airlied@gmail.com>
Cc: Eric Paris <eparis@parisplace.org>
Cc: Felix Kuehling <felix.kuehling@amd.com>
Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/events/core.c |   33 +++++++++++----------------------
 1 file changed, 11 insertions(+), 22 deletions(-)

--- a/kernel/events/core.c~perf-core-use-vma_is_initial_stack-and-vma_is_initial_heap
+++ a/kernel/events/core.c
@@ -8631,7 +8631,7 @@ static void perf_event_mmap_event(struct
 	unsigned int size;
 	char tmp[16];
 	char *buf = NULL;
-	char *name;
+	char *name = NULL;
 
 	if (vma->vm_flags & VM_READ)
 		prot |= PROT_READ;
@@ -8678,29 +8678,18 @@ static void perf_event_mmap_event(struct
 
 		goto got_name;
 	} else {
-		if (vma->vm_ops && vma->vm_ops->name) {
+		if (vma->vm_ops && vma->vm_ops->name)
 			name = (char *) vma->vm_ops->name(vma);
-			if (name)
-				goto cpy_name;
+		if (!name)
+			name = (char *)arch_vma_name(vma);
+		if (!name) {
+			if (vma_is_initial_heap(vma))
+				name = "[heap]";
+			else if (vma_is_initial_stack(vma))
+				name = "[stack]";
+			else
+				name = "//anon";
 		}
-
-		name = (char *)arch_vma_name(vma);
-		if (name)
-			goto cpy_name;
-
-		if (vma->vm_start <= vma->vm_mm->start_brk &&
-				vma->vm_end >= vma->vm_mm->brk) {
-			name = "[heap]";
-			goto cpy_name;
-		}
-		if (vma->vm_start <= vma->vm_mm->start_stack &&
-				vma->vm_end >= vma->vm_mm->start_stack) {
-			name = "[stack]";
-			goto cpy_name;
-		}
-
-		name = "//anon";
-		goto cpy_name;
 	}
 
 cpy_name:
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-remove-arguments-of-show_mem.patch
mm-make-show_free_areas-static.patch
mm-factor-out-vma-stack-and-heap-checks.patch
drm-amdkfd-use-vma_is_initial_stack-and-vma_is_initial_heap.patch
selinux-use-vma_is_initial_stack-and-vma_is_initial_heap.patch
perf-core-use-vma_is_initial_stack-and-vma_is_initial_heap.patch

