Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199741624C0
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 16:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774369392; cv=none; b=TkjCv0aLZiG7wyw6xgafEPzCLlwJSfJN2SgL0NZISINfPLfW15dcdybzUW8AN+LK1JkdauuUFub3EFxRE31ZDArPOV0ejNXQ+s0hyECM7bfoo6E9u1QhzLC3OVL6RUlBnG4MvX0JMWjakuniXIEwZJywaXvdjROngzOEzLc1YQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774369392; c=relaxed/simple;
	bh=PYy6DO20MGYVR72MJCkYowit598U99F0WjqsF12LiZs=;
	h=Date:To:From:Subject:Message-Id; b=l5Isp3r2QGZnEO3MR2J3Jz0OGmRXUX2WQ+LPP9YRq38RAI9UbFZmy+rg/XuqnSfYINF1BwnZSNKddMe3zdKzQgSOzbn8po4eRpBMd3QXs6o1PxpPn4Bi97axwPMaKXEAl/qtO+yoElK4eYariSjDhCH9TbNqRoj0mlt5vwDZn84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RFzW9rXY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RFzW9rXY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76E06C19424;
	Tue, 24 Mar 2026 16:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774369391;
	bh=PYy6DO20MGYVR72MJCkYowit598U99F0WjqsF12LiZs=;
	h=Date:To:From:Subject:From;
	b=RFzW9rXYh9+8DGIJiJZwfralfVV+PSgotWjy0gDwq7xpIPEJ9dEmgSsNnx/P6S+sv
	 jv6Z2fPWp3QM0MBbx9bTxJPdDHsIxjA21lL6V6MI16lum3SYs/H732D8u+OhtdLONL
	 oSCl17asjAJmjjlam2qMkVair6CJrLJ7MbqzMvEg=
Date: Tue, 24 Mar 2026 09:23:10 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,ljs@kernel.org,liam.howlett@oracle.com,jhladky@redhat.com,jannh@google.com,dev.jain@arm.com,david@kernel.org,pfalcato@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mprotect-move-softleaf-code-out-of-the-main-function.patch added to mm-new branch
Message-Id: <20260324162311.76E06C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mprotect: move softleaf code out of the main function
has been added to the -mm mm-new branch.  Its filename is
     mm-mprotect-move-softleaf-code-out-of-the-main-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mprotect-move-softleaf-code-out-of-the-main-function.patch

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
From: Pedro Falcato <pfalcato@suse.de>
Subject: mm/mprotect: move softleaf code out of the main function
Date: Tue, 24 Mar 2026 15:43:41 +0000

Patch series "mm/mprotect: micro-optimization work", v2.

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

The micro-benchmark used for the tests was [0] (usable using google/benchmark
and g++ -O2 -lbenchmark repro.cpp)

This resulted in the following (first entry is baseline):

---------------------------------------------------------
Benchmark               Time             CPU   Iterations
---------------------------------------------------------
mprotect_bench      85967 ns        85967 ns         6935
mprotect_bench      73374 ns        73373 ns         9602


After the patchset we can observe a 14% speedup in mprotect.  Wonderful
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


This patch (of 2):

Move softleaf change_pte_range code into a separate function.  This makes
the change_pte_range() function a good bit smaller, and lessens cognitive
load when reading through the function.

Link: https://lkml.kernel.org/r/20260324154342.156640-1-pfalcato@suse.de
Link: https://lkml.kernel.org/r/20260324154342.156640-2-pfalcato@suse.de
Link: https://lore.kernel.org/all/aY8-XuFZ7zCvXulB@luyang-thinkpadp1gen7.toromso.csb/
Link: https://gist.github.com/heatd/1450d273005aba91fa5744f44dfcd933 [0]
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jiri Hladky <jhladky@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |  129 +++++++++++++++++++++++++-----------------------
 1 file changed, 69 insertions(+), 60 deletions(-)

--- a/mm/mprotect.c~mm-mprotect-move-softleaf-code-out-of-the-main-function
+++ a/mm/mprotect.c
@@ -211,6 +211,74 @@ static void set_write_prot_commit_flush_
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
+			entry = make_readable_exclusive_migration_entry(
+					     swp_offset(entry));
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
+		entry = make_readable_device_private_entry(
+					swp_offset(entry));
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
@@ -317,66 +385,7 @@ static long change_pte_range(struct mmu_
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

mm-mprotect-move-softleaf-code-out-of-the-main-function.patch
mm-mprotect-special-case-small-folios-when-applying-write-permissions.patch

