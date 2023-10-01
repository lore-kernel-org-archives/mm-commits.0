Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2BC3E78486
	for <mm-commits@archiver.kernel.org>; Sun,  1 Oct 2023 19:56:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235368AbjJAT4t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 1 Oct 2023 15:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235356AbjJAT4p (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 1 Oct 2023 15:56:45 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 362C9C4
        for <mm-commits@vger.kernel.org>; Sun,  1 Oct 2023 12:56:43 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1022C433C8;
        Sun,  1 Oct 2023 19:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696190202;
        bh=8BOBaU5HJDllt7D06i2IXgCm/ljMyrsKdQHlEmzxZx0=;
        h=Date:To:From:Subject:From;
        b=mrYAdiy7s4ZEZm0FJABT7y8UbeXyFfoDFLkomMl0HREGIPSQa7Q2/+sMf1MUE3qKp
         DKgpaMeqyQjvYnoYawt0P4uYxnEcg2kSvm9lNOI7ActfKbOgxJVkZBeR5nSm6pgel2
         Q3GMTipnrbA/rTMk0KfNl52kXPfhF/pRn6kKN2OA=
Date:   Sun, 01 Oct 2023 12:56:42 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tim.c.chen@intel.com, jack@suse.cz, hannes@cmpxchg.org,
        djwong@kernel.org, dchinner@redhat.com, chuck.lever@oracle.com,
        cem@kernel.org, brauner@kernel.org, axelrasmussen@google.com,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + shmem-factor-shmem_falloc_wait-out-of-shmem_fault.patch added to mm-unstable branch
Message-Id: <20231001195642.C1022C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: factor shmem_falloc_wait() out of shmem_fault()
has been added to the -mm mm-unstable branch.  Its filename is
     shmem-factor-shmem_falloc_wait-out-of-shmem_fault.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/shmem-factor-shmem_falloc_wait-out-of-shmem_fault.patch

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
From: Hugh Dickins <hughd@google.com>
Subject: shmem: factor shmem_falloc_wait() out of shmem_fault()
Date: Fri, 29 Sep 2023 20:27:53 -0700 (PDT)

That Trinity livelock shmem_falloc avoidance block is unlikely, and a
distraction from the proper business of shmem_fault(): separate it out. 
(This used to help compilers save stack on the fault path too, but both
gcc and clang nowadays seem to make better choices anyway.)

Link: https://lkml.kernel.org/r/6fe379a4-6176-9225-9263-fe60d2633c0@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Carlos Maiolino <cem@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Tim Chen <tim.c.chen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |  126 +++++++++++++++++++++++++++------------------------
 1 file changed, 69 insertions(+), 57 deletions(-)

--- a/mm/shmem.c~shmem-factor-shmem_falloc_wait-out-of-shmem_fault
+++ a/mm/shmem.c
@@ -2165,87 +2165,99 @@ int shmem_get_folio(struct inode *inode,
  * entry unconditionally - even if something else had already woken the
  * target.
  */
-static int synchronous_wake_function(wait_queue_entry_t *wait, unsigned mode, int sync, void *key)
+static int synchronous_wake_function(wait_queue_entry_t *wait,
+			unsigned int mode, int sync, void *key)
 {
 	int ret = default_wake_function(wait, mode, sync, key);
 	list_del_init(&wait->entry);
 	return ret;
 }
 
+/*
+ * Trinity finds that probing a hole which tmpfs is punching can
+ * prevent the hole-punch from ever completing: which in turn
+ * locks writers out with its hold on i_rwsem.  So refrain from
+ * faulting pages into the hole while it's being punched.  Although
+ * shmem_undo_range() does remove the additions, it may be unable to
+ * keep up, as each new page needs its own unmap_mapping_range() call,
+ * and the i_mmap tree grows ever slower to scan if new vmas are added.
+ *
+ * It does not matter if we sometimes reach this check just before the
+ * hole-punch begins, so that one fault then races with the punch:
+ * we just need to make racing faults a rare case.
+ *
+ * The implementation below would be much simpler if we just used a
+ * standard mutex or completion: but we cannot take i_rwsem in fault,
+ * and bloating every shmem inode for this unlikely case would be sad.
+ */
+static vm_fault_t shmem_falloc_wait(struct vm_fault *vmf, struct inode *inode)
+{
+	struct shmem_falloc *shmem_falloc;
+	struct file *fpin = NULL;
+	vm_fault_t ret = 0;
+
+	spin_lock(&inode->i_lock);
+	shmem_falloc = inode->i_private;
+	if (shmem_falloc &&
+	    shmem_falloc->waitq &&
+	    vmf->pgoff >= shmem_falloc->start &&
+	    vmf->pgoff < shmem_falloc->next) {
+		wait_queue_head_t *shmem_falloc_waitq;
+		DEFINE_WAIT_FUNC(shmem_fault_wait, synchronous_wake_function);
+
+		ret = VM_FAULT_NOPAGE;
+		fpin = maybe_unlock_mmap_for_io(vmf, NULL);
+		shmem_falloc_waitq = shmem_falloc->waitq;
+		prepare_to_wait(shmem_falloc_waitq, &shmem_fault_wait,
+				TASK_UNINTERRUPTIBLE);
+		spin_unlock(&inode->i_lock);
+		schedule();
+
+		/*
+		 * shmem_falloc_waitq points into the shmem_fallocate()
+		 * stack of the hole-punching task: shmem_falloc_waitq
+		 * is usually invalid by the time we reach here, but
+		 * finish_wait() does not dereference it in that case;
+		 * though i_lock needed lest racing with wake_up_all().
+		 */
+		spin_lock(&inode->i_lock);
+		finish_wait(shmem_falloc_waitq, &shmem_fault_wait);
+	}
+	spin_unlock(&inode->i_lock);
+	if (fpin) {
+		fput(fpin);
+		ret = VM_FAULT_RETRY;
+	}
+	return ret;
+}
+
 static vm_fault_t shmem_fault(struct vm_fault *vmf)
 {
-	struct vm_area_struct *vma = vmf->vma;
-	struct inode *inode = file_inode(vma->vm_file);
+	struct inode *inode = file_inode(vmf->vma->vm_file);
 	gfp_t gfp = mapping_gfp_mask(inode->i_mapping);
 	struct folio *folio = NULL;
+	vm_fault_t ret = 0;
 	int err;
-	vm_fault_t ret = VM_FAULT_LOCKED;
 
 	/*
 	 * Trinity finds that probing a hole which tmpfs is punching can
-	 * prevent the hole-punch from ever completing: which in turn
-	 * locks writers out with its hold on i_rwsem.  So refrain from
-	 * faulting pages into the hole while it's being punched.  Although
-	 * shmem_undo_range() does remove the additions, it may be unable to
-	 * keep up, as each new page needs its own unmap_mapping_range() call,
-	 * and the i_mmap tree grows ever slower to scan if new vmas are added.
-	 *
-	 * It does not matter if we sometimes reach this check just before the
-	 * hole-punch begins, so that one fault then races with the punch:
-	 * we just need to make racing faults a rare case.
-	 *
-	 * The implementation below would be much simpler if we just used a
-	 * standard mutex or completion: but we cannot take i_rwsem in fault,
-	 * and bloating every shmem inode for this unlikely case would be sad.
+	 * prevent the hole-punch from ever completing: noted in i_private.
 	 */
 	if (unlikely(inode->i_private)) {
-		struct shmem_falloc *shmem_falloc;
-
-		spin_lock(&inode->i_lock);
-		shmem_falloc = inode->i_private;
-		if (shmem_falloc &&
-		    shmem_falloc->waitq &&
-		    vmf->pgoff >= shmem_falloc->start &&
-		    vmf->pgoff < shmem_falloc->next) {
-			struct file *fpin;
-			wait_queue_head_t *shmem_falloc_waitq;
-			DEFINE_WAIT_FUNC(shmem_fault_wait, synchronous_wake_function);
-
-			ret = VM_FAULT_NOPAGE;
-			fpin = maybe_unlock_mmap_for_io(vmf, NULL);
-			if (fpin)
-				ret = VM_FAULT_RETRY;
-
-			shmem_falloc_waitq = shmem_falloc->waitq;
-			prepare_to_wait(shmem_falloc_waitq, &shmem_fault_wait,
-					TASK_UNINTERRUPTIBLE);
-			spin_unlock(&inode->i_lock);
-			schedule();
-
-			/*
-			 * shmem_falloc_waitq points into the shmem_fallocate()
-			 * stack of the hole-punching task: shmem_falloc_waitq
-			 * is usually invalid by the time we reach here, but
-			 * finish_wait() does not dereference it in that case;
-			 * though i_lock needed lest racing with wake_up_all().
-			 */
-			spin_lock(&inode->i_lock);
-			finish_wait(shmem_falloc_waitq, &shmem_fault_wait);
-			spin_unlock(&inode->i_lock);
-
-			if (fpin)
-				fput(fpin);
+		ret = shmem_falloc_wait(vmf, inode);
+		if (ret)
 			return ret;
-		}
-		spin_unlock(&inode->i_lock);
 	}
 
+	WARN_ON_ONCE(vmf->page != NULL);
 	err = shmem_get_folio_gfp(inode, vmf->pgoff, &folio, SGP_CACHE,
 				  gfp, vmf, &ret);
 	if (err)
 		return vmf_error(err);
-	if (folio)
+	if (folio) {
 		vmf->page = folio_file_page(folio, vmf->pgoff);
+		ret |= VM_FAULT_LOCKED;
+	}
 	return ret;
 }
 
_

Patches currently in -mm which might be from hughd@google.com are

shmem-shrink-shmem_inode_info-dir_offsets-in-a-union.patch
shmem-remove-vma-arg-from-shmem_get_folio_gfp.patch
shmem-factor-shmem_falloc_wait-out-of-shmem_fault.patch
shmem-trivial-tidyups-removing-extra-blank-lines-etc.patch
shmem-shmem_acct_blocks-and-shmem_inode_acct_blocks.patch
shmem-move-memcg-charge-out-of-shmem_add_to_page_cache.patch
shmem-_add_to_page_cache-before-shmem_inode_acct_blocks.patch
shmempercpu_counter-add-_limited_addfbc-limit-amount.patch

