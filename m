Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 665D5C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  1 Jun 2022 22:09:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232120AbiFAWJC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Jun 2022 18:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232103AbiFAWJC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jun 2022 18:09:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D962022CEC0
        for <mm-commits@vger.kernel.org>; Wed,  1 Jun 2022 15:09:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61CFB6123E
        for <mm-commits@vger.kernel.org>; Wed,  1 Jun 2022 22:09:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1F0EC385A5;
        Wed,  1 Jun 2022 22:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654121339;
        bh=tk8W7gTll2/xrNeB2g2szqMrf37hTqHG+nr/tH5TOTY=;
        h=Date:To:From:Subject:From;
        b=IvU3G3JvBHQ7CpPVG6lrzGPqTHBqIFSuimqaO8Tz/CagogtC+FmEjTvtvKzlMjrzr
         AKG//khpq9BIg9rZ97MZ1Lg8U1ROfKyaXm+sIZ6g8zh7GzXd9/VmAyWr2mcPdIS66O
         73cC578/qMhKAp7iPjv/ep7mP0eJOpRe1rR6/PQ4=
Date:   Wed, 01 Jun 2022 15:08:58 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-drop-oom-code-from-exit_mmap-fix.patch added to mm-unstable branch
Message-Id: <20220601220859.B1F0EC385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-drop-oom-code-from-exit_mmap-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-drop-oom-code-from-exit_mmap-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-drop-oom-code-from-exit_mmap-fix.patch

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
Subject: mm-drop-oom-code-from-exit_mmap-fix
Date: Wed Jun  1 03:07:59 PM PDT 2022

fix it for presense of mapletree patchset, per Suren

Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/mmap.c~mm-drop-oom-code-from-exit_mmap-fix
+++ a/mm/mmap.c
@@ -3215,7 +3215,6 @@ void exit_mmap(struct mm_struct *mm)
 
 	trace_exit_mmap(mm);
 	__mt_destroy(&mm->mm_mt);
-	mm->mmap = NULL;
 	mmap_write_unlock(mm);
 	vm_unacct_memory(nr_accounted);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
mm-page_alloc-remotely-drain-per-cpu-lists-checkpatch-fixes.patch
mm-start-tracking-vmas-with-maple-tree-fix.patch
damon-convert-__damon_va_three_regions-to-use-the-vma-iterator-fix.patch
mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix-checkpatch-fixes.patch
mm-remove-the-vma-linked-list-fix-fix.patch
mm-handling-non-lru-pages-returned-by-vm_normal_pages-fix.patch
mm-introduce-clear_highpage_tagged-fix.patch
kasan-fix-zeroing-vmalloc-memory-with-hw_tags-fix.patch
mm-drop-oom-code-from-exit_mmap-fix.patch
squashfs-implement-readahead-checkpatch-fixes.patch

