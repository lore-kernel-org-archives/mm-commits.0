Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ECDEC1550E
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 01:09:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 023EA64EFD
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 01:09:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345966AbhCDA7M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:59:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:49168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1450170AbhCDA0Q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Mar 2021 19:26:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD62C64E56;
        Thu,  4 Mar 2021 00:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614817535;
        bh=cGbjyA66KLR1rbNftXJgBx+nsF00tYNhUdWnGdlPYrw=;
        h=Date:From:To:Subject:From;
        b=amH1SQUMRbYffCBpOTzVpWJ9O36MDqUDHTSG2SeFSTloAe2kn3hkO9PryHi/WjD4D
         c1iOuTIP+8zb5IQIyNlSYjBnmjh40n5qg3LitHCaunGm4XK3+iWgzrF2j+d2tVeWnA
         YaUXU4YVj6xFLSilrD+T2ISUlFVW2rbMLS2RDSw8=
Date:   Wed, 03 Mar 2021 16:25:35 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, hughd@google.com, Liam.Howlett@Oracle.com,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  + mm-mmap-dont-unlock-vmas-in-remap_file_pages.patch
 added to -mm tree
Message-ID: <20210304002535.95GtdZn3S%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: don't unlock VMAs in remap_file_pages()
has been added to the -mm tree.  Its filename is
     mm-mmap-dont-unlock-vmas-in-remap_file_pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mmap-dont-unlock-vmas-in-remap_file_pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mmap-dont-unlock-vmas-in-remap_file_pages.patch

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
Subject: mm/mmap.c: don't unlock VMAs in remap_file_pages()

Since this call uses MAP_FIXED, do_mmap() will munlock the necessary
range.  There is also an error in the loop test expression which will
evaluate as false and the loop body has never execute.

Link: https://lkml.kernel.org/r/20210223235010.2296915-1-Liam.Howlett@Oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Acked-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

--- a/mm/mmap.c~mm-mmap-dont-unlock-vmas-in-remap_file_pages
+++ a/mm/mmap.c
@@ -3038,25 +3038,9 @@ SYSCALL_DEFINE5(remap_file_pages, unsign
 
 	flags &= MAP_NONBLOCK;
 	flags |= MAP_SHARED | MAP_FIXED | MAP_POPULATE;
-	if (vma->vm_flags & VM_LOCKED) {
-		struct vm_area_struct *tmp;
+	if (vma->vm_flags & VM_LOCKED)
 		flags |= MAP_LOCKED;
 
-		/* drop PG_Mlocked flag for over-mapped range */
-		for (tmp = vma; tmp->vm_start >= start + size;
-				tmp = tmp->vm_next) {
-			/*
-			 * Split pmd and munlock page on the border
-			 * of the range.
-			 */
-			vma_adjust_trans_huge(tmp, start, start + size, 0);
-
-			munlock_vma_pages_range(tmp,
-					max(tmp->vm_start, start),
-					min(tmp->vm_end, start + size));
-		}
-	}
-
 	file = get_file(vma->vm_file);
 	ret = do_mmap(vma->vm_file, start, size,
 			prot, flags, pgoff, &populate, NULL);
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

mm-mmap-dont-unlock-vmas-in-remap_file_pages.patch

