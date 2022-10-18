Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45FF1C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 22:04:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbiJRWER (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Oct 2022 18:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbiJRWEP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2022 18:04:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD770CF19F
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 15:04:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70C87B81F29
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 22:04:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10130C433C1;
        Tue, 18 Oct 2022 22:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666130648;
        bh=dE4Wrol/e8PGi36TynDadY+h3jznB477UoLyUoew9dw=;
        h=Date:To:From:Subject:From;
        b=meqCrbYYZCosG6cKHpAyQNUW/IFXiE3hDNw7KLoBhamFSkrakgtEwSFdKkBUgRwIF
         R9mE4oHDI5HLfh24AKOeOGRFcb85IMtTurHAJxO6KjQqRy1cep1H0myhp5p9FXS3yE
         8S8j3D+QhIZm9mc5IlWQs7vMDAO+vjt/the4+8xE=
Date:   Tue, 18 Oct 2022 15:04:07 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        mark.rutland@arm.com, liuzixian4@huawei.com,
        Liam.Howlett@oracle.com, jgg@nvidia.com, david@redhat.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-fix-map_fixed-address-return-on-vma-merge.patch added to mm-hotfixes-unstable branch
Message-Id: <20221018220408.10130C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: fix MAP_FIXED address return on VMA merge
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mmap-fix-map_fixed-address-return-on-vma-merge.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-fix-map_fixed-address-return-on-vma-merge.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Liam Howlett <liam.howlett@oracle.com>
Subject: mm/mmap: fix MAP_FIXED address return on VMA merge
Date: Tue, 18 Oct 2022 19:17:12 +0000

mmap should return the start address of newly mapped area when successful.
On a successful merge of a VMA, the return address was changed and thus
was violating that expectation from userspace.

This is a restoration of functionality provided by 309d08d9b3a3
(mm/mmap.c: fix mmap return value when vma is merged after call_mmap()). 
For completeness of fixing MAP_FIXED, implement the comments from the
previous discussion to never update the address and fail if the address
changes.  Leaving the error as a WARN_ON() to avoid crashing the kernel.

Link: https://lkml.kernel.org/r/20221018191613.4133459-1-Liam.Howlett@oracle.com
Link: https://lore.kernel.org/all/Y06yk66SKxlrwwfb@lakrids/
Link: https://lore.kernel.org/all/20201203085350.22624-1-liuzixian4@huawei.com/
Fixes: 4dd1b84140c1 ("mm/mmap: use advanced maple tree API for mmap_region()")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Mark Rutland <mark.rutland@arm.com>
Cc: Liu Zixian <liuzixian4@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/mm/mmap.c~mm-mmap-fix-map_fixed-address-return-on-vma-merge
+++ a/mm/mmap.c
@@ -2626,14 +2626,14 @@ cannot_expand:
 		if (error)
 			goto unmap_and_free_vma;
 
-		/* Can addr have changed??
-		 *
-		 * Answer: Yes, several device drivers can do it in their
-		 *         f_op->mmap method. -DaveM
+		/*
+		 * Expansion is handled above, merging is handled below.
+		 * Drivers should not alter the address of the VMA.
 		 */
-		WARN_ON_ONCE(addr != vma->vm_start);
-
-		addr = vma->vm_start;
+		if (WARN_ON((addr != vma->vm_start))) {
+			error = -EINVAL;
+			goto close_and_free_vma;
+		}
 		mas_reset(&mas);
 
 		/*
@@ -2655,7 +2655,6 @@ cannot_expand:
 				vm_area_free(vma);
 				vma = merge;
 				/* Update vm_flags to pick up the change. */
-				addr = vma->vm_start;
 				vm_flags = vma->vm_flags;
 				goto unmap_writable;
 			}
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

mm-mempolicy-fix-mbind_range-arguments-to-vma_merge.patch
mm-mmap-fix-map_fixed-address-return-on-vma-merge.patch

