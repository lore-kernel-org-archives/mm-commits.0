Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 746A2C433B4
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 05:08:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5179E61433
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 05:08:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbhEJFJm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 May 2021 01:09:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:60986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230050AbhEJFJj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 10 May 2021 01:09:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBC0561430;
        Mon, 10 May 2021 05:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620623295;
        bh=oxVBEgUVMyhddUN3rc700OCrjo0XrFqfAhkrKBZrLX8=;
        h=Date:From:To:Subject:From;
        b=SnIMHopDpz5xQlW75YyLCXy2DpG2tuUAY1sjSm2fFkpVPc4gfxY+tFq0/JRXygYWZ
         +KcfL1k3cq5ojSsiQui7Gm8KX+h6zZTHO6ofyHhpuikwqWK5zqU9hH+N+8vgSZirwV
         52KXxu844Qu7OAiLVjNleYo8XKt1JrGUogcEk0T0=
Date:   Sun, 09 May 2021 22:08:15 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, gmjuareztello@gmail.com,
        mm-commits@vger.kernel.org
Subject:  +
 mm-mmapc-logic-of-find_vma_intersection-repeated-in-__do_munmap.patch added
 to -mm tree
Message-ID: <20210510050815.AWt0F3I_9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: logic of find_vma_intersection repeated in __do_munmap
has been added to the -mm tree.  Its filename is
     mm-mmapc-logic-of-find_vma_intersection-repeated-in-__do_munmap.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mmapc-logic-of-find_vma_intersection-repeated-in-__do_munmap.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mmapc-logic-of-find_vma_intersection-repeated-in-__do_munmap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gonzalo Matias Juarez Tello <gmjuareztello@gmail.com>
Subject: mm/mmap.c: logic of find_vma_intersection repeated in __do_munmap

Logic of find_vma_intersection() is repeated in __do_munmap().

Also, prev is assigned a value before checking vma->vm_start >= end which
might end up on a return statement making that assignment useless.

Calling find_vma_intersection() checks that condition and returns NULL if
no vma is found, hence only the !vma check is needed in __do_munmap().

Link: https://lkml.kernel.org/r/20210409162129.18313-1-gmjuareztello@gmail.com
Signed-off-by: Gonzalo Matias Juarez Tello <gmjuareztello@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/mm/mmap.c~mm-mmapc-logic-of-find_vma_intersection-repeated-in-__do_munmap
+++ a/mm/mmap.c
@@ -2828,16 +2828,11 @@ int __do_munmap(struct mm_struct *mm, un
 	 */
 	arch_unmap(mm, start, end);
 
-	/* Find the first overlapping VMA */
-	vma = find_vma(mm, start);
+	/* Find the first overlapping VMA where start < vma->vm_end */
+	vma = find_vma_intersection(mm, start, end);
 	if (!vma)
 		return 0;
 	prev = vma->vm_prev;
-	/* we have  start < vma->vm_end  */
-
-	/* if it doesn't overlap, we have nothing.. */
-	if (vma->vm_start >= end)
-		return 0;
 
 	/*
 	 * If we need to split any vma, do it now to save pain later.
_

Patches currently in -mm which might be from gmjuareztello@gmail.com are

mm-mmapc-logic-of-find_vma_intersection-repeated-in-__do_munmap.patch

