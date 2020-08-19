Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03A0EC433E1
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 20:14:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D96F52083B
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 20:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597868059;
	bh=6o7Vjmk8r5T+5oCUjSAkHcTeq7yQtYdX8DnAUTLmVNc=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=sqarhdsLEs2I8hzU28FFLMGGBt+FxYrVZkuil4IuAQLU1U3VGsLm7oDmmWsF/bufS
	 nrt16xh5SyK3f/tq5Q8vKHeDVdOD3GPHSan005rkHqmc6nUilo3wCA0y4hMQyGX/kT
	 bloaCpOFqvrPE86cpuhbkEBGSVvWHLyn0u5KgRrw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgHSUOT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Aug 2020 16:14:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:34384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725997AbgHSUOS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Aug 2020 16:14:18 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD0C22078D;
        Wed, 19 Aug 2020 20:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597868058;
        bh=6o7Vjmk8r5T+5oCUjSAkHcTeq7yQtYdX8DnAUTLmVNc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=WRsvN9LWtDdRZ53NGR7tZf4Y799Bq6vH7QQd2O7iwHxDDpAN/nh0/bjnIpbLG5xEK
         Sny4CdqQ7u/0LwiXbTcoZIOU3cfUpiZ2dBHNKglPvCwazUnTR1SWKnKQ7KRfwB7O1S
         Z31QJFXbrFEVgqGrl5fFWobTbg8vtdsVhZus5mHw=
Date:   Wed, 19 Aug 2020 13:14:17 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        richard.weiyang@linux.alibaba.com
Subject:  +
 mm-mmap-rename-__vma_unlink_common-to-__vma_unlink.patch added to -mm tree
Message-ID: <20200819201417.G21XYv1hm%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: rename __vma_unlink_common() to __vma_unlink()
has been added to the -mm tree.  Its filename is
     mm-mmap-rename-__vma_unlink_common-to-__vma_unlink.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mmap-rename-__vma_unlink_common-to-__vma_unlink.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mmap-rename-__vma_unlink_common-to-__vma_unlink.patch

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

mm-mmap-rename-__vma_unlink_common-to-__vma_unlink.patch
mm-mmap-leverage-vma_rb_erase_ignore-to-implement-vma_rb_erase.patch
mm-page_reporting-drop-stale-list-head-check-in-page_reporting_cycle.patch

