Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA32FC07E96
	for <mm-commits@archiver.kernel.org>; Tue, 13 Jul 2021 22:41:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1AC761279
	for <mm-commits@archiver.kernel.org>; Tue, 13 Jul 2021 22:41:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236671AbhGMWoZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Jul 2021 18:44:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:50600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236669AbhGMWoZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Jul 2021 18:44:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0F7461284;
        Tue, 13 Jul 2021 22:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626216094;
        bh=B1hcD6SR1IfVW9g8w+NboVOS2C9yMkM6rLHqqkwF7VE=;
        h=Date:From:To:Subject:From;
        b=IhgXYsqa/M039lqcJFNlHAJdUgIhravYsg8eHPw38DtNP0NtutKitj4TK3SpIXgox
         03O3BtLoftLeP7dYyu+fvahqV4xC403dM08dezT3D0W2JGdsa2+ENl8pvXKxO3KNQn
         +kRe2PMeoOaPMIPRcIbnV+TrTCae1VSTC9z/ddCM=
Date:   Tue, 13 Jul 2021 15:41:34 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, hch@lst.de, hughd@google.com, jgg@nvidia.com,
        kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        rcampbell@nvidia.com, shakeelb@google.com, shy828301@gmail.com
Subject:  [merged]
 mm-rmap-fix-comments-left-over-from-recent-changes.patch removed from -mm
 tree
Message-ID: <20210713224134.9qsenWxai%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap: fix comments left over from recent changes
has been removed from the -mm tree.  Its filename was
     mm-rmap-fix-comments-left-over-from-recent-changes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/rmap: fix comments left over from recent changes

Parallel developments in mm/rmap.c have left behind some out-of-date
comments: try_to_migrate_one() also accepts TTU_SYNC (already commented in
try_to_migrate() itself), and try_to_migrate() returns nothing at all.

TTU_SPLIT_FREEZE has just been deleted, so reword the comment about it in
mm/huge_memory.c; and TTU_IGNORE_ACCESS was removed in 5.11, so delete the
"recently referenced" comment from try_to_unmap_one() (once upon a time
the comment was near the removed codeblock, but they drifted apart).

Link: https://lkml.kernel.org/r/563ce5b2-7a44-5b4d-1dfd-59a0e65932a9@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 mm/rmap.c        |    7 +------
 2 files changed, 2 insertions(+), 7 deletions(-)

--- a/mm/huge_memory.c~mm-rmap-fix-comments-left-over-from-recent-changes
+++ a/mm/huge_memory.c
@@ -2331,7 +2331,7 @@ static void remap_page(struct page *page
 {
 	int i;
 
-	/* If TTU_SPLIT_FREEZE is ever extended to file, remove this check */
+	/* If unmap_page() uses try_to_migrate() on file, remove this check */
 	if (!PageAnon(page))
 		return;
 	if (PageTransHuge(page)) {
--- a/mm/rmap.c~mm-rmap-fix-comments-left-over-from-recent-changes
+++ a/mm/rmap.c
@@ -1439,8 +1439,6 @@ static bool try_to_unmap_one(struct page
 	while (page_vma_mapped_walk(&pvmw)) {
 		/*
 		 * If the page is mlock()d, we cannot swap it out.
-		 * If it's recently referenced (perhaps page_referenced
-		 * skipped over this mm) then we should reactivate it.
 		 */
 		if (!(flags & TTU_IGNORE_MLOCK)) {
 			if (vma->vm_flags & VM_LOCKED) {
@@ -1687,8 +1685,7 @@ void try_to_unmap(struct page *page, enu
  * @arg: enum ttu_flags will be passed to this argument.
  *
  * If TTU_SPLIT_HUGE_PMD is specified any PMD mappings will be split into PTEs
- * containing migration entries. This and TTU_RMAP_LOCKED are the only supported
- * flags.
+ * containing migration entries.
  */
 static bool try_to_migrate_one(struct page *page, struct vm_area_struct *vma,
 		     unsigned long address, void *arg)
@@ -1928,8 +1925,6 @@ static bool try_to_migrate_one(struct pa
  *
  * Tries to remove all the page table entries which are mapping this page and
  * replace them with special swap entries. Caller must hold the page lock.
- *
- * If is successful, return true. Otherwise, false.
  */
 void try_to_migrate(struct page *page, enum ttu_flags flags)
 {
_

Patches currently in -mm which might be from hughd@google.com are

fs-mm-fix-race-in-unlinking-swapfile.patch

