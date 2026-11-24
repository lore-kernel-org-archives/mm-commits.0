Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795559246;
	b=vo7cRCiOYFC/aq2qaltHe04tuyoJjwjMeZ661GTk07baZtSZeiZ2QbE69mBRedXPoW7U
	 t8OWfdg3r3gCxHhDY0dC5s0j92NFadUk0uIKxuHCXEuXOJ19lF9ssSPEVWfaQxcFEnGfc
	 imKEoqWGtLNBwo5fREwMMuoTmHRQH+DThxGMmz9rg0twoS2wpQipHa7EdudRnr9sHC1Ii
	 NxFyYIRhqB83Y9QPEZeub3wQGmWKGt3g69FijBNBUTeTyxtPCZDn3RZNppRhvOigiP7Af
	 bCejDrlEL1twFxAmGN5yZ1/FLJ+ov347OR4oGL54GqLTiRJRGILiW/tbU6IVERwPB8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795559246;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=Dr5ubJWB0hJe+ALyJFqd9IbMpA/4SYmejGZ7ZlRj8vM=;
	b=mlThkxAkjSPZkSmZNIQo8MqG014alqkSTtaB8sl82gK77vyDH98c8OmXP2mUzSRY4Ajp
	 lNlTQpvheZ+sbhmWlWDbn9i8mxbspibeKK4fYsITcr56zffvqicq9l29XbN+sFpLAUfZ4
	 s7ILR0xIGhjm0pFQV6eV/V0EI8wFiFqzbbOp6YOa5mkq4C+QjCWzAmLL5DBqk1jOn+kUz
	 HL6rxVtNvJkHLbRb2C4dysNDWg2Gj3pc0f158mT4MrME26Vqpx77bkbZiU/XwpOOTuzt3
	 NL6RLsu3kqshDdJ5DyBeCDnNPN2MTRiD/v1hLOGO4u+rmzdHv4BZ25lpVsWuLQdly/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=qDsJBnkD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C898606A31E;
	Tue, 24 Nov 2026 22:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=qDsJBnkD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D3251F000D3;
	Tue, 24 Nov 2026 22:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795559245;
	bh=Dr5ubJWB0hJe+ALyJFqd9IbMpA/4SYmejGZ7ZlRj8vM=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=qDsJBnkDDrs9M1BTQyTsqyDmw4Z/x/qDQMbq1+MI3WiFY+3MoO8uXe9p1WDQPDZlL
	 JDBCSxl05cwd6FAHk2dkVSKeAAPQaXB7PYUxusYaOkkg+EwcdFN6pOUWnFSIFMf44F
	 iLejzFBIPqBzOawiOMV4a+yvd6+Ox/83hoPlP6kA=
Date: Tue, 24 Nov 2026 14:27:24 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,
	vbabka@kernel.org,usama.arif@linux.dev,usama.anjum@arm.com,surenb@google.com,
	stable@vger.kernel.org,sfr@canb.auug.org.au,ryan.roberts@arm.com,
	rppt@kernel.org,pfalcato@suse.de,peterx@redhat.com,osalvador@suse.de,
	nico.pache@linux.dev,muchun.song@linux.dev,mirq-linux@rere.qmqm.pl,
	miko.lenczewski@arm.com,mhocko@suse.com,matthew.brost@intel.com,
	ljs@kernel.org,liam@infradead.org,leitao@debian.org,lance.yang@linux.dev,
	kas@kernel.org,jthoughton@google.com,joshua.hahnjy@gmail.com,
	jannh@google.com,gourry@gourry.net,dev.jain@arm.com,david@kernel.org,
	byungchul@sk.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,
	balbirs@nvidia.com,avagin@gmail.com,arnd@arndb.de,apopple@nvidia.com,
	aarcange@redhat.com,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261117-uffd-state-fixes-v3-1-b617009d1a4a@columbia.edu>
References: <20261117-uffd-state-fixes-v3-1-b617009d1a4a@columbia.edu>
Subject: + userfaultfd-use-anonymous-memory-for-uffdio_zeropage-on-private-file-mappings.patch added to mm-new branch
Message-Id: <20261124222725.1D3251F000D3@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: userfaultfd: use anonymous memory for UFFDIO_ZEROPAGE on private file mappings
has been added to the -mm mm-new branch.  Its filename is
     userfaultfd-use-anonymous-memory-for-uffdio_zeropage-on-private-file-mappings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-use-anonymous-memory-for-uffdio_zeropage-on-private-file-mappings.patch

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
From: Tal Zussman <tz2294@columbia.edu>
Subject: userfaultfd: use anonymous memory for UFFDIO_ZEROPAGE on private file mappings
Date: Tue, 17 Nov 2026 23:28:41 -0500

