Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6FEE3D47B3
	for <mm-commits@vger.kernel.org>; Tue, 10 Mar 2026 17:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773163929; cv=none; b=trLM8h3kTIvUMpEmwXgIKZWaQDoo7TZAfqk7ORFdmAiSuEneapSdgfK4BOSqngri1p1BGpBH6VIvo1SfRsV7S5BHFBYWfRjgzoIze0hdUqtrnxJNSfKqUV086oXnLwXhlb0z8E9RVLYwEKTZ7E9yv/7ikUkUzIW2mOTGPnlBm30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773163929; c=relaxed/simple;
	bh=IwOHil0I1aY5CWJoJKpF+ld0maBM18ARXrSj+F+ZvC4=;
	h=Date:To:From:Subject:Message-Id; b=f/ZXG6EkmKKkSDA6nibdI9/Fssos1rXhMcocXIw1Dl1ndq2EWDhHmkYE4Emq2YK7s9Yy71hLUAPsu1BfOReHHS8TmmfF2/BrHedNZKLLhHo3TB2+usAE45NNmoiv2z6/5hlq8q3SMSlH1MnUbKLbYMDG9KgB6kTZHQuVD1DyK0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TiEbLfOH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TiEbLfOH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49D5DC19423;
	Tue, 10 Mar 2026 17:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773163928;
	bh=IwOHil0I1aY5CWJoJKpF+ld0maBM18ARXrSj+F+ZvC4=;
	h=Date:To:From:Subject:From;
	b=TiEbLfOH5nH0ItHGQuagHorhEtpUkJEgOaybiN5h46ijfF809hPybMTLkXBbjK/vS
	 xtACiRd1MDuV5llW6xO0IS/EB0nwzbJtM9kgdYA88tvHtw5sC65Jwcb/skNUXj1B9O
	 C+kb0H17lCUMFRQmPJLyVVS4XjP+SrEQJHOmV3js=
Date: Tue, 10 Mar 2026 10:32:07 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,jason@zx2c4.com,jannh@google.com,david@kernel.org,anthony.yznaga@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-prevent-droppable-mappings-from-being-locked.patch added to mm-new branch
Message-Id: <20260310173208.49D5DC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: prevent droppable mappings from being locked
has been added to the -mm mm-new branch.  Its filename is
     mm-prevent-droppable-mappings-from-being-locked.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-prevent-droppable-mappings-from-being-locked.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Anthony Yznaga <anthony.yznaga@oracle.com>
Subject: mm: prevent droppable mappings from being locked
Date: Tue, 10 Mar 2026 08:58:20 -0700

Droppable mappings must not be lockable.  There is a check for VMAs with
VM_DROPPABLE set in mlock_fixup() along with checks for other types of
unlockable VMAs which ensures this when calling mlock()/mlock2().

For mlockall(MCL_FUTURE), the check for unlockable VMAs is different.  In
apply_mlockall_flags(), if the flags parameter has MCL_FUTURE set, the
current task's mm's default VMA flag field mm->def_flags has VM_LOCKED
applied to it.  VM_LOCKONFAULT is also applied if MCL_ONFAULT is also set.
When these flags are set as default in this manner they are cleared in
__mmap_complete() for new mappings that do not support mlock.  A check for
VM_DROPPABLE in __mmap_complete() is missing resulting in droppable
mappings created with VM_LOCKED set.  To fix this and reduce that chance
of similar bugs in the future, introduce and use vma_supports_mlock().

Link: https://lkml.kernel.org/r/20260310155821.17869-1-anthony.yznaga@oracle.com
Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always lazily freeable mappings")
Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
Suggested-by: David Hildenbrand <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jason A. Donenfeld <jason@zx2c4.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb_inline.h    |    2 +-
 mm/internal.h                     |   10 ++++++++++
 mm/mlock.c                        |   10 ++++++----
 mm/vma.c                          |    4 +---
 tools/testing/vma/include/stubs.h |    5 +++++
 5 files changed, 23 insertions(+), 8 deletions(-)

