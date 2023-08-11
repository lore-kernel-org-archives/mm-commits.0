Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CD46C04A6A
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:05:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236855AbjHKXFh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237128AbjHKXD5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:03:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5ED1448B
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:02:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BA7D6464E
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:02:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 923E5C433C7;
        Fri, 11 Aug 2023 23:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794921;
        bh=/x2cTxpCNRem1OvqFHsmeJ/5+qs0gqNmWLNet427gnY=;
        h=Date:To:From:Subject:From;
        b=hnlFiNVmILdg2GNBl+jtSvgrE2ClfPe+2bd8oaoHE36cmSmMPIfIhFcafYDwBL37N
         MCVwYoiVlfQDQOJUkW6QYqQ3cXPvgNpQ6BAxqnJIIp6Rcc08aca+p50qPCqmXhSqAC
         13bAhmH8MEzkUBWJnqwz+tDA0fXChRZR2owPf6GQ=
Date:   Fri, 11 Aug 2023 16:02:01 -0700
To:     mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        oliver.sang@intel.com, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-change-detached-vma-locking-scheme.patch removed from -mm tree
Message-Id: <20230811230201.923E5C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap: change detached vma locking scheme
has been removed from the -mm tree.  Its filename was
     mm-mmap-change-detached-vma-locking-scheme.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -2428,7 +2428,7 @@ do_vmi_align_munmap(struct vma_iterator
 	unsigned long locked_vm = 0;
 	MA_STATE(mas_detach, &mt_detach, 0, 0);
 	mt_init_flags(&mt_detach, vmi->mas.tree->ma_flags & MT_FLAGS_LOCK_MASK);
-	mt_set_external_lock(&mt_detach, &mm->mmap_lock);
+	mt_on_stack(mt_detach);
 
 	/*
 	 * If we need to split any vma, do it now to save pain later.
@@ -2546,11 +2546,11 @@ do_vmi_align_munmap(struct vma_iterator
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

maple_tree-add-hex-output-to-maple_arange64-dump.patch
maple_tree-reorder-replacement-of-nodes-to-avoid-live-lock.patch
maple_tree-introduce-mas_put_in_tree.patch
maple_tree-introduce-mas_tree_parent-definition.patch
maple_tree-change-mas_adopt_children-parent-usage.patch
maple_tree-replace-data-before-marking-dead-in-split-and-spanning-store.patch

