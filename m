Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45186371CE2
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776499121; cv=none; b=Sw4lbBXn9iWPSKaTpwIgz9qHMWzXF09LKk+AvnscWetK7SqdBVxv8cvhcT/ffMxsYoSWbbm1P8Aw96hF3Zoi4Mn7u+AeByGYQj2ZscbyGQNby3I2QUQdZUs3FwDVus7IrhrDlOpNCFv05mhjG6kauFzIkT83xnNqFAEyAmNP0SA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776499121; c=relaxed/simple;
	bh=2pMQAzZVq9/ClDS/3FWEYJa+7ZrcjxYup9NOwDTMGFo=;
	h=Date:To:From:Subject:Message-Id; b=V7BOiI0m7YrYp8ZvOy4VUyqfr94jHPAHE4rKQzvJyzS5ScOvY16I+rFDuXxAeTLXC0/tLHrfTiA9YMcFp3BUhwfubCZolUVY0QV+uln0J8qTG+mXPADYBY0mHIiKxSASAq0/oCiKwBictyYAmWJDMrif1lcHfIwZsVWArq5SNTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vu4ndMKy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vu4ndMKy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F2FC19424;
	Sat, 18 Apr 2026 07:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776499121;
	bh=2pMQAzZVq9/ClDS/3FWEYJa+7ZrcjxYup9NOwDTMGFo=;
	h=Date:To:From:Subject:From;
	b=vu4ndMKy+gjbIq/i7Yo42tvirITqvccO5W8T7RhDY+deAr7PJXZE24yFaCsfx1tWG
	 T7PW+7brnJhGkXjWgZraIY+Ez/WyFTRzwhyp3gRVkAEzqntlmfNGPGDH1p4c2jVHZa
	 qXnQndTHrdUVKDlZSKTQBhi+FyktzLJX4gbj2NF8=
Date: Sat, 18 Apr 2026 00:58:35 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,luyang@redhat.com,ljs@kernel.org,liam.howlett@oracle.com,jhladky@redhat.com,jannh@google.com,dev.jain@arm.com,david@kernel.org,dave@stgolabs.net,pfalcato@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mprotect-move-softleaf-code-out-of-the-main-function.patch removed from -mm tree
Message-Id: <20260418075840.58F2FC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mprotect: move softleaf code out of the main function
has been removed from the -mm tree.  Its filename was
     mm-mprotect-move-softleaf-code-out-of-the-main-function.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pedro Falcato <pfalcato@suse.de>
Subject: mm/mprotect: move softleaf code out of the main function
Date: Thu, 2 Apr 2026 15:16:27 +0100

Patch series "mm/mprotect: micro-optimization work", v3.

Micro-optimize the change_protection functionality and the
change_pte_range() routine.  This set of functions works in an incredibly
tight loop, and even small inefficiencies are incredibly evident when spun
hundreds, thousands or hundreds of thousands of times.

There was an attempt to keep the batching functionality as much as
possible, which introduced some part of the slowness, but not all of it. 
Removing it for !arm64 architectures would speed mprotect() up even
further, but could easily pessimize cases where large folios are mapped
(which is not as rare as it seems, particularly when it comes to the page
cache these days).

The micro-benchmark used for the tests was [0] (usable using
google/benchmark and g++ -O2 -lbenchmark repro.cpp)

This resulted in the following (first entry is baseline):

---------------------------------------------------------
Benchmark               Time             CPU   Iterations
---------------------------------------------------------
mprotect_bench      85967 ns        85967 ns         6935
mprotect_bench      70684 ns        70684 ns         9887


After the patchset we can observe an ~18% speedup in mprotect.  Wonderful
for the elusive mprotect-based workloads!

Testing & more ideas welcome.  I suspect there is plenty of improvement
possible but it would require more time than what I have on my hands right
now.  The entire inlined function (which inlines into change_protection())
is gigantic - I'm not surprised this is so finnicky.

Note: per my profiling, the next _big_ bottleneck here is
modify_prot_start_ptes, exactly on the xchg() done by x86. 
ptep_get_and_clear() is _expensive_.  I don't think there's a properly
safe way to go about it since we do depend on the D bit quite a lot.  This
might not be such an issue on other architectures.

Luke Yang reported [1]:

: On average, we see improvements ranging from a minimum of 5% to a
: maximum of 55%, with most improvements showing around a 25% speed up in
: the libmicro/mprot_tw4m micro benchmark.


This patch (of 2):

Move softleaf change_pte_range code into a separate function.  This makes
the change_pte_range() function a good bit smaller, and lessens cognitive
load when reading through the function.

Link: https://lore.kernel.org/20260402141628.3367596-1-pfalcato@suse.de
Link: https://lore.kernel.org/20260402141628.3367596-2-pfalcato@suse.de
Link: https://lore.kernel.org/all/aY8-XuFZ7zCvXulB@luyang-thinkpadp1gen7.toromso.csb/
Link: https://gist.github.com/heatd/1450d273005aba91fa5744f44dfcd933 [0]
Link: https://lore.kernel.org/CAL2CeBxT4jtJ+LxYb6=BNxNMGinpgD_HYH5gGxOP-45Q2OncqQ@mail.gmail.com [1]
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Luke Yang <luyang@redhat.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jiri Hladky <jhladky@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |  127 +++++++++++++++++++++++++-----------------------
 1 file changed, 67 insertions(+), 60 deletions(-)

