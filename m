Return-Path: <SRS0=BOB0=CX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CA66C43461
	for <mm-commits@archiver.kernel.org>; Mon, 14 Sep 2020 00:33:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EA9921D1A
	for <mm-commits@archiver.kernel.org>; Mon, 14 Sep 2020 00:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600043620;
	bh=iU1EBZY1XUQ/fC011sa3lENBqE94yIH0spxd6v1SD3s=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=YAdoKNAe0V5RvO89NL+c1erWEaWRpulDCTpym5ZI6i21kfFJG5f7+mqF2XHw9jWHT
	 Q6gf/ZUNmTtdOfk8GRtKwMk+TYqjfo+vQddX3su2Y0ZqYx7zWPamL74vuDZMIKmxVq
	 bGUy2Piy+2ZWcuYAnNtcvS2292r5H7/ZsSotcGwU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbgINAdj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 13 Sep 2020 20:33:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:60322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725965AbgINAdj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 13 Sep 2020 20:33:39 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B719721D80;
        Mon, 14 Sep 2020 00:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600043618;
        bh=iU1EBZY1XUQ/fC011sa3lENBqE94yIH0spxd6v1SD3s=;
        h=Date:From:To:Subject:From;
        b=zUfPlrTLxwiDfkWVzbTQti1A9ZDmnpdo7IioAaieoVdsjampnaUsgtyxWvl9+B//r
         Y24FrEnkqQ0IjqAcUl8GLQYqsGPL8bN/TKS6VqQf55i/xyn6zNPjpbpcR/xKwSiRv7
         D/HgZfq6mYuTcvQABueDEevfKSjgQkOyRcYx5lGU=
Date:   Sun, 13 Sep 2020 17:33:38 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        richard.weiyang@linux.alibaba.com
Subject:  +
 mm-mmap-check-on-file-instead-of-the-rb_root_cached-of-its-address_space.patch
 added to -mm tree
Message-ID: <20200914003338.e35ZI%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: check on file instead of the rb_root_cached of its address_space
has been added to the -mm tree.  Its filename is
     mm-mmap-check-on-file-instead-of-the-rb_root_cached-of-its-address_space.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mmap-check-on-file-instead-of-the-rb_root_cached-of-its-address_space.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mmap-check-on-file-instead-of-the-rb_root_cached-of-its-address_space.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: mm/mmap: check on file instead of the rb_root_cached of its address_space

In __vma_adjust(), we do the check on *root* to decide whether to adjust
the address_space.  It seems to be more meaningful to do the check on
*file* itself.  This means we are adjusting some data because it is a file
backed vma.

Since we seem to assume the address_space is valid if it is a file backed
vma, let's just replace *root* with *file* here.

Link: https://lkml.kernel.org/r/20200913133631.37781-2-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/mmap.c~mm-mmap-check-on-file-instead-of-the-rb_root_cached-of-its-address_space
+++ a/mm/mmap.c
@@ -823,7 +823,7 @@ again:
 			anon_vma_interval_tree_pre_update_vma(next);
 	}
 
-	if (root) {
+	if (file) {
 		flush_dcache_mmap_lock(mapping);
 		vma_interval_tree_remove(vma, root);
 		if (adjust_next)
@@ -844,7 +844,7 @@ again:
 		next->vm_pgoff += adjust_next >> PAGE_SHIFT;
 	}
 
-	if (root) {
+	if (file) {
 		if (adjust_next)
 			vma_interval_tree_insert(next, root);
 		vma_interval_tree_insert(vma, root);
@@ -896,7 +896,7 @@ again:
 		anon_vma_unlock_write(anon_vma);
 	}
 
-	if (root) {
+	if (file) {
 		i_mmap_unlock_write(mapping);
 		uprobe_mmap(vma);
 
_

Patches currently in -mm which might be from richard.weiyang@linux.alibaba.com are

mm-mmap-rename-__vma_unlink_common-to-__vma_unlink.patch
mm-mmap-leverage-vma_rb_erase_ignore-to-implement-vma_rb_erase.patch
mm-mmap-leave-adjust_next-as-virtual-address-instead-of-page-frame-number.patch
mm-mmap-not-necessary-to-check-mapping-separately.patch
mm-mmap-check-on-file-instead-of-the-rb_root_cached-of-its-address_space.patch
mm-hugetlb-not-necessary-to-coalesce-regions-recursively.patch
mm-hugetlb-remove-vm_bug_onnrg-in-get_file_region_entry_from_cache.patch
mm-hugetlb-use-list_splice-to-merge-two-list-at-once.patch
mm-hugetlb-count-file_region-to-be-added-when-regions_needed-=-null.patch
mm-hugetlb-a-page-from-buddy-is-not-on-any-list.patch
mm-hugetlb-narrow-the-hugetlb_lock-protection-area-during-preparing-huge-page.patch
mm-hugetlb-take-the-free-hpage-during-the-iteration-directly.patch
mm-hugetlb-take-the-free-hpage-during-the-iteration-directly-v4.patch
mm-page_reporting-drop-stale-list-head-check-in-page_reporting_cycle.patch
bitops-simplify-get_count_order_long.patch
bitops-use-the-same-mechanism-for-get_count_order.patch

