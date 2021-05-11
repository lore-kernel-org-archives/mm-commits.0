Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A173AC433ED
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 01:56:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 749C96147E
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 01:56:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbhEKB5H (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 May 2021 21:57:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:54864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230427AbhEKB5H (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 10 May 2021 21:57:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 943CE61554;
        Tue, 11 May 2021 01:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620698161;
        bh=kgyPECGLaQQ0xWJapHnIyOzvfV4OYKBhtKemu9x7Ltk=;
        h=Date:From:To:Subject:From;
        b=Y/NZsnx9Qnpl4Xi9BkInyTYgfmOewMQEU7KEXudhdPvK6m8h8RkyuJr7l1JPqZAqI
         ADKsna4VbSbLjP8E8SkjJZDba0USDbvUABB2bNDfZ4jUlpy807OEWh+XkG/JS5R+ea
         ohY2FyL11MDa4YentroUG+3J6EigW2E1r/XIFszg=
Date:   Mon, 10 May 2021 18:56:01 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, Liam.Howlett@Oracle.com,
        mm-commits@vger.kernel.org
Subject:  +
 mm-mmap-use-find_vma_intersection-in-do_mmap-for-overlap.patch added to -mm
 tree
Message-ID: <20210511015601.OaDxwahgC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: use find_vma_intersection() in do_mmap() for overlap
has been added to the -mm tree.  Its filename is
     mm-mmap-use-find_vma_intersection-in-do_mmap-for-overlap.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mmap-use-find_vma_intersection-in-do_mmap-for-overlap.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mmap-use-find_vma_intersection-in-do_mmap-for-overlap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Liam Howlett <liam.howlett@oracle.com>
Subject: mm/mmap: use find_vma_intersection() in do_mmap() for overlap

Using find_vma_intersection() avoids the need for a temporary variable and
makes the code cleaner.

Link: https://lkml.kernel.org/r/20210511014328.2902782-1-Liam.Howlett@Oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/mmap.c~mm-mmap-use-find_vma_intersection-in-do_mmap-for-overlap
+++ a/mm/mmap.c
@@ -1457,9 +1457,7 @@ unsigned long do_mmap(struct file *file,
 		return addr;
 
 	if (flags & MAP_FIXED_NOREPLACE) {
-		struct vm_area_struct *vma = find_vma(mm, addr);
-
-		if (vma && vma->vm_start < addr + len)
+		if (find_vma_intersection(mm, addr, addr + len))
 			return -EEXIST;
 	}
 
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

mm-mmap-introduce-unlock_range-for-code-cleanup.patch
mm-mmap-use-find_vma_intersection-in-do_mmap-for-overlap.patch

