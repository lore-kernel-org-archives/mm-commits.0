Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02D75C6FA8A
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:30:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiILDaf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbiILD3C (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:29:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C9427FFD
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:29:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94B3561171
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:28:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD94C4347C;
        Mon, 12 Sep 2022 03:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953339;
        bh=J4e5Jh54wCP47u99poHxzUZRQLvsjTfUzpJsOoywWHs=;
        h=Date:To:From:Subject:From;
        b=Ywk6EvutSvqRzKVBty21+27oYmKFgJEEaQoFkmqpu7txXQ9i1U/yCOPJogDZHw8DD
         13Bs1x0s4IGtJcRbhTn334iAB9sm6Lv7mj/BBj3LrWDuzBi2lKqegrNvi7WrvqgKcp
         mlmn6oMPuWKyWAtybHhfXwy/TGkS/TaQQPd+mFLY=
Date:   Sun, 11 Sep 2022 20:28:58 -0700
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        almasrymina@google.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb_cgroup-use-helper-for_each_hstate-and-hstate_index.patch removed from -mm tree
Message-Id: <20220912032858.EBD94C4347C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb_cgroup: use helper for_each_hstate and hstate_index
has been removed from the -mm tree.  Its filename was
     hugetlb_cgroup-use-helper-for_each_hstate-and-hstate_index.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: hugetlb_cgroup: use helper for_each_hstate and hstate_index
Date: Fri, 29 Jul 2022 16:01:06 +0800

Use helper for_each_hstate and hstate_index to iterate the hstate and get
the hstate index. Minor readability improvement.

Link: https://lkml.kernel.org/r/20220729080106.12752-6-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cgroup.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/mm/hugetlb_cgroup.c~hugetlb_cgroup-use-helper-for_each_hstate-and-hstate_index
+++ a/mm/hugetlb_cgroup.c
@@ -75,11 +75,11 @@ parent_hugetlb_cgroup(struct hugetlb_cgr
 
 static inline bool hugetlb_cgroup_have_usage(struct hugetlb_cgroup *h_cg)
 {
-	int idx;
+	struct hstate *h;
 
-	for (idx = 0; idx < hugetlb_max_hstate; idx++) {
+	for_each_hstate(h) {
 		if (page_counter_read(
-				hugetlb_cgroup_counter_from_cgroup(h_cg, idx)))
+		    hugetlb_cgroup_counter_from_cgroup(h_cg, hstate_index(h))))
 			return true;
 	}
 	return false;
@@ -225,17 +225,14 @@ static void hugetlb_cgroup_css_offline(s
 	struct hugetlb_cgroup *h_cg = hugetlb_cgroup_from_css(css);
 	struct hstate *h;
 	struct page *page;
-	int idx;
 
 	do {
-		idx = 0;
 		for_each_hstate(h) {
 			spin_lock_irq(&hugetlb_lock);
 			list_for_each_entry(page, &h->hugepage_activelist, lru)
-				hugetlb_cgroup_move_parent(idx, h_cg, page);
+				hugetlb_cgroup_move_parent(hstate_index(h), h_cg, page);
 
 			spin_unlock_irq(&hugetlb_lock);
-			idx++;
 		}
 		cond_resched();
 	} while (hugetlb_cgroup_have_usage(h_cg));
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hwpoison-use-clearpagehwpoison-in-memory_failure.patch
mm-hwpoison-use-__pagemovable-to-detect-non-lru-movable-pages.patch
mm-hwpoison-use-num_poisoned_pages_sub-to-decrease-num_poisoned_pages.patch
mm-hwpoison-avoid-unneeded-page_mapped_in_vma-overhead-in-collect_procs_anon.patch
mm-hwpoison-check-pagetable-explicitly-in-hwpoison_user_mappings.patch
mm-hwpoison-cleanup-some-obsolete-comments.patch
writeback-remove-unused-macro-dirty_full_scope.patch

