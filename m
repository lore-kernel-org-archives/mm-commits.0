Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EDD415E5CB
	for <mm-commits@vger.kernel.org>; Tue,  6 Aug 2024 20:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722976942; cv=none; b=I3SNzugrFF2bAFjlLF14Lo5fuBM5mY3zLartaN2uULTuQjyWO7OdYw6IdsI61kaAkUmXvEfj9ksecihiHPFSw/PZkXUUgT1UpLmsqAbm5DsaGOVWwh1HbrENC3Nro8meR8tefXYSxiQRI1TtDJF8TBuwN3viBXLUYNtERrOzIJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722976942; c=relaxed/simple;
	bh=YkKTLB6Cm9tYbU+8VDNZ0SE5vemoNjEB0u3WvP8XhLg=;
	h=Date:To:From:Subject:Message-Id; b=DSZ8eomkreaRwnZc25EEhZZJPBCVptwPCfARXNHOEMigP/yF0Ed+ZRUrjrJYCFnr57utYnYb6H29NygHeDvkRWX/la2y1300hO4yahRILY5h3yPulXv++9cYgZupD+xu7Me1deoI4pXW2l9JyPsrsU6ZEj8M+cHkc5e9TfAx8pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nP5Q9L7m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nP5Q9L7m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D49BC32786;
	Tue,  6 Aug 2024 20:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722976942;
	bh=YkKTLB6Cm9tYbU+8VDNZ0SE5vemoNjEB0u3WvP8XhLg=;
	h=Date:To:From:Subject:From;
	b=nP5Q9L7muoPqSqmxXPPc7TzzCL42IPP8Fzyb/r/+2XC0E0vS0kYGQXFdt+A6642v2
	 y/tovpH14UQtnXSUMotYR0z3GortSsD0H1C1GrDkmawW855zVcm49whb5yVMyoRxai
	 NSFdr0wdY2XDCKUeejqx4yf1OQ+cmlsFhtCkuEmo=
Date: Tue, 06 Aug 2024 13:42:21 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,surenb@google.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-harmless-type-confusion-in-lock_vma_under_rcu.patch added to mm-unstable branch
Message-Id: <20240806204222.1D49BC32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix (harmless) type confusion in lock_vma_under_rcu()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-harmless-type-confusion-in-lock_vma_under_rcu.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-harmless-type-confusion-in-lock_vma_under_rcu.patch

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
Subject: mm: fix (harmless) type confusion in lock_vma_under_rcu()
Date: Mon, 05 Aug 2024 14:52:03 +0200

There is a (harmless) type confusion in lock_vma_under_rcu(): After
vma_start_read(), we have taken the VMA lock but don't know yet whether
the VMA has already been detached and scheduled for RCU freeing.  At this
point, ->vm_start and ->vm_end are accessed.

vm_area_struct contains a union such that ->vm_rcu uses the same memory as
->vm_start and ->vm_end; so accessing ->vm_start and ->vm_end of a
detached VMA is illegal and leads to type confusion between union members.

Fix it by reordering the vma->detached check above the address checks, and
document the rules for RCU readers accessing VMAs.

This will probably change the number of observed VMA_LOCK_MISS events
(since previously, trying to access a detached VMA whose ->vm_rcu has been
scheduled would bail out when checking the fault address against the
rcu_head members reinterpreted as VMA bounds).

Link: https://lkml.kernel.org/r/20240805-fix-vma-lock-type-confusion-v1-1-9f25443a9a71@google.com
Fixes: 50ee32537206 ("mm: introduce lock_vma_under_rcu to be used from arch-specific code")
Signed-off-by: Jann Horn <jannh@google.com>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |   15 +++++++++++++--
 mm/memory.c              |   14 ++++++++++----
 2 files changed, 23 insertions(+), 6 deletions(-)

--- a/include/linux/mm_types.h~mm-fix-harmless-type-confusion-in-lock_vma_under_rcu
+++ a/include/linux/mm_types.h
@@ -660,6 +660,9 @@ struct vma_numab_state {
  * per VM-area/task. A VM area is any part of the process virtual memory
  * space that has a special rule for the page-fault handlers (ie a shared
  * library, the executable area etc).
+ *
+ * Only explicitly marked struct members may be accessed by RCU readers before
+ * getting a stable reference.
  */
 struct vm_area_struct {
 	/* The first cache line has the info for VMA tree walking. */
@@ -675,7 +678,11 @@ struct vm_area_struct {
 #endif
 	};
 
-	struct mm_struct *vm_mm;	/* The address space we belong to. */
+	/*
+	 * The address space we belong to.
+	 * Unstable RCU readers are allowed to read this.
+	 */
+	struct mm_struct *vm_mm;
 	pgprot_t vm_page_prot;          /* Access permissions of this VMA. */
 
 	/*
@@ -688,7 +695,10 @@ struct vm_area_struct {
 	};
 
 #ifdef CONFIG_PER_VMA_LOCK
-	/* Flag to indicate areas detached from the mm->mm_mt tree */
+	/*
+	 * Flag to indicate areas detached from the mm->mm_mt tree.
+	 * Unstable RCU readers are allowed to read this.
+	 */
 	bool detached;
 
 	/*
@@ -706,6 +716,7 @@ struct vm_area_struct {
 	 * slowpath.
 	 */
 	int vm_lock_seq;
+	/* Unstable RCU readers are allowed to read this. */
 	struct vma_lock *vm_lock;
 #endif
 
--- a/mm/memory.c~mm-fix-harmless-type-confusion-in-lock_vma_under_rcu
+++ a/mm/memory.c
@@ -6164,10 +6164,6 @@ retry:
 	if (!vma_start_read(vma))
 		goto inval;
 
-	/* Check since vm_start/vm_end might change before we lock the VMA */
-	if (unlikely(address < vma->vm_start || address >= vma->vm_end))
-		goto inval_end_read;
-
 	/* Check if the VMA got isolated after we found it */
 	if (vma->detached) {
 		vma_end_read(vma);
@@ -6175,6 +6171,16 @@ retry:
 		/* The area was replaced with another one */
 		goto retry;
 	}
+	/*
+	 * At this point, we have a stable reference to a VMA: The VMA is
+	 * locked and we know it hasn't already been isolated.
+	 * From here on, we can access the VMA without worrying about which
+	 * fields are accessible for RCU readers.
+	 */
+
+	/* Check since vm_start/vm_end might change before we lock the VMA */
+	if (unlikely(address < vma->vm_start || address >= vma->vm_end))
+		goto inval_end_read;
 
 	rcu_read_unlock();
 	return vma;
_

Patches currently in -mm which might be from jannh@google.com are

kasan-catch-invalid-free-before-slub-reinitializes-the-object.patch
slub-introduce-config_slub_rcu_debug.patch
mm-fix-harmless-type-confusion-in-lock_vma_under_rcu.patch

