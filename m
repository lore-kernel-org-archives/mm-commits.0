Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645D3208A7
	for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2024 18:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711477129; cv=none; b=rUJsTjQC1fGnY5qRx/4RjwiZjqQiEqUsgxyclXlYTl3Ztmb2ccssghAH7aLlotIigkymoINWfqeTXKez22grXHTxgeu7bpEURWup+Dyiz5ocgdicuE+JcMEMlIkiC2LGVFlb1+En6fRNxf1CcPOfMR7z1XmvosV9f+il7hkuLfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711477129; c=relaxed/simple;
	bh=m7H8F7+9EIrWnkTlF33RZcFqXHPw1mjsDl2X/A3hE18=;
	h=Date:To:From:Subject:Message-Id; b=kcB665H7MUHpmupWa1NHdNsmLP6NPbNHz9UMxLLevBHQ6HaA5jmvr9hNExnCq2S/g9JW0DAl84ooGLVnYChk5pvFUQlGmEdJRzlMtzgNpp0ezJhry9PswKaaM7b+M4WrYnMR4Up/V+7jB1Veu02KSEvmwFof6gPsTc15SdE2Bt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zQK0ArFw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zQK0ArFw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E15E3C433C7;
	Tue, 26 Mar 2024 18:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711477129;
	bh=m7H8F7+9EIrWnkTlF33RZcFqXHPw1mjsDl2X/A3hE18=;
	h=Date:To:From:Subject:From;
	b=zQK0ArFwqHARQXHEpDt7p67mssvCC9jxyqVaSRuVuSlP5Sh66U+UCoi9aN85HZtcJ
	 IyGg9TpRR2YcXQwyXTm8rVFbnT9ZezmlKi1ikjJkWjOIHwRV/8Y+SbTXpjneLkZN3Q
	 PfDHooSk0fjwyi4MAWGUpSxS1LO3FN+ibaqzwAys=
Date: Tue, 26 Mar 2024 11:18:48 -0700
To: mm-commits@vger.kernel.org,xrivendell7@gmail.com,samsun1006219@gmail.com,rppt@kernel.org,mszeredi@redhat.com,lstoakes@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-merge-folio_is_secretmem-and-folio_fast_pin_allowed-into-gup_fast_folio_allowed.patch added to mm-unstable branch
Message-Id: <20240326181848.E15E3C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: merge folio_is_secretmem() and folio_fast_pin_allowed() into gup_fast_folio_allowed()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-merge-folio_is_secretmem-and-folio_fast_pin_allowed-into-gup_fast_folio_allowed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-merge-folio_is_secretmem-and-folio_fast_pin_allowed-into-gup_fast_folio_allowed.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm: merge folio_is_secretmem() and folio_fast_pin_allowed() into gup_fast_folio_allowed()
Date: Tue, 26 Mar 2024 15:32:10 +0100

folio_is_secretmem() is currently only used during GUP-fast.  Nowadays,
folio_fast_pin_allowed() performs similar checks during GUP-fast and
contains a lot of careful handling -- READ_ONCE() -- , sanity checks --
lockdep_assert_irqs_disabled() -- and helpful comments on how this
handling is safe and correct.

So let's merge folio_is_secretmem() into folio_fast_pin_allowed().  Rename
folio_fast_pin_allowed() to gup_fast_folio_allowed(), to better match the
new semantics.

Link: https://lkml.kernel.org/r/20240326143210.291116-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Cc: xingwei lee <xrivendell7@gmail.com>
Cc: yue sun <samsun1006219@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/secretmem.h |   21 +--------------
 mm/gup.c                  |   48 +++++++++++++++++++++---------------
 2 files changed, 30 insertions(+), 39 deletions(-)

--- a/include/linux/secretmem.h~mm-merge-folio_is_secretmem-and-folio_fast_pin_allowed-into-gup_fast_folio_allowed
+++ a/include/linux/secretmem.h
@@ -6,25 +6,8 @@
 
 extern const struct address_space_operations secretmem_aops;
 
-static inline bool folio_is_secretmem(struct folio *folio)
+static inline bool secretmem_mapping(struct address_space *mapping)
 {
-	struct address_space *mapping;
-
-	/*
-	 * Using folio_mapping() is quite slow because of the actual call
-	 * instruction.
-	 * We know that secretmem pages are not compound, so we can
-	 * save a couple of cycles here.
-	 */
-	if (folio_test_large(folio))
-		return false;
-
-	mapping = (struct address_space *)
-		((unsigned long)folio->mapping & ~PAGE_MAPPING_FLAGS);
-
-	if (!mapping || mapping != folio->mapping)
-		return false;
-
 	return mapping->a_ops == &secretmem_aops;
 }
 
@@ -38,7 +21,7 @@ static inline bool vma_is_secretmem(stru
 	return false;
 }
 
-static inline bool folio_is_secretmem(struct folio *folio)
+static inline bool secretmem_mapping(struct address_space *mapping)
 {
 	return false;
 }
