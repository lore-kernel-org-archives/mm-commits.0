Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1471C43334
	for <mm-commits@archiver.kernel.org>; Wed, 22 Jun 2022 02:19:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355997AbiFVCTo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Jun 2022 22:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232438AbiFVCTn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jun 2022 22:19:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C243531220
        for <mm-commits@vger.kernel.org>; Tue, 21 Jun 2022 19:19:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 729C5B81C02
        for <mm-commits@vger.kernel.org>; Wed, 22 Jun 2022 02:19:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB66C3411C;
        Wed, 22 Jun 2022 02:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655864380;
        bh=OJqFXnk9hH+ndXAFmc/cfz14K8qNoVjzXN4ZRuUUcw8=;
        h=Date:To:From:Subject:From;
        b=WEVW9pK2PDSb2z/M1bQzuzdQmXnigpvhp1a7lBwtMb4s7phr/+9ezpp5VGQ1WYiWz
         Y7KOLwVy4XwjJYVKBDqUJmA0mlu5PTvsWcK2ySs9BNxRQYODOY09Oq0hk22lWjQdkw
         dOW4f6SOYo+ZEcgM1EyukYk/ibL2/z8bKLjIhQTg=
Date:   Tue, 21 Jun 2022 19:19:39 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, tkjos@android.com,
        surenb@google.com, minchan@kernel.org, maco@android.com,
        Liam.Howlett@oracle.com, joel@joelfernandes.org, hridya@google.com,
        gregkh@linuxfoundation.org, brauner@kernel.org,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + android-binder-stop-saving-a-pointer-to-the-vma-fix.patch added to mm-unstable branch
Message-Id: <20220622021940.0BB66C3411C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: android-binder-stop-saving-a-pointer-to-the-vma-fix
has been added to the -mm mm-unstable branch.  Its filename is
     android-binder-stop-saving-a-pointer-to-the-vma-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/android-binder-stop-saving-a-pointer-to-the-vma-fix.patch

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
Subject: android-binder-stop-saving-a-pointer-to-the-vma-fix
Date: Tue Jun 21 07:16:17 PM PDT 2022

fix drivers/android/binder_alloc_selftest.c

drivers/android/binder_alloc_selftest.c: In function 'binder_selftest_alloc':
drivers/android/binder_alloc_selftest.c:290:43: error: 'struct binder_alloc' has no member named 'vma'
  290 |         if (!binder_selftest_run || !alloc->vma)


Cc: Christian Brauner (Microsoft) <brauner@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hridya Valsaraju <hridya@google.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Martijn Coenen <maco@android.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Todd Kjos <tkjos@android.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/android/binder_alloc_selftest.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/android/binder_alloc_selftest.c~android-binder-stop-saving-a-pointer-to-the-vma-fix
+++ a/drivers/android/binder_alloc_selftest.c
@@ -287,7 +287,7 @@ void binder_selftest_alloc(struct binder
 	if (!binder_selftest_run)
 		return;
 	mutex_lock(&binder_selftest_lock);
-	if (!binder_selftest_run || !alloc->vma)
+	if (!binder_selftest_run || !alloc->vma_addr)
 		goto done;
 	pr_info("STARTED\n");
 	binder_selftest_alloc_offset(alloc, end_offset, 0);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

android-binder-stop-saving-a-pointer-to-the-vma-fix.patch
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
mm-thp-kill-transparent_hugepage_active-fix.patch
mm-convert-destroy_compound_page-to-destroy_large_folio-fix.patch
mm-madvise-minor-cleanup-for-swapin_walk_pmd_entry-fix.patch
mm-docs-fix-comments-that-mention-mem_hotplug_end-fix.patch

