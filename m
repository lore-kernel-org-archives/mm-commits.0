Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4F93C433DB
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:12:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A274922D07
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:12:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbhAXBM3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 23 Jan 2021 20:12:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:45822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbhAXBM1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 23 Jan 2021 20:12:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFFA222CB9;
        Sun, 24 Jan 2021 01:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611450707;
        bh=dOhpZZKdmFgjf15OkaLjpJTzt3hVZN67jly0iSPHcfQ=;
        h=Date:From:To:Subject:From;
        b=QZx2Hp4j+t8chd+nRPqxY54qbrPfWR0C3UbZKWE/HwxwaGeYn7rM0EobYI369xcg9
         9AAfGqgK3Yz2y7lw/yxqJUawuYAG+nxqiIjSm9WQmufQaBC2vzbFRLfCJCMuAo96XL
         lBVUavcbZAbfP/aecF7xRJckuNBdyhT4F26Q8CQA=
Date:   Sat, 23 Jan 2021 17:11:46 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mm-commits@vger.kernel.org, riel@surriel.com
Subject:  +
 mm-rmap-correct-some-obsolete-comments-of-anon_vma.patch added to -mm tree
Message-ID: <20210124011146.s3UKDZBkv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap: correct some obsolete comments of anon_vma
has been added to the -mm tree.  Its filename is
     mm-rmap-correct-some-obsolete-comments-of-anon_vma.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-rmap-correct-some-obsolete-comments-of-anon_vma.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-rmap-correct-some-obsolete-comments-of-anon_vma.patch

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
Subject: mm/rmap: correct some obsolete comments of anon_vma

commit 2b575eb64f7a ("mm: convert anon_vma->lock to a mutex") changed
spinlock used to serialize access to vma list to mutex.  And further, the
commit 5a505085f043 ("mm/rmap: Convert the struct anon_vma::mutex to an
rwsem") converted the mutex to an rwsem for solving scalability problem. 
So replace spinlock with rwsem to make comment uptodate.

Link: https://lkml.kernel.org/r/20210123072459.25903-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/rmap.c~mm-rmap-correct-some-obsolete-comments-of-anon_vma
+++ a/mm/rmap.c
@@ -168,7 +168,7 @@ static void anon_vma_chain_link(struct v
  *
  * Anon-vma allocations are very subtle, because we may have
  * optimistically looked up an anon_vma in page_lock_anon_vma_read()
- * and that may actually touch the spinlock even in the newly
+ * and that may actually touch the rwsem even in the newly
  * allocated vma (it depends on RCU to make sure that the
  * anon_vma isn't actually destroyed).
  *
@@ -359,7 +359,7 @@ int anon_vma_fork(struct vm_area_struct
 		goto out_error_free_anon_vma;
 
 	/*
-	 * The root anon_vma's spinlock is the lock actually used when we
+	 * The root anon_vma's rwsem is the lock actually used when we
 	 * lock any of the anon_vmas in this anon_vma tree.
 	 */
 	anon_vma->root = pvma->anon_vma->root;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hugetlb-fix-potential-double-free-in-hugetlb_register_node-error-path.patch
mm-hugetlb-avoid-unnecessary-hugetlb_acct_memory-call.patch
mm-hugetlb-use-helper-huge_page_order-and-pages_per_huge_page.patch
mm-workingsetc-avoid-unnecessary-max_nodes-estimation-in-count_shadow_nodes.patch
z3fold-remove-unused-attribute-for-release_z3fold_page.patch
z3fold-simplify-the-zhdr-initialization-code-in-init_z3fold_page.patch
mm-compaction-remove-duplicated-vm_bug_on_page-pagelocked.patch
hugetlbfs-remove-useless-bug_oninode-in-hugetlbfs_setattr.patch
hugetlbfs-use-helper-macro-default_hstate-in-init_hugetlbfs_fs.patch
hugetlbfs-correct-obsolete-function-name-in-hugetlbfs_read_iter.patch
hugetlbfs-remove-meaningless-variable-avoid_reserve.patch
mm-rmap-correct-some-obsolete-comments-of-anon_vma.patch
mm-zsmallocc-convert-to-use-kmem_cache_zalloc-in-cache_alloc_zspage.patch

