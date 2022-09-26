Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5098C32771
	for <mm-commits@archiver.kernel.org>; Mon, 26 Sep 2022 21:03:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbiIZVD6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 17:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231303AbiIZVDv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 17:03:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FB33A1D3E
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 14:03:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A112CB80AE8
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 21:03:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56C88C433C1;
        Mon, 26 Sep 2022 21:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664226227;
        bh=adexIy7O8pwKcYcpatrGz0exQOwYY0zwRBH3zuwsP5U=;
        h=Date:To:From:Subject:From;
        b=OZeEMgrUfsQWGzsxxz8JOFXaxYYJ67xDFMU0634ate/OU6hUCf7GlTfGp0JWORl0N
         8pWXZgae2Agbt2ar6KMsHOUddOYUTgwgtLBcyrsypWE9aepBW7hZthF+FgF1mBTwA1
         kuU6396+NioE7cST138CY4BA4oVQiuEkekeLOCXg=
Date:   Mon, 26 Sep 2022 14:03:46 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-drop-oom-code-from-exit_mmap-fix-fix.patch removed from -mm tree
Message-Id: <20220926210347.56C88C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-drop-oom-code-from-exit_mmap-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-drop-oom-code-from-exit_mmap-fix-fix.patch

This patch was dropped because it was folded into mm-drop-oom-code-from-exit_mmap.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-drop-oom-code-from-exit_mmap-fix-fix
Date: Wed Jun  1 03:17:52 PM PDT 2022

restore Suren's mmap_read_lock() optimization

Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/mmap.c~mm-drop-oom-code-from-exit_mmap-fix-fix
+++ a/mm/mmap.c
@@ -3085,13 +3085,13 @@ void exit_mmap(struct mm_struct *mm)
 	/* mm's last user has gone, and its about to be pulled down */
 	mmu_notifier_release(mm);
 
-	mmap_write_lock(mm);
+	mmap_read_lock(mm);
 	arch_exit_mmap(mm);
 
 	vma = mas_find(&mas, ULONG_MAX);
 	if (!vma) {
 		/* Can happen if dup_mmap() received an OOM */
-		mmap_write_unlock(mm);
+		mmap_read_unlock(mm);
 		return;
 	}
 
@@ -3101,6 +3101,7 @@ void exit_mmap(struct mm_struct *mm)
 	/* update_hiwater_rss(mm) here? but nobody should be looking */
 	/* Use ULONG_MAX here to ensure all VMAs in the mm are unmapped */
 	unmap_vmas(&tlb, &mm->mm_mt, vma, 0, ULONG_MAX);
+	mmap_read_unlock(mm);
 
 	/*
 	 * Set MMF_OOM_SKIP to hide this task from the oom killer/reaper
@@ -3108,6 +3109,7 @@ void exit_mmap(struct mm_struct *mm)
 	 * mm_is_oom_victim because setting a bit unconditionally is cheaper.
 	 */
 	set_bit(MMF_OOM_SKIP, &mm->flags);
+	mmap_write_lock(mm);
 	free_pgtables(&tlb, &mm->mm_mt, vma, FIRST_USER_ADDRESS,
 		      USER_PGTABLES_CEILING);
 	tlb_finish_mmu(&tlb);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-drop-oom-code-from-exit_mmap.patch
mm-delete-unused-mmf_oom_victim-flag-fix.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree-fix.patch
mm-vmscan-fix-a-lot-of-comments-vs-mglru.patch
swap-add-swap_cache_get_folio-fix.patch
memcg-reduce-size-of-memcg-vmstats-structures-fix.patch
mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme-fix.patch
mm-page_allocc-rename-check_free_page-to-free_page_is_bad.patch
mm-page_allocc-rename-check_free_page-to-free_page_is_bad-fix.patch
mm-page_allocc-document-bulkfree_pcp_prepare-return-value.patch
fs-uninline-inode_maybe_inc_iversion.patch
ipc-msg-mitigate-the-lock-contention-with-percpu-counter-checkpatch-fixes.patch
ipc-msg-mitigate-the-lock-contention-with-percpu-counter-fix-fix.patch

