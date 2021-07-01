Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5BC1C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 00:58:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92C40610A7
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 00:58:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236736AbhGABBB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:01:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:58354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232066AbhGABBA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:01:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 650016146D;
        Thu,  1 Jul 2021 00:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625101110;
        bh=j7lnXVodcvivamT1O0g4VOXKyJmStAcHYOKym/+Opxk=;
        h=Date:From:To:Subject:From;
        b=JPwoO47gRTZfwDVVuqgyVF5OHYMVjIEUw9YyaAjPvbAt/SnIT+whm0JV9v8cwjA9G
         d2f+iX6hndS6sYHBKPOZXKk3wLJXWthdmCTVDx9+ECan8qdH3Ws7NH6Sqp7AxJErxQ
         rABPyBeYYJm7YAy8/fSD+DnLZ3isS+3/RpLwzZtE=
Date:   Wed, 30 Jun 2021 17:58:30 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, david@redhat.com,
        mm-commits@vger.kernel.org
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-madvise-introduce-madv=5Fpopulate=5Freadwrite-to-prefaul?=
 =?US-ASCII?Q?t-page-tables-checkpatch-fixes.patch?= removed from -mm tree
Message-ID: <20210701005830.Y_lunk1NS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes

WARNING: please, no space before tabs
#506: FILE: mm/gup.c:1513:
+^I * ^I       the page dirty with FOLL_WRITE -- which doesn't make a$

WARNING: please, no space before tabs
#507: FILE: mm/gup.c:1514:
+^I * ^I       difference with !FOLL_FORCE, because the page is writable$

WARNING: please, no space before tabs
#508: FILE: mm/gup.c:1515:
+^I * ^I       in the page table.$

total: 0 errors, 3 warnings, 214 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/gup.c~mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes
+++ a/mm/gup.c
@@ -1538,9 +1538,9 @@ long faultin_vma_page_range(struct vm_ar
 
 	/*
 	 * FOLL_TOUCH: Mark page accessed and thereby young; will also mark
-	 * 	       the page dirty with FOLL_WRITE -- which doesn't make a
-	 * 	       difference with !FOLL_FORCE, because the page is writable
-	 * 	       in the page table.
+	 *	       the page dirty with FOLL_WRITE -- which doesn't make a
+	 *	       difference with !FOLL_FORCE, because the page is writable
+	 *	       in the page table.
 	 * FOLL_HWPOISON: Return -EHWPOISON instead of -EFAULT when we hit
 	 *		  a poisoned page.
 	 * FOLL_POPULATE: Always populate memory with VM_LOCKONFAULT.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables.patch
mmmemory_hotplug-drop-unneeded-locking-fix.patch
fs-proc-kcorec-add-mmap-interface-fix.patch
kernelh-split-out-panic-and-oops-helpers-fix.patch
lib-math-rational-add-kunit-test-cases-fix.patch
lib-decompressors-remove-set-but-not-used-variabled-level-fix.patch
ipc-utilc-use-binary-search-for-max_idx-fix.patch
mm.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
linux-next-pre.patch
linux-next-post.patch
linux-next-rejects.patch
kernel-cgroup-cgroupc-dont-export-cgroup_get_e_css-twice.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