--- a/include/linux/hugetlb_inline.h~mm-prevent-droppable-mappings-from-being-locked
+++ a/include/linux/hugetlb_inline.h
@@ -30,7 +30,7 @@ static inline bool is_vma_hugetlb_flags(
 
 #endif
 
-static inline bool is_vm_hugetlb_page(struct vm_area_struct *vma)
+static inline bool is_vm_hugetlb_page(const struct vm_area_struct *vma)
 {
 	return is_vm_hugetlb_flags(vma->vm_flags);
 }
--- a/mm/internal.h~mm-prevent-droppable-mappings-from-being-locked
+++ a/mm/internal.h
@@ -1249,6 +1249,16 @@ static inline struct file *maybe_unlock_
 	}
 	return fpin;
 }
+
+static inline bool vma_supports_mlock(const struct vm_area_struct *vma)
+{
+	if (vma->vm_flags & (VM_SPECIAL | VM_DROPPABLE))
+		return false;
+	if (vma_is_dax(vma) || is_vm_hugetlb_page(vma))
+		return false;
+	return vma != get_gate_vma(current->mm);
+}
+
 #else /* !CONFIG_MMU */
 static inline void unmap_mapping_folio(struct folio *folio) { }
 static inline void mlock_new_folio(struct folio *folio) { }
--- a/mm/mlock.c~mm-prevent-droppable-mappings-from-being-locked
+++ a/mm/mlock.c
@@ -472,10 +472,12 @@ static int mlock_fixup(struct vma_iterat
 	int ret = 0;
 	vm_flags_t oldflags = vma->vm_flags;
 
-	if (newflags == oldflags || (oldflags & VM_SPECIAL) ||
-	    is_vm_hugetlb_page(vma) || vma == get_gate_vma(current->mm) ||
-	    vma_is_dax(vma) || vma_is_secretmem(vma) || (oldflags & VM_DROPPABLE))
-		/* don't set VM_LOCKED or VM_LOCKONFAULT and don't count */
+	if (newflags == oldflags || vma_is_secretmem(vma) ||
+	    !vma_supports_mlock(vma))
+		/*
+		 * Don't set VM_LOCKED or VM_LOCKONFAULT and don't count.
+		 * For secretmem, don't allow the memory to be unlocked.
+		 */
 		goto out;
 
 	vma = vma_modify_flags(vmi, *prev, vma, start, end, &newflags);
--- a/mm/vma.c~mm-prevent-droppable-mappings-from-being-locked
+++ a/mm/vma.c
@@ -2589,9 +2589,7 @@ static void __mmap_complete(struct mmap_
 
 	vm_stat_account(mm, vma->vm_flags, map->pglen);
 	if (vm_flags & VM_LOCKED) {
-		if ((vm_flags & VM_SPECIAL) || vma_is_dax(vma) ||
-					is_vm_hugetlb_page(vma) ||
-					vma == get_gate_vma(mm))
+		if (!vma_supports_mlock(vma))
 			vm_flags_clear(vma, VM_LOCKED_MASK);
 		else
 			mm->locked_vm += map->pglen;
--- a/tools/testing/vma/include/stubs.h~mm-prevent-droppable-mappings-from-being-locked
+++ a/tools/testing/vma/include/stubs.h
@@ -426,3 +426,8 @@ static inline void vma_adjust_trans_huge
 }
 
 static inline void hugetlb_split(struct vm_area_struct *, unsigned long) {}
+
+static inline bool vma_supports_mlock(const struct vm_area_struct *vma)
+{
+	return false;
+}
_

Patches currently in -mm which might be from anthony.yznaga@oracle.com are

mm-prevent-droppable-mappings-from-being-locked.patch
selftests-mm-verify-droppable-mappings-cannot-be-locked.patch

