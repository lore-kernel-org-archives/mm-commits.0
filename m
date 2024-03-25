Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7386110962
	for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2024 18:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711391345; cv=none; b=Az/AmuXCot7goG/GNcbXAQgFzpbYkZK+4rfPf2QEOa9PfRfC8KCx+rAzshf2QOpr4uCNpzIdETIQmBXVSeVuNLk3Hyc7ZASVOrRaure+DKiijnfoxHbk3KVPizKu5dgm4ZSM7YqprMeNBy5jcAyRcSQIWcsFLsNdeWS6+H2c8WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711391345; c=relaxed/simple;
	bh=QhRDSQdkDUnLb7A6N2IgUIOlRV5sAbXTBkl4Anru7ic=;
	h=Date:To:From:Subject:Message-Id; b=GNCDcJzJcJNNsF0ATr0deRaBXJQ8PWzHBtP2lVeHJpImbb/KXvWd0CY2J4xmDqxTEFHx5TjGYq/crn/Yu2o44aVZrRuxPY+ES5EiiZF7ZDCGLBXewz4fuIXjDt5KDzj+TXFRWjZ+J1DzD4fk17HCUYXC6Dd+u5aEG303rTzi7lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GxGQH5GN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GxGQH5GN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAEF0C433C7;
	Mon, 25 Mar 2024 18:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711391344;
	bh=QhRDSQdkDUnLb7A6N2IgUIOlRV5sAbXTBkl4Anru7ic=;
	h=Date:To:From:Subject:From;
	b=GxGQH5GNqKL8Ng4ax1/jRAXwJEVF5+xNHzDUMlOrky66sdG4/GGdPhpNy5ZLD6GNg
	 4DQdTCgyHvud1bQoa0G0132dNsuzfGWdH8ActFv/v3ziJPW4r39uO6UAGT7mvlWyoa
	 cWns+PUw6KxhEOIVAKORslicZEZFGcQZamXMzzAU=
Date: Mon, 25 Mar 2024 11:29:04 -0700
To: mm-commits@vger.kernel.org,xrivendell7@gmail.com,samsun1006219@gmail.com,rppt@kernel.org,mszeredi@redhat.com,lstoakes@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-merge-folio_is_secretmem-into-folio_fast_pin_allowed.patch added to mm-unstable branch
Message-Id: <20240325182904.DAEF0C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: merge folio_is_secretmem() into folio_fast_pin_allowed()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-merge-folio_is_secretmem-into-folio_fast_pin_allowed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-merge-folio_is_secretmem-into-folio_fast_pin_allowed.patch

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
Subject: mm: merge folio_is_secretmem() into folio_fast_pin_allowed()
Date: Mon, 25 Mar 2024 14:41:14 +0100

folio_is_secretmem() is currently only used during GUP-fast, and using it
in wrong context where concurrent truncation might happen, could be
problematic.

Nowadays, folio_fast_pin_allowed() performs similar checks during GUP-fast
and contains a lot of careful handling -- READ_ONCE( -- ), sanity checks
-- lockdep_assert_irqs_disabled() -- and helpful comments on how this
handling is safe and correct.

So let's merge folio_is_secretmem() into folio_fast_pin_allowed(), still
avoiding checking the actual mapping only if really required.

Link: https://lkml.kernel.org/r/20240325134114.257544-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Cc: xingwei lee <xrivendell7@gmail.com>
Cc: yue sun <samsun1006219@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/secretmem.h |   21 ++-------------------
 mm/gup.c                  |   33 +++++++++++++++++++++------------
 2 files changed, 23 insertions(+), 31 deletions(-)

--- a/include/linux/secretmem.h~mm-merge-folio_is_secretmem-into-folio_fast_pin_allowed
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
-	 * We know that secretmem pages are not compound and LRU so we can
-	 * save a couple of cycles here.
-	 */
-	if (folio_test_large(folio) || folio_test_lru(folio))
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
--- a/mm/gup.c~mm-merge-folio_is_secretmem-into-folio_fast_pin_allowed
+++ a/mm/gup.c
@@ -2472,6 +2472,8 @@ EXPORT_SYMBOL(get_user_pages_unlocked);
  * This call assumes the caller has pinned the folio, that the lowest page table
  * level still points to this folio, and that interrupts have been disabled.
  *
+ * GUP-fast must reject all secretmem folios.
+ *
  * Writing to pinned file-backed dirty tracked folios is inherently problematic
  * (see comment describing the writable_file_mapping_allowed() function). We
  * therefore try to avoid the most egregious case of a long-term mapping doing
@@ -2484,22 +2486,32 @@ EXPORT_SYMBOL(get_user_pages_unlocked);
 static bool folio_fast_pin_allowed(struct folio *folio, unsigned int flags)
 {
 	struct address_space *mapping;
+	bool check_secretmem = false;
+	bool reject_file_backed = false;
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
+
+	/* secretmem folios are only order-0 folios and never LRU folios. */
+	if (IS_ENABLED(CONFIG_SECRETMEM) && !folio_test_large(folio) &&
+	    !folio_test_lru(folio))
+		check_secretmem = true;
 
-	/* The folio is pinned, so we can safely access folio fields. */
+	if (!reject_file_backed && !check_secretmem)
+		return true;
 
 	if (WARN_ON_ONCE(folio_test_slab(folio)))
 		return false;
 
-	/* hugetlb mappings do not require dirty-tracking. */
+	/* hugetlb neither requires dirty-tracking nor can be secretmem. */
 	if (folio_test_hugetlb(folio))
 		return true;
 
@@ -2535,10 +2547,12 @@ static bool folio_fast_pin_allowed(struc
 
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
@@ -2624,11 +2638,6 @@ static int gup_pte_range(pmd_t pmd, pmd_
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
_

Patches currently in -mm which might be from david@redhat.com are

mm-secretmem-fix-gup-fast-succeeding-on-secretmem-folios.patch
mm-madvise-make-madv_populate_readwrite-handle-vm_fault_retry-properly.patch
mm-madvise-dont-perform-madvise-vma-walk-for-madv_populate_readwrite.patch
mm-userfaultfd-dont-place-zeropages-when-zeropages-are-disallowed.patch
s390-mm-re-enable-the-shared-zeropage-for-pv-and-skeys-kvm-guests.patch
mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared.patch
selftests-memfd_secret-add-vmsplice-test.patch
mm-merge-folio_is_secretmem-into-folio_fast_pin_allowed.patch

