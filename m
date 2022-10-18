Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0616CC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 21:04:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbiJRVEC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Oct 2022 17:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbiJRVEB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2022 17:04:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF5D4193DC
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 14:04:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64708B81F7F
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 21:03:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06ED0C433C1;
        Tue, 18 Oct 2022 21:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666127038;
        bh=JZitrsTBK216QWcmL4np+CMxVaj5pyK33O48IH05WqU=;
        h=Date:To:From:Subject:From;
        b=dBBucGVVVb8veMVqzcuW+u0UXw1XoSyrMGD/tFT+H9c1YPvoqNoZgkX0JPiG3Gov3
         NvCOQAiW8oXF4whVDh+hE4NZ7a+GzbygBila+7uWJcIahUXbrVMTkfv/Ok4zNfTG4t
         2FB9WZURswlvwKv/faGUGTuIrAN6IBnFmtX3siuU=
Date:   Tue, 18 Oct 2022 14:03:57 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com, Liam.Howlett@Oracle.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmapc-__vma_adjust-suppress-unintialized-var-warning.patch added to mm-hotfixes-unstable branch
Message-Id: <20221018210358.06ED0C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: __vma_adjust(): suppress uninitialized var warning
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mmapc-__vma_adjust-suppress-unintialized-var-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmapc-__vma_adjust-suppress-unintialized-var-warning.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

mm-mmapc-__vma_adjust-suppress-unintialized-var-warning.patch
mm-hugetlb-convert-free_huge_page-to-folios-fix.patch
powerpc-ptrace-user_regset_copyin_ignore-always-returns-0-fix.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes-fix.patch

