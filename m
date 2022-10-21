Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D5B8C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 21 Oct 2022 20:02:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbiJUUCC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Oct 2022 16:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbiJUUBv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Oct 2022 16:01:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7A23262054
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 13:01:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 210C061F78
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 20:01:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C94C433D6;
        Fri, 21 Oct 2022 20:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666382502;
        bh=F4kDIsAzxazz7q84/Qxbge2Ym45wfC4NDBlX9CuXh8g=;
        h=Date:To:From:Subject:From;
        b=Kf8lBvVOacV7g9Zq8HnZ5CpEH+xOuJoqAB7iDmkMvwM2nWD5546Ru7xtHvoYl4EAU
         875J7GqHaoR+LUGVgZGlJQWMxtuJvf1GMs3k89QW6oemr+xwlNK5TKDXlZl5PIQzZ2
         DF8SL++UzVn8bmFBq0uIFwfg+YDtc+uZfT7oe3eo=
Date:   Fri, 21 Oct 2022 13:01:41 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shuah@kernel.org, peterx@redhat.com, jhubbard@nvidia.com,
        jgg@nvidia.com, hughd@google.com, aarcange@redhat.com,
        david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pagewalk-dont-trigger-test_walk-in-walk_page_vma.patch added to mm-unstable branch
Message-Id: <20221021200142.77C94C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/pagewalk: don't trigger test_walk() in walk_page_vma()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pagewalk-dont-trigger-test_walk-in-walk_page_vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pagewalk-dont-trigger-test_walk-in-walk_page_vma.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/pagewalk: don't trigger test_walk() in walk_page_vma()
Date: Fri, 21 Oct 2022 12:11:38 +0200

As Peter points out, the caller passes a single VMA and can just do that
check itself.

And in fact, no existing users rely on test_walk() getting called.  So
let's just remove it and make the implementation slightly more efficient.

Link: https://lkml.kernel.org/r/20221021101141.84170-7-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagewalk.h |    2 ++
 mm/pagewalk.c            |    7 -------
 2 files changed, 2 insertions(+), 7 deletions(-)

--- a/include/linux/pagewalk.h~mm-pagewalk-dont-trigger-test_walk-in-walk_page_vma
+++ a/include/linux/pagewalk.h
@@ -27,6 +27,8 @@ struct mm_walk;
  *			"do page table walk over the current vma", returning
  *			a negative value means "abort current page table walk
  *			right now" and returning 1 means "skip the current vma"
+ *			Note that this callback is not called when the caller
+ *			passes in a single VMA as for walk_page_vma().
  * @pre_vma:            if set, called before starting walk on a non-null vma.
  * @post_vma:           if set, called after a walk on a non-null vma, provided
  *                      that @pre_vma and the vma walk succeeded.
--- a/mm/pagewalk.c~mm-pagewalk-dont-trigger-test_walk-in-walk_page_vma
+++ a/mm/pagewalk.c
@@ -526,18 +526,11 @@ int walk_page_vma(struct vm_area_struct
 		.vma		= vma,
 		.private	= private,
 	};
-	int err;
 
 	if (!walk.mm)
 		return -EINVAL;
 
 	mmap_assert_locked(walk.mm);
-
-	err = walk_page_test(vma->vm_start, vma->vm_end, &walk);
-	if (err > 0)
-		return 0;
-	if (err < 0)
-		return err;
 	return __walk_page_range(vma->vm_start, vma->vm_end, &walk);
 }
 
_

Patches currently in -mm which might be from david@redhat.com are

selftests-vm-anon_cow-test-cow-handling-of-anonymous-memory.patch
selftests-vm-factor-out-pagemap_is_populated-into-vm_util.patch
selftests-vm-anon_cow-thp-tests.patch
selftests-vm-anon_cow-hugetlb-tests.patch
selftests-vm-anon_cow-add-liburing-test-cases.patch
mm-gup_test-start-stop-read-functionality-for-pin-longterm-test.patch
mm-gup_test-start-stop-read-functionality-for-pin-longterm-test-fix.patch
selftests-vm-anon_cow-add-r-o-longterm-tests-via-gup_test.patch
selftests-vm-add-ksm-unmerge-tests.patch
mm-pagewalk-dont-trigger-test_walk-in-walk_page_vma.patch
selftests-vm-add-test-to-measure-madv_unmergeable-performance.patch
mm-ksm-simplify-break_ksm-to-not-rely-on-vm_fault_write.patch
mm-remove-vm_fault_write.patch
mm-ksm-fix-ksm-cow-breaking-with-userfaultfd-wp-via-fault_flag_unshare.patch
mm-pagewalk-add-walk_page_range_vma.patch
mm-ksm-convert-break_ksm-to-use-walk_page_range_vma.patch
mm-gup-remove-foll_migration.patch

