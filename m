Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89491C27C6D
	for <mm-commits@archiver.kernel.org>; Wed, 16 Aug 2023 22:54:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347033AbjHPWxh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Aug 2023 18:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347039AbjHPWxL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Aug 2023 18:53:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9956FFD
        for <mm-commits@vger.kernel.org>; Wed, 16 Aug 2023 15:53:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 358CF65199
        for <mm-commits@vger.kernel.org>; Wed, 16 Aug 2023 22:53:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 873B6C433CA;
        Wed, 16 Aug 2023 22:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692226389;
        bh=uYaIDqtCdsB31dj3qSLGvHKdKScMCyxzFyvURrfktw4=;
        h=Date:To:From:Subject:From;
        b=CdRbj0hKskmyxQ9GaZgPRB8+LGHOsCAmGzkRHaMcl/Qrpe0RFoOxXpkUftLHLNkYp
         oqJSjj2GZp7+emA1wEgYhrITXAiSFmj/I9hIa+jKBwK5nMCmmaPlRBQ3QDERMHxzti
         OxsGOYaD+tvC85ojyZzByBFipL/igIja2qezBrsw=
Date:   Wed, 16 Aug 2023 15:53:08 -0700
To:     mm-commits@vger.kernel.org, jannh@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-userfaultfd-remove-stale-comment-about-core-dump-locking.patch added to mm-unstable branch
Message-Id: <20230816225309.873B6C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: userfaultfd: remove stale comment about core dump locking
has been added to the -mm mm-unstable branch.  Its filename is
     mm-userfaultfd-remove-stale-comment-about-core-dump-locking.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-userfaultfd-remove-stale-comment-about-core-dump-locking.patch

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
From: Jann Horn <jannh@google.com>
Subject: mm: userfaultfd: remove stale comment about core dump locking
Date: Tue, 15 Aug 2023 23:22:16 +0200

Since commit 7f3bfab52cab ("mm/gup: take mmap_lock in get_dump_page()"),
which landed in v5.10, core dumping doesn't enter fault handling without
holding the mmap_lock anymore.  Remove the stale parts of the comments,
but leave the behavior as-is - letting core dumping block on userfault
handling would be a bad idea and could lead to deadlocks if the dumping
process was handling its own userfaults.

Link: https://lkml.kernel.org/r/20230815212216.264445-1-jannh@google.com
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/fs/userfaultfd.c~mm-userfaultfd-remove-stale-comment-about-core-dump-locking
+++ a/fs/userfaultfd.c
@@ -428,15 +428,11 @@ vm_fault_t handle_userfault(struct vm_fa
 	 * FOLL_DUMP case, anon memory also checks for FOLL_DUMP with
 	 * the no_page_table() helper in follow_page_mask(), but the
 	 * shmem_vm_ops->fault method is invoked even during
-	 * coredumping without mmap_lock and it ends up here.
+	 * coredumping and it ends up here.
 	 */
 	if (current->flags & (PF_EXITING|PF_DUMPCORE))
 		goto out;
 
-	/*
-	 * Coredumping runs without mmap_lock so we can only check that
-	 * the mmap_lock is held, if PF_DUMPCORE was not set.
-	 */
 	assert_fault_locked(vmf);
 
 	ctx = vma->vm_userfaultfd_ctx.ctx;
_

Patches currently in -mm which might be from jannh@google.com are

mm-userfaultfd-remove-stale-comment-about-core-dump-locking.patch

