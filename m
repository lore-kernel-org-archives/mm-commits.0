Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39196C433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:13:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04B2D21D7B
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602630802;
	bh=ywlPRBqNxd/72/CVs+cstbC5eDsDEOQ+DBhLQlCIhGQ=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=BdCjx+LLSok47/2Olha7CWEe99O/+xydOe/dsVR/1/O6TU+sx0t7D9F/IIyDXxjfC
	 rTL/BbOaqIj5Xhj7rOvk5pOHp7SI84pgaKZOSgd5ZNckOOIOzdxYncpY8sDNLow4qE
	 tpxqFy0lUn1GNRxozW6v6YJ1aJ9CHezBQQOpiq+M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387894AbgJMXNV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:13:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:47146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729677AbgJMXNT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:13:19 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED04121582;
        Tue, 13 Oct 2020 23:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602630799;
        bh=ywlPRBqNxd/72/CVs+cstbC5eDsDEOQ+DBhLQlCIhGQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ZfC3Dz7Ng1A7gfXU8pDOdRHrbVOCZqvdg32ZZDYZ/aqV5wScTeytF1m8vbFVlxz0f
         FVvkFl41oc8chCOwDTGQEz288gyxJWU+xVwyWLH8JeE3T/nur/sMugFHUCnp3Yd3Ih
         14YG6n/8yMK4ZTxT/W8wDdPMOvp5cK639DBMI8EQ=
Date:   Tue, 13 Oct 2020 16:13:18 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     bhe@redhat.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, richard.weiyang@linux.alibaba.com,
        vbabka@suse.cz
Subject:  [folded-merged]
 mm-hugetlb-take-the-free-hpage-during-the-iteration-directly-v4.patch
 removed from -mm tree
Message-ID: <20201013231318.ZuF7AZDKV%akpm@linux-foundation.org>
In-Reply-To: <20201010231559.e148a66f744d0b4870301450@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-take-the-free-hpage-during-the-iteration-directly-v4
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-take-the-free-hpage-during-the-iteration-directly-v4.patch

This patch was dropped because it was folded into mm-hugetlb-take-the-free-hpage-during-the-iteration-directly.patch

------------------------------------------------------
From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: mm-hugetlb-take-the-free-hpage-during-the-iteration-directly-v4

[mike.kravetz@oracle.com: points out a logic error]
Link: https://lkml.kernel.org/r/20200901014636.29737-8-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-take-the-free-hpage-during-the-iteration-directly-v4
+++ a/mm/hugetlb.c
@@ -1041,7 +1041,7 @@ static struct page *dequeue_huge_page_no
 			continue;
 
 		if (PageHWPoison(page))
-			break;
+			continue;
 
 		list_move(&page->lru, &h->hugepage_activelist);
 		set_page_refcounted(page);
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
mm-mempolicy-remove-or-narrow-the-lock-on-current.patch
mm-remove-unused-alloc_page_vma_node.patch
mm-page_reporting-drop-stale-list-head-check-in-page_reporting_cycle.patch
bitops-simplify-get_count_order_long.patch
bitops-use-the-same-mechanism-for-get_count_order.patch