Patch series "userfaultfd: assorted fixes (part 1)", v3.

This is a first batch of userfaultfd fixes, with more to come.

These were found by a mix of regular old LLM review and by having an LLM
write a TLA+ model of uffd interactions with PTE bits and other state and
seeing what issues fell out.

Most of these fix places where mm code loses uffd-wp or RWP protection
while moving or migrating an entry. Userspace then either misses writes
and accesses, or gets pages reported that nobody touched.
There is also a hang in UFFDIO_MOVE, and UFFDIO_ZEROPAGE modifying a
file through a private mapping.

A few of the fixes change what userspace sees:

 - UFFDIO_ZEROPAGE on a private file mapping no longer fails with
   -EEXIST where the file already has a page, on an mm that cannot use
   the zero page (patch 1)
 - UFFDIO_MOVE returns -EEXIST for any huge destination PMD, not only
   for a present THP (patch 2)
 - UFFDIO_UNREGISTER with a misaligned hugetlb end fails before
   unregistering anything, also if that hugetlb VMA is not registered
   (patch 9)
 - UFFDIO_REGISTER and UFFDIO_UNREGISTER accept a misaligned start that
   lies in a gap before the first hugetlb VMA of the range (patch 9)
 - UFFDIO_REGISTER returns -EINVAL rather than -EPERM for a misaligned
   end in a hugetlb VMA without VM_MAYWRITE (patch 9)


This patch (of 7):

If the mm cannot map the shared zero page, UFFDIO_ZEROPAGE falls back to
mfill_atomic_pte_zeroed_folio(), which allocates a zeroed folio and
installs it through vma_uffd_ops(), no matter what kind of mapping it
is. An s390 KVM guest with storage keys or protected virtualization is
such an mm.

For a MAP_PRIVATE shmem mapping, that adds the zeroed folio to the page
cache of the file. That is wrong: a private mapping must never modify
the file it maps, and the file might even be mapped from a read-only fd.

The ioctl can also fail where it should succeed. A missing fault is only
delivered for a hole in the file, but UFFDIO_ZEROPAGE can be called on
an address that did not fault, or can race with a write to the file. If
the file has a page at that offset by then, inserting the zeroed folio
fails and the ioctl returns -EEXIST although nothing is mapped at the
destination address.

What we want is what UFFDIO_ZEROPAGE does on a private mapping when the
shared zero page can be used, and what UFFDIO_COPY does: only check that
nothing is mapped at the destination address, map zeroed memory there,
and leave the page cache alone. The zeroed folio path did that before it
was moved to vm_uffd_ops.

To fix it, pick the ops in the common folio path, as
mfill_atomic_pte_copy() did for UFFDIO_COPY: anon_uffd_ops for a private
mapping, the ops of the VMA otherwise. That makes
mfill_atomic_pte_copy() and mfill_atomic_pte_zeroed_folio() redundant,
so remove them and rename __mfill_atomic_pte() to
mfill_atomic_pte_folio().

While at it, use vma_is_cow_mapping() to check for a private mapping.

UFFDIO_ZEROPAGE no longer modifies the file, and only fails with -EEXIST
if something is already mapped at the destination address.

Link: https://lore.kernel.org/20261117-uffd-state-fixes-v3-0-b617009d1a4a@columbia.edu
Link: https://patch.msgid.link/20261117-uffd-state-fixes-v3-1-b617009d1a4a@columbia.edu
Fixes: f74991b4e383 ("shmem, userfaultfd: implement shmem uffd operations using vm_uffd_ops")
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Mikołaj Lenczewski <miko.lenczewski@arm.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: <stable@vger.kernel.org>

 mm/userfaultfd.c |   46 +++++++++++++++------------------------------
 1 file changed, 16 insertions(+), 30 deletions(-)

--- a/mm/userfaultfd.c~userfaultfd-use-anonymous-memory-for-uffdio_zeropage-on-private-file-mappings
+++ a/mm/userfaultfd.c
@@ -535,15 +535,27 @@ static int mfill_copy_folio_retry(struct
 	return 0;
 }
 
