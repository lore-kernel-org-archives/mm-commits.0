Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E378CC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89879221FF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709269;
	bh=Y1vKqP5CHx1ywCd8peNNZNm+3v7he0tlSWO8q0CYN+A=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=hLfdfltCtWXSJg0ln9BJtMKF5oTz8egfmT0Ogb4FUCxOIVdPZyd5lZeEEGA7DeB5d
	 uvlS1CAvDkSIXuWMcZ0f33j35SnCBzYvc9SeG1tKSOOK8G9J8stvKhrNtDuPL2lN6v
	 JQu2Y+iOd3mE+3gjmAb9V8f0jkkQD5VTPijp3uT8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728970AbgJNVBF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:01:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:51176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727897AbgJNVBD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:01:03 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 931AB22258;
        Wed, 14 Oct 2020 21:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709252;
        bh=Y1vKqP5CHx1ywCd8peNNZNm+3v7he0tlSWO8q0CYN+A=;
        h=Date:From:To:Subject:From;
        b=IB7WdQP2b1AZlD4/JelEfN9iA1OO5ivCLDdeHsgwYSw7yAZAn25JXKwgb/+PHekHt
         zChY+3dMyuK9uj0gi32bSLcqgFwTe8pW4lQCnjEPwVO5SKmrc0C/6MgTizp/t22YnY
         1SG6o1QkrOpYx5WvMiDUd+/ZGaDsl8vHeKLBjQKg=
Date:   Wed, 14 Oct 2020 14:00:52 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        richard.weiyang@linux.alibaba.com
Subject:  [merged]
 mm-mmap-rename-__vma_unlink_common-to-__vma_unlink.patch removed from -mm
 tree
Message-ID: <20201014210052.-DKIQct1u%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: rename __vma_unlink_common() to __vma_unlink()
has been removed from the -mm tree.  Its filename was
     mm-mmap-rename-__vma_unlink_common-to-__vma_unlink.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: mm/mmap: rename __vma_unlink_common() to __vma_unlink()

__vma_unlink_common() and __vma_unlink() are counterparts.  Since there is
no function named __vma_unlink(), let's rename __vma_unlink_common() to
__vma_unlink() to make the code more self-explanatory and easy for
audience to understand.

Otherwise we may expect there are several variants of vma_unlink() and
__vma_unlink_common() is used by them.

Link: https://lkml.kernel.org/r/20200809232057.23477-1-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/mmap.c~mm-mmap-rename-__vma_unlink_common-to-__vma_unlink
+++ a/mm/mmap.c
@@ -677,7 +677,7 @@ static void __insert_vm_struct(struct mm
 	mm->map_count++;
 }
 
-static __always_inline void __vma_unlink_common(struct mm_struct *mm,
+static __always_inline void __vma_unlink(struct mm_struct *mm,
 						struct vm_area_struct *vma,
 						struct vm_area_struct *ignore)
 {
@@ -859,7 +859,7 @@ again:
 		 * us to remove next before dropping the locks.
 		 */
 		if (remove_next != 3)
-			__vma_unlink_common(mm, next, next);
+			__vma_unlink(mm, next, next);
 		else
 			/*
 			 * vma is not before next if they've been
@@ -870,7 +870,7 @@ again:
 			 * "next" (which is stored in post-swap()
 			 * "vma").
 			 */
-			__vma_unlink_common(mm, next, vma);
+			__vma_unlink(mm, next, vma);
 		if (file)
 			__remove_shared_vm_struct(next, file, mapping);
 	} else if (insert) {
_

Patches currently in -mm which might be from richard.weiyang@linux.alibaba.com are

mm-page_reporting-drop-stale-list-head-check-in-page_reporting_cycle.patch
bitops-simplify-get_count_order_long.patch
bitops-use-the-same-mechanism-for-get_count_order.patch

