Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F6ACC001DB
	for <mm-commits@archiver.kernel.org>; Sun,  3 Sep 2023 01:36:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235425AbjICBgV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 2 Sep 2023 21:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235422AbjICBgV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 2 Sep 2023 21:36:21 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 237DC120
        for <mm-commits@vger.kernel.org>; Sat,  2 Sep 2023 18:36:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4F5ABCE0947
        for <mm-commits@vger.kernel.org>; Sun,  3 Sep 2023 01:36:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F58C433C8;
        Sun,  3 Sep 2023 01:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693704974;
        bh=p7PS6eRz2XZ6e4xGDNt7Wbl9R8mkoTmUetPsIw62nRY=;
        h=Date:To:From:Subject:From;
        b=0lPztBOvjmTouOAeItwPFVvid9QNi4VK7vTWdxNMNmb1W0p7zX4ggC1AJTVzHUOuD
         owMitybEQPUXDEP8ic2uD6raMfTZNn8K66w3vjBrD9tkLdRGbMz4P3e6dmy31KIhb0
         ieJb/shY+Wi3Qf6gcIFoGFeJ9SuVrIEvABmyTVwI=
Date:   Sat, 02 Sep 2023 18:36:13 -0700
To:     mm-commits@vger.kernel.org, bgeffon@google.com,
        anthony.yznaga@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-fix-unaccount-of-memory-on-vma_merge-failure.patch added to mm-unstable branch
Message-Id: <20230903013614.93F58C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mremap: fix unaccount of memory on vma_merge() failure
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mremap-fix-unaccount-of-memory-on-vma_merge-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-fix-unaccount-of-memory-on-vma_merge-failure.patch

This patch will later appear in the mm-unstable branch at
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
From: Anthony Yznaga <anthony.yznaga@oracle.com>
Subject: mm/mremap: fix unaccount of memory on vma_merge() failure
Date: Tue, 29 Aug 2023 17:45:49 -0700

Fix mremap so that only accounted memory is unaccounted if the mapping is
expandable but vma_merge() fails.

Link: https://lkml.kernel.org/r/20230830004549.16131-1-anthony.yznaga@oracle.com
Fixes: fdbef6149135 ("mm/mremap: don't account pages in vma_to_resize()")
Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
Acked-by: Brian Geffon <bgeffon@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/mremap.c~mm-mremap-fix-unaccount-of-memory-on-vma_merge-failure
+++ a/mm/mremap.c
@@ -1037,12 +1037,14 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 			pgoff_t extension_pgoff = vma->vm_pgoff +
 				((extension_start - vma->vm_start) >> PAGE_SHIFT);
 			VMA_ITERATOR(vmi, mm, extension_start);
+			long charged = 0;
 
 			if (vma->vm_flags & VM_ACCOUNT) {
 				if (security_vm_enough_memory_mm(mm, pages)) {
 					ret = -ENOMEM;
 					goto out;
 				}
+				charged = pages;
 			}
 
 			/*
@@ -1058,7 +1060,7 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 				vma->vm_file, extension_pgoff, vma_policy(vma),
 				vma->vm_userfaultfd_ctx, anon_vma_name(vma));
 			if (!vma) {
-				vm_unacct_memory(pages);
+				vm_unacct_memory(charged);
 				ret = -ENOMEM;
 				goto out;
 			}
_

Patches currently in -mm which might be from anthony.yznaga@oracle.com are

mm-mremap-fix-unaccount-of-memory-on-vma_merge-failure.patch

