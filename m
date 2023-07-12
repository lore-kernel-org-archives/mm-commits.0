Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09C2DEB64DA
	for <mm-commits@archiver.kernel.org>; Wed, 12 Jul 2023 20:06:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231486AbjGLUGL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Jul 2023 16:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbjGLUGK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2023 16:06:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC43F1FE4
        for <mm-commits@vger.kernel.org>; Wed, 12 Jul 2023 13:06:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7068F618FE
        for <mm-commits@vger.kernel.org>; Wed, 12 Jul 2023 20:06:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1B3CC433C7;
        Wed, 12 Jul 2023 20:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689192368;
        bh=EWOaF8s/QgF0E+sSt2Rz4DbBqkjPzUKg/F+H0xDtLQE=;
        h=Date:To:From:Subject:From;
        b=MFM0qRpI+XZOXgaOSjEEarnotxWuTqBPRlJNGYpHkJsAgcnZPKfY/6DDfEoIDJ+G3
         Ue1BVsBsSKtch++5muBvTIPm0FOYJkdNlmJdBwy53qdaKjhe2JALio37oPAVWt4kkP
         26F9IZyp26GI9YoyoC6q7+vGgsVaXCYKBNFnHEnE=
Date:   Wed, 12 Jul 2023 13:06:07 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        paulmck@kernel.org, michel@lespinasse.org, liam.howlett@oracle.com,
        ldufour@linux.ibm.com, brauner@kernel.org, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-handle-userfaults-under-vma-lock-fix.patch added to mm-unstable branch
Message-Id: <20230712200608.B1B3CC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix a lockdep issue in vma_assert_write_locked
has been added to the -mm mm-unstable branch.  Its filename is
     mm-handle-userfaults-under-vma-lock-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-handle-userfaults-under-vma-lock-fix.patch

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
@@ -668,6 +668,7 @@ static inline void vma_end_read(struct v
 	rcu_read_unlock();
 }
 
+/* WARNING! Can only be used if mmap_lock is expected to be write-locked */
 static bool __is_vma_write_locked(struct vm_area_struct *vma, int *mm_lock_seq)
 {
 	mmap_assert_write_locked(vma->vm_mm);
@@ -707,22 +708,17 @@ static inline bool vma_try_start_write(s
 	return true;
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
mm-handle-userfaults-under-vma-lock-fix.patch

