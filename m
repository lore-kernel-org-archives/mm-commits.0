Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA45FC63697
	for <mm-commits@archiver.kernel.org>; Tue, 24 Nov 2020 01:12:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 863ED20721
	for <mm-commits@archiver.kernel.org>; Tue, 24 Nov 2020 01:12:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ioLn70zL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729863AbgKXBMd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 23 Nov 2020 20:12:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:49060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729850AbgKXBMd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 23 Nov 2020 20:12:33 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AB4D20721;
        Tue, 24 Nov 2020 01:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606180352;
        bh=Ebca+I+YiPQs5bhSrz/ysCEadYHlr7Yx9sGgbeyRdHw=;
        h=Date:From:To:Subject:From;
        b=ioLn70zLwyFf4WeD2mA55RSjZ1EsycSUAGEX1/rvPnP4dIUEN4TbiKVwRvbtW2WGJ
         x9LhwDQuJMs9S0obfPwUyvUYwvyMpGQeeKCJQUxrKiou4RYdLNxpxRiUkA0Zqtfj5q
         z3gBi80TzP7a1BnAGb0PdFONRevuIA1RLhuziGi4=
Date:   Mon, 23 Nov 2020 17:12:31 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com,
        hughd@google.com, koct9i@gmail.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, yuzhao@google.com
Subject:  + mm-swapc-reduce-lock-contention-in-lru_cache_add.patch
 added to -mm tree
Message-ID: <20201124011231.SlSNRYgMC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap.c: reduce lock contention in lru_cache_add
has been added to the -mm tree.  Its filename is
     mm-swapc-reduce-lock-contention-in-lru_cache_add.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-swapc-reduce-lock-contention-in-lru_cache_add.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-swapc-reduce-lock-contention-in-lru_cache_add.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm/swap.c: reduce lock contention in lru_cache_add

The current relock logic will change lru_lock when it finds a new lruvec,
so if 2 memcgs are reading a file or allocating pages at same time, they
could hold the lru_lock alternately, and wait for each other for fairness
attribute of ticket spin lock.

This patch will sort all lru_locks and only hold them once in the above
scenario.  That could reduce fairness waiting for lock reacquision. 
vm-scalability/case-lru-file-readtwice gets a ~5% performance gain on my
2P*20core*HT machine.

Testing when all or most of the pages belong to the same lruvec show no
regression - most time is spent on lru_lock for lru sensitive cases.

Link: https://lkml.kernel.org/r/1605860847-47445-1-git-send-email-alex.shi@linux.alibaba.com
Suggested-by: Konstantin Khlebnikov <koct9i@gmail.com>
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   57 ++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 49 insertions(+), 8 deletions(-)

--- a/mm/swap.c~mm-swapc-reduce-lock-contention-in-lru_cache_add
+++ a/mm/swap.c
@@ -1009,24 +1009,65 @@ static void __pagevec_lru_add_fn(struct
 	trace_mm_lru_insertion(page, lru);
 }
 
