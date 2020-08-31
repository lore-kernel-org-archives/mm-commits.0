Return-Path: <SRS0=vJaG=CJ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A487C433E2
	for <mm-commits@archiver.kernel.org>; Mon, 31 Aug 2020 19:49:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7825D206F0
	for <mm-commits@archiver.kernel.org>; Mon, 31 Aug 2020 19:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598903389;
	bh=nVbBUelXwTw2NYMs10N/PHYexeyLyKaLt7EhFYRxQmc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=H6snFgvfdRj6y4nYQ0Ki59HF3AFaTBKq8WT19cxOHTS2a0DmxoXkm1DnovnZL2FCw
	 pRIBxl436C0zjWoJXg02DWdt3A2a8xkhOb+meruo3B23MKxDF91m60u9An18iq66C/
	 d1164EQz4UVUFlmHpuq8mPr8PLmEsu7eiT3U1Yno=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbgHaTtt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Aug 2020 15:49:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:60574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729784AbgHaTtt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 31 Aug 2020 15:49:49 -0400
Received: from X1 (unknown [65.49.58.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B3F92083E;
        Mon, 31 Aug 2020 19:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598903387;
        bh=nVbBUelXwTw2NYMs10N/PHYexeyLyKaLt7EhFYRxQmc=;
        h=Date:From:To:Subject:From;
        b=0q0QC9uqcqOSWCedPjoDN8ji7gbDDmtks4A8QDNbD5KcALjYd3wZqTBGqa3Q4q/QJ
         3J/B1CPx2q1XgaUU7arwI10n8HyL0lwoc+I9zc9tuYOd4Omn+ttG1UinVwSznu01/m
         15LSnXCKGUB7jE6a1dba/w/sX8TE0biam+zLev3U=
Date:   Mon, 31 Aug 2020 12:49:46 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        bhe@redhat.com, richard.weiyang@linux.alibaba.com
Subject:  +
 =?us-ascii?Q?mm-hugetlb-narrow-the-hugetlb=5Flock-protection-area-duri?=
 =?us-ascii?Q?ng-preparing-huge-page.patch?= added to -mm tree
Message-ID: <20200831194946.sAS_N%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: narrow the hugetlb_lock protection area during preparing huge page
has been added to the -mm tree.  Its filename is
     mm-hugetlb-narrow-the-hugetlb_lock-protection-area-during-preparing-huge-page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-narrow-the-hugetlb_lock-protection-area-during-preparing-huge-page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-narrow-the-hugetlb_lock-protection-area-during-preparing-huge-page.patch

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
Subject: mm/hugetlb: narrow the hugetlb_lock protection area during preparing huge page

set_hugetlb_cgroup_[rsvd] just manipulate page local data, which is not
necessary to be protected by hugetlb_lock.

Let's take this out.

Link: https://lkml.kernel.org/r/20200831022351.20916-7-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-narrow-the-hugetlb_lock-protection-area-during-preparing-huge-page
+++ a/mm/hugetlb.c
@@ -1500,9 +1500,9 @@ static void prep_new_huge_page(struct hs
 {
 	INIT_LIST_HEAD(&page->lru);
 	set_compound_page_dtor(page, HUGETLB_PAGE_DTOR);
-	spin_lock(&hugetlb_lock);
 	set_hugetlb_cgroup(page, NULL);
 	set_hugetlb_cgroup_rsvd(page, NULL);
+	spin_lock(&hugetlb_lock);
 	h->nr_huge_pages++;
 	h->nr_huge_pages_node[nid]++;
 	spin_unlock(&hugetlb_lock);
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

