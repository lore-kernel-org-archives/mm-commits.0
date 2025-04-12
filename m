Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B53DDAB
	for <mm-commits@vger.kernel.org>; Sat, 12 Apr 2025 00:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744418028; cv=none; b=Fk2hflYZ76CGmkzRJ/WZ9mLJIyxmv0PJu5Ps6vXYpYGUI7Ln30o3U3nNVo9QO77ctW1UpUIo9fzxRLa1ah3aAQ7B6CQ7ytZcf0Lc3JAqit5Qtk0uro8dlWlgwL7KWYqhWLCnvVf5CyG1EFbjIoO0sJIRCTL4xJLcBNtfEkXPfrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744418028; c=relaxed/simple;
	bh=pSeYqxKA6+yCStyHZMcgWAKFBR+85Iex/BXnMLBjWn4=;
	h=Date:To:From:Subject:Message-Id; b=WUEEcUfZs/YJ5kXX8vDZ2DU7xN6lh/8BkgW8jq5uxzvl6nn5DffLzOm9oVX+iSGuhBGoPfd68sXDPGHFq6UDk5/H+2jzJVItP1VKN0AVb6UdJ+bKpp39zCXVS1W8+9vE30QR0YUhhDynWrcOLd4/RyZRyJSPuL7Doy4AuOYRQyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sUtZiTzy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sUtZiTzy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1885DC4CEE2;
	Sat, 12 Apr 2025 00:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744418028;
	bh=pSeYqxKA6+yCStyHZMcgWAKFBR+85Iex/BXnMLBjWn4=;
	h=Date:To:From:Subject:From;
	b=sUtZiTzynS4XI8ylXyAGHLVRToOiXtlTewhQCUSSIaOqe5c7QPAqvdZO98bz76FBc
	 Px6rO1nfnvzU2pb474CJQ0suCzBAev/tYcsXU83q5giM32bnir9BLsKvdKhS2QKQUv
	 9PICFf3n/B9ppeLywCq2CHWoD6DmP3TuiC86O03c=
Date: Fri, 11 Apr 2025 17:33:47 -0700
To: mm-commits@vger.kernel.org,torvalds@linux-foundation.org,tglx@linutronix.de,riel@surriel.com,peterz@infradead.org,mingo@kernel.org,luto@kernel.org,lorenzo.stoakes@oracle.com,lkp@intel.com,hpa@zytor.com,error27@gmail.com,dave.hansen@linux.intel.com,bp@alien8.de,akpm@linux-foundation.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] x86-mm-pat-untrack_pfn_copy-fix-doc-improvements.patch removed from -mm tree
Message-Id: <20250412003348.1885DC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: (un)track_pfn_copy() fix + doc improvements
has been removed from the -mm tree.  Its filename was
     x86-mm-pat-untrack_pfn_copy-fix-doc-improvements.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: (un)track_pfn_copy() fix + doc improvements
Date: Tue, 8 Apr 2025 10:59:50 +0200

We got a late smatch warning and some additional review feedback.

	smatch warnings:
	mm/memory.c:1428 copy_page_range() error: uninitialized symbol 'pfn'.

We actually use the pfn only when it is properly initialized; however, we
may pass an uninitialized value to a function -- although it will not use
it that likely still is UB in C.

So let's just fix it by always initializing pfn in the caller of
track_pfn_copy(), and improving the documentation of track_pfn_copy().

While at it, clarify the doc of untrack_pfn_copy(), that internal checks
make sure if we actually have to untrack anything.

Link: https://lkml.kernel.org/r/20250408085950.976103-1-david@redhat.com
Fixes: dc84bc2aba85 ("x86/mm/pat: Fix VM_PAT handling when fork() fails in copy_page_range()")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202503270941.IFILyNCX-lkp@intel.com/
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Rik van Riel <riel@surriel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |    9 ++++++---
 mm/memory.c             |    2 +-
 2 files changed, 7 insertions(+), 4 deletions(-)

--- a/include/linux/pgtable.h~x86-mm-pat-untrack_pfn_copy-fix-doc-improvements
+++ a/include/linux/pgtable.h
@@ -1511,8 +1511,9 @@ static inline void track_pfn_insert(stru
 
 /*
  * track_pfn_copy is called when a VM_PFNMAP VMA is about to get the page
- * tables copied during copy_page_range(). On success, stores the pfn to be
- * passed to untrack_pfn_copy().
+ * tables copied during copy_page_range(). Will store the pfn to be
+ * passed to untrack_pfn_copy() only if there is something to be untracked.
+ * Callers should initialize the pfn to 0.
  */
 static inline int track_pfn_copy(struct vm_area_struct *dst_vma,
 		struct vm_area_struct *src_vma, unsigned long *pfn)
@@ -1522,7 +1523,9 @@ static inline int track_pfn_copy(struct
 
 /*
  * untrack_pfn_copy is called when a VM_PFNMAP VMA failed to copy during
- * copy_page_range(), but after track_pfn_copy() was already called.
+ * copy_page_range(), but after track_pfn_copy() was already called. Can
+ * be called even if track_pfn_copy() did not actually track anything:
+ * handled internally.
  */
 static inline void untrack_pfn_copy(struct vm_area_struct *dst_vma,
 		unsigned long pfn)
--- a/mm/memory.c~x86-mm-pat-untrack_pfn_copy-fix-doc-improvements
+++ a/mm/memory.c
@@ -1361,7 +1361,7 @@ copy_page_range(struct vm_area_struct *d
 	struct mm_struct *dst_mm = dst_vma->vm_mm;
 	struct mm_struct *src_mm = src_vma->vm_mm;
 	struct mmu_notifier_range range;
-	unsigned long next, pfn;
+	unsigned long next, pfn = 0;
 	bool is_cow;
 	int ret;
 
_

Patches currently in -mm which might be from david@redhat.com are

fs-dax-fix-folio-splitting-issue-by-resetting-old-folio-order-_nr_pages.patch
kernel-events-uprobes-pass-vma-instead-of-mm-to-remove_breakpoint.patch
kernel-events-uprobes-pass-vma-to-set_swbp-set_orig_insn-and-uprobe_write_opcode.patch
kernel-events-uprobes-uprobe_write_opcode-rewrite.patch

