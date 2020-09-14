Return-Path: <SRS0=BOB0=CX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2D32C433E2
	for <mm-commits@archiver.kernel.org>; Mon, 14 Sep 2020 00:33:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9FA121D1A
	for <mm-commits@archiver.kernel.org>; Mon, 14 Sep 2020 00:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600043618;
	bh=+gcwfQxdlQTV3JlSQiXiGc/vOaYrVBjMFvhYJhTWtKQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=0PohVKMUC1sVEO871Xe4MyMYWGazMDcTV/9dEhAB1wvtS2KZV2P1WCJhPxjQacu94
	 zsx4cY+ng8DNUNgXQ7KS7qOynutksFWxR8eaGxsCrsbK3nR8jvfZKt6SW5jCZ+0N5I
	 iMrZ3exlIlCvkYALElCkqmgMr7KT/rkmzKqutbGs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbgINAdi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 13 Sep 2020 20:33:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:60294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725965AbgINAdh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 13 Sep 2020 20:33:37 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA34821655;
        Mon, 14 Sep 2020 00:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600043617;
        bh=+gcwfQxdlQTV3JlSQiXiGc/vOaYrVBjMFvhYJhTWtKQ=;
        h=Date:From:To:Subject:From;
        b=qDM5OraXZHjnv946MyAb5gcQyYVNP6ZqnL8iMQ1UCKyEf4shUthfZqNcL3W0+W8K+
         mzMy5prQBgVdfygET+tvphphgCfe3msNk5ConmROEjettorRy0FIwqidPA0SG1+Akk
         dRuaGQD8w03pLgvO5OZKDx8b4xpcgcpPI5bZ2jaU=
Date:   Sun, 13 Sep 2020 17:33:36 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        richard.weiyang@linux.alibaba.com
Subject:  + mm-mmap-not-necessary-to-check-mapping-separately.patch
 added to -mm tree
Message-ID: <20200914003336.wusqM%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: not necessary to check mapping separately
has been added to the -mm tree.  Its filename is
     mm-mmap-not-necessary-to-check-mapping-separately.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mmap-not-necessary-to-check-mapping-separately.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mmap-not-necessary-to-check-mapping-separately.patch

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
Subject: mm/mmap: not necessary to check mapping separately

*root* with type of struct rb_root_cached is an element of *mapping*
with type of struct address_space. This implies when we have a valid
*root* it must be a part of valid *mapping*.

So we can merge these two checks together to make the code more easy to
read and to save some cpu cycles.

Link: https://lkml.kernel.org/r/20200913133631.37781-1-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/mmap.c~mm-mmap-not-necessary-to-check-mapping-separately
+++ a/mm/mmap.c
@@ -895,10 +895,9 @@ again:
 			anon_vma_interval_tree_post_update_vma(next);
 		anon_vma_unlock_write(anon_vma);
 	}
-	if (mapping)
-		i_mmap_unlock_write(mapping);
 
 	if (root) {
+		i_mmap_unlock_write(mapping);
 		uprobe_mmap(vma);
 
 		if (adjust_next)
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

