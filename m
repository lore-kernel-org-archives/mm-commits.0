Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DBECEE49A6
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:42:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbjHUUmA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbjHUUk6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:40:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62001CDE
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:40:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 439D561B8D
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:40:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98BDAC433C8;
        Mon, 21 Aug 2023 20:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650435;
        bh=clohcsegEZpqjs0k4OpBW9wE0XfdABo1C/wR8uI+Jtg=;
        h=Date:To:From:Subject:From;
        b=WjrNYT+3IHV0x+b+jYuoKzgOklrru/ujcov0mpceKBDMVxqQJI2jnQbbFCEPpbntX
         UTAwpwdFoZC+bIA2KThU53GZ00NDVQM054A834y5Bl0/sPcnRMAWHfnR7Fkqo4jHcm
         ZX80SOXQE37ilpAvvWxPkAiISFRstYVzX1Fk1+Yc=
Date:   Mon, 21 Aug 2023 13:40:35 -0700
To:     mm-commits@vger.kernel.org, torvalds@linuxfoundation.org,
        Liam.Howlett@oracle.com, jannh@google.com, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-replace-mmap-with-vma-write-lock-assertions-when-operating-on-a-vma.patch removed from -mm tree
Message-Id: <20230821204035.98BDAC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: replace mmap with vma write lock assertions when operating on a vma
has been removed from the -mm tree.  Its filename was
     mm-replace-mmap-with-vma-write-lock-assertions-when-operating-on-a-vma.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -5029,7 +5029,7 @@ int copy_hugetlb_page_range(struct mm_st
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

swap-remove-remnants-of-polling-from-read_swap_cache_async.patch
mm-add-missing-vm_fault_result_trace-name-for-vm_fault_completed.patch
mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed.patch
mm-change-folio_lock_or_retry-to-use-vm_fault-directly.patch
mm-handle-swap-page-faults-under-per-vma-lock.patch
mm-handle-userfaults-under-vma-lock.patch
mm-handle-userfaults-under-vma-lock-fix.patch

