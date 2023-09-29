Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08A78E728EE
	for <mm-commits@archiver.kernel.org>; Fri, 29 Sep 2023 20:06:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232985AbjI2UGW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Sep 2023 16:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232748AbjI2UGV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Sep 2023 16:06:21 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4261A7
        for <mm-commits@vger.kernel.org>; Fri, 29 Sep 2023 13:06:17 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B1CC433C8;
        Fri, 29 Sep 2023 20:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696017977;
        bh=dJbkm6yw7MYjtJ1JHJMd4fEBwtx0G+XUScAk8OOlnEQ=;
        h=Date:To:From:Subject:From;
        b=OfwTUX2e2uEegnvJIxg7zW1DpbYPnXJG7nbsZrfeCWeHSnxtlJiFUNkuRQAJOxRcn
         k4jY2TRI6+zCreKAUnD39B64GV5CA4RrrU+eGivd7jcKD4WdzxiFls+Ii5E6pyJXuR
         IoalJzXK3hagJXxQ0v81uipiMeYrTlKSY8zUS6eo=
Date:   Fri, 29 Sep 2023 13:06:16 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        ryan.roberts@arm.com, fengwei.yin@intel.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap-fix.patch added to mm-unstable branch
Message-Id: <20230929200616.E0B1CC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap-fix
Date: Fri Sep 29 01:02:43 PM PDT 2023

__page_set_anon_rmap() has become __folio_set_anon()

Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/rmap.c~mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap-fix
+++ a/mm/rmap.c
@@ -1336,7 +1336,7 @@ void folio_add_new_anon_rmap(struct foli
 	if (likely(!folio_test_large(folio))) {
 		/* increment count (starts at -1) */
 		atomic_set(&folio->_mapcount, 0);
-		__page_set_anon_rmap(folio, &folio->page, vma, address, 1);
+		__folio_set_anon(folio, vma, address, 1);
 	} else if (!folio_test_pmd_mappable(folio)) {
 		int i;
 
@@ -1345,8 +1345,8 @@ void folio_add_new_anon_rmap(struct foli
 
 			/* increment count (starts at -1) */
 			atomic_set(&page->_mapcount, 0);
-			__page_set_anon_rmap(folio, page, vma,
-					address + (i << PAGE_SHIFT), 1);
+			__folio_set_anon(folio, vma,
+				         address + (i << PAGE_SHIFT), 1);
 		}
 
 		atomic_set(&folio->_nr_pages_mapped, nr);
@@ -1354,7 +1354,7 @@ void folio_add_new_anon_rmap(struct foli
 		/* increment count (starts at -1) */
 		atomic_set(&folio->_entire_mapcount, 0);
 		atomic_set(&folio->_nr_pages_mapped, COMPOUND_MAPPED);
-		__page_set_anon_rmap(folio, &folio->page, vma, address, 1);
+		__folio_set_anon(folio, vma, address, 1);
 		__lruvec_stat_mod_folio(folio, NR_ANON_THPS, nr);
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-memcg-reconsider-kmemlimit_in_bytes-deprecation-fix.patch
mm-shrinker-convert-shrinker_rwsem-to-mutex-fix.patch
mm-memcg-add-thp-swap-out-info-for-anonymous-reclaim-fix.patch
mm-hugetlb-skip-initialization-of-gigantic-tail-struct-pages-if-freed-by-hvo-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-2.patch
mm-ksm-add-smart-page-scanning-mode-fix.patch
mm-ksm-document-smart-scan-mode-fix.patch
mm-ksm-document-smart-scan-mode-fix-2.patch
mm-kmem-scoped-objcg-protection-checkpatch-fixes.patch
mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap-fix.patch
kthread-add-kthread_stop_put-v2-fix.patch

