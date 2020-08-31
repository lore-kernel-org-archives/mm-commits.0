Return-Path: <SRS0=vJaG=CJ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 965BDC433E6
	for <mm-commits@archiver.kernel.org>; Mon, 31 Aug 2020 19:49:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E8F62083E
	for <mm-commits@archiver.kernel.org>; Mon, 31 Aug 2020 19:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598903385;
	bh=+jSBvxZUI8I54XyatMVbGApAH10tq5tq/sdhzI5UKUE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=YAEaUnRag13AbgtpDzIOMcgC7SBbtBFJh2RC/Is4Mlb1CB+hGIxU4y+083kiagkQ/
	 MGP9Uxx5862Jr1qdiar+EXkf/SY0NbAZkdOV4ceJGeaZSbtzwbGiAmwWIRj2OUgz7x
	 QbDR4M+W5Cz5J606dvlv66I2NjYmNtEX8I1Jhnww=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729754AbgHaTtp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Aug 2020 15:49:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:60344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726714AbgHaTto (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 31 Aug 2020 15:49:44 -0400
Received: from X1 (unknown [65.49.58.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F38A4206F0;
        Mon, 31 Aug 2020 19:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598903384;
        bh=+jSBvxZUI8I54XyatMVbGApAH10tq5tq/sdhzI5UKUE=;
        h=Date:From:To:Subject:From;
        b=RVaTvzV8QEBsSiNEE5v/1s188kP3WUxTEWHIJvGT/xRG23QX528j7hym7+J7N8Vln
         lcD+xxmY9FUl6byQp/LK+8a2rPYrY0UApflsNAGXHzy4CrVU65ejzNQntfBVqL5Ivm
         qrmiYxSwulvsqnOq99WK/qDFsnX1dkPSwDGtMbYg=
Date:   Mon, 31 Aug 2020 12:49:43 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        bhe@redhat.com, richard.weiyang@linux.alibaba.com
Subject:  + mm-hugetlb-a-page-from-buddy-is-not-on-any-list.patch
 added to -mm tree
Message-ID: <20200831194943.5LTb6%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: a page from buddy is not on any list
has been added to the -mm tree.  Its filename is
     mm-hugetlb-a-page-from-buddy-is-not-on-any-list.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-a-page-from-buddy-is-not-on-any-list.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-a-page-from-buddy-is-not-on-any-list.patch

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
Subject: mm/hugetlb: a page from buddy is not on any list

The page allocated from buddy is not on any list, so just use list_add()
is enough.

Link: https://lkml.kernel.org/r/20200831022351.20916-6-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-a-page-from-buddy-is-not-on-any-list
+++ a/mm/hugetlb.c
@@ -2412,7 +2412,7 @@ struct page *alloc_huge_page(struct vm_a
 			h->resv_huge_pages--;
 		}
 		spin_lock(&hugetlb_lock);
-		list_move(&page->lru, &h->hugepage_activelist);
+		list_add(&page->lru, &h->hugepage_activelist);
 		/* Fall through */
 	}
 	hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h), h_cg, page);
_

Patches currently in -mm which might be from richard.weiyang@linux.alibaba.com are

mm-mmap-rename-__vma_unlink_common-to-__vma_unlink.patch
mm-mmap-leverage-vma_rb_erase_ignore-to-implement-vma_rb_erase.patch
mm-mmap-leave-adjust_next-as-virtual-address-instead-of-page-frame-number.patch
mm-hugetlb-not-necessary-to-coalesce-regions-recursively.patch
mm-hugetlb-remove-vm_bug_onnrg-in-get_file_region_entry_from_cache.patch
mm-hugetlb-use-list_splice-to-merge-two-list-at-once.patch
mm-hugetlb-count-file_region-to-be-added-when-regions_needed-=-null.patch
mm-hugetlb-a-page-from-buddy-is-not-on-any-list.patch
mm-hugetlb-narrow-the-hugetlb_lock-protection-area-during-preparing-huge-page.patch
mm-hugetlb-take-the-free-hpage-during-the-iteration-directly.patch
mm-page_reporting-drop-stale-list-head-check-in-page_reporting_cycle.patch
bitops-simplify-get_count_order_long.patch
bitops-use-the-same-mechanism-for-get_count_order.patch

