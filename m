Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 464C6C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  1 Jun 2022 22:23:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbiFAWXP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Jun 2022 18:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232229AbiFAWXP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jun 2022 18:23:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37CC8C2C
        for <mm-commits@vger.kernel.org>; Wed,  1 Jun 2022 15:23:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2920614B0
        for <mm-commits@vger.kernel.org>; Wed,  1 Jun 2022 22:23:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EB65C385A5;
        Wed,  1 Jun 2022 22:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654122191;
        bh=74d5hEKKGp34aZrpAp95Wb+pCq5NpFsvMlhXHvEFUQc=;
        h=Date:To:From:Subject:From;
        b=R0/KOB6AaokQ16uEpI4qszTSOrQYRMSBtFg0EkH2GGNzpxQhsjaNRNtr6XW7KpeRR
         YlJV2iM9Ocjdfd3AyWevk1zg2mENsBAi3KI7on4OgQujj2M+Gm7iuQrD3SahckI0Om
         SbgBhkKI/h/dCNpp2CfvKJ8JAsFauymQw+Gs48OU=
Date:   Wed, 01 Jun 2022 15:23:10 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-drop-oom-code-from-exit_mmap-fix-fix.patch added to mm-unstable branch
Message-Id: <20220601222311.2EB65C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-drop-oom-code-from-exit_mmap-fix-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-drop-oom-code-from-exit_mmap-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-drop-oom-code-from-exit_mmap-fix-fix.patch

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
@@ -3171,13 +3171,13 @@ void exit_mmap(struct mm_struct *mm)
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
 
@@ -3187,6 +3187,7 @@ void exit_mmap(struct mm_struct *mm)
 	/* update_hiwater_rss(mm) here? but nobody should be looking */
 	/* Use ULONG_MAX here to ensure all VMAs in the mm are unmapped */
 	unmap_vmas(&tlb, &mm->mm_mt, vma, 0, ULONG_MAX);
+	mmap_read_unlock(mm);
 
 	/*
 	 * Set MMF_OOM_SKIP to hide this task from the oom killer/reaper
@@ -3194,6 +3195,7 @@ void exit_mmap(struct mm_struct *mm)
 	 * mm_is_oom_victim because setting a bit unconditionally is cheaper.
 	 */
 	set_bit(MMF_OOM_SKIP, &mm->flags);
+	mmap_write_unlock(mm);
 	free_pgtables(&tlb, &mm->mm_mt, vma, FIRST_USER_ADDRESS,
 		      USER_PGTABLES_CEILING);
 	tlb_finish_mmu(&tlb);
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
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
squashfs-implement-readahead-checkpatch-fixes.patch

