Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18ADECE7AB1
	for <mm-commits@archiver.kernel.org>; Mon, 25 Sep 2023 17:55:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbjIYRzy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Sep 2023 13:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232166AbjIYRzw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Sep 2023 13:55:52 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF3E193
        for <mm-commits@vger.kernel.org>; Mon, 25 Sep 2023 10:55:44 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B177C433C9;
        Mon, 25 Sep 2023 17:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695664544;
        bh=ZVgWBrVSu+P7SyOs2EKW7za47Wr/vT8kjJOMcULfsoM=;
        h=Date:To:From:Subject:From;
        b=wvkM6xp/6MYQLTt+AjJsecviN8o00t7ybwWhfWQH+XMc8SziI3usyz1UITC51CzN4
         SqU3ANxtfqHG/gQdZ5nNtEqCRtw0rqOFG1NiJpIoclbqUwXP24/lGzWGAJFDZr4NJ4
         /x32SGPHVsj1am3skUkX31YdwUVwM5n1LEZmsDTE=
Date:   Mon, 25 Sep 2023 10:55:43 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        ryan.roberts@arm.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix.patch added to mm-unstable branch
Message-Id: <20230925175544.1B177C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix
has been added to the -mm mm-unstable branch.  Its filename is
     fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix.patch

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
Subject: fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix
Date: Mon Sep 25 10:53:52 AM PDT 2023

update it for "mm: hugetlb: add huge page size param to set_huge_pte_at()".

Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix
+++ a/fs/proc/task_mmu.c
@@ -1923,18 +1923,22 @@ static void make_uffd_wp_huge_pte(struct
 				  unsigned long addr, pte_t *ptep,
 				  pte_t ptent)
 {
+	unsigned long psize;
+
 	if (is_hugetlb_entry_hwpoisoned(ptent) || is_pte_marker(ptent))
 		return;
 
+	psize = huge_page_size(hstate_vma(vma));
+
 	if (is_hugetlb_entry_migration(ptent))
 		set_huge_pte_at(vma->vm_mm, addr, ptep,
-				pte_swp_mkuffd_wp(ptent));
+				pte_swp_mkuffd_wp(ptent), psize);
 	else if (!huge_pte_none(ptent))
 		huge_ptep_modify_prot_commit(vma, addr, ptep, ptent,
 					     huge_pte_mkuffd_wp(ptent));
 	else
 		set_huge_pte_at(vma->vm_mm, addr, ptep,
-				make_pte_marker(PTE_MARKER_UFFD_WP));
+				make_pte_marker(PTE_MARKER_UFFD_WP), psize);
 }
 #endif /* CONFIG_HUGETLB_PAGE */
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-memcg-add-thp-swap-out-info-for-anonymous-reclaim-fix.patch
mm-hugetlb-skip-initialization-of-gigantic-tail-struct-pages-if-freed-by-hvo-fix.patch
vmscan-add-trace-events-for-lru_gen-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix.patch
kthread-add-kthread_stop_put-v2-fix.patch

