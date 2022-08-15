Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5767C25B06
	for <mm-commits@archiver.kernel.org>; Mon, 15 Aug 2022 00:06:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiHOAGM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 14 Aug 2022 20:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiHOAGJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 14 Aug 2022 20:06:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59EC7EE14
        for <mm-commits@vger.kernel.org>; Sun, 14 Aug 2022 17:06:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A8C1B80B77
        for <mm-commits@vger.kernel.org>; Mon, 15 Aug 2022 00:06:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99FC6C43470;
        Mon, 15 Aug 2022 00:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660521965;
        bh=2Tq9uV3RdpSWFRrZ4MCal6FskilkL9zvOzgTVlSZ8EQ=;
        h=Date:To:From:Subject:From;
        b=AtJN3eQmCU/nbzAxEjVj8jGVIFZpuxH5ZonreA2Rc1Ls2pyBWqkUJUzzI2vGmtv6c
         mXnTTqu7vHupxvJLX5bvHu3OhMVVrRv4/dgc+cbPQizAcllbeIeeWs2IRDUxsntCJC
         Lss4C0SVIpQ9w5lOgZ95GCwisBIRBBaNliugq8nw=
Date:   Sun, 14 Aug 2022 17:06:04 -0700
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        almasrymina@google.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb_cgroup-use-helper-for_each_hstate-and-hstate_index.patch added to mm-unstable branch
Message-Id: <20220815000605.99FC6C43470@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb_cgroup: use helper for_each_hstate and hstate_index
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb_cgroup-use-helper-for_each_hstate-and-hstate_index.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb_cgroup-use-helper-for_each_hstate-and-hstate_index.patch

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

mm-hugetlb-avoid-corrupting-page-mapping-in-hugetlb_mcopy_atomic_pte.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
hugetlb_cgroup-remove-unneeded-nr_pages-0-check.patch
hugetlb_cgroup-hugetlbfs-use-helper-macro-sz_1kmg.patch
hugetlb_cgroup-remove-unneeded-return-value.patch
hugetlb_cgroup-use-helper-macro-numa_no_node.patch
hugetlb_cgroup-use-helper-for_each_hstate-and-hstate_index.patch