--- a/mm/gup.c~mm-merge-folio_is_secretmem-and-folio_fast_pin_allowed-into-gup_fast_folio_allowed
+++ a/mm/gup.c
@@ -2466,12 +2466,14 @@ EXPORT_SYMBOL(get_user_pages_unlocked);
 #ifdef CONFIG_HAVE_FAST_GUP
 
 /*
- * Used in the GUP-fast path to determine whether a pin is permitted for a
- * specific folio.
+ * Used in the GUP-fast path to determine whether GUP is permitted to work on
+ * a specific folio.
  *
  * This call assumes the caller has pinned the folio, that the lowest page table
  * level still points to this folio, and that interrupts have been disabled.
  *
+ * GUP-fast must reject all secretmem folios.
+ *
  * Writing to pinned file-backed dirty tracked folios is inherently problematic
  * (see comment describing the writable_file_mapping_allowed() function). We
  * therefore try to avoid the most egregious case of a long-term mapping doing
@@ -2481,25 +2483,34 @@ EXPORT_SYMBOL(get_user_pages_unlocked);
  * in the fast path, so instead we whitelist known good cases and if in doubt,
  * fall back to the slow path.
  */
-static bool folio_fast_pin_allowed(struct folio *folio, unsigned int flags)
+static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
 {
+	bool reject_file_backed = false;
 	struct address_space *mapping;
+	bool check_secretmem = false;
 	unsigned long mapping_flags;
 
 	/*
 	 * If we aren't pinning then no problematic write can occur. A long term
 	 * pin is the most egregious case so this is the one we disallow.
 	 */
-	if ((flags & (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE)) !=
+	if ((flags & (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE)) ==
 	    (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE))
-		return true;
+		reject_file_backed = true;
+
+	/* We hold a folio reference, so we can safely access folio fields. */
 
-	/* The folio is pinned, so we can safely access folio fields. */
+	/* secretmem folios are always order-0 folios. */
+	if (IS_ENABLED(CONFIG_SECRETMEM) && !folio_test_large(folio))
+		check_secretmem = true;
+
+	if (!reject_file_backed && !check_secretmem)
+		return true;
 
 	if (WARN_ON_ONCE(folio_test_slab(folio)))
 		return false;
 
-	/* hugetlb mappings do not require dirty-tracking. */
+	/* hugetlb neither requires dirty-tracking nor can be secretmem. */
 	if (folio_test_hugetlb(folio))
 		return true;
 
@@ -2535,10 +2546,12 @@ static bool folio_fast_pin_allowed(struc
 
 	/*
 	 * At this point, we know the mapping is non-null and points to an
-	 * address_space object. The only remaining whitelisted file system is
-	 * shmem.
+	 * address_space object.
 	 */
-	return shmem_mapping(mapping);
+	if (check_secretmem && secretmem_mapping(mapping))
+		return false;
+	/* The only remaining allowed file system is shmem. */
+	return !reject_file_backed || shmem_mapping(mapping);
 }
 
 static void __maybe_unused undo_dev_pagemap(int *nr, int nr_start,
@@ -2624,18 +2637,13 @@ static int gup_pte_range(pmd_t pmd, pmd_
 		if (!folio)
 			goto pte_unmap;
 
-		if (unlikely(folio_is_secretmem(folio))) {
-			gup_put_folio(folio, 1, flags);
-			goto pte_unmap;
-		}
-
 		if (unlikely(pmd_val(pmd) != pmd_val(*pmdp)) ||
 		    unlikely(pte_val(pte) != pte_val(ptep_get(ptep)))) {
 			gup_put_folio(folio, 1, flags);
 			goto pte_unmap;
 		}
 
-		if (!folio_fast_pin_allowed(folio, flags)) {
+		if (!gup_fast_folio_allowed(folio, flags)) {
 			gup_put_folio(folio, 1, flags);
 			goto pte_unmap;
 		}
@@ -2832,7 +2840,7 @@ static int gup_hugepte(pte_t *ptep, unsi
 		return 0;
 	}
 
-	if (!folio_fast_pin_allowed(folio, flags)) {
+	if (!gup_fast_folio_allowed(folio, flags)) {
 		gup_put_folio(folio, refs, flags);
 		return 0;
 	}
@@ -2903,7 +2911,7 @@ static int gup_huge_pmd(pmd_t orig, pmd_
 		return 0;
 	}
 
-	if (!folio_fast_pin_allowed(folio, flags)) {
+	if (!gup_fast_folio_allowed(folio, flags)) {
 		gup_put_folio(folio, refs, flags);
 		return 0;
 	}
@@ -2947,7 +2955,7 @@ static int gup_huge_pud(pud_t orig, pud_
 		return 0;
 	}
 
-	if (!folio_fast_pin_allowed(folio, flags)) {
+	if (!gup_fast_folio_allowed(folio, flags)) {
 		gup_put_folio(folio, refs, flags);
 		return 0;
 	}
@@ -2992,7 +3000,7 @@ static int gup_huge_pgd(pgd_t orig, pgd_
 		return 0;
 	}
 
-	if (!folio_fast_pin_allowed(folio, flags)) {
+	if (!gup_fast_folio_allowed(folio, flags)) {
 		gup_put_folio(folio, refs, flags);
 		return 0;
 	}
_

Patches currently in -mm which might be from david@redhat.com are

mm-secretmem-fix-gup-fast-succeeding-on-secretmem-folios.patch
mm-madvise-make-madv_populate_readwrite-handle-vm_fault_retry-properly.patch
mm-madvise-dont-perform-madvise-vma-walk-for-madv_populate_readwrite.patch
mm-userfaultfd-dont-place-zeropages-when-zeropages-are-disallowed.patch
s390-mm-re-enable-the-shared-zeropage-for-pv-and-skeys-kvm-guests.patch
mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared.patch
mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared-fix.patch
selftests-memfd_secret-add-vmsplice-test.patch
mm-merge-folio_is_secretmem-and-folio_fast_pin_allowed-into-gup_fast_folio_allowed.patch

