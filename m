Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C7F1A00F0
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 00:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763598133; cv=none; b=iFtOrogID76yWo/bnlRoh5OmSWTtJBmYnHm/TzLuVRWMiMMR0n/YY0r8xdvMqxxdocafHMt78/HsC8OB8FFNZNW+eZKEAkkJ7d5ZBb1ug6WeD92mFWgzK0aIVxfyM3ip2lieSdY/Gu+1sa0rNI+6BifaU33Pa2yfsxksu862rW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763598133; c=relaxed/simple;
	bh=XzuayzDsIc9ZKqDs0KueumAXnJKIxUr3wIsBoJ6S0TY=;
	h=Date:To:From:Subject:Message-Id; b=Wd6U3y/SAKEdv8oyBRT0bJTk+w+yqPA3HrrNhizW/TOiI3ut713QPL+WK0ltLf5qVnM8gzNEzLxxfZmOKR8rihlJImJvOQog8ERlkAma5lrb/jpX0Hn51kzCHsDSjoSM0YCbvp6rpIrXAeX1dXMgo/Q2jaK83HkXli78RE3R4qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MVpaX3AE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MVpaX3AE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6731C4CEF5;
	Thu, 20 Nov 2025 00:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763598132;
	bh=XzuayzDsIc9ZKqDs0KueumAXnJKIxUr3wIsBoJ6S0TY=;
	h=Date:To:From:Subject:From;
	b=MVpaX3AEbsDeCYfDDc4hwwsl89qzgwrd66zspi7hPO4KH8Ohv3t2rH4Rd1QN9IOTG
	 g9rkk8lpdeCdzxcRycqwXtF+8MC6aFjV0vaU+vDTFHkHfN9Rl/s4pL8lWgVHp2njua
	 f313ClniTCMRus39l8XccqPSDN7hXLCJz0bhbq1g=
Date: Wed, 19 Nov 2025 16:22:12 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,lorenzo.stoakes@oracle.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-tweak-__vma_enter_locked.patch added to mm-new branch
Message-Id: <20251120002212.C6731C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: tweak __vma_enter_locked()
has been added to the -mm mm-new branch.  Its filename is
     mm-tweak-__vma_enter_locked.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-tweak-__vma_enter_locked.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: tweak __vma_enter_locked()
Date: Wed, 19 Nov 2025 04:26:35 +0000

Move the commentary on how __vma_enter_locked() behaves from the body of
__vma_start_write() to the head of __vma_enter_locked() and merge it with
the existing documentation.  Also add a call to
mmap_assert_write_locked().

Link: https://lkml.kernel.org/r/20251119042639.3937024-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap_lock.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/mm/mmap_lock.c~mm-tweak-__vma_enter_locked
+++ a/mm/mmap_lock.c
@@ -46,9 +46,9 @@ EXPORT_SYMBOL(__mmap_lock_do_trace_relea
 #ifdef CONFIG_MMU
 #ifdef CONFIG_PER_VMA_LOCK
 /*
- * Return value: 0 if vma detached,
- * 1 if vma attached with no readers,
- * -EINTR if signal received,
+ * __vma_enter_locked() returns 0 immediately if the vma is not
+ * attached, otherwise it waits for any current readers to finish and
+ * returns 1.  Returns -EINTR if a signal is received while waiting.
  */
 static inline int __vma_enter_locked(struct vm_area_struct *vma,
 		bool detaching, int state)
@@ -56,6 +56,8 @@ static inline int __vma_enter_locked(str
 	int err;
 	unsigned int tgt_refcnt = VMA_LOCK_OFFSET;
 
+	mmap_assert_write_locked(vma->vm_mm);
+
 	/* Additional refcnt if the vma is attached. */
 	if (!detaching)
 		tgt_refcnt++;
@@ -91,11 +93,6 @@ int __vma_start_write(struct vm_area_str
 {
 	int locked;
 
-	/*
-	 * __vma_enter_locked() returns false immediately if the vma is not
-	 * attached, otherwise it waits until refcnt is indicating that vma
-	 * is attached with no readers.
-	 */
 	locked = __vma_enter_locked(vma, false, state);
 	if (locked < 0)
 		return locked;
_

Patches currently in -mm which might be from willy@infradead.org are

hugetlb-optimise-hugetlb_folio_init_tail_vmemmap.patch
migrate-optimise-alloc_migration_target.patch
memory_hotplug-optimise-try_offline_memory_block.patch
mm-constify-__dump_folio-arguments.patch
mm-add-vma_start_write_killable.patch
mm-use-vma_start_write_killable-in-dup_mmap.patch
mm-tweak-__vma_enter_locked.patch

