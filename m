Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E17EC433E9
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:49:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03B6B22D06
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:49:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726288AbhAXBtq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 23 Jan 2021 20:49:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:49666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726448AbhAXBtk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 23 Jan 2021 20:49:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F82022D06;
        Sun, 24 Jan 2021 01:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611452939;
        bh=zNXM8PjsRL+FW2rPwPccoC8ISijRvDVgwaXdClhUJHg=;
        h=Date:From:To:Subject:From;
        b=Jr/ZxcDaRANRelYsQLMLtZP3t+kJ0qTyTQpQEv7687bgX+cklIKt9IzlX74U9+1mW
         nwojKTTAYqeSTLziH2WrDiurK2BpuIpvsE2tNTKjLy+3lC6ncEOwGsNQo4B8bEYlA/
         J+8CdFVnKZPI3oNlkvnb0JowLy/9rest8bSvcAE8=
Date:   Sat, 23 Jan 2021 17:48:58 -0800
From:   akpm@linux-foundation.org
To:     hch@lst.de, kent.overstreet@gmail.com, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  +
 mm-filemap-pass-a-sleep-state-to-put_and_wait_on_page_locked.patch added to
 -mm tree
Message-ID: <20210124014858.gKp5tRLuA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: pass a sleep state to put_and_wait_on_page_locked
has been added to the -mm tree.  Its filename is
     mm-filemap-pass-a-sleep-state-to-put_and_wait_on_page_locked.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-filemap-pass-a-sleep-state-to-put_and_wait_on_page_locked.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-filemap-pass-a-sleep-state-to-put_and_wait_on_page_locked.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -1378,20 +1378,23 @@ static int wait_on_page_locked_async(str
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

Patches currently in -mm which might be from willy@infradead.org are

mm-debug-improve-memcg-debugging.patch
mm-filemap-rename-generic_file_buffered_read-subfunctions.patch
mm-filemap-remove-dynamically-allocated-array-from-filemap_read.patch
mm-filemap-convert-filemap_get_pages-to-take-a-pagevec.patch
mm-filemap-use-head-pages-in-generic_file_buffered_read.patch
mm-filemap-pass-a-sleep-state-to-put_and_wait_on_page_locked.patch
mm-filemap-support-readpage-splitting-a-page.patch
mm-filemap-inline-__wait_on_page_locked_async-into-caller.patch
mm-filemap-dont-call-readpage-if-iocb_waitq-is-set.patch
mm-filemap-change-filemap_read_page-calling-conventions.patch
mm-filemap-change-filemap_create_page-calling-conventions.patch
mm-filemap-convert-filemap_update_page-to-return-an-errno.patch
mm-filemap-move-the-iocb-checks-into-filemap_update_page.patch
mm-filemap-add-filemap_range_uptodate.patch
mm-filemap-split-filemap_readahead-out-of-filemap_get_pages.patch
mm-filemap-restructure-filemap_get_pages.patch
mm-filemap-dont-relock-the-page-after-calling-readpage.patch
mm-make-pagecache-tagged-lookups-return-only-head-pages.patch
mm-shmem-use-pagevec_lookup-in-shmem_unlock_mapping.patch
mm-swap-optimise-get_shadow_from_swap_cache.patch
mm-add-fgp_entry.patch
mm-filemap-rename-find_get_entry-to-mapping_get_entry.patch
mm-filemap-add-helper-for-finding-pages.patch
mm-filemap-add-helper-for-finding-pages-fix.patch
mm-filemap-add-mapping_seek_hole_data.patch
mm-filemap-add-mapping_seek_hole_data-fix.patch
iomap-use-mapping_seek_hole_data.patch
mm-add-and-use-find_lock_entries.patch
mm-add-and-use-find_lock_entries-fix.patch
mm-add-an-end-parameter-to-find_get_entries.patch
mm-add-an-end-parameter-to-pagevec_lookup_entries.patch
mm-remove-nr_entries-parameter-from-pagevec_lookup_entries.patch
mm-pass-pvec-directly-to-find_get_entries.patch
mm-remove-pagevec_lookup_entries.patch

