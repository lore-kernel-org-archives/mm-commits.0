Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D796C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 29 Mar 2022 01:11:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiC2BMy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Mar 2022 21:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiC2BMt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2022 21:12:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 098C92E9C9
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 18:11:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5222B815AA
        for <mm-commits@vger.kernel.org>; Tue, 29 Mar 2022 01:11:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD2FC340EC;
        Tue, 29 Mar 2022 01:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648516264;
        bh=lkKi6eRcSEXobthscKo5U85fTVG3wYZHzpFPnoT7YHY=;
        h=Date:To:From:Subject:From;
        b=zmbpxfzjmFsn3W6a5TAth4KdWbAFMe8F/gJnOkybK8VRWpO5MleRpigTVtpcE07Wm
         mT48EC9qIdUdRP4jb5F9WfwUcXXQnCAVIDOnIrn1MncJHCfni/oSD+2Z54pfULoS5+
         IWK2ptua2399dy57QGGyIgDLH02AI/cZ0sly4Bz8=
Date:   Mon, 28 Mar 2022 18:11:03 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-z3fold-move-decrement-of-pool-pages_nr-into-__release_z3fold_page.patch added to -mm tree
Message-Id: <20220329011104.3AD2FC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/z3fold: move decrement of pool->pages_nr into __release_z3fold_page()
has been added to the -mm tree.  Its filename is
     mm-z3fold-move-decrement-of-pool-pages_nr-into-__release_z3fold_page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-z3fold-move-decrement-of-pool-pages_nr-into-__release_z3fold_page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-z3fold-move-decrement-of-pool-pages_nr-into-__release_z3fold_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/z3fold: move decrement of pool->pages_nr into __release_z3fold_page()

The z3fold will always do atomic64_dec(&pool->pages_nr) when the
__release_z3fold_page() is called.  Thus we can move decrement of
pool->pages_nr into __release_z3fold_page() to simplify the code.

Also we can reduce the size of z3fold.o ~1k.

Without this patch:
   text	   data	    bss	    dec	    hex	filename
  15444	   1376	      8	  16828	   41bc	mm/z3fold.o
With this patch:
   text	   data	    bss	    dec	    hex	filename
  15044	   1248	      8	  16300	   3fac	mm/z3fold.o

Link: https://lkml.kernel.org/r/20220308134311.59086-7-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |   41 ++++++++++++-----------------------------
 1 file changed, 12 insertions(+), 29 deletions(-)

--- a/mm/z3fold.c~mm-z3fold-move-decrement-of-pool-pages_nr-into-__release_z3fold_page
+++ a/mm/z3fold.c
@@ -520,6 +520,8 @@ static void __release_z3fold_page(struct
 	list_add(&zhdr->buddy, &pool->stale);
 	queue_work(pool->release_wq, &pool->work);
 	spin_unlock(&pool->stale_lock);
+
+	atomic64_dec(&pool->pages_nr);
 }
 
 static void release_z3fold_page(struct kref *ref)
@@ -737,13 +739,9 @@ static struct z3fold_header *compact_sin
 	return new_zhdr;
 
 out_fail:
