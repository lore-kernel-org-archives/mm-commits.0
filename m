Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CCA3C4167B
	for <mm-commits@archiver.kernel.org>; Mon, 27 Nov 2023 17:21:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbjK0RVb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Nov 2023 12:21:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjK0RVa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Nov 2023 12:21:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F9A6192
        for <mm-commits@vger.kernel.org>; Mon, 27 Nov 2023 09:21:37 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A685AC433C7;
        Mon, 27 Nov 2023 17:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701105696;
        bh=6AaijepKMnAkHSixb7za+BTsknZMNC73cGJIwQR8nsY=;
        h=Date:To:From:Subject:From;
        b=K7GihBAOSx9ONWUs8T++H5QSJCU0jJvocKPDN02KmgxCX6mFYaOum/ZTwvqQdSWIG
         pqCMOR4Vaq/cBHGj9+RH7wgHL5iW6rWZC/ioj+RCh2Ohq0yf1679H/rojaGEIBf/MC
         DKMc3crE6gWtRdQI+W1F4s+XaTqs3meM5TOyj98Y=
Date:   Mon, 27 Nov 2023 09:21:36 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pagewalk-assert-write-mmap-lock-only-for-walking-the-user-page-tables.patch added to mm-unstable branch
Message-Id: <20231127172136.A685AC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: pagewalk: assert write mmap lock only for walking the user page tables
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pagewalk-assert-write-mmap-lock-only-for-walking-the-user-page-tables.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pagewalk-assert-write-mmap-lock-only-for-walking-the-user-page-tables.patch

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
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: pagewalk: assert write mmap lock only for walking the user page tables
Date: Mon, 27 Nov 2023 16:46:42 +0800

The 8782fb61cc848 ("mm: pagewalk: Fix race between unmap and page walker")
introduces an assertion to walk_page_range_novma() to make all the users
of page table walker is safe.  However, the race only exists for walking
the user page tables.  And it is ridiculous to hold a particular user mmap
write lock against the changes of the kernel page tables.  So only assert
at least mmap read lock when walking the kernel page tables.  And some
users matching this case could downgrade to a mmap read lock to relief the
contention of mmap lock of init_mm, it will be nicer in hugetlb (only
holding mmap read lock) in the next patch.

Link: https://lkml.kernel.org/r/20231127084645.27017-2-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pagewalk.c |   29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

--- a/mm/pagewalk.c~mm-pagewalk-assert-write-mmap-lock-only-for-walking-the-user-page-tables
+++ a/mm/pagewalk.c
@@ -539,6 +539,11 @@ int walk_page_range(struct mm_struct *mm
  * not backed by VMAs. Because 'unusual' entries may be walked this function
  * will also not lock the PTEs for the pte_entry() callback. This is useful for
  * walking the kernel pages tables or page tables for firmware.
+ *
+ * Note: Be careful to walk the kernel pages tables, the caller may be need to
+ * take other effective approache (mmap lock may be insufficient) to prevent
+ * the intermediate kernel page tables belonging to the specified address range
+ * from being freed (e.g. memory hot-remove).
  */
 int walk_page_range_novma(struct mm_struct *mm, unsigned long start,
 			  unsigned long end, const struct mm_walk_ops *ops,
@@ -556,7 +561,29 @@ int walk_page_range_novma(struct mm_stru
 	if (start >= end || !walk.mm)
 		return -EINVAL;
 
-	mmap_assert_write_locked(walk.mm);
+	/*
+	 * 1) For walking the user virtual address space:
+	 *
+	 * The mmap lock protects the page walker from changes to the page
+	 * tables during the walk.  However a read lock is insufficient to
+	 * protect those areas which don't have a VMA as munmap() detaches
+	 * the VMAs before downgrading to a read lock and actually tearing
+	 * down PTEs/page tables. In which case, the mmap write lock should
+	 * be hold.
+	 *
+	 * 2) For walking the kernel virtual address space:
+	 *
+	 * The kernel intermediate page tables usually do not be freed, so
+	 * the mmap map read lock is sufficient. But there are some exceptions.
+	 * E.g. memory hot-remove. In which case, the mmap lock is insufficient
+	 * to prevent the intermediate kernel pages tables belonging to the
+	 * specified address range from being freed. The caller should take
+	 * other actions to prevent this race.
+	 */
+	if (mm == &init_mm)
+		mmap_assert_locked(walk.mm);
+	else
+		mmap_assert_write_locked(walk.mm);
 
 	return walk_pgd_range(start, end, &walk);
 }
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-pagewalk-assert-write-mmap-lock-only-for-walking-the-user-page-tables.patch
mm-hugetlb_vmemmap-use-walk_page_range_novma-to-simplify-the-code.patch
mm-hugetlb_vmemmap-move-pagevmemmapselfhosted-check-to-split_vmemmap_huge_pmd.patch
mm-hugetlb_vmemmap-convert-page-to-folio.patch

