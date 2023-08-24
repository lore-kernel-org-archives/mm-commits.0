Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 548BEC6FA8F
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:08:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232561AbjHXXIJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244006AbjHXXHl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:07:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07CA310E0
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:07:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 792B0636A9
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:07:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11A8C433C7;
        Thu, 24 Aug 2023 23:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692918457;
        bh=F9Hb/46CFapuiCslHRCfJL41Ncf9ng2iPZIeLNZdeQw=;
        h=Date:To:From:Subject:From;
        b=FY5vncFICiAUk5XUJbUum7ZifDAwWMB5weAWncGzG34kF6ATO6j1XTstk3iux5eNq
         4mWMp7hrV1TmplouAJBuEbwnTyXfXfwD4qMkNm81VuxcSKwyVHOU01gqIBr3D2g6dT
         rnjNzTZNToqZYTfEcMUfR4ujSKf7+WmYpkYyvotI=
Date:   Thu, 24 Aug 2023 16:07:37 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        paulmck@kernel.org, michel@lespinasse.org, liam.howlett@oracle.com,
        ldufour@linux.ibm.com, brauner@kernel.org, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-handle-userfaults-under-vma-lock-fix.patch removed from -mm tree
Message-Id: <20230824230737.D11A8C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: fix a lockdep issue in vma_assert_write_locked
has been removed from the -mm tree.  Its filename was
     mm-handle-userfaults-under-vma-lock-fix.patch

This patch was dropped because it was folded into mm-handle-userfaults-under-vma-lock.patch

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: fix a lockdep issue in vma_assert_write_locked
Date: Wed, 12 Jul 2023 12:56:52 -0700

__is_vma_write_locked() can be used only when mmap_lock is write-locked to
guarantee vm_lock_seq and mm_lock_seq stability during the check. 
Therefore it asserts this condition before further checks.  Because of
that it can't be used unless the user expects the mmap_lock to be
write-locked.  vma_assert_locked() can't assume this before ensuring that
VMA is not read-locked.

Change the order of the checks in vma_assert_locked() to check if the VMA
is read-locked first and only then assert if it's not write-locked.

Link: https://lkml.kernel.org/r/20230712195652.969194-1-surenb@google.com
Fixes: 50b88b63e3e4 ("mm: handle userfaults under VMA lock")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: Liam R. Howlett <liam.howlett@oracle.com>
Closes: https://lore.kernel.org/all/20230712022620.3yytbdh24b7i4zrn@revolver/
Reported-by: syzbot+339b02f826caafd5f7a8@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/0000000000002db68f05ffb791bc@google.com/
Cc: Christian Brauner <brauner@kernel.org>
Cc: Laurent Dufour <ldufour@linux.ibm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michel Lespinasse <michel@lespinasse.org>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/include/linux/mm.h~mm-handle-userfaults-under-vma-lock-fix
+++ a/include/linux/mm.h
@@ -679,6 +679,7 @@ static inline void vma_end_read(struct v
 	rcu_read_unlock();
 }
 
+/* WARNING! Can only be used if mmap_lock is expected to be write-locked */
 static bool __is_vma_write_locked(struct vm_area_struct *vma, int *mm_lock_seq)
 {
 	mmap_assert_write_locked(vma->vm_mm);
@@ -714,22 +715,17 @@ static inline void vma_start_write(struc
 	up_write(&vma->vm_lock->lock);
 }
 
-static inline void vma_assert_locked(struct vm_area_struct *vma)
+static inline void vma_assert_write_locked(struct vm_area_struct *vma)
 {
 	int mm_lock_seq;
 
-	if (__is_vma_write_locked(vma, &mm_lock_seq))
-		return;
-
-	lockdep_assert_held(&vma->vm_lock->lock);
-	VM_BUG_ON_VMA(!rwsem_is_locked(&vma->vm_lock->lock), vma);
+	VM_BUG_ON_VMA(!__is_vma_write_locked(vma, &mm_lock_seq), vma);
 }
 
-static inline void vma_assert_write_locked(struct vm_area_struct *vma)
+static inline void vma_assert_locked(struct vm_area_struct *vma)
 {
-	int mm_lock_seq;
-
-	VM_BUG_ON_VMA(!__is_vma_write_locked(vma, &mm_lock_seq), vma);
+	if (!rwsem_is_locked(&vma->vm_lock->lock))
+		vma_assert_write_locked(vma);
 }
 
 static inline void vma_mark_detached(struct vm_area_struct *vma, bool detached)
_

Patches currently in -mm which might be from surenb@google.com are

swap-remove-remnants-of-polling-from-read_swap_cache_async.patch
mm-add-missing-vm_fault_result_trace-name-for-vm_fault_completed.patch
mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed.patch
mm-change-folio_lock_or_retry-to-use-vm_fault-directly.patch
mm-handle-swap-page-faults-under-per-vma-lock.patch
mm-handle-userfaults-under-vma-lock.patch