-	if (new_zhdr) {
-		if (kref_put(&new_zhdr->refcount, release_z3fold_page_locked))
-			atomic64_dec(&pool->pages_nr);
-		else {
-			add_to_unbuddied(pool, new_zhdr);
-			z3fold_page_unlock(new_zhdr);
-		}
+	if (new_zhdr && !kref_put(&new_zhdr->refcount, release_z3fold_page_locked)) {
+		add_to_unbuddied(pool, new_zhdr);
+		z3fold_page_unlock(new_zhdr);
 	}
 	return NULL;
 
@@ -816,10 +814,8 @@ static void do_compact_page(struct z3fol
 	list_del_init(&zhdr->buddy);
 	spin_unlock(&pool->lock);
 
-	if (kref_put(&zhdr->refcount, release_z3fold_page_locked)) {
-		atomic64_dec(&pool->pages_nr);
+	if (kref_put(&zhdr->refcount, release_z3fold_page_locked))
 		return;
-	}
 
 	if (test_bit(PAGE_STALE, &page->private) ||
 	    test_and_set_bit(PAGE_CLAIMED, &page->private)) {
@@ -829,9 +825,7 @@ static void do_compact_page(struct z3fol
 
 	if (!zhdr->foreign_handles && buddy_single(zhdr) &&
 	    zhdr->mapped_count == 0 && compact_single_buddy(zhdr)) {
-		if (kref_put(&zhdr->refcount, release_z3fold_page_locked))
-			atomic64_dec(&pool->pages_nr);
-		else {
+		if (!kref_put(&zhdr->refcount, release_z3fold_page_locked)) {
 			clear_bit(PAGE_CLAIMED, &page->private);
 			z3fold_page_unlock(zhdr);
 		}
@@ -1089,10 +1083,8 @@ retry:
 		if (zhdr) {
 			bud = get_free_buddy(zhdr, chunks);
 			if (bud == HEADLESS) {
-				if (kref_put(&zhdr->refcount,
+				if (!kref_put(&zhdr->refcount,
 					     release_z3fold_page_locked))
-					atomic64_dec(&pool->pages_nr);
-				else
 					z3fold_page_unlock(zhdr);
 				pr_err("No free chunks in unbuddied\n");
 				WARN_ON(1);
@@ -1239,10 +1231,8 @@ static void z3fold_free(struct z3fold_po
 
 	if (!page_claimed)
 		free_handle(handle, zhdr);
-	if (kref_put(&zhdr->refcount, release_z3fold_page_locked_list)) {
-		atomic64_dec(&pool->pages_nr);
+	if (kref_put(&zhdr->refcount, release_z3fold_page_locked_list))
 		return;
-	}
 	if (page_claimed) {
 		/* the page has not been claimed by us */
 		put_z3fold_header(zhdr);
@@ -1353,9 +1343,7 @@ static int z3fold_reclaim_page(struct z3
 				break;
 			}
 			if (!z3fold_page_trylock(zhdr)) {
-				if (kref_put(&zhdr->refcount,
-						release_z3fold_page))
-					atomic64_dec(&pool->pages_nr);
+				kref_put(&zhdr->refcount, release_z3fold_page);
 				zhdr = NULL;
 				continue; /* can't evict at this point */
 			}
@@ -1366,10 +1354,8 @@ static int z3fold_reclaim_page(struct z3
 			 */
 			if (zhdr->foreign_handles ||
 			    test_and_set_bit(PAGE_CLAIMED, &page->private)) {
-				if (kref_put(&zhdr->refcount,
+				if (!kref_put(&zhdr->refcount,
 						release_z3fold_page_locked))
-					atomic64_dec(&pool->pages_nr);
-				else
 					z3fold_page_unlock(zhdr);
 				zhdr = NULL;
 				continue; /* can't evict such page */
@@ -1447,7 +1433,6 @@ next:
 			if (kref_put(&zhdr->refcount,
 					release_z3fold_page_locked)) {
 				kmem_cache_free(pool->c_handle, slots);
-				atomic64_dec(&pool->pages_nr);
 				return 0;
 			}
 			/*
@@ -1669,10 +1654,8 @@ static void z3fold_page_putback(struct p
 	if (!list_empty(&zhdr->buddy))
 		list_del_init(&zhdr->buddy);
 	INIT_LIST_HEAD(&page->lru);
-	if (kref_put(&zhdr->refcount, release_z3fold_page_locked)) {
-		atomic64_dec(&pool->pages_nr);
+	if (kref_put(&zhdr->refcount, release_z3fold_page_locked))
 		return;
-	}
 	spin_lock(&pool->lock);
 	list_add(&page->lru, &pool->lru);
 	spin_unlock(&pool->lock);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-shmem-make-shmem_init-return-void.patch
mm-memcg-remove-unneeded-nr_scanned.patch
mm-mremap-use-helper-mlock_future_check.patch
mm-mlock-fix-two-bugs-in-user_shm_lock.patch
mm-z3fold-declare-z3fold_mount-with-__init.patch
mm-z3fold-remove-obsolete-comment-in-z3fold_alloc.patch
mm-z3fold-minor-clean-up-for-z3fold_free.patch
mm-z3fold-remove-unneeded-page_mapcount_reset-and-clearpageprivate.patch
mm-z3fold-remove-confusing-local-variable-l-reassignment.patch
mm-z3fold-move-decrement-of-pool-pages_nr-into-__release_z3fold_page.patch
mm-z3fold-remove-redundant-list_del_init-of-zhdr-buddy-in-z3fold_free.patch
mm-z3fold-remove-unneeded-page_headless-check-in-free_handle.patch
mm-compaction-use-helper-isolation_suitable.patch
mm-migration-remove-unneeded-local-variable-mapping_locked.patch
mm-migration-remove-unneeded-out-label.patch
mm-migration-remove-unneeded-local-variable-page_lru.patch
mm-migration-fix-the-confusing-pagetranshuge-check.patch
mm-migration-use-helper-function-vma_lookup-in-add_page_for_migration.patch
mm-migration-use-helper-macro-min-in-do_pages_stat.patch
mm-migration-avoid-unneeded-nodemask_t-initialization.patch
mm-migration-remove-some-duplicated-codes-in-migrate_pages.patch
mm-migration-fix-potential-page-refcounts-leak-in-migrate_pages.patch
mm-migration-fix-potential-invalid-node-access-for-reclaim-based-migration.patch
mm-migration-fix-possible-do_pages_stat_array-racing-with-memory-offline.patch

