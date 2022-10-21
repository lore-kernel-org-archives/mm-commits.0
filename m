Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73CAAC43217
	for <mm-commits@archiver.kernel.org>; Fri, 21 Oct 2022 04:35:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiJUEfN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Oct 2022 00:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiJUEe4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Oct 2022 00:34:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 807541F618
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 21:34:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B19161DB3
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 04:34:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E0F3C433B5;
        Fri, 21 Oct 2022 04:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666326890;
        bh=38VvYWOj/KHKF+TyiKKqbfURgTIxe8OuB07vHg2DvDk=;
        h=Date:To:From:Subject:From;
        b=pyCOi4ND9Yjeb3MjFinQJ2VAgDnyVd30qEXzimqmykV1LkfqUQcAnEf7WMHyfpRpm
         z9HYvit+YRP/5jKZb++Rrak01uQiAC9l826D8QljgKZ4UA2ERSrOF9W3Cz2+K/hgOO
         8JCsZjtN6/v/sgP27N8ljhNi9WEuQlG6cdZc5MLk=
Date:   Thu, 20 Oct 2022 21:34:49 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com, Liam.Howlett@Oracle.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mmapc-__vma_adjust-suppress-unintialized-var-warning.patch removed from -mm tree
Message-Id: <20221021043450.6E0F3C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap.c: __vma_adjust(): suppress uninitialized var warning
has been removed from the -mm tree.  Its filename was
     mm-mmapc-__vma_adjust-suppress-unintialized-var-warning.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/mmap.c: __vma_adjust(): suppress uninitialized var warning
Date: Tue Oct 18 01:57:37 PM PDT 2022

The code is OK, but it fools gcc.

mm/mmap.c:802 __vma_adjust() error: uninitialized symbol 'next_next'.

Fixes: 524e00b36e8c5 ("mm: remove rb tree.")
Reported-by: kernel test robot <lkp@intel.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/mmap.c~mm-mmapc-__vma_adjust-suppress-unintialized-var-warning
+++ a/mm/mmap.c
@@ -618,7 +618,8 @@ int __vma_adjust(struct vm_area_struct *
 	struct vm_area_struct *expand)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	struct vm_area_struct *next_next, *next = find_vma(mm, vma->vm_end);
+	struct vm_area_struct *next_next = NULL;	/* uninit var warning */
+	struct vm_area_struct *next = find_vma(mm, vma->vm_end);
 	struct vm_area_struct *orig_vma = vma;
 	struct address_space *mapping = NULL;
 	struct rb_root_cached *root = NULL;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

ipc-msgc-fix-percpu_counter-use-after-free.patch
mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios-fix.patch
mm-hugetlb-convert-free_huge_page-to-folios-fix.patch
vmalloc-add-reviewers-for-vmalloc-code-checkpatch-fixes.patch
powerpc-ptrace-user_regset_copyin_ignore-always-returns-0-fix.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes-fix.patch
proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v3-fix.patch

