Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94069C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 15 Jun 2022 23:06:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238604AbiFOXGD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Jun 2022 19:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346086AbiFOXGD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Jun 2022 19:06:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D517824BD9
        for <mm-commits@vger.kernel.org>; Wed, 15 Jun 2022 16:06:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 799E361994
        for <mm-commits@vger.kernel.org>; Wed, 15 Jun 2022 23:06:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4240C3411A;
        Wed, 15 Jun 2022 23:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655334361;
        bh=2PTgetWCtJg/UoQpKvYsmk1KrYJb7mO3cAGz62GD9/Y=;
        h=Date:To:From:Subject:From;
        b=IQ9WI5ttZIlvt9gd+SlyAcjwcEm9/bllr1v7yfDP98tdNZMJycSpTr+M9MXQrKgEu
         /ZXzLyHNvLExuyOjcKjI20ukN03wc/Bmgr1ZD2CJVoFMC/CuO8uFh0WFXjpKg8IFXX
         OSeqCujYSrD8HFdbvegECaidKpTa2/zwREfDOoDQ=
Date:   Wed, 15 Jun 2022 16:06:01 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, nsaenzju@redhat.com,
        mtosatti@redhat.com, minchan@kernel.org, mhocko@kernel.org,
        mgorman@techsingularity.net, hughd@google.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-replace-local_lock-with-normal-spinlock-fix.patch added to mm-unstable branch
Message-Id: <20220615230601.C4240C3411A@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-replace-local_lock-with-normal-spinlock-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-replace-local_lock-with-normal-spinlock-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-replace-local_lock-with-normal-spinlock-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_alloc-replace-local_lock-with-normal-spinlock-fix
Date: Wed Jun 15 04:00:27 PM PDT 2022

maybe fix pcpu_spin_trylock_irqsave()

Cc: Hugh Dickins <hughd@google.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nicolas Saenz Julienne <nsaenzju@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-replace-local_lock-with-normal-spinlock-fix
+++ a/mm/page_alloc.c
@@ -183,8 +183,10 @@ static DEFINE_MUTEX(pcp_batch_high_lock)
 	type *_ret;							\
 	pcpu_task_pin();						\
 	_ret = this_cpu_ptr(ptr);					\
-	if (!spin_trylock_irqsave(&_ret->member, flags))		\
+	if (!spin_trylock_irqsave(&_ret->member, flags)) {		\
+		pcpu_task_unpin();					\
 		_ret = NULL;						\
+	}								\
 	_ret;								\
 })
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maintainers-update-tree-references.patch
mm-start-tracking-vmas-with-maple-tree-fix.patch
damon-convert-__damon_va_three_regions-to-use-the-vma-iterator-fix.patch
mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix-checkpatch-fixes.patch
mm-remove-the-vma-linked-list-fix-fix.patch
mm-remove-the-vma-linked-list-fix-fix-fix.patch
mm-handling-non-lru-pages-returned-by-vm_normal_pages-fix.patch
mm-shrinkers-introduce-debugfs-interface-for-memory-shrinkers-fix.patch
mm-shrinkers-add-scan-interface-for-shrinker-debugfs-fix-fix.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
mm-factor-helpers-for-memory_failure_dev_pagemap-fix.patch
xfs-support-cow-in-fsdax-mode-fix.patch
mm-page_alloc-replace-local_lock-with-normal-spinlock-fix.patch