--- a/mm/mprotect.c~mm-mprotect-move-softleaf-code-out-of-the-main-function
+++ a/mm/mprotect.c
@@ -211,6 +211,72 @@ static void set_write_prot_commit_flush_
 	commit_anon_folio_batch(vma, folio, page, addr, ptep, oldpte, ptent, nr_ptes, tlb);
 }
 
+static long change_softleaf_pte(struct vm_area_struct *vma,
+	unsigned long addr, pte_t *pte, pte_t oldpte, unsigned long cp_flags)
+{
+	const bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
+	const bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
+	softleaf_t entry = softleaf_from_pte(oldpte);
+	pte_t newpte;
+
+	if (softleaf_is_migration_write(entry)) {
+		const struct folio *folio = softleaf_to_folio(entry);
+
+		/*
+		 * A protection check is difficult so
+		 * just be safe and disable write
+		 */
+		if (folio_test_anon(folio))
+			entry = make_readable_exclusive_migration_entry(swp_offset(entry));
+		else
+			entry = make_readable_migration_entry(swp_offset(entry));
+		newpte = swp_entry_to_pte(entry);
+		if (pte_swp_soft_dirty(oldpte))
+			newpte = pte_swp_mksoft_dirty(newpte);
+	} else if (softleaf_is_device_private_write(entry)) {
+		/*
+		 * We do not preserve soft-dirtiness. See
+		 * copy_nonpresent_pte() for explanation.
+		 */
+		entry = make_readable_device_private_entry(swp_offset(entry));
+		newpte = swp_entry_to_pte(entry);
+		if (pte_swp_uffd_wp(oldpte))
+			newpte = pte_swp_mkuffd_wp(newpte);
+	} else if (softleaf_is_marker(entry)) {
+		/*
+		 * Ignore error swap entries unconditionally,
+		 * because any access should sigbus/sigsegv
+		 * anyway.
+		 */
+		if (softleaf_is_poison_marker(entry) ||
+		    softleaf_is_guard_marker(entry))
+			return 0;
+		/*
+		 * If this is uffd-wp pte marker and we'd like
+		 * to unprotect it, drop it; the next page
+		 * fault will trigger without uffd trapping.
+		 */
+		if (uffd_wp_resolve) {
+			pte_clear(vma->vm_mm, addr, pte);
+			return 1;
+		}
+		return 0;
+	} else {
+		newpte = oldpte;
+	}
+
+	if (uffd_wp)
+		newpte = pte_swp_mkuffd_wp(newpte);
+	else if (uffd_wp_resolve)
+		newpte = pte_swp_clear_uffd_wp(newpte);
+
+	if (!pte_same(oldpte, newpte)) {
+		set_pte_at(vma->vm_mm, addr, pte, newpte);
+		return 1;
+	}
+	return 0;
+}
+
 static long change_pte_range(struct mmu_gather *tlb,
 		struct vm_area_struct *vma, pmd_t *pmd, unsigned long addr,
 		unsigned long end, pgprot_t newprot, unsigned long cp_flags)
@@ -317,66 +383,7 @@ static long change_pte_range(struct mmu_
 				pages++;
 			}
 		} else  {
-			softleaf_t entry = softleaf_from_pte(oldpte);
-			pte_t newpte;
-
-			if (softleaf_is_migration_write(entry)) {
-				const struct folio *folio = softleaf_to_folio(entry);
-
-				/*
-				 * A protection check is difficult so
-				 * just be safe and disable write
-				 */
-				if (folio_test_anon(folio))
-					entry = make_readable_exclusive_migration_entry(
-							     swp_offset(entry));
-				else
-					entry = make_readable_migration_entry(swp_offset(entry));
-				newpte = swp_entry_to_pte(entry);
-				if (pte_swp_soft_dirty(oldpte))
-					newpte = pte_swp_mksoft_dirty(newpte);
-			} else if (softleaf_is_device_private_write(entry)) {
-				/*
-				 * We do not preserve soft-dirtiness. See
-				 * copy_nonpresent_pte() for explanation.
-				 */
-				entry = make_readable_device_private_entry(
-							swp_offset(entry));
-				newpte = swp_entry_to_pte(entry);
-				if (pte_swp_uffd_wp(oldpte))
-					newpte = pte_swp_mkuffd_wp(newpte);
-			} else if (softleaf_is_marker(entry)) {
-				/*
-				 * Ignore error swap entries unconditionally,
-				 * because any access should sigbus/sigsegv
-				 * anyway.
-				 */
-				if (softleaf_is_poison_marker(entry) ||
-				    softleaf_is_guard_marker(entry))
-					continue;
-				/*
-				 * If this is uffd-wp pte marker and we'd like
-				 * to unprotect it, drop it; the next page
-				 * fault will trigger without uffd trapping.
-				 */
-				if (uffd_wp_resolve) {
-					pte_clear(vma->vm_mm, addr, pte);
-					pages++;
-				}
-				continue;
-			} else {
-				newpte = oldpte;
-			}
-
-			if (uffd_wp)
-				newpte = pte_swp_mkuffd_wp(newpte);
-			else if (uffd_wp_resolve)
-				newpte = pte_swp_clear_uffd_wp(newpte);
-
-			if (!pte_same(oldpte, newpte)) {
-				set_pte_at(vma->vm_mm, addr, pte, newpte);
-				pages++;
-			}
+			pages += change_softleaf_pte(vma, addr, pte, oldpte, cp_flags);
 		}
 	} while (pte += nr_ptes, addr += nr_ptes * PAGE_SIZE, addr != end);
 	lazy_mmu_mode_disable();
_

Patches currently in -mm which might be from pfalcato@suse.de are