-static int __mfill_atomic_pte(struct mfill_state *state,
-			      const struct vm_uffd_ops *ops)
+static int mfill_atomic_pte_folio(struct mfill_state *state)
 {
+	const struct vm_uffd_ops *ops = vma_uffd_ops(state->vma);
 	unsigned long dst_addr = state->dst_addr;
 	unsigned long src_addr = state->src_addr;
 	uffd_flags_t flags = state->flags;
 	struct folio *folio;
 	int ret;
 
+	/*
+	 * The normal page fault path for a MAP_PRIVATE mapping in a
+	 * file-backed VMA will invoke the fault, fill the hole in the file and
+	 * COW it right away. The result generates plain anonymous memory.
+	 * So when we are asked to fill a hole in a MAP_PRIVATE mapping, we'll
+	 * generate anonymous memory directly without actually filling the
+	 * hole. For the MAP_PRIVATE case the robustness check only happens in
+	 * the pagetable (to verify it's still none) and not in the page cache.
+	 */
+	if (vma_is_cow_mapping(state->vma))
+		ops = &anon_uffd_ops;
+
 	if (!ops) {
 		VM_WARN_ONCE(1, "UFFDIO_COPY for unsupported VMA");
 		return -EOPNOTSUPP;
@@ -601,32 +613,6 @@ err_folio_put:
 	return ret;
 }
 
-static int mfill_atomic_pte_copy(struct mfill_state *state)
-{
-	const struct vm_uffd_ops *ops = vma_uffd_ops(state->vma);
-
-	/*
-	 * The normal page fault path for a MAP_PRIVATE mapping in a
-	 * file-backed VMA will invoke the fault, fill the hole in the file and
-	 * COW it right away. The result generates plain anonymous memory.
-	 * So when we are asked to fill a hole in a MAP_PRIVATE mapping, we'll
-	 * generate anonymous memory directly without actually filling the
-	 * hole. For the MAP_PRIVATE case the robustness check only happens in
-	 * the pagetable (to verify it's still none) and not in the page cache.
-	 */
-	if (!(state->vma->vm_flags & VM_SHARED))
-		ops = &anon_uffd_ops;
-
-	return __mfill_atomic_pte(state, ops);
-}
-
-static int mfill_atomic_pte_zeroed_folio(struct mfill_state *state)
-{
-	const struct vm_uffd_ops *ops = vma_uffd_ops(state->vma);
-
-	return __mfill_atomic_pte(state, ops);
-}
-
 static int mfill_atomic_pte_zeropage(struct mfill_state *state)
 {
 	struct vm_area_struct *dst_vma = state->vma;
@@ -638,7 +624,7 @@ static int mfill_atomic_pte_zeropage(str
 
 	if (mm_forbids_zeropage(dst_vma->vm_mm) ||
 	    (dst_vma->vm_flags & VM_SHARED))
-		return mfill_atomic_pte_zeroed_folio(state);
+		return mfill_atomic_pte_folio(state);
 
 	_dst_pte = pte_mkspecial(pfn_pte(zero_pfn(dst_addr),
 					 dst_vma->vm_page_prot));
@@ -931,7 +917,7 @@ static __always_inline ssize_t mfill_ato
 	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_POISON))
 		return mfill_atomic_pte_poison(state);
 	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_COPY))
-		return mfill_atomic_pte_copy(state);
+		return mfill_atomic_pte_folio(state);
 	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_ZEROPAGE))
 		return mfill_atomic_pte_zeropage(state);
 
_

Patches currently in -mm which might be from tz2294@columbia.edu are

mm-memcontrol-remove-mod_memcg_page_state.patch
mm-memcontrol-remove-page_memcg_check.patch
mm-userfaultfd-store-the-childs-new-uffd-context-in-the-wait-queue-entry.patch
userfaultfd-use-anonymous-memory-for-uffdio_zeropage-on-private-file-mappings.patch
userfaultfd-refuse-uffdio_move-into-a-non-present-huge-destination-pmd.patch
fs-proc-task_mmu-downgrade-writable-migration-entries-in-pagemap_scan-write-protect.patch
fs-proc-task_mmu-write-protect-device-private-thps-in-pagemap_scan.patch
mm-huge_memory-build-the-moved-huge-zero-pmd-from-the-destination-vma.patch
mm-mremap-resolve-uffd-state-when-the-context-is-dropped-not-during-the-move.patch
mm-userfaultfd-check-the-hugetlb-alignment-of-every-vma-in-the-pre-scan.patch

