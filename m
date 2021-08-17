Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C122C432BE
	for <mm-commits@archiver.kernel.org>; Tue, 17 Aug 2021 20:10:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 858C161056
	for <mm-commits@archiver.kernel.org>; Tue, 17 Aug 2021 20:10:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233763AbhHQULZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 17 Aug 2021 16:11:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:52092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233841AbhHQULY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 17 Aug 2021 16:11:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A16E26109F;
        Tue, 17 Aug 2021 20:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629231050;
        bh=stcp/SnCVmqLFnhvqwmbNSgUkh4iEDW2lQbfny2yuG0=;
        h=Date:From:To:Subject:From;
        b=KKfi14fEVRDgNYPp6cHEUiTHV9H+t39dC5SpuPjfEQl/i2hcxzPLKBvz2Jl/VcRTn
         wnQ30d9BVgnx/MsRMKs28UA+exi0suq37UpKFvthrM2gIzHxuOMyYnY7WlxuHzziiB
         qHwOgX2s88Lgz2uP6CeKYprQnEWvhLU2xeuYCuN0=
Date:   Tue, 17 Aug 2021 13:10:50 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        shy828301@gmail.com, shakeelb@google.com, riel@surriel.com,
        mike.kravetz@oracle.com, mhocko@suse.com, linmiaohe@huawei.com,
        kirill.shutemov@linux.intel.com, hughd@google.com
Subject:  +
 huge-tmpfs-revert-shmems-use-of-transhuge_vma_enabled.patch added to -mm tree
Message-ID: <20210817201050.e6Uxg%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: huge tmpfs: revert shmem's use of transhuge_vma_enabled()
has been added to the -mm tree.  Its filename is
     huge-tmpfs-revert-shmems-use-of-transhuge_vma_enabled.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/huge-tmpfs-revert-shmems-use-of-transhuge_vma_enabled.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/huge-tmpfs-revert-shmems-use-of-transhuge_vma_enabled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: huge tmpfs: revert shmem's use of transhuge_vma_enabled()

5.14 commit e6be37b2e7bd ("mm/huge_memory.c: add missing read-only THP
checking in transparent_hugepage_enabled()") added transhuge_vma_enabled()
as a wrapper for two very different checks (one check is whether the app
has marked its address range not to use THPs, the other check is whether
the app is running in a hierarchy that has been marked never to use THPs).
shmem_huge_enabled() prefers to show those two checks explicitly, as
before.

Link: https://lkml.kernel.org/r/45e5338-18d-c6f9-c17e-34f510bc1728@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/shmem.c~huge-tmpfs-revert-shmems-use-of-transhuge_vma_enabled
+++ a/mm/shmem.c
@@ -3987,7 +3987,8 @@ bool shmem_huge_enabled(struct vm_area_s
 	loff_t i_size;
 	pgoff_t off;
 
-	if (!transhuge_vma_enabled(vma, vma->vm_flags))
+	if ((vma->vm_flags & VM_NOHUGEPAGE) ||
+	    test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags))
 		return false;
 	if (shmem_huge == SHMEM_HUGE_FORCE)
 		return true;
_

Patches currently in -mm which might be from hughd@google.com are

fs-mm-fix-race-in-unlinking-swapfile.patch
huge-tmpfs-fix-fallocatevanilla-advance-over-huge-pages.patch
huge-tmpfs-fix-split_huge_page-after-falloc_fl_keep_size.patch
huge-tmpfs-remove-shrinklist-addition-from-shmem_setattr.patch
huge-tmpfs-revert-shmems-use-of-transhuge_vma_enabled.patch
huge-tmpfs-move-shmem_huge_enabled-upwards.patch
huge-tmpfs-sgp_noalloc-to-stop-collapse_file-on-race.patch
huge-tmpfs-shmem_is_hugevma-inode-index.patch
huge-tmpfs-decide-statst_blksize-by-shmem_is_huge.patch
shmem-shmem_writepage-split-unlikely-i915-thp.patch

