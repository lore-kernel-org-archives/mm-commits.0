Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8023523C70B
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837029; cv=none; b=ACsvyPwVKPXl6vqNnKd4QBBnkHJrwgYEsmSvUvBPN6fknVzEWLOXvHkxn3Sr5t4iOpBWMQpBqPFmOqqhNdcovYzyCv8StaXEQlttjS8CfQix/Z/qRAJIuLw7SNv0ngDEA3NI4K9SWM3NabYikIB3ePev0pfnWueyU+yKrRXBmbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837029; c=relaxed/simple;
	bh=OkxUzzASvAHIyuPw4+MTIWelnh4wTT2L0GzVgQ49xXI=;
	h=Date:To:From:Subject:Message-Id; b=SviLQqEpRVG4NrK6bg713DFy0xZgoD1JqAFN/kuG8S1drXEl1yXd896fupKGBHEfHhIUsjlkAnO+um4JnUkb2cTHD2274Eq+SchKSyOmGUy/k80Kc6LwCAh/0zvrLuqdIXUPWGBowCXhYt9K+K0AgBZs4lLPe3ZGw4V0d7saoZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o0duaqfh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o0duaqfh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55402C4CEDD;
	Tue, 14 Jan 2025 06:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837029;
	bh=OkxUzzASvAHIyuPw4+MTIWelnh4wTT2L0GzVgQ49xXI=;
	h=Date:To:From:Subject:From;
	b=o0duaqfhA8kX35VzYbTnQ4dgaM1OBmV7J4Z80/ZOS5UEMPe1EHl8AMsPmRjidDsTU
	 0ZubbhDRTY4T5y8wW5IT8CwTTnM55S+5YRlNP2nYrCKGbngYdVDkRfSyLFDvrcpBP4
	 fTxNfQHivegpldpIeWEnoNqrNIu3tggFnu3XTt4A=
Date: Mon, 13 Jan 2025 22:43:48 -0800
To: mm-commits@vger.kernel.org,peterx@redhat.com,muchun.song@linux.dev,ehagberg@janestreet.com,david@redhat.com,akpm@linux-foundation.org,guillaume@morinfr.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-support-foll_forcefoll_write.patch removed from -mm tree
Message-Id: <20250114064349.55402C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: support FOLL_FORCE|FOLL_WRITE
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-support-foll_forcefoll_write.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Guillaume Morin <guillaume@morinfr.org>
Subject: mm/hugetlb: support FOLL_FORCE|FOLL_WRITE
Date: Fri, 6 Dec 2024 22:28:36 +0100

Eric reported that PTRACE_POKETEXT fails when applications use hugetlb for
mapping text using huge pages.  Before commit 1d8d14641fd9 ("mm/hugetlb:
support write-faults in shared mappings"), PTRACE_POKETEXT worked by
accident, but it was buggy and silently ended up mapping pages writable
into the page tables even though VM_WRITE was not set.

In general, FOLL_FORCE|FOLL_WRITE does currently not work with hugetlb. 
Let's implement FOLL_FORCE|FOLL_WRITE properly for hugetlb, such that what
used to work in the past by accident now properly works, allowing
applications using hugetlb for text etc.  to get properly debugged.

This change might also be required to implement uprobes support for
hugetlb [1].

[1] https://lore.kernel.org/lkml/ZiK50qob9yl5e0Xz@bender.morinfr.org/

Link: https://lkml.kernel.org/r/Z1NshNfWuzUCPebA@bender.morinfr.org
Signed-off-by: Guillaume Morin <guillaume@morinfr.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Eric Hagberg <ehagberg@janestreet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c     |   91 +++++++++++++++++++++++--------------------------
 mm/hugetlb.c |   17 ++++-----
 2 files changed, 53 insertions(+), 55 deletions(-)

--- a/mm/gup.c~mm-hugetlb-support-foll_forcefoll_write
+++ a/mm/gup.c
@@ -596,6 +596,33 @@ static struct folio *try_grab_folio_fast
 }
 #endif	/* CONFIG_HAVE_GUP_FAST */
 
+/* Common code for can_follow_write_* */
+static inline bool can_follow_write_common(struct page *page,
+		struct vm_area_struct *vma, unsigned int flags)
+{
+	/* Maybe FOLL_FORCE is set to override it? */
+	if (!(flags & FOLL_FORCE))
+		return false;
+
+	/* But FOLL_FORCE has no effect on shared mappings */
+	if (vma->vm_flags & (VM_MAYSHARE | VM_SHARED))
+		return false;
+
+	/* ... or read-only private ones */
+	if (!(vma->vm_flags & VM_MAYWRITE))
+		return false;
+
+	/* ... or already writable ones that just need to take a write fault */
+	if (vma->vm_flags & VM_WRITE)
+		return false;
+
+	/*
+	 * See can_change_pte_writable(): we broke COW and could map the page
+	 * writable if we have an exclusive anonymous page ...
+	 */
+	return page && PageAnon(page) && PageAnonExclusive(page);
+}
+
 static struct page *no_page_table(struct vm_area_struct *vma,
 				  unsigned int flags, unsigned long address)
 {
@@ -622,6 +649,18 @@ static struct page *no_page_table(struct
 }
 
 #ifdef CONFIG_PGTABLE_HAS_HUGE_LEAVES
+/* FOLL_FORCE can write to even unwritable PUDs in COW mappings. */
+static inline bool can_follow_write_pud(pud_t pud, struct page *page,
+					struct vm_area_struct *vma,
+					unsigned int flags)
+{
+	/* If the pud is writable, we can write to the page. */
+	if (pud_write(pud))
+		return true;
+
+	return can_follow_write_common(page, vma, flags);
+}
+
 static struct page *follow_huge_pud(struct vm_area_struct *vma,
 				    unsigned long addr, pud_t *pudp,
 				    int flags, struct follow_page_context *ctx)
@@ -634,10 +673,11 @@ static struct page *follow_huge_pud(stru
 
 	assert_spin_locked(pud_lockptr(mm, pudp));
 
-	if ((flags & FOLL_WRITE) && !pud_write(pud))
+	if (!pud_present(pud))
 		return NULL;
 
-	if (!pud_present(pud))
+	if ((flags & FOLL_WRITE) &&
+	    !can_follow_write_pud(pud, pfn_to_page(pfn), vma, flags))
 		return NULL;
 
 	pfn += (addr & ~PUD_MASK) >> PAGE_SHIFT;
@@ -686,27 +726,7 @@ static inline bool can_follow_write_pmd(
 	if (pmd_write(pmd))
 		return true;
 
-	/* Maybe FOLL_FORCE is set to override it? */
-	if (!(flags & FOLL_FORCE))
-		return false;
-
-	/* But FOLL_FORCE has no effect on shared mappings */
-	if (vma->vm_flags & (VM_MAYSHARE | VM_SHARED))
-		return false;
-
-	/* ... or read-only private ones */
-	if (!(vma->vm_flags & VM_MAYWRITE))
-		return false;
-
-	/* ... or already writable ones that just need to take a write fault */
-	if (vma->vm_flags & VM_WRITE)
-		return false;
-
-	/*
-	 * See can_change_pte_writable(): we broke COW and could map the page
-	 * writable if we have an exclusive anonymous page ...
-	 */
-	if (!page || !PageAnon(page) || !PageAnonExclusive(page))
+	if (!can_follow_write_common(page, vma, flags))
 		return false;
 
 	/* ... and a write-fault isn't required for other reasons. */
@@ -807,27 +827,7 @@ static inline bool can_follow_write_pte(
 	if (pte_write(pte))
 		return true;
 
-	/* Maybe FOLL_FORCE is set to override it? */
-	if (!(flags & FOLL_FORCE))
-		return false;
-
-	/* But FOLL_FORCE has no effect on shared mappings */
-	if (vma->vm_flags & (VM_MAYSHARE | VM_SHARED))
-		return false;
-
-	/* ... or read-only private ones */
-	if (!(vma->vm_flags & VM_MAYWRITE))
-		return false;
-
-	/* ... or already writable ones that just need to take a write fault */
-	if (vma->vm_flags & VM_WRITE)
-		return false;
-
-	/*
-	 * See can_change_pte_writable(): we broke COW and could map the page
-	 * writable if we have an exclusive anonymous page ...
-	 */
-	if (!page || !PageAnon(page) || !PageAnonExclusive(page))
+	if (!can_follow_write_common(page, vma, flags))
 		return false;
 
 	/* ... and a write-fault isn't required for other reasons. */
@@ -1294,9 +1294,6 @@ static int check_vma_flags(struct vm_are
 		if (!(vm_flags & VM_WRITE) || (vm_flags & VM_SHADOW_STACK)) {
 			if (!(gup_flags & FOLL_FORCE))
 				return -EFAULT;
-			/* hugetlb does not support FOLL_FORCE|FOLL_WRITE. */
-			if (is_vm_hugetlb_page(vma))
-				return -EFAULT;
 			/*
 			 * We used to let the write,force case do COW in a
 			 * VM_MAYWRITE VM_SHARED !VM_WRITE vma, so ptrace could
--- a/mm/hugetlb.c~mm-hugetlb-support-foll_forcefoll_write
+++ a/mm/hugetlb.c
@@ -5183,6 +5183,13 @@ static void set_huge_ptep_writable(struc
 		update_mmu_cache(vma, address, ptep);
 }
 
+static void set_huge_ptep_maybe_writable(struct vm_area_struct *vma,
+					 unsigned long address, pte_t *ptep)
+{
+	if (vma->vm_flags & VM_WRITE)
+		set_huge_ptep_writable(vma, address, ptep);
+}
+
 bool is_hugetlb_entry_migration(pte_t pte)
 {
 	swp_entry_t swp;
@@ -5828,13 +5835,6 @@ static vm_fault_t hugetlb_wp(struct foli
 	if (!unshare && huge_pte_uffd_wp(pte))
 		return 0;
 
-	/*
-	 * hugetlb does not support FOLL_FORCE-style write faults that keep the
-	 * PTE mapped R/O such as maybe_mkwrite() would do.
-	 */
-	if (WARN_ON_ONCE(!unshare && !(vma->vm_flags & VM_WRITE)))
-		return VM_FAULT_SIGSEGV;
-
 	/* Let's take out MAP_SHARED mappings first. */
 	if (vma->vm_flags & VM_MAYSHARE) {
 		set_huge_ptep_writable(vma, vmf->address, vmf->pte);
@@ -5863,7 +5863,8 @@ retry_avoidcopy:
 			SetPageAnonExclusive(&old_folio->page);
 		}
 		if (likely(!unshare))
-			set_huge_ptep_writable(vma, vmf->address, vmf->pte);
+			set_huge_ptep_maybe_writable(vma, vmf->address,
+						     vmf->pte);
 
 		delayacct_wpcopy_end();
 		return 0;
_

Patches currently in -mm which might be from guillaume@morinfr.org are


