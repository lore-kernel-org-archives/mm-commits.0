Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B281C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  4 Apr 2022 23:38:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbiDDXkK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Apr 2022 19:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiDDXkJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Apr 2022 19:40:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42FE262BD7
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 16:38:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C07A1616EA
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 23:37:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F732C2BBE4;
        Mon,  4 Apr 2022 23:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649115479;
        bh=GGbh2QXdpeS/76Mc1kEQopefwIeGJY4yFUFPYzIOShQ=;
        h=Date:To:From:Subject:From;
        b=U882mzeNnXxcAD6LadsJG1Hdk9Q5nHzoi8vle37zFNFvJ/YyG9lQXOWe0/2R1Kb/R
         ih7wNtU4lqfoyy66bpkeHWnCAPlCtVX6LBzru3+78dTMXisUaiJVGQs69bW7NToDaX
         BqmJs5yvHgztUZqdqe7Jf0gFM4SfGnEKG2akzYmk=
Date:   Mon, 04 Apr 2022 16:37:58 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
        vbabka@suse.cz, tytso@mit.edu, song@kernel.org, riel@surriel.com,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        shy828301@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + sched-coredumph-clarify-the-use-of-mmf_vm_hugepage.patch added to -mm tree
Message-Id: <20220404233759.0F732C2BBE4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sched: coredump.h: clarify the use of MMF_VM_HUGEPAGE
has been added to the -mm tree.  Its filename is
     sched-coredumph-clarify-the-use-of-mmf_vm_hugepage.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/sched-coredumph-clarify-the-use-of-mmf_vm_hugepage.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/sched-coredumph-clarify-the-use-of-mmf_vm_hugepage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

sched-coredumph-clarify-the-use-of-mmf_vm_hugepage.patch
mm-khugepaged-remove-redundant-check-for-vm_no_khugepaged.patch
mm-khugepaged-skip-dax-vma.patch
mm-thp-only-regular-file-could-be-thp-eligible.patch
mm-khugepaged-make-khugepaged_enter-void-function.patch
mm-khugepaged-move-some-khugepaged_-functions-to-khugepagedc.patch
mm-khugepaged-introduce-khugepaged_enter_vma-helper.patch
mm-mmap-register-suitable-readonly-file-vmas-for-khugepaged.patch

