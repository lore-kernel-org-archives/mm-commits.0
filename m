Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6D9BC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:04:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8753964F33
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:04:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235031AbhBXUEQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:04:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:56272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235370AbhBXUDC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:03:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0076164F28;
        Wed, 24 Feb 2021 20:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614196923;
        bh=cm6mdEuoH//0Y6Q7axT1Aq8f1W47cBae5a1t7577Krs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=q0NuLO6N6GC7auWubzEgj/x/lUomTWEfg36WnunhQ2OijXlUCuNaJnZkRvXuelQIO
         kd++hTzzcbkRIBDcnAoWNBZlA7Eju+PWgPVLvFty68Yn8vnEndbhr7NzxY1CFPRtGr
         nwbGVbkTZ+1Pz9X2uM5wzCuVqTVv3oQXhjPCWyV0=
Date:   Wed, 24 Feb 2021 12:02:02 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hch@lst.de, kent.overstreet@gmail.com,
        linmiaohe@huawei.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 034/173] mm/filemap: pass a sleep state to
 put_and_wait_on_page_locked
Message-ID: <20210224200202.wo6eFwQ-w%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/filemap: pass a sleep state to put_and_wait_on_page_locked

This is prep work for the next patch, but I think at least one of the
current callers would prefer a killable sleep to an uninterruptible one.

Link: https://lkml.kernel.org/r/20210122160140.223228-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Kent Overstreet <kent.overstreet@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    3 +--
 mm/filemap.c            |    7 +++++--
 mm/huge_memory.c        |    4 ++--
 mm/migrate.c            |    4 ++--
 4 files changed, 10 insertions(+), 8 deletions(-)

--- a/include/linux/pagemap.h~mm-filemap-pass-a-sleep-state-to-put_and_wait_on_page_locked
+++ a/include/linux/pagemap.h
@@ -681,8 +681,7 @@ static inline int wait_on_page_locked_ki
 	return wait_on_page_bit_killable(compound_head(page), PG_locked);
 }
 
-extern void put_and_wait_on_page_locked(struct page *page);
-
+int put_and_wait_on_page_locked(struct page *page, int state);
 void wait_on_page_writeback(struct page *page);
 extern void end_page_writeback(struct page *page);
 void wait_for_stable_page(struct page *page);
--- a/mm/filemap.c~mm-filemap-pass-a-sleep-state-to-put_and_wait_on_page_locked
+++ a/mm/filemap.c
@@ -1384,20 +1384,23 @@ static int wait_on_page_locked_async(str
 /**
  * put_and_wait_on_page_locked - Drop a reference and wait for it to be unlocked
  * @page: The page to wait for.
+ * @state: The sleep state (TASK_KILLABLE, TASK_UNINTERRUPTIBLE, etc).
  *
  * The caller should hold a reference on @page.  They expect the page to
  * become unlocked relatively soon, but do not wish to hold up migration
  * (for example) by holding the reference while waiting for the page to
  * come unlocked.  After this function returns, the caller should not
  * dereference @page.
+ *
+ * Return: 0 if the page was unlocked or -EINTR if interrupted by a signal.
  */
-void put_and_wait_on_page_locked(struct page *page)
+int put_and_wait_on_page_locked(struct page *page, int state)
 {
 	wait_queue_head_t *q;
 
 	page = compound_head(page);
 	q = page_waitqueue(page);
-	wait_on_page_bit_common(q, page, PG_locked, TASK_UNINTERRUPTIBLE, DROP);
+	return wait_on_page_bit_common(q, page, PG_locked, state, DROP);
 }
 
 /**
--- a/mm/huge_memory.c~mm-filemap-pass-a-sleep-state-to-put_and_wait_on_page_locked
+++ a/mm/huge_memory.c
@@ -1439,7 +1439,7 @@ vm_fault_t do_huge_pmd_numa_page(struct
 		if (!get_page_unless_zero(page))
 			goto out_unlock;
 		spin_unlock(vmf->ptl);
-		put_and_wait_on_page_locked(page);
+		put_and_wait_on_page_locked(page, TASK_UNINTERRUPTIBLE);
 		goto out;
 	}
 
@@ -1475,7 +1475,7 @@ vm_fault_t do_huge_pmd_numa_page(struct
 		if (!get_page_unless_zero(page))
 			goto out_unlock;
 		spin_unlock(vmf->ptl);
-		put_and_wait_on_page_locked(page);
+		put_and_wait_on_page_locked(page, TASK_UNINTERRUPTIBLE);
 		goto out;
 	}
 
--- a/mm/migrate.c~mm-filemap-pass-a-sleep-state-to-put_and_wait_on_page_locked
+++ a/mm/migrate.c
@@ -331,7 +331,7 @@ void __migration_entry_wait(struct mm_st
 	if (!get_page_unless_zero(page))
 		goto out;
 	pte_unmap_unlock(ptep, ptl);
-	put_and_wait_on_page_locked(page);
+	put_and_wait_on_page_locked(page, TASK_UNINTERRUPTIBLE);
 	return;
 out:
 	pte_unmap_unlock(ptep, ptl);
@@ -365,7 +365,7 @@ void pmd_migration_entry_wait(struct mm_
 	if (!get_page_unless_zero(page))
 		goto unlock;
 	spin_unlock(ptl);
-	put_and_wait_on_page_locked(page);
+	put_and_wait_on_page_locked(page, TASK_UNINTERRUPTIBLE);
 	return;
 unlock:
 	spin_unlock(ptl);
_
