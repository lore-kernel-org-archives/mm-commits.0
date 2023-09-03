Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34E07C83F2C
	for <mm-commits@archiver.kernel.org>; Sun,  3 Sep 2023 01:36:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235426AbjICBg7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 2 Sep 2023 21:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235422AbjICBg6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 2 Sep 2023 21:36:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0115C120
        for <mm-commits@vger.kernel.org>; Sat,  2 Sep 2023 18:36:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CB7060BB7
        for <mm-commits@vger.kernel.org>; Sun,  3 Sep 2023 01:36:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE974C433C8;
        Sun,  3 Sep 2023 01:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693705014;
        bh=zCvtsiQq4f40uMwgRyDJ4SN3Ui8KFiUqtsm92/V2awI=;
        h=Date:To:From:Subject:From;
        b=V2sQUmDiMk3dSBcKONwcshZev5z5dg6Z+xlKnldN2IJH1w1n61DiJ6/k8msKfT15C
         Pt/EpzrP1sbWAe3bTglPePail0Dzkr543UZIJwAImImEGiQcGAIL+by6xgrxr8QAAW
         NtFFWYk0r2kR7Ya2r7Hoqc+QgP0WKOR5pgIUnSWk=
Date:   Sat, 02 Sep 2023 18:36:54 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        Liam.Howlett@oracle.com, anthony.yznaga@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-unaccount-of-memory-on-vma_link-failure.patch added to mm-unstable branch
Message-Id: <20230903013654.CE974C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix unaccount of memory on vma_link() failure
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-unaccount-of-memory-on-vma_link-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-unaccount-of-memory-on-vma_link-failure.patch

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
Subject: mm: fix unaccount of memory on vma_link() failure
Date: Tue, 29 Aug 2023 17:43:24 -0700

Fix insert_vm_struct() so that only accounted memory is unaccounted if
vma_link() fails.

Link: https://lkml.kernel.org/r/20230830004324.16101-1-anthony.yznaga@oracle.com
Fixes: d4af56c5c7c6 ("mm: start tracking VMAs with maple tree")
Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/mmap.c~mm-fix-unaccount-of-memory-on-vma_link-failure
+++ a/mm/mmap.c
@@ -3278,7 +3278,8 @@ int insert_vm_struct(struct mm_struct *m
 	}
 
 	if (vma_link(mm, vma)) {
-		vm_unacct_memory(charged);
+		if (vma->vm_flags & VM_ACCOUNT)
+			vm_unacct_memory(charged);
 		return -ENOMEM;
 	}
 
_

Patches currently in -mm which might be from anthony.yznaga@oracle.com are

mm-mremap-fix-unaccount-of-memory-on-vma_merge-failure.patch
mm-fix-unaccount-of-memory-on-vma_link-failure.patch

