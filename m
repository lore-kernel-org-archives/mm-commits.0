Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16994C001DF
	for <mm-commits@archiver.kernel.org>; Mon, 17 Jul 2023 18:39:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbjGQSjX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Jul 2023 14:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbjGQSjV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Jul 2023 14:39:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B78CBC0
        for <mm-commits@vger.kernel.org>; Mon, 17 Jul 2023 11:39:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54CDF611E9
        for <mm-commits@vger.kernel.org>; Mon, 17 Jul 2023 18:39:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8800C433C9;
        Mon, 17 Jul 2023 18:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689619159;
        bh=S5zZSrZxccbCxeThGZspAQ/ySL5/6+xeTYSd+Tj5dPc=;
        h=Date:To:From:Subject:From;
        b=STaKuTBfqORK+UjSzqrSQN3OV/bSw54VpHD1QQOXXLBWL18/NGQ8aZMvc/ddkvysn
         SzAqg3Z7Hv8TlzkcNqbO4qW23Yzek4/EJPzdSKIebzCC2uWMAvRS9JQ7o1fWDD+VuE
         OUhEYpCuv9bqodVpjtCtbYYAGLCMBR/qfZhSYQZI=
Date:   Mon, 17 Jul 2023 11:39:18 -0700
To:     mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        oliver.sang@intel.com, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-change-detached-vma-locking-scheme.patch added to mm-unstable branch
Message-Id: <20230717183919.A8800C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: change detached vma locking scheme
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-change-detached-vma-locking-scheme.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-change-detached-vma-locking-scheme.patch

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
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mm/mmap: change detached vma locking scheme
Date: Fri, 14 Jul 2023 15:55:50 -0400

Don't set the lock to the mm lock so that the detached VMA tree does not
complain about being unlocked when the mmap_lock is dropped prior to
freeing the tree.

Move the destroying of the detached tree outside the mmap lock all
together.

Link: https://lkml.kernel.org/r/20230714195551.894800-4-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oliver Sang <oliver.sang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mmap.c~mm-mmap-change-detached-vma-locking-scheme
+++ a/mm/mmap.c
@@ -2427,7 +2427,7 @@ do_vmi_align_munmap(struct vma_iterator
 	unsigned long locked_vm = 0;
 	MA_STATE(mas_detach, &mt_detach, 0, 0);
 	mt_init_flags(&mt_detach, vmi->mas.tree->ma_flags & MT_FLAGS_LOCK_MASK);
-	mt_set_external_lock(&mt_detach, &mm->mmap_lock);
+	mt_detach.ma_external_lock = NULL;
 
 	/*
 	 * If we need to split any vma, do it now to save pain later.
@@ -2545,11 +2545,11 @@ do_vmi_align_munmap(struct vma_iterator
 	/* Statistics and freeing VMAs */
 	mas_set(&mas_detach, start);
 	remove_mt(mm, &mas_detach);
-	__mt_destroy(&mt_detach);
 	validate_mm(mm);
 	if (unlock)
 		mmap_read_unlock(mm);
 
+	__mt_destroy(&mt_detach);
 	return 0;
 
 clear_tree_failed:
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

mm-mlock-fix-vma-iterator-conversion-of-apply_vma_lock_flags.patch
maple_tree-fix-32-bit-mas_next-testing.patch
maple_tree-fix-node-allocation-testing-on-32-bit.patch
mm-mmap-clean-up-validate_mm-calls.patch
maple_tree-relax-lockdep-checks-for-on-stack-trees.patch
mm-mmap-change-detached-vma-locking-scheme.patch
maple_tree-be-more-strict-about-locking.patch

