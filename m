Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F35FC43460
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 01:13:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48DCB6161F
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 01:13:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbhEKBOW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 May 2021 21:14:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:46394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229934AbhEKBOV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 10 May 2021 21:14:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFA216157F;
        Tue, 11 May 2021 01:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620695595;
        bh=c9VPw3v8LGb7lHnQng7u34tD4JuTOyMuy6FoM5TokwE=;
        h=Date:From:To:Subject:From;
        b=E2RsXXozy4MMGPmXlX4X0e7Ea87UmczhvI6weBAGSgf3YjkAtvHPvJt5zFjqFGSaX
         qZHMuPOatjp/tIrw6G0CL/M/N2fOCVvGRXe9R+Uwbbd2hl9zh3sfIdBYeHKPJqBtpW
         QnVbyPEU5GRyeNxjj/gGWDighi5AsZnByMp79I9o=
Date:   Mon, 10 May 2021 18:13:15 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, liam.howlett@oracle.com,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  +
 mm-mmap-introduce-unlock_range-for-code-cleanup-fix.patch added to -mm tree
Message-ID: <20210511011315.XNrvF4gwF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mmap-introduce-unlock_range-for-code-cleanup-fix
has been added to the -mm tree.  Its filename is
     mm-mmap-introduce-unlock_range-for-code-cleanup-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mmap-introduce-unlock_range-for-code-cleanup-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mmap-introduce-unlock_range-for-code-cleanup-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-mmap-introduce-unlock_range-for-code-cleanup-fix

tweak code layout

Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mmap.c~mm-mmap-introduce-unlock_range-for-code-cleanup-fix
+++ a/mm/mmap.c
@@ -2802,8 +2802,8 @@ int split_vma(struct mm_struct *mm, stru
 	return __split_vma(mm, vma, addr, new_below);
 }
 
-static inline
-void unlock_range(struct vm_area_struct *start, unsigned long limit)
+static inline void
+unlock_range(struct vm_area_struct *start, unsigned long limit)
 {
 	struct mm_struct *mm = start->vm_mm;
 	struct vm_area_struct *tmp = start;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
mm-improve-mprotectrw-efficiency-on-pages-referenced-once-fix.patch
mm-mmap-introduce-unlock_range-for-code-cleanup-fix.patch
mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch
nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch
mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch

