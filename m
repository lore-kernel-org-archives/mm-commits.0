Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE2B8462
	for <mm-commits@vger.kernel.org>; Sun,  6 Apr 2025 23:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743980522; cv=none; b=ZzPZwxSWfAHUVb1L/Z4n13MntrjK0gQtubT0W3pxcnN9Ar/6nWIbSzrQg7OgUyrgM+ERFqmliYLkxzKlCILFj1FZ1eh8PxKebYs8pkdrVVYJYlY2ThMZHQCDjnHG+wues9u6LL7J+uApOpzWFugKbNYWXPHjUKPq/nuNKguqcl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743980522; c=relaxed/simple;
	bh=LRX8IdCFYn9dYNh7vicbdXKK/ItUzDQfjD8IT7IqagE=;
	h=Date:To:From:Subject:Message-Id; b=GehlfVEAnv6zi8HriPHJTOw3JagFkNyy7+sRAxbi0gjyL11iBJC1J4186+6z4oXgRlAFw04DYzD2HBv9t4ofLP0yLv5MUjsbpUvIciFOIQGnbAOqlqf7e+2OiMnJjT2iYhYTsBcA/lM9vLRd4WmmkCjXq1bIKabnfiIhraJDUGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kExtp9Ok; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kExtp9Ok"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB9BFC4CEE3;
	Sun,  6 Apr 2025 23:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743980522;
	bh=LRX8IdCFYn9dYNh7vicbdXKK/ItUzDQfjD8IT7IqagE=;
	h=Date:To:From:Subject:From;
	b=kExtp9OkIjKUfLFNrJO9lwnHcvuXv0O3r3qP6oI0D89RTVArS/Ky6NCZloREoAQTB
	 mP2EtysghaAJFZsKqkvScg9hC/AJufYHQYhviyTfupEp0T+3ttcJIIXf3LaLj4Vw/E
	 en+Ayu+/SRiqlWzWmasrLFh+GyuqWUxKhrU+wUWU=
Date: Sun, 06 Apr 2025 16:02:01 -0700
To: mm-commits@vger.kernel.org,torvalds@linux-foundation.org,tglx@linutronix.de,riel@surriel.com,peterz@infradead.org,mingo@redhat.com,luto@kernel.org,lorenzo.stoakes@oracle.com,lkp@intel.com,hpa@zytor.com,error27@gmail.com,dave.hansen@linux.intel.com,bp@alien8.de,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-mm-pat-untrack_pfn_copy-fix-improvements.patch added to mm-hotfixes-unstable branch
Message-Id: <20250406230201.DB9BFC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/mm/pat: (un)track_pfn_copy() fix + improvements
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     x86-mm-pat-untrack_pfn_copy-fix-improvements.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-mm-pat-untrack_pfn_copy-fix-improvements.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: David Hildenbrand <david@redhat.com>
Subject: x86/mm/pat: (un)track_pfn_copy() fix + improvements
Date: Fri, 4 Apr 2025 14:49:31 +0200

We got a late smatch warning and some additional review feedback.

	smatch warnings:
	mm/memory.c:1428 copy_page_range() error: uninitialized symbol 'pfn'.

We actually use the pfn only when it is properly initialized; however, we
may pass an uninitialized value to a function -- although it will not use
it that likely still is UB in C.

Fix it by always initializing pfn when track_pfn_copy() returns 0 -- just
as we document ("On success, stores the pfn to be passed to
untrack_pfn_copy()").  In addition, to avoid further wrong smatch
warnings, just initialize pfn = 0 in the caller as well.

While at it, clarify the doc of untrack_pfn_copy(), that internal checks
make sure if we actually have to untrack anything.

Link: https://lkml.kernel.org/r/20250404124931.2255618-1-david@redhat.com
Fixes: dc84bc2aba85 ("x86/mm/pat: Fix VM_PAT handling when fork() fails in copy_page_range()")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202503270941.IFILyNCX-lkp@intel.com/
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Rik van Riel <riel@surriel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pat/memtype.c |    4 +++-
 include/linux/pgtable.h   |    5 ++++-
 mm/memory.c               |    2 +-
 3 files changed, 8 insertions(+), 3 deletions(-)

--- a/arch/x86/mm/pat/memtype.c~x86-mm-pat-untrack_pfn_copy-fix-improvements
+++ a/arch/x86/mm/pat/memtype.c
@@ -992,8 +992,10 @@ int track_pfn_copy(struct vm_area_struct
 	pgprot_t pgprot;
 	int rc;
 
-	if (!(src_vma->vm_flags & VM_PAT))
+	if (!(src_vma->vm_flags & VM_PAT)) {
+		*pfn = 0;
 		return 0;
+	}
 
 	/*
 	 * Duplicate the PAT information for the dst VMA based on the src
--- a/include/linux/pgtable.h~x86-mm-pat-untrack_pfn_copy-fix-improvements
+++ a/include/linux/pgtable.h
@@ -1517,12 +1517,15 @@ static inline void track_pfn_insert(stru
 static inline int track_pfn_copy(struct vm_area_struct *dst_vma,
 		struct vm_area_struct *src_vma, unsigned long *pfn)
 {
+	*pfn = 0;
 	return 0;
 }
 
 /*
  * untrack_pfn_copy is called when a VM_PFNMAP VMA failed to copy during
- * copy_page_range(), but after track_pfn_copy() was already called.
+ * copy_page_range(), but after track_pfn_copy() was already called. Can
+ * be called even if track_pfn_copy() did not actually track anything:
+ * handled internally.
  */
 static inline void untrack_pfn_copy(struct vm_area_struct *dst_vma,
 		unsigned long pfn)
--- a/mm/memory.c~x86-mm-pat-untrack_pfn_copy-fix-improvements
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

x86-mm-pat-untrack_pfn_copy-fix-improvements.patch

