Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55B48C64E7B
	for <mm-commits@archiver.kernel.org>; Mon, 30 Nov 2020 20:23:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0214D207F7
	for <mm-commits@archiver.kernel.org>; Mon, 30 Nov 2020 20:23:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GyySwzNM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbgK3UXd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 30 Nov 2020 15:23:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:58900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727527AbgK3UXd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 30 Nov 2020 15:23:33 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52B962073C;
        Mon, 30 Nov 2020 20:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606767766;
        bh=c4vqtWtnnkzsTeQRmTWkdeYeNXtXHy4HPwp7Q5S+As0=;
        h=Date:From:To:Subject:From;
        b=GyySwzNMA1PVWQR38Y8KRYWOrWJ4MqvHksRdSFr9KktLUQkWukCRoQ9zWGvUyWKnn
         M/YtFvg3eLRTApVSa8YR5U5xfpmCWaFXARQ2HIAq6HWUgu23LG6sqkw9sDpSAa3bSi
         vwS0hruO7hMHavQ4z0MIuxd72UeVCLBmRmgKtF6U=
Date:   Mon, 30 Nov 2020 12:22:44 -0800
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, alexander.h.duyck@linux.intel.com,
        guro@fb.com, hannes@cmpxchg.org, laoar.shao@gmail.com,
        lstoakes@gmail.com, mhocko@kernel.org, mm-commits@vger.kernel.org,
        richard.weiyang@gmail.com, sfr@canb.auug.org.au,
        shakeelb@google.com
Subject:  [failures]
 mm-memcg-bail-out-early-when-memcg-in-mem_cgroup_lruvec.patch removed from
 -mm tree
Message-ID: <20201130202244.1HtlYOuKE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: bail out early when !memcg in mem_cgroup_lruvec
has been removed from the -mm tree.  Its filename was
     mm-memcg-bail-out-early-when-memcg-in-mem_cgroup_lruvec.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm/memcg: bail out early when !memcg in mem_cgroup_lruvec

Sometime, we use NULL memcg in mem_cgroup_lruvec(memcg, pgdat) so we could
get out early in the situation to avoid useless checking.

Polished as Andrew Morton's suggestion.

Link: https://lkml.kernel.org/r/9ddb17cd-cf5f-15b1-6a7d-986ee44fd5df@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-bail-out-early-when-memcg-in-mem_cgroup_lruvec
+++ a/include/linux/memcontrol.h
@@ -459,20 +459,17 @@ mem_cgroup_nodeinfo(struct mem_cgroup *m
 static inline struct lruvec *mem_cgroup_lruvec(struct mem_cgroup *memcg,
 					       struct pglist_data *pgdat)
 {
-	struct mem_cgroup_per_node *mz;
 	struct lruvec *lruvec;
 
-	if (mem_cgroup_disabled()) {
+	if (mem_cgroup_disabled() || !memcg) {
 		lruvec = &pgdat->__lruvec;
-		goto out;
-	}
+	} else {
+		struct mem_cgroup_per_node *mz;
 
-	if (!memcg)
-		memcg = root_mem_cgroup;
+		mz = mem_cgroup_nodeinfo(memcg, pgdat->node_id);
+		lruvec = &mz->lruvec;
+	}
 
-	mz = mem_cgroup_nodeinfo(memcg, pgdat->node_id);
-	lruvec = &mz->lruvec;
-out:
 	/*
 	 * Since a node can be onlined after the mem_cgroup was created,
 	 * we have to be prepared to initialize lruvec->pgdat here;
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
mm-vmscan-__isolate_lru_page_prepare-clean-up.patch
gcov-fix-kernel-doc-markup-issue.patch
mm-swapc-reduce-lock-contention-in-lru_cache_add.patch
mm-memcg-bail-early-from-swap-accounting-if-memcg-disabled.patch
mm-memcg-warning-on-memcg-after-readahead-page-charged.patch
mm-memcontrol-rewrite-mem_cgroup_page_lruvec-fix.patch

