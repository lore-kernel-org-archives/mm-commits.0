Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E5E1C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 21:10:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbiEJVK0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 17:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbiEJVKZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 17:10:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DAA0293B67
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 14:10:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40013B81FE8
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 21:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF10AC385CA;
        Tue, 10 May 2022 21:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652217021;
        bh=CFu/ZastalVTnjLcGsmKD2EEK5XnaWnfgHr52pAfCrw=;
        h=Date:To:From:Subject:From;
        b=FVXh80zic/EHo0m2q1J0WddExaeLHenl03RiHz3Nq1nQHP/qVOUVMAYI2WI05i+D8
         uLsp13tXrZE/V7evrMjYHBzoh/cXWJs/dRar9Nko5pe2aN+lwAJ3quuSl7slAWpZJo
         CseAsPxirA5kxF1plohy0zlOXID5Pnf7RLEnZYDA=
Date:   Tue, 10 May 2022 14:10:20 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
        vbabka@suse.cz, tytso@mit.edu, songliubraving@fb.com,
        song@kernel.org, riel@surriel.com, linmiaohe@huawei.com,
        kirill.shutemov@linux.intel.com, shy828301@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + sched-coredumph-clarify-the-use-of-mmf_vm_hugepage.patch added to mm-unstable branch
Message-Id: <20220510211020.DF10AC385CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sched: coredump.h: clarify the use of MMF_VM_HUGEPAGE
has been added to the -mm mm-unstable branch.  Its filename is
     sched-coredumph-clarify-the-use-of-mmf_vm_hugepage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sched-coredumph-clarify-the-use-of-mmf_vm_hugepage.patch

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
From: Yang Shi <shy828301@gmail.com>
Subject: sched: coredump.h: clarify the use of MMF_VM_HUGEPAGE

Patch series "Make khugepaged collapse readonly FS THP more consistent", v4.

The readonly FS THP relies on khugepaged to collapse THP for suitable
vmas.  But the behavior is inconsistent for "always" mode
(https://lore.kernel.org/linux-mm/00f195d4-d039-3cf2-d3a1-a2c88de397a0@suse.cz/).

The "always" mode means THP allocation should be tried all the time and
khugepaged should try to collapse THP all the time.  Of course the
allocation and collapse may fail due to other factors and conditions.

Currently file THP may not be collapsed by khugepaged even though all the
conditions are met.  That does break the semantics of "always" mode.

So make sure readonly FS vmas are registered to khugepaged to fix the
break.

Register suitable vmas in common mmap path, that could cover both readonly
FS vmas and shmem vmas, so remove the khugepaged calls in shmem.c.

The patch 1-7 are minor bug fixes, clean up and preparation patches. 
Patch 8 is the real meat.  

Tested with khugepaged test in selftests and the testcase provided by
Vlastimil Babka in
https://lore.kernel.org/lkml/df3b5d1c-a36b-2c73-3e27-99e74983de3a@suse.cz/
by commenting out MADV_HUGEPAGE call.


This patch (of 8):

MMF_VM_HUGEPAGE is set as long as the mm is available for khugepaged by
khugepaged_enter(), not only when VM_HUGEPAGE is set on vma.  Correct the
comment to avoid confusion.

Link: https://lkml.kernel.org/r/20220510203222.24246-1-shy828301@gmail.com
Link: https://lkml.kernel.org/r/20220510203222.24246-2-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Song Liu <song@kernel.org>
Acked-by: Vlastmil Babka <vbabka@suse.cz>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Zi Yan <ziy@nvidia.com>
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

sched-coredumph-clarify-the-use-of-mmf_vm_hugepage.patch
mm-khugepaged-remove-redundant-check-for-vm_no_khugepaged.patch
mm-khugepaged-skip-dax-vma.patch
mm-thp-only-regular-file-could-be-thp-eligible.patch
mm-khugepaged-make-khugepaged_enter-void-function.patch
mm-khugepaged-make-hugepage_vma_check-non-static.patch
mm-khugepaged-introduce-khugepaged_enter_vma-helper.patch
mm-mmap-register-suitable-readonly-file-vmas-for-khugepaged.patch

