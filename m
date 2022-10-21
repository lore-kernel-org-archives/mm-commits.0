Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F3FFC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 21 Oct 2022 20:02:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbiJUUCX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Oct 2022 16:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbiJUUCB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Oct 2022 16:02:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E190A261AE0
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 13:01:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5EC6B82CF8
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 20:01:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8338DC433D6;
        Fri, 21 Oct 2022 20:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666382506;
        bh=DX+2GJohhQKJcZbpiRmb9F5LOWry5/ExoMg4Gm23FJI=;
        h=Date:To:From:Subject:From;
        b=yIlZNJmjDBC4YfKtdyOn9Y4qJJEt/nKwf7NObw1hZ4dzowqQthtPs3XVrfF4tlHts
         E5xCN3sJGjD/kQWKrTjHX0AAp52f83WFx4T50H+x2FWtuGsamqMwSbm51Gme5+aB8T
         abUXx7pOYMZS64K7PflkY0w86BNcHrPr1BLWhoZg=
Date:   Fri, 21 Oct 2022 13:01:46 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shuah@kernel.org, peterx@redhat.com, jhubbard@nvidia.com,
        jgg@nvidia.com, hughd@google.com, aarcange@redhat.com,
        david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-simplify-break_ksm-to-not-rely-on-vm_fault_write.patch added to mm-unstable branch
Message-Id: <20221021200146.8338DC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/ksm: simplify break_ksm() to not rely on VM_FAULT_WRITE
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ksm-simplify-break_ksm-to-not-rely-on-vm_fault_write.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-simplify-break_ksm-to-not-rely-on-vm_fault_write.patch

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
Subject: mm/ksm: simplify break_ksm() to not rely on VM_FAULT_WRITE
Date: Fri, 21 Oct 2022 12:11:34 +0200

Now that GUP no longer requires VM_FAULT_WRITE, break_ksm() is the sole
remaining user of VM_FAULT_WRITE.  As we also want to stop triggering a
fake write fault and instead use FAULT_FLAG_UNSHARE -- similar to
GUP-triggered unsharing when taking a R/O pin on a shared anonymous page
(including KSM pages), let's stop relying on VM_FAULT_WRITE.

Let's rework break_ksm() to not rely on the return value of
handle_mm_fault() anymore to figure out whether COW-breaking was
successful.  Simply perform another follow_page() lookup to verify the
result.

While this makes break_ksm() slightly less efficient, we can simplify
handle_mm_fault() a little and easily switch to FAULT_FLAG_UNSHARE without
introducing similar KSM-specific behavior for FAULT_FLAG_UNSHARE.

In my setup (AMD Ryzen 9 3900X), running the KSM selftest to test unmerge
performance on 2 GiB (taskset 0x8 ./ksm_tests -D -s 2048), this results in
a performance degradation of ~4% -- 5% (old: ~5250 MiB/s, new: ~5010
MiB/s).

I don't think that we particularly care about that performance drop when
unmerging.  If it ever turns out to be an actual performance issue, we can
think about a better alternative for FAULT_FLAG_UNSHARE -- let's just keep
it simple for now.

Link: https://lkml.kernel.org/r/20221021101141.84170-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

--- a/mm/ksm.c~mm-ksm-simplify-break_ksm-to-not-rely-on-vm_fault_write
+++ a/mm/ksm.c
@@ -440,26 +440,27 @@ static int break_ksm(struct vm_area_stru
 	vm_fault_t ret = 0;
 
 	do {
+		bool ksm_page = false;
+
 		cond_resched();
 		page = follow_page(vma, addr,
 				FOLL_GET | FOLL_MIGRATION | FOLL_REMOTE);
 		if (IS_ERR_OR_NULL(page))
 			break;
 		if (PageKsm(page))
-			ret = handle_mm_fault(vma, addr,
-					      FAULT_FLAG_WRITE | FAULT_FLAG_REMOTE,
-					      NULL);
-		else
-			ret = VM_FAULT_WRITE;
+			ksm_page = true;
 		put_page(page);
-	} while (!(ret & (VM_FAULT_WRITE | VM_FAULT_SIGBUS | VM_FAULT_SIGSEGV | VM_FAULT_OOM)));
+
+		if (!ksm_page)
+			return 0;
+		ret = handle_mm_fault(vma, addr,
+				      FAULT_FLAG_WRITE | FAULT_FLAG_REMOTE,
+				      NULL);
+	} while (!(ret & (VM_FAULT_SIGBUS | VM_FAULT_SIGSEGV | VM_FAULT_OOM)));
 	/*
-	 * We must loop because handle_mm_fault() may back out if there's
-	 * any difficulty e.g. if pte accessed bit gets updated concurrently.
-	 *
-	 * VM_FAULT_WRITE is what we have been hoping for: it indicates that
-	 * COW has been broken, even if the vma does not permit VM_WRITE;
-	 * but note that a concurrent fault might break PageKsm for us.
+	 * We must loop until we no longer find a KSM page because
+	 * handle_mm_fault() may back out if there's any difficulty e.g. if
+	 * pte accessed bit gets updated concurrently.
 	 *
 	 * VM_FAULT_SIGBUS could occur if we race with truncation of the
 	 * backing file, which also invalidates anonymous pages: that's
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

