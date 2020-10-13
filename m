Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41D7CC43457
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 091B122203
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633224;
	bh=/r2mebtdATowPkbsAhZedwG8NxXGvyeO7Q/eQKbWt1g=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=OYwgt+sgXXPKd/7k+mrXoB0FLgLSMWvLENBsHAEtqEw5+U8XdzoNq0AJH4yP1h1p1
	 BlUCaCrK+tY+ki6BzHz3GAVUdwoSW2+rVLmXtwrc3sSrkohgFIzIkuossO1E9UjZSm
	 WRGsBpP3zGQ9F3lb6RgokoQsYb1Z/204QCWwuIx0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387433AbgJMXxn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:53:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:38636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729182AbgJMXxe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:53:34 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A5CA206D5;
        Tue, 13 Oct 2020 23:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633213;
        bh=/r2mebtdATowPkbsAhZedwG8NxXGvyeO7Q/eQKbWt1g=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=dGpppEsq1Xy1tS8V38a6o00UD9zX3d1VS08B+R8R5iaWC+ZCR3Yd4AIwyKTTg/Jtb
         rZDqsKe3pOfTPr7Npydsq4Q+9cubKTuUk73kNS0vMao8m/jE3oq419nsM5UCo5gM3T
         fvEjEu8Yx1v6YoeB7o8smI1MMV9KASv/A96SUNuk=
Date:   Tue, 13 Oct 2020 16:53:32 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, richard.weiyang@linux.alibaba.com,
        torvalds@linux-foundation.org
Subject:  [patch 095/181] mm/mmap: rename __vma_unlink_common() to
 __vma_unlink()
Message-ID: <20201013235332.gKH75Vzq8%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
