Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E49D5C001E0
	for <mm-commits@archiver.kernel.org>; Wed, 19 Jul 2023 19:21:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbjGSTVl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jul 2023 15:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbjGSTVb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jul 2023 15:21:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC99E2136
        for <mm-commits@vger.kernel.org>; Wed, 19 Jul 2023 12:21:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2F26617E5
        for <mm-commits@vger.kernel.org>; Wed, 19 Jul 2023 19:21:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17522C433BA;
        Wed, 19 Jul 2023 19:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689794479;
        bh=RsXRmd1VuXjrNMG2pLI2/0zWKR99LUUtK8Us+kVBXyg=;
        h=Date:To:From:Subject:From;
        b=GVaFNdLJnkXNS4c2e4UnZ4yl22mAYZ8r6opfJNUeY5mEJzejF7PsXdk6SH66ozMQc
         KJrGChnfHwUVymdqhe57Jx80ALVNQtgyxfpRPUdygYiuKjUk85C8mlD26qzzWw4AOT
         lgKPz1CzxUqpC7Wb259A74ryzN1je3WqwRiKge7o=
Date:   Wed, 19 Jul 2023 12:21:17 -0700
To:     mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        oliver.sang@intel.com, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-change-detached-vma-locking-scheme.patch added to mm-unstable branch
Message-Id: <20230719192119.17522C433BA@smtp.kernel.org>
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
Date: Wed, 5 Jul 2023 14:47:49 -0400

Don't set the lock to the mm lock so that the detached VMA tree does not
complain about being unlocked when the mmap_lock is dropped prior to
freeing the tree.

Introduce mt_on_stack() for setting the external lock to NULL only when
LOCKDEP is used.

Move the destroying of the detached tree outside the mmap lock all
together.

Link: https://lkml.kernel.org/r/20230719183142.ktgcmuj2pnlr3h3s@revolver
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oliver Sang <oliver.sang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h |    3 +++
 mm/mmap.c                  |    4 ++--
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/include/linux/maple_tree.h~mm-mmap-change-detached-vma-locking-scheme
+++ a/include/linux/maple_tree.h
@@ -187,10 +187,13 @@ typedef struct lockdep_map *lockdep_map_
 
 #define mt_set_external_lock(mt, lock)					\
 	(mt)->ma_external_lock = &(lock)->dep_map
+
+#define mt_on_stack(mt)			(mt).ma_external_lock = NULL
 #else
 typedef struct { /* nothing */ } lockdep_map_p;
 #define mt_lock_is_held(mt)	1
 #define mt_set_external_lock(mt, lock)	do { } while (0)
+#define mt_on_stack(mt)			do { } while (0)
 #endif
 
 /*
--- a/mm/mmap.c~mm-mmap-change-detached-vma-locking-scheme
+++ a/mm/mmap.c
@@ -2427,7 +2427,7 @@ do_vmi_align_munmap(struct vma_iterator
 	unsigned long locked_vm = 0;
 	MA_STATE(mas_detach, &mt_detach, 0, 0);
 	mt_init_flags(&mt_detach, vmi->mas.tree->ma_flags & MT_FLAGS_LOCK_MASK);
-	mt_set_external_lock(&mt_detach, &mm->mmap_lock);
+	mt_on_stack(mt_detach);
 
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

mm-mmap-clean-up-validate_mm-calls.patch
maple_tree-relax-lockdep-checks-for-on-stack-trees.patch
mm-mmap-change-detached-vma-locking-scheme.patch
maple_tree-be-more-strict-about-locking.patch

