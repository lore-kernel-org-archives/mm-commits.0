Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD2C1C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70BA8221FF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709273;
	bh=grkfr+bTM6cxfbWnXhkPmU5kYPuKqBDR/XvWInCKlUA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=GQNuliSfWHT2pRS+TlE7e7F29kq733lW+eRu5l4hpTlVlTXKQF6wYlEgrVOBMiRHY
	 28YsxixITe9DQRPdOADN1RFHC6XqGGvuGgjj0nW/n/e0E27dtNSZWlwvIiZd5IgPJb
	 D1o3odNzsWqfafM1ODhfM8ydOqoqoAmh2zIRBZdo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725923AbgJNVBI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:01:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:51164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727897AbgJNVBG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:01:06 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A19692225C;
        Wed, 14 Oct 2020 21:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709255;
        bh=grkfr+bTM6cxfbWnXhkPmU5kYPuKqBDR/XvWInCKlUA=;
        h=Date:From:To:Subject:From;
        b=a5pLh1N8rH1LnmN31TTaP7yAzO9MIufbqPg3AUtHXJIpVIV3AiKCqDWEQD4kuj3wy
         plt8sRWyuwxzlVtKnqsFCjmNNOSapvahTOoBf+ThFgBZr9C7ZvnM2hoUOsz/igvd21
         pKPyfTjiGpzp2fSSVskza44lmmTLBfgnO3sfGMys=
Date:   Wed, 14 Oct 2020 14:00:55 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        richard.weiyang@linux.alibaba.com
Subject:  [merged]
 mm-mmap-leverage-vma_rb_erase_ignore-to-implement-vma_rb_erase.patch
 removed from -mm tree
Message-ID: <20201014210055.yy5dYRrlm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: leverage vma_rb_erase_ignore() to implement vma_rb_erase()
has been removed from the -mm tree.  Its filename was
     mm-mmap-leverage-vma_rb_erase_ignore-to-implement-vma_rb_erase.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: mm/mmap: leverage vma_rb_erase_ignore() to implement vma_rb_erase()

These two functions share the same logic except ignore a different vma.

Let's reuse the code.

Link: https://lkml.kernel.org/r/20200809232057.23477-2-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--- a/mm/mmap.c~mm-mmap-leverage-vma_rb_erase_ignore-to-implement-vma_rb_erase
+++ a/mm/mmap.c
@@ -474,8 +474,12 @@ static __always_inline void vma_rb_erase
 {
 	/*
 	 * All rb_subtree_gap values must be consistent prior to erase,
-	 * with the possible exception of the "next" vma being erased if
-	 * next->vm_start was reduced.
+	 * with the possible exception of
+	 *
+	 * a. the "next" vma being erased if next->vm_start was reduced in
+	 *    __vma_adjust() -> __vma_unlink()
+	 * b. the vma being erased in detach_vmas_to_be_unmapped() ->
+	 *    vma_rb_erase()
 	 */
 	validate_mm_rb(root, ignore);
 
@@ -485,13 +489,7 @@ static __always_inline void vma_rb_erase
 static __always_inline void vma_rb_erase(struct vm_area_struct *vma,
 					 struct rb_root *root)
 {
-	/*
-	 * All rb_subtree_gap values must be consistent prior to erase,
-	 * with the possible exception of the vma being erased.
-	 */
-	validate_mm_rb(root, vma);
-
-	__vma_rb_erase(vma, root);
+	vma_rb_erase_ignore(vma, root, vma);
 }
 
 /*
_

Patches currently in -mm which might be from richard.weiyang@linux.alibaba.com are

mm-page_reporting-drop-stale-list-head-check-in-page_reporting_cycle.patch
bitops-simplify-get_count_order_long.patch
bitops-use-the-same-mechanism-for-get_count_order.patch

