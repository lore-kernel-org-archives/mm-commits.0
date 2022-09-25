Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B8E7C04A95
	for <mm-commits@archiver.kernel.org>; Sun, 25 Sep 2022 19:13:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232934AbiIYTN2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 25 Sep 2022 15:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231887AbiIYTNZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 25 Sep 2022 15:13:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F7624F33
        for <mm-commits@vger.kernel.org>; Sun, 25 Sep 2022 12:13:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5762DB80D70
        for <mm-commits@vger.kernel.org>; Sun, 25 Sep 2022 19:13:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39B9C433C1;
        Sun, 25 Sep 2022 19:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664133202;
        bh=b7kpW05gdRk0zwaw4MYUZ5vAgIaEAwVi0W1CUa8ZCis=;
        h=Date:To:From:Subject:From;
        b=IHYVonFYoUrBVgdbXJNhOAwEaiATRYECLyY5iE27DlU9xvgVZbkmRlVBzHBmkpMkf
         QsQGMc6bVX3KkDWeCP8geBnEI0KNR+ABAZ/8bBhvWSr6+5REDgj1Rfe5yziH330Wi+
         sgDt/LeBWLCxB+8HTSBaNoSf9TJjDfYN/dHlUFM0=
Date:   Sun, 25 Sep 2022 12:13:20 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        songliubraving@fb.com, sj@kernel.org, shy828301@gmail.com,
        rongwei.wang@linux.alibaba.com, rientjes@google.com,
        peterx@redhat.com, pasha.tatashin@soleen.com, minchan@kernel.org,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        jthoughton@google.com, hughd@google.com, david@redhat.com,
        ckennelly@google.com, axelrasmussen@google.com, zokeefe@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-madv_collapse-return-eagain-when-page-cannot-be-isolated.patch added to mm-unstable branch
Message-Id: <20220925191321.C39B9C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/madvise: MADV_COLLAPSE return EAGAIN when page cannot be isolated
has been added to the -mm mm-unstable branch.  Its filename is
     mm-madvise-madv_collapse-return-eagain-when-page-cannot-be-isolated.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-madv_collapse-return-eagain-when-page-cannot-be-isolated.patch

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
From: "Zach O'Keefe" <zokeefe@google.com>
Subject: mm/madvise: MADV_COLLAPSE return EAGAIN when page cannot be isolated
Date: Thu, 22 Sep 2022 11:46:50 -0700

MADV_COLLAPSE is a best-effort request that attempts to set an actionable
errno value if the request cannot be fulfilled at the time.  EAGAIN should
be used to communicate that a resource was temporarily unavailable, but
that the user may try again immediately.

SCAN_DEL_PAGE_LRU is an internal result code used when a page cannot be
isolated from it's LRU list.  Since this, like SCAN_PAGE_LRU, is likely a
transitory state, make MADV_COLLAPSE return EAGAIN so that users know they
may reattempt the operation.

Another important scenario to consider is race with khugepaged. 
khugepaged might isolate a page while MADV_COLLAPSE is interested in it. 
Even though racing with khugepaged might mean that the memory has already
been collapsed, signalling an errno that is non-intrinsic to that memory
or arguments provided to madvise(2) lets the user know that future
attempts might (and in this case likely would) succeed, and avoids
false-negative assumptions by the user.

Link: https://lkml.kernel.org/r/20220922184651.1016461-1-zokeefe@google.com
Fixes: 7d8faaf15545 ("mm/madvise: introduce MADV_COLLAPSE sync hugepage collapse")
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Kennelly <ckennelly@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rongwei Wang <rongwei.wang@linux.alibaba.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/khugepaged.c~mm-madvise-madv_collapse-return-eagain-when-page-cannot-be-isolated
+++ a/mm/khugepaged.c
@@ -2372,6 +2372,7 @@ static int madvise_collapse_errno(enum s
 	/* Resource temporary unavailable - trying again might succeed */
 	case SCAN_PAGE_LOCK:
 	case SCAN_PAGE_LRU:
+	case SCAN_DEL_PAGE_LRU:
 		return -EAGAIN;
 	/*
 	 * Other: Trying again likely not to succeed / error intrinsic to
@@ -2454,6 +2455,7 @@ int madvise_collapse(struct vm_area_stru
 		case SCAN_PAGE_LOCK:
 		case SCAN_PAGE_COMPOUND:
 		case SCAN_PAGE_LRU:
+		case SCAN_DEL_PAGE_LRU:
 			last_fail = result;
 			break;
 		default:
_

Patches currently in -mm which might be from zokeefe@google.com are

mm-khugepaged-check-compound_order-in-collapse_pte_mapped_thp.patch
mm-madvise-madv_collapse-return-eagain-when-page-cannot-be-isolated.patch
selftests-vm-retry-on-eagain-for-madv_collapse-selftest.patch
mm-shmem-add-flag-to-enforce-shmem-thp-in-hugepage_vma_check.patch
mm-khugepaged-attempt-to-map-file-shmem-backed-pte-mapped-thps-by-pmds.patch
mm-madvise-add-file-and-shmem-support-to-madv_collapse.patch
mm-khugepaged-add-tracepoint-to-hpage_collapse_scan_file.patch
selftests-vm-dedup-thp-helpers.patch
selftests-vm-modularize-thp-collapse-memory-operations.patch
selftests-vm-add-thp-collapse-file-and-tmpfs-testing.patch
selftests-vm-add-thp-collapse-shmem-testing.patch
selftests-vm-add-file-shmem-madv_collapse-selftest-for-cleared-pmd.patch
selftests-vm-add-selftest-for-madv_collapse-of-uffd-minor-memory.patch

