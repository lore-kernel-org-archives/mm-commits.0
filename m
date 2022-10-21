Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D95DFC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 21 Oct 2022 20:02:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbiJUUC0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Oct 2022 16:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbiJUUCC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Oct 2022 16:02:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA708262DE3
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 13:01:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D20EB82D4B
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 20:01:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D120DC433C1;
        Fri, 21 Oct 2022 20:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666382512;
        bh=bm4ANKv9oqqQOWF/U54VGjFYzy9oPS3msZOYxcbMn88=;
        h=Date:To:From:Subject:From;
        b=nJrDK/MiRqZw7pFrE4j4sDvty6rxFWfAoPXMuViIc5+htci4smGNvho2JMvbaJteT
         FWDBS90aJXVpgndf/17nch4wHSjdpifaD5ZY2pD9s8Pum+Sjsgvn6cN4eMBiu1u7Kr
         3uLK/nl4jDd7/9G3OHlVqtlHMmYPncuanK7mZ+7k=
Date:   Fri, 21 Oct 2022 13:01:52 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shuah@kernel.org, peterx@redhat.com, jhubbard@nvidia.com,
        jgg@nvidia.com, hughd@google.com, aarcange@redhat.com,
        david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pagewalk-add-walk_page_range_vma.patch added to mm-unstable branch
Message-Id: <20221021200152.D120DC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/pagewalk: add walk_page_range_vma()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pagewalk-add-walk_page_range_vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pagewalk-add-walk_page_range_vma.patch

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
Subject: mm/pagewalk: add walk_page_range_vma()
Date: Fri, 21 Oct 2022 12:11:39 +0200

Let's add walk_page_range_vma(), which is similar to walk_page_vma(),
however, is only interested in a subset of the VMA range.

To be used in KSM code to stop using follow_page() next.

Link: https://lkml.kernel.org/r/20221021101141.84170-8-david@redhat.com
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

 include/linux/pagewalk.h |    3 +++
 mm/pagewalk.c            |   20 ++++++++++++++++++++
 2 files changed, 23 insertions(+)

--- a/include/linux/pagewalk.h~mm-pagewalk-add-walk_page_range_vma
+++ a/include/linux/pagewalk.h
@@ -101,6 +101,9 @@ int walk_page_range_novma(struct mm_stru
 			  unsigned long end, const struct mm_walk_ops *ops,
 			  pgd_t *pgd,
 			  void *private);
+int walk_page_range_vma(struct vm_area_struct *vma, unsigned long start,
+			unsigned long end, const struct mm_walk_ops *ops,
+			void *private);
 int walk_page_vma(struct vm_area_struct *vma, const struct mm_walk_ops *ops,
 		void *private);
 int walk_page_mapping(struct address_space *mapping, pgoff_t first_index,
--- a/mm/pagewalk.c~mm-pagewalk-add-walk_page_range_vma
+++ a/mm/pagewalk.c
@@ -517,6 +517,26 @@ int walk_page_range_novma(struct mm_stru
 	return walk_pgd_range(start, end, &walk);
 }
 
+int walk_page_range_vma(struct vm_area_struct *vma, unsigned long start,
+			unsigned long end, const struct mm_walk_ops *ops,
+			void *private)
+{
+	struct mm_walk walk = {
+		.ops		= ops,
+		.mm		= vma->vm_mm,
+		.vma		= vma,
+		.private	= private,
+	};
+
+	if (start >= end || !walk.mm)
+		return -EINVAL;
+	if (start < vma->vm_start || end > vma->vm_end)
+		return -EINVAL;
+
+	mmap_assert_locked(walk.mm);
+	return __walk_page_range(start, end, &walk);
+}
+
 int walk_page_vma(struct vm_area_struct *vma, const struct mm_walk_ops *ops,
 		void *private)
 {
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

