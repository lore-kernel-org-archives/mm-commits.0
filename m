Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62FC0C74A5B
	for <mm-commits@archiver.kernel.org>; Wed, 15 Mar 2023 19:19:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232725AbjCOTS7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Mar 2023 15:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232511AbjCOTS5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Mar 2023 15:18:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2546226CCA
        for <mm-commits@vger.kernel.org>; Wed, 15 Mar 2023 12:18:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3AA8B80F62
        for <mm-commits@vger.kernel.org>; Wed, 15 Mar 2023 19:18:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B53FC433EF;
        Wed, 15 Mar 2023 19:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678907933;
        bh=/s2T0gGn60ezrfB19twaqWGtZ8conRN7wunBW62Rdkk=;
        h=Date:To:From:Subject:From;
        b=q1nODnVvxpiNhgpRKHBYqZrlCdex2xIrBRsqCPtS4iJFuSZgHwn0Dz/W8jMR2zyAO
         lsqC+AZyfZu17x9+szAq6+nNO6rdiczwnbMEec1rNPote4IkdkL5y+nXzYXglC5JCJ
         tA5J2nkBvKe2TtcoVbJxPbH+K1xF4bSnWcjUggJk=
Date:   Wed, 15 Mar 2023 12:18:52 -0700
To:     mm-commits@vger.kernel.org, shy828301@gmail.com,
        aneesh.kumar@linux.ibm.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp-rename-transparent_hugepage_never_dax-to-_unsupported.patch added to mm-unstable branch
Message-Id: <20230315191853.7B53FC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp: rename TRANSPARENT_HUGEPAGE_NEVER_DAX to _UNSUPPORTED
has been added to the -mm mm-unstable branch.  Its filename is
     mm-thp-rename-transparent_hugepage_never_dax-to-_unsupported.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-thp-rename-transparent_hugepage_never_dax-to-_unsupported.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: mm/thp: rename TRANSPARENT_HUGEPAGE_NEVER_DAX to _UNSUPPORTED
Date: Wed, 15 Mar 2023 13:16:42 -0400

TRANSPARENT_HUGEPAGE_NEVER_DAX has nothing to do with DAX.  It's set when
has_transparent_hugepage() returns false, checked in hugepage_vma_check()
and will disable THP completely if false.  Rename it to
TRANSPARENT_HUGEPAGE_UNSUPPORTED to reflect its real purpose.

Link: https://lkml.kernel.org/r/20230315171642.1244625-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    2 +-
 mm/huge_memory.c        |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/huge_mm.h~mm-thp-rename-transparent_hugepage_never_dax-to-_unsupported
+++ a/include/linux/huge_mm.h
@@ -44,7 +44,7 @@ vm_fault_t vmf_insert_pfn_pmd(struct vm_
 vm_fault_t vmf_insert_pfn_pud(struct vm_fault *vmf, pfn_t pfn, bool write);
 
 enum transparent_hugepage_flag {
-	TRANSPARENT_HUGEPAGE_NEVER_DAX,
+	TRANSPARENT_HUGEPAGE_UNSUPPORTED,
 	TRANSPARENT_HUGEPAGE_FLAG,
 	TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
 	TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG,
--- a/mm/huge_memory.c~mm-thp-rename-transparent_hugepage_never_dax-to-_unsupported
+++ a/mm/huge_memory.c
@@ -88,7 +88,7 @@ bool hugepage_vma_check(struct vm_area_s
 	/*
 	 * If the hardware/firmware marked hugepage support disabled.
 	 */
-	if (transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_NEVER_DAX))
+	if (transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_UNSUPPORTED))
 		return false;
 
 	/* khugepaged doesn't collapse DAX vma, but page fault is fine. */
@@ -464,7 +464,7 @@ static int __init hugepage_init(void)
 		 * Hardware doesn't support hugepages, hence disable
 		 * DAX PMD support.
 		 */
-		transparent_hugepage_flags = 1 << TRANSPARENT_HUGEPAGE_NEVER_DAX;
+		transparent_hugepage_flags = 1 << TRANSPARENT_HUGEPAGE_UNSUPPORTED;
 		return -EINVAL;
 	}
 
_

Patches currently in -mm which might be from peterx@redhat.com are

kselftest-vm-fix-unused-variable-warning.patch
tools-headers-uapi-sync-linux-prctlh-with-the-kernel-sources.patch
mm-khugepaged-alloc_charge_hpage-take-care-of-mem-charge-errors.patch
mm-khugepaged-cleanup-memcg-uncharge-for-failure-path.patch
mm-uffd-uffd_feature_wp_unpopulated.patch
selftests-mm-smoke-test-uffd_feature_wp_unpopulated.patch
mm-thp-rename-transparent_hugepage_never_dax-to-_unsupported.patch

