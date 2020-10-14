Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4A0BC43457
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 643AA22259
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709266;
	bh=OlryHtK+do+Nx2HwNtFjQkFwX79EpTZSp8mBMf+8hh8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=VRADTjG9I99msvEBhzoRhRMtS1pADc5SIICpKMnjNDDjTYYznyHFHRSSb4gKPDv4U
	 FHqAUFbblQuPDgO1awK0+4ateT4w1UAdoZxrCS2XeaV8MouMxV41U9o9JCSmG5WmJO
	 90jwMabqXy20rpcB8kZCIO2D76KU/1Bt7ofzwZdE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbgJNVBF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:01:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:51164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728478AbgJNVBD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:01:03 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91E7B22253;
        Wed, 14 Oct 2020 21:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709246;
        bh=OlryHtK+do+Nx2HwNtFjQkFwX79EpTZSp8mBMf+8hh8=;
        h=Date:From:To:Subject:From;
        b=doIjvd5/p2HeQgYDILh8A7P0Jv1UHWwvd/8o+LEnsso0qqNB23VHttSn0hIDirgIS
         vsV5brBiprCHPphkctjmIpoH7sWLiQq3D3CyYrpOTMZR59Q+gq1XUicyOuhGw1HkH+
         aRbRSeT955ML20+xzM45jk385VcuSdjtJbAlS1RM=
Date:   Wed, 14 Oct 2020 14:00:46 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, mm-commits@vger.kernel.org,
        yanfei.xu@windriver.com
Subject:  [merged] mm-memory-fix-typo-in-__do_fault-comment.patch
 removed from -mm tree
Message-ID: <20201014210046.QfpR_q8Ug%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: fix typo in __do_fault() comment
has been removed from the -mm tree.  Its filename was
     mm-memory-fix-typo-in-__do_fault-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yanfei Xu <yanfei.xu@windriver.com>
Subject: mm/memory.c: fix typo in __do_fault() comment

It's "pte_alloc_one", not "pte_alloc_pne". Let's fix that.

Link: http://lkml.kernel.org/r/20200818104339.5310-1-yanfei.xu@windriver.com
Signed-off-by: Yanfei Xu <yanfei.xu@windriver.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-memory-fix-typo-in-__do_fault-comment
+++ a/mm/memory.c
@@ -3589,7 +3589,7 @@ static vm_fault_t __do_fault(struct vm_f
 	 *				unlock_page(A)
 	 * lock_page(B)
 	 *				lock_page(B)
-	 * pte_alloc_pne
+	 * pte_alloc_one
 	 *   shrink_page_list
 	 *     wait_on_page_writeback(A)
 	 *				SetPageWriteback(B)
_

Patches currently in -mm which might be from yanfei.xu@windriver.com are


