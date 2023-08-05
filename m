Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D216C04E69
	for <mm-commits@archiver.kernel.org>; Sat,  5 Aug 2023 16:56:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbjHEQ4L (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 5 Aug 2023 12:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbjHEQ4K (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 5 Aug 2023 12:56:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B09F1BD
        for <mm-commits@vger.kernel.org>; Sat,  5 Aug 2023 09:56:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10D7460AFE
        for <mm-commits@vger.kernel.org>; Sat,  5 Aug 2023 16:56:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64CDCC433C8;
        Sat,  5 Aug 2023 16:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691254568;
        bh=uKI+FR12arz+zSRMRdF87C5UMV47ICZhhGiBZajPO4Q=;
        h=Date:To:From:Subject:From;
        b=Je9oba2l7ejU33YeWzOq9xgGXc6GdPKvPq7qj26VF1e36gdNcNeWRPY8k1IY6Ts4h
         0OGp8N0xNyAGVaslaxMZLduUyTdIgrvUacpH8k8s9e0Ht3j/JMVPjXfUGONI/cQPVC
         TwtL0nMuAVk6TqNwoCqFZFfOiXp2d87qO0l8nF3c=
Date:   Sat, 05 Aug 2023 09:56:07 -0700
To:     mm-commits@vger.kernel.org, torvalds@linuxfoundation.org,
        Liam.Howlett@oracle.com, jannh@google.com, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-replace-mmap-with-vma-write-lock-assertions-when-operating-on-a-vma.patch added to mm-unstable branch
Message-Id: <20230805165608.64CDCC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: replace mmap with vma write lock assertions when operating on a vma
has been added to the -mm mm-unstable branch.  Its filename is
     mm-replace-mmap-with-vma-write-lock-assertions-when-operating-on-a-vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-replace-mmap-with-vma-write-lock-assertions-when-operating-on-a-vma.patch

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
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: replace mmap with vma write lock assertions when operating on a vma
Date: Fri, 4 Aug 2023 08:27:21 -0700

Vma write lock assertion always includes mmap write lock assertion and
additional vma lock checks when per-VMA locks are enabled. Replace
weaker mmap_assert_write_locked() assertions with stronger
vma_assert_write_locked() ones when we are operating on a vma which
is expected to be locked.

Link: https://lkml.kernel.org/r/20230804152724.3090321-4-surenb@google.com
Suggested-by: Jann Horn <jannh@google.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 mm/memory.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-replace-mmap-with-vma-write-lock-assertions-when-operating-on-a-vma
+++ a/mm/hugetlb.c
@@ -5056,7 +5056,7 @@ int copy_hugetlb_page_range(struct mm_st
 					src_vma->vm_start,
 					src_vma->vm_end);
 		mmu_notifier_invalidate_range_start(&range);
-		mmap_assert_write_locked(src);
+		vma_assert_write_locked(src_vma);
 		raw_write_seqcount_begin(&src->write_protect_seq);
 	} else {
 		/*
--- a/mm/memory.c~mm-replace-mmap-with-vma-write-lock-assertions-when-operating-on-a-vma
+++ a/mm/memory.c
@@ -1312,7 +1312,7 @@ copy_page_range(struct vm_area_struct *d
 		 * Use the raw variant of the seqcount_t write API to avoid
 		 * lockdep complaining about preemptibility.
 		 */
-		mmap_assert_write_locked(src_mm);
+		vma_assert_write_locked(src_vma);
 		raw_write_seqcount_begin(&src_mm->write_protect_seq);
 	}
 
_

Patches currently in -mm which might be from surenb@google.com are

mm-enable-page-walking-api-to-lock-vmas-during-the-walk.patch
swap-remove-remnants-of-polling-from-read_swap_cache_async.patch
mm-add-missing-vm_fault_result_trace-name-for-vm_fault_completed.patch
mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed.patch
mm-change-folio_lock_or_retry-to-use-vm_fault-directly.patch
mm-handle-swap-page-faults-under-per-vma-lock.patch
mm-handle-userfaults-under-vma-lock.patch
mm-handle-userfaults-under-vma-lock-fix.patch
mm-for-config_per_vma_lock-equate-write-lock-assertion-for-vma-and-mmap.patch
mm-replace-mmap-with-vma-write-lock-assertions-when-operating-on-a-vma.patch
mm-lock-vma-explicitly-before-doing-vm_flags_reset-and-vm_flags_reset_once.patch
mm-always-lock-new-vma-before-inserting-into-vma-tree.patch
mm-move-vma-locking-out-of-vma_prepare-and-dup_anon_vma.patch

