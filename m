Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F2D8C43219
	for <mm-commits@archiver.kernel.org>; Wed, 27 Apr 2022 22:57:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234401AbiD0XAt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Apr 2022 19:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239397AbiD0W5x (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2022 18:57:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F33446E563
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 15:53:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D13D9B82AEA
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 22:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0C1C385A9;
        Wed, 27 Apr 2022 22:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651100024;
        bh=wRGhMmSwn+Ms/t7q69TU5J0DCJ5M64Q1U6sxIMWzQC0=;
        h=Date:To:From:Subject:From;
        b=bee2VY7P/EVZOARtyjYHfpdseYgOAhGjZ7lWMl4NLZSsKgdUih4K6sQzhBULyFxzO
         MbQ8Yb8EKFlNzvC9yCyyKVe2mUF3SdURiSejAKUnScKu3FXqR3/Bb6IllUqnn1Pvc2
         1S/qomXBSvqDRzWqCmeczzogMBsHJ4J/HtfAtUBo=
Date:   Wed, 27 Apr 2022 15:53:43 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
        vbabka@suse.cz, tytso@mit.edu, song@kernel.org, riel@surriel.com,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        shy828301@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] sched-coredumph-clarify-the-use-of-mmf_vm_hugepage.patch removed from -mm tree
Message-Id: <20220427225344.6F0C1C385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sched: coredump.h: clarify the use of MMF_VM_HUGEPAGE
has been removed from the -mm tree.  Its filename was
     sched-coredumph-clarify-the-use-of-mmf_vm_hugepage.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: sched: coredump.h: clarify the use of MMF_VM_HUGEPAGE

Patch series "Make khugepaged collapse readonly FS THP more consistent", v3.

The readonly FS THP relies on khugepaged to collapse THP for suitable
vmas.  But it is kind of "random luck" for khugepaged to see the readonly
FS vmas (see report:
https://lore.kernel.org/linux-mm/00f195d4-d039-3cf2-d3a1-a2c88de397a0@suse.cz/)
since currently the vmas are registered to khugepaged when:

  - Anon huge pmd page fault
  - VMA merge
  - MADV_HUGEPAGE
  - Shmem mmap

If the above conditions are not met, even though khugepaged is enabled it
won't see readonly FS vmas at all.  MADV_HUGEPAGE could be specified
explicitly to tell khugepaged to collapse this area, but when khugepaged
mode is "always" it should scan suitable vmas as long as VM_NOHUGEPAGE is
not set.

So make sure readonly FS vmas are registered to khugepaged to make the
behavior more consistent.

Registering suitable vmas in common mmap path, that could cover both
readonly FS vmas and shmem vmas, so removed the khugepaged calls in
shmem.c.

Patches 1 ~ 7 are minor bug fixes, clean up and preparation patches. 
Patch 8 is the real meat.  

Tested with khugepaged test in selftests and the testcase provided by
Vlastimil Babka in
https://lore.kernel.org/lkml/df3b5d1c-a36b-2c73-3e27-99e74983de3a@suse.cz/
by commenting out MADV_HUGEPAGE call.


This patch (of 8):

MMF_VM_HUGEPAGE is set as long as the mm is available for khugepaged by
khugepaged_enter(), not only when VM_HUGEPAGE is set on vma.  Correct the
comment to avoid confusion.

Link: https://lkml.kernel.org/r/20220404200250.321455-1-shy828301@gmail.com
Link: https://lkml.kernel.org/r/20220404200250.321455-2-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Song Liu <song@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/coredump.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/sched/coredump.h~sched-coredumph-clarify-the-use-of-mmf_vm_hugepage
+++ a/include/linux/sched/coredump.h
@@ -57,7 +57,8 @@ static inline int get_dumpable(struct mm
 #endif
 					/* leave room for more dump flags */
 #define MMF_VM_MERGEABLE	16	/* KSM may merge identical pages */
-#define MMF_VM_HUGEPAGE		17	/* set when VM_HUGEPAGE is set on vma */
+#define MMF_VM_HUGEPAGE		17	/* set when mm is available for
+					   khugepaged */
 /*
  * This one-shot flag is dropped due to necessity of changing exe once again
  * on NFS restore
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-khugepaged-remove-redundant-check-for-vm_no_khugepaged.patch
mm-khugepaged-skip-dax-vma.patch
mm-thp-only-regular-file-could-be-thp-eligible.patch
mm-khugepaged-make-khugepaged_enter-void-function.patch
mm-khugepaged-move-some-khugepaged_-functions-to-khugepagedc.patch
mm-khugepaged-introduce-khugepaged_enter_vma-helper.patch
mm-mmap-register-suitable-readonly-file-vmas-for-khugepaged.patch

