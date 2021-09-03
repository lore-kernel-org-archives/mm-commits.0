Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C7F2C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:57:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0520460E9B
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:57:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350352AbhICU6C (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:58:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:56822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350309AbhICU6C (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:58:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E8BE601FD;
        Fri,  3 Sep 2021 20:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702621;
        bh=Vn4Zbb1WfuKeLBhhiu6258IzuLIU9q/4ATMI4vMR+6U=;
        h=Date:From:To:Subject:From;
        b=AGr9zuJGvZm05ppUoy3owJZI+JAMvkCqh6zKElM4gWxngz/HKeyjF8fAGmOT7Vvup
         a3pNspgis3wjH19JoYML4ihU5Hjqrw8NThTa/d5/Vdlh4kOCTKyJril9PNlpQHx55P
         hAWfCHzA+DgIzNiX/Z1TjULe+0397IiQWAK5nnYU=
Date:   Fri, 03 Sep 2021 13:57:01 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, kirill.shutemov@linux.intel.com,
        linmiaohe@huawei.com, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, riel@surriel.com, shakeelb@google.com,
        shy828301@gmail.com, willy@infradead.org
Subject:  [merged]
 huge-tmpfs-revert-shmems-use-of-transhuge_vma_enabled.patch removed from
 -mm tree
Message-ID: <20210903205701.0lBWvgFXo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: huge tmpfs: revert shmem's use of transhuge_vma_enabled()
has been removed from the -mm tree.  Its filename was
     huge-tmpfs-revert-shmems-use-of-transhuge_vma_enabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


