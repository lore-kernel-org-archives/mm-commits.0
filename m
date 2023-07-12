Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92718C001DD
	for <mm-commits@archiver.kernel.org>; Wed, 12 Jul 2023 18:25:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232047AbjGLSZg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Jul 2023 14:25:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbjGLSZe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2023 14:25:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58BAF1FE3
        for <mm-commits@vger.kernel.org>; Wed, 12 Jul 2023 11:25:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8FF7618CE
        for <mm-commits@vger.kernel.org>; Wed, 12 Jul 2023 18:25:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4820DC433C7;
        Wed, 12 Jul 2023 18:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689186331;
        bh=AezrYvIfSMY4vvlxJtjrmBr1JGgLxQMkZWfuwGy7L5E=;
        h=Date:To:From:Subject:From;
        b=IXBTty56ttA2eie/1+gpASGw/AzTiqFYErUbNhC4RZ9uo1zvxtlfh75iwQpMf2yXJ
         G5XvNaoJSXbPNJcAHe97W0CYVwKXq1PgFw7lzsYq887p6BVX9IkbGYZXREC4t8pvCc
         lxMQOct6xjk02Xi1GmRNOXymxwooLGRpA2W62AZE=
Date:   Wed, 12 Jul 2023 11:25:30 -0700
To:     mm-commits@vger.kernel.org, peterz@infradead.org, acme@kernel.org,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + perf-core-use-vma_is_stack-and-vma_is_heap.patch added to mm-unstable branch
Message-Id: <20230712182531.4820DC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: perf/core: use vma_is_stack() and vma_is_heap()
has been added to the -mm mm-unstable branch.  Its filename is
     perf-core-use-vma_is_stack-and-vma_is_heap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/perf-core-use-vma_is_stack-and-vma_is_heap.patch

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
Subject: perf/core: use vma_is_stack() and vma_is_heap()
Date: Wed, 12 Jul 2023 22:38:31 +0800

Use the helpers to simplify code, also kill unneeded goto cpy_name.

Link: https://lkml.kernel.org/r/20230712143831.120701-6-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/events/core.c |   22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

--- a/kernel/events/core.c~perf-core-use-vma_is_stack-and-vma_is_heap
+++ a/kernel/events/core.c
@@ -8685,22 +8685,14 @@ static void perf_event_mmap_event(struct
 		}
 
 		name = (char *)arch_vma_name(vma);
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
+		if (!name) {
+			if (vma_is_heap(vma))
+				name = "[heap]";
+			else if (vma_is_stack(vma))
+				name = "[stack]";
+			else
+				name = "//anon";
 		}
-
-		name = "//anon";
-		goto cpy_name;
 	}
 
 cpy_name:
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-remove-arguments-of-show_mem.patch
mm-make-show_free_areas-static.patch
mm-introduce-vma_is_stack-and-vma_is_heap.patch
mm-use-vma_is_stack-and-vma_is_heap.patch
drm-amdkfd-use-vma_is_stack-and-vma_is_heap.patch
selinux-use-vma_is_stack-and-vma_is_heap.patch
perf-core-use-vma_is_stack-and-vma_is_heap.patch

