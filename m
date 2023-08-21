Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB83FEE49A5
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:39:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbjHUUjp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbjHUUjb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:39:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1749B136
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:39:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1C8D64A31
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:39:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF9A8C433C7;
        Mon, 21 Aug 2023 20:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650366;
        bh=XpyFhaWI0Hmuw8LrUigx63aT7TRyU6o1eXAQiMB/44M=;
        h=Date:To:From:Subject:From;
        b=DVsAnVMcTK2+EkJGWsrPWaGs4gRydeUP6LtJC8FmlyCFRTgmu0jABIaOn4YkTZnVA
         moK7671l0g6MCZfVqGD6XEDrgGJT5K4PWwPZccKGE954yoQHLTlFRsAtvgzF5qgcR7
         EDn9/0vjR+K21zmSk5aoRN0+fHamyngFWB1wYGhA=
Date:   Mon, 21 Aug 2023 13:39:25 -0700
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com,
        stephen.smalley.work@gmail.com, peterz@infradead.org,
        paul@paul-moore.com, felix.kuehling@amd.com, eparis@parisplace.org,
        david@redhat.com, daniel@ffwll.ch, christian.koenig@amd.com,
        cgzones@googlemail.com, alexander.deucher@amd.com,
        airlied@gmail.com, acme@kernel.org, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] perf-core-use-vma_is_initial_stack-and-vma_is_initial_heap.patch removed from -mm tree
Message-Id: <20230821203925.EF9A8C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: perf/core: use vma_is_initial_stack() and vma_is_initial_heap()
has been removed from the -mm tree.  Its filename was
     perf-core-use-vma_is_initial_stack-and-vma_is_initial_heap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: perf/core: use vma_is_initial_stack() and vma_is_initial_heap()
Date: Fri, 28 Jul 2023 13:00:43 +0800

Use the helpers to simplify code, also kill unneeded goto cpy_name.

Link: https://lkml.kernel.org/r/20230728050043.59880-5-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
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


