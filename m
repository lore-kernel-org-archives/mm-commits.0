Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C7E5C7EE2E
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 22:01:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232320AbjFIWBI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 18:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjFIWBH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 18:01:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37FC230E8
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 15:01:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C26DA65C7B
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 22:01:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26211C433EF;
        Fri,  9 Jun 2023 22:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686348063;
        bh=TGiWAdh8M/WKwel8FhLKGp+qgkuEWpOO2IK7OfTdnRw=;
        h=Date:To:From:Subject:From;
        b=d9t/QVL9zNYNkju7TcN9HStTvWH4a+U/EQrwxwgl1Rf32hR963aMjRpGcnhCpdV3w
         k7jP45zimPuWL7bRD3ZfLoaF25Pmqjf7CPJIdrX1h1g1xj8eWLSXiMlRFkp29Pv18c
         bqFf40HxmAXRStbFxwjzD6DNxUiMy4L4mYEA6Ds0=
Date:   Fri, 09 Jun 2023 15:01:02 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, hannes@cmpxchg.org,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_isolation-write-proper-kerneldoc-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20230609220103.26211C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_isolation-write-proper-kerneldoc-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mm-page_isolation-write-proper-kerneldoc-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_isolation-write-proper-kerneldoc-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: mm-page_isolation-write-proper-kerneldoc-fix
Date: Fri Jun  9 02:59:37 PM PDT 2023

s/lower/first/, s/upper/last/, per Mike

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/page_isolation.c~mm-page_isolation-write-proper-kerneldoc-fix
+++ a/mm/page_isolation.c
@@ -482,8 +482,8 @@ failed:
 
 /**
  * start_isolate_page_range() - mark page range MIGRATE_ISOLATE
- * @start_pfn:		The lower PFN of the range to be isolated.
- * @end_pfn:		The upper PFN of the range to be isolated.
+ * @start_pfn:		The first PFN of the range to be isolated.
+ * @end_pfn:		The last PFN of the range to be isolated.
  * @migratetype:	Migrate type to set in error recovery.
  * @flags:		The following flags are allowed (they can be combined in
  *			a bit mask)
@@ -572,8 +572,8 @@ int start_isolate_page_range(unsigned lo
 
 /**
  * undo_isolate_page_range - undo effects of start_isolate_page_range()
- * @start_pfn:		The lower PFN of the isolated range
- * @end_pfn:		The upper PFN of the isolated range
+ * @start_pfn:		The first PFN of the isolated range
+ * @end_pfn:		The last PFN of the isolated range
  * @migratetype:	New migrate type to set on the range
  *
  * This finds every MIGRATE_ISOLATE page block in the given range
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-compaction-optimize-compact_memory-to-comply-with-the-admin-guide-fix.patch
mm-gup-remove-vmas-parameter-from-get_user_pages_remote-fix.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix-fix.patch
mmpage_owner-filter-out-stacks-by-a-threshold-counter-fix.patch
selftests-mm-gup_longterm-new-functional-test-for-foll_longterm-fix.patch
mm-mlock-rename-mlock_future_check-to-mlock_future_ok.patch
mm-hugetlb-use-a-folio-in-hugetlb_fault-fix.patch
fork-optimize-memcg_charge_kernel_stack-a-bit-fix.patch
squashfs-cache-partial-compressed-blocks-fix.patch
squashfs-cache-partial-compressed-blocks-fix-3-fix.patch
init-add-bdev-fs-printk-if-mount_block_root-failed-fix.patch
kexec-add-helper-__crash_shrink_memory-fix.patch
mm-page_isolation-write-proper-kerneldoc-fix.patch