+struct lruvecs {
+	struct list_head lists[PAGEVEC_SIZE];
+	struct lruvec *vecs[PAGEVEC_SIZE];
+};
+
+/* Sort pvec pages on their lruvec */
+int sort_page_lruvec(struct lruvecs *lruvecs, struct pagevec *pvec)
+{
+	int i, j, nr_lruvec;
+	struct page *page;
+	struct lruvec *lruvec = NULL;
+
+	lruvecs->vecs[0] = NULL;
+	for (i = nr_lruvec = 0; i < pagevec_count(pvec); i++) {
+		page = pvec->pages[i];
+		lruvec = mem_cgroup_page_lruvec(page, page_pgdat(page));
+
+		/* Try to find a same lruvec */
+		for (j = 0; j <= nr_lruvec; j++)
+			if (lruvec == lruvecs->vecs[j])
+				break;
+
+		/* A new lruvec */
+		if (j > nr_lruvec) {
+			INIT_LIST_HEAD(&lruvecs->lists[nr_lruvec]);
+			lruvecs->vecs[nr_lruvec] = lruvec;
+			j = nr_lruvec++;
+			lruvecs->vecs[nr_lruvec] = 0;
+		}
+
+		list_add_tail(&page->lru, &lruvecs->lists[j]);
+	}
+
+	return nr_lruvec;
+}
+
 /*
  * Add the passed pages to the LRU, then drop the caller's refcount
  * on them.  Reinitialises the caller's pagevec.
  */
 void __pagevec_lru_add(struct pagevec *pvec)
 {
-	int i;
-	struct lruvec *lruvec = NULL;
+	int i, nr_lruvec;
 	unsigned long flags = 0;
+	struct page *page;
+	struct lruvecs lruvecs;
 
-	for (i = 0; i < pagevec_count(pvec); i++) {
-		struct page *page = pvec->pages[i];
+	nr_lruvec = sort_page_lruvec(&lruvecs, pvec);
 
-		lruvec = relock_page_lruvec_irqsave(page, lruvec, &flags);
-		__pagevec_lru_add_fn(page, lruvec);
+	for (i = 0; i < nr_lruvec; i++) {
+		spin_lock_irqsave(&lruvecs.vecs[i]->lru_lock, flags);
+		while (!list_empty(&lruvecs.lists[i])) {
+			page = lru_to_page(&lruvecs.lists[i]);
+			list_del(&page->lru);
+			__pagevec_lru_add_fn(page, lruvecs.vecs[i]);
+		}
+		spin_unlock_irqrestore(&lruvecs.vecs[i]->lru_lock, flags);
 	}
-	if (lruvec)
-		unlock_page_lruvec_irqrestore(lruvec, flags);
+
 	release_pages(pvec->pages, pvec->nr);
 	pagevec_reinit(pvec);
 }
_

Patches currently in -mm which might be from alex.shi@linux.alibaba.com are

mm-filemap-add-static-for-function-__add_to_page_cache_locked.patch
fs-ntfs-remove-unused-varibles.patch
fs-ntfs-remove-unused-varible-attr_len.patch
mm-truncate-add-parameter-explanation-for-invalidate_mapping_pagevec.patch
mm-memcg-update-page-struct-member-in-comments.patch
mm-thp-move-lru_add_page_tail-func-to-huge_memoryc.patch
mm-thp-use-head-for-head-page-in-lru_add_page_tail.patch
mm-thp-simplify-lru_add_page_tail.patch
mm-thp-narrow-lru-locking.patch
mm-vmscan-remove-unnecessary-lruvec-adding.patch
mm-rmap-stop-store-reordering-issue-on-page-mapping.patch
mm-rmap-stop-store-reordering-issue-on-page-mapping-fix.patch
mm-memcg-add-debug-checking-in-lock_page_memcg.patch
mm-swapc-fold-vm-event-pgrotated-into-pagevec_move_tail_fn.patch
mm-lru-move-lock-into-lru_note_cost.patch
mm-vmscan-remove-lruvec-reget-in-move_pages_to_lru.patch
mm-mlock-remove-lru_lock-on-testclearpagemlocked.patch
mm-mlock-remove-__munlock_isolate_lru_page.patch
mm-lru-introduce-testclearpagelru.patch
mm-compaction-do-page-isolation-first-in-compaction.patch
mm-swapc-serialize-memcg-changes-in-pagevec_lru_move_fn.patch
mm-lru-replace-pgdat-lru_lock-with-lruvec-lock.patch
mm-lru-replace-pgdat-lru_lock-with-lruvec-lock-fix.patch
mm-lru-replace-pgdat-lru_lock-with-lruvec-lock-fix-2.patch
mm-lru-introduce-the-relock_page_lruvec-function-fix.patch
mm-memcg-remove-incorrect-comments.patch
mm-mapping_dirty_helpers-enhance-the-kernel-doc-markups.patch
mm-add-colon-to-fix-kernel-doc-markups-error-for-check_pte.patch
mm-vmalloc-add-align-parameter-explanation-for-pvm_determine_end_from_reverse.patch
docs-vm-remove-unused-3-items-explanation-for-proc-vmstat.patch
khugepaged-add-couples-parameter-explanation-for-kernel-doc-markup.patch
gcov-fix-kernel-doc-markup-issue.patch
mm-swapc-reduce-lock-contention-in-lru_cache_add.patch
mm-memcg-bail-early-from-swap-accounting-if-memcg-disabled.patch
mm-memcg-warning-on-memcg-after-readahead-page-charged.patch
mm-memcontrol-rewrite-mem_cgroup_page_lruvec-fix.patch

