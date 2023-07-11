Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07EB3EB64DC
	for <mm-commits@archiver.kernel.org>; Tue, 11 Jul 2023 19:07:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbjGKTH5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Jul 2023 15:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbjGKTHz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2023 15:07:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B96B170B
        for <mm-commits@vger.kernel.org>; Tue, 11 Jul 2023 12:07:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D953614CE
        for <mm-commits@vger.kernel.org>; Tue, 11 Jul 2023 19:07:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D68C433C9;
        Tue, 11 Jul 2023 19:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689102473;
        bh=qlc/tQfMOFeCwV+3p8XNpFLVRBduqvV2ummhX87LRV8=;
        h=Date:To:From:Subject:From;
        b=MeVTOyUotlUEUssXXRaGIVqxJ+r579jQMvxjozfJbp1VxO0MyjY+z+DVcb1hWO3P8
         xD9JLTY7K1/odqU0OmQ8hMW8yr50kBasDtnCwokc384yYo5L73nHs55+7jLA7+cx1j
         RHrpeH1FDGlb6wHVJX0/tcXfXVDB7PzXC3ZC+WcI=
Date:   Tue, 11 Jul 2023 12:07:52 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-minor-cleanup-for-comments-and-codestyle.patch added to mm-unstable branch
Message-Id: <20230711190752.F3D68C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory-failure: minor cleanup for comments and codestyle
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-minor-cleanup-for-comments-and-codestyle.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-minor-cleanup-for-comments-and-codestyle.patch

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
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: memory-failure: minor cleanup for comments and codestyle
Date: Tue, 11 Jul 2023 13:50:14 +0800

Fix some wrong function names and grammar error in comments. Also remove
unneeded space after for_each_process. No functional change intended.

Link: https://lkml.kernel.org/r/20230711055016.2286677-7-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-minor-cleanup-for-comments-and-codestyle
+++ a/mm/memory-failure.c
@@ -608,7 +608,7 @@ static void collect_procs_anon(struct pa
 
 	pgoff = page_to_pgoff(page);
 	read_lock(&tasklist_lock);
-	for_each_process (tsk) {
+	for_each_process(tsk) {
 		struct anon_vma_chain *vmac;
 		struct task_struct *t = task_early_kill(tsk, force_early);
 
@@ -652,7 +652,7 @@ static void collect_procs_file(struct pa
 			/*
 			 * Send early kill signal to tasks where a vma covers
 			 * the page but the corrupted page is not necessarily
-			 * mapped it in its pte.
+			 * mapped in its pte.
 			 * Assume applications who requested early kill want
 			 * to be informed of all such data corruptions.
 			 */
@@ -2127,7 +2127,7 @@ static DEFINE_MUTEX(mf_mutex);
  * detected by a background scrubber)
  *
  * Must run in process context (e.g. a work queue) with interrupts
- * enabled and no spinlocks hold.
+ * enabled and no spinlocks held.
  *
  * Return: 0 for successfully handled the memory error,
  *         -EOPNOTSUPP for hwpoison_filter() filtered the error event,
@@ -2232,7 +2232,7 @@ try_again:
 		 * otherwise it may race with THP split.
 		 * And the flag can't be set in get_hwpoison_page() since
 		 * it is called by soft offline too and it is just called
-		 * for !MF_COUNT_INCREASE.  So here seems to be the best
+		 * for !MF_COUNT_INCREASED.  So here seems to be the best
 		 * place.
 		 *
 		 * Don't need care about the above error handling paths for
@@ -2589,10 +2589,10 @@ static bool isolate_page(struct page *pa
 
 	/*
 	 * If we succeed to isolate the page, we grabbed another refcount on
-	 * the page, so we can safely drop the one we got from get_any_pages().
+	 * the page, so we can safely drop the one we got from get_any_page().
 	 * If we failed to isolate the page, it means that we cannot go further
 	 * and we will return an error, so drop the reference we got from
-	 * get_any_pages() as well.
+	 * get_any_page() as well.
 	 */
 	put_page(page);
 	return isolated;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-mm_initc-update-obsolete-comment-in-get_pfn_range_for_nid.patch
mm-memory-failure-fix-unexpected-return-value-in-soft_offline_page.patch
mm-memory-failure-fix-potential-page-refcnt-leak-in-memory_failure.patch
mm-memory-failure-remove-unneeded-page-state-check-in-shake_page.patch
memory-tier-use-helper-function-destroy_memory_type.patch
mm-memory-failure-remove-unneeded-inline-annotation.patch
mm-mm_initc-remove-obsolete-macro-hash_small.patch
mm-page_alloc-avoid-false-page-outside-zone-error-info.patch
memory-tier-rename-destroy_memory_type-to-put_memory_type.patch
mm-remove-obsolete-comment-above-struct-per_cpu_pages.patch
mm-memcg-minor-cleanup-for-mem_cgroup_id_max.patch
mm-memory-failure-remove-unneeded-pagehuge-check.patch
mm-memory-failure-ensure-moving-hwpoison-flag-to-the-raw-error-pages.patch
mm-memory-failure-dont-account-hwpoison_filter-filtered-pages.patch
mm-memory-failure-use-local-variable-huge-to-check-hugetlb-page.patch
mm-memory-failure-remove-unneeded-header-files.patch
mm-memory-failure-minor-cleanup-for-comments-and-codestyle.patch
mm-memory-failure-fetch-compound-head-after-extra-page-refcnt-is-held.patch
mm-memory-failure-fix-race-window-when-trying-to-get-hugetlb-folio.patch

