Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561EE1714B7
	for <mm-commits@vger.kernel.org>; Thu, 13 Feb 2025 21:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739483245; cv=none; b=Ra9hFlxzSfjPWcIGpSEhDWPv3O2T0pAMmJIE2rkw6RhuUzZxRvmqsjjwsvOudpKaom8PxtJX8UFBn/ERT5vpqLV4JtCJ4+bmImr3UFGcuO1DDbt8oNNCfjJ5/wV5xYjLSZXcuKW1pbfLJuj7YchWL96KTjx0QCf4dYRaU1GIcYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739483245; c=relaxed/simple;
	bh=iVIKdnlaKjbtEs4Xg/CX79c6KlvNE4551hE92rAM+7M=;
	h=Date:To:From:Subject:Message-Id; b=RrZrVYxAhae4NtoR9J0Bl8OoRnjDBLo5YU44ib1DdOO+4gTkNjissW10slO0kr5OZmTDZNWRwVpvwd57d3wf1ecf1R5jcykldQONJoRRqLXOz+rLSxa46JwuNyYbTnwkb7bngBR3ixSCaPRng7GO0TD5ZjPfEM6rVwqj/Ek6+J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cJMIYKvW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cJMIYKvW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B020EC4CED1;
	Thu, 13 Feb 2025 21:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739483244;
	bh=iVIKdnlaKjbtEs4Xg/CX79c6KlvNE4551hE92rAM+7M=;
	h=Date:To:From:Subject:From;
	b=cJMIYKvW+/tcYZswPAhlNiy+3Gm3RthMJ9xkPcR+R1OBrvlHvVpqyS+aZDFJHvyyp
	 YnKagPsDZjZHft3PeifD6Ac5FNUxyOk4h9Z8I1K3svFsxev9Tr1+Nnw3o14UU02E9X
	 VfEuADeY5bUVSt1Gl3/6+ifdDOAON0W5Q01SwshI=
Date: Thu, 13 Feb 2025 13:47:24 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,paulmck@kernel.org,liam.howlett@oracle.com,kaleshsingh@google.com,jhubbard@nvidia.com,jannh@google.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-allow-guard-regions-in-file-backed-and-read-only-mappings.patch added to mm-unstable branch
Message-Id: <20250213214724.B020EC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: allow guard regions in file-backed and read-only mappings
has been added to the -mm mm-unstable branch.  Its filename is
     mm-allow-guard-regions-in-file-backed-and-read-only-mappings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-allow-guard-regions-in-file-backed-and-read-only-mappings.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: allow guard regions in file-backed and read-only mappings
Date: Thu, 13 Feb 2025 18:17:00 +0000

Patch series "mm: permit guard regions for file-backed/shmem mappings".

The guard regions feature was initially implemented to support anonymous
mappings only, excluding shmem.

This was done so as to introduce the feature carefully and incrementally
and to be conservative when considering the various caveats and corner
cases that are applicable to file-backed mappings but not to anonymous
ones.

Now this feature has landed in 6.13, it is time to revisit this and to
extend this functionality to file-backed and shmem mappings.

In order to make this maximally useful, and since one may map file-backed
mappings read-only (for instance ELF images), we also remove the
restriction on read-only mappings and permit the establishment of guard
regions in any non-hugetlb, non-mlock()'d mapping.

It is permissible to permit the establishment of guard regions in
read-only mappings because the guard regions only reduce access to the
mapping, and when removed simply reinstate the existing attributes of the
underlying VMA, meaning no access violations can occur.

While the change in kernel code introduced in this series is small, the
majority of the effort here is spent in extending the testing to assert
that the feature works correctly across numerous file-backed mapping
scenarios.

Every single guard region self-test performed against anonymous memory
(which is relevant and not anon-only) has now been updated to also be
performed against shmem and a mapping of a file in the working directory.

This confirms that all cases also function correctly for file-backed guard
regions.

In addition a number of other tests are added for specific file-backed
mapping scenarios.

There are a number of other concerns that one might have with regard to
guard regions, addressed below:

Readahead
~~~~~~~~~

Readahead is a process through which the page cache is populated on the
assumption that sequential reads will occur, thus amortising I/O and,
through a clever use of the PG_readahead folio flag establishing during
major fault and checked upon minor fault, provides for asynchronous I/O to
occur as dat is processed, reducing I/O stalls as data is faulted in.

Guard regions do not alter this mechanism which operates at the folio and
fault level, but does of course prevent the faulting of folios that would
otherwise be mapped.

In the instance of a major fault prior to a guard region, synchronous
readahead will occur including populating folios in the page cache which
the guard regions will, in the case of the mapping in question, prevent
access to.

In addition, if PG_readahead is placed in a folio that is now
inaccessible, this will prevent asynchronous readahead from occurring as
it would otherwise do.

However, there are mechanisms for heuristically resetting this within
readahead regardless, which will 'recover' correct readahead behaviour.

Readahead presumes sequential data access, the presence of a guard region
clearly indicates that, at least in the guard region, no such sequential
access will occur, as it cannot occur there.

So this should have very little impact on any real workload.  The far more
important point is as to whether readahead causes incorrect or
inappropriate mapping of ranges disallowed by the presence of guard
regions - this is not the case, as readahead does not 'pre-fault' memory
in this fashion.

At any rate, any mechanism which would attempt to do so would hit the
usual page fault paths, which correctly handle PTE markers as with
anonymous mappings.

Fault-Around
~~~~~~~~~~~~

The fault-around logic, in a similar vein to readahead, attempts to
improve efficiency with regard to file-backed memory mappings, however it
differs in that it does not try to fetch folios into the page cache that
are about to be accessed, but rather pre-maps a range of folios around the
faulting address.

Guard regions making use of PTE markers makes this relatively trivial, as
this case is already handled - see filemap_map_folio_range() and
filemap_map_order0_folio() - in both instances, the solution is to simply
keep the established page table mappings and let the fault handler take
care of PTE markers, as per the comment:

	/*
	 * NOTE: If there're PTE markers, we'll leave them to be
	 * handled in the specific fault path, and it'll prohibit
	 * the fault-around logic.
	 */

This works, as establishing guard regions results in page table mappings
with PTE markers, and clearing them removes them.

Truncation
~~~~~~~~~~

File truncation will not eliminate existing guard regions, as the
truncation operation will ultimately zap the range via
unmap_mapping_range(), which specifically excludes PTE markers.

Zapping
~~~~~~~

Zapping is, as with anonymous mappings, handled by zap_nonpresent_ptes(),
which specifically deals with guard entries, leaving them intact except in
instances such as process teardown or munmap() where they need to be
removed.

Reclaim
~~~~~~~

When reclaim is performed on file-backed folios, it ultimately invokes
try_to_unmap_one() via the rmap.  If the folio is non-large, then
map_pte() will ultimately abort the operation for the guard region
mapping.  If large, then check_pte() will determine that this is a
non-device private entry/device-exclusive entry 'swap' PTE and thus abort
the operation in that instance.

Therefore, no odd things happen in the instance of reclaim being attempted
upon a file-backed guard region.

Hole Punching
~~~~~~~~~~~~~

This updates the page cache and ultimately invokes unmap_mapping_range(),
which explicitly leaves PTE markers in place.

Because the establishment of guard regions zapped any existing mappings to
file-backed folios, once the guard regions are removed then the
hole-punched region will be faulted in as usual and everything will behave
as expected.


This patch (of 4):

There is no reason to disallow guard regions in file-backed mappings -
readahead and fault-around both function correctly in the presence of PTE
markers, equally other operations relating to memory-mapped files function
correctly.

Additionally, read-only mappings if introducing guard-regions, only
restrict the mapping further, which means there is no violation of any
access rights by permitting this to be so.

Removing this restriction allows for read-only mapped files (such as
executable files) correctly which would otherwise not be permitted.

Link: https://lkml.kernel.org/r/cover.1739469950.git.lorenzo.stoakes@oracle.com
Link: https://lkml.kernel.org/r/d885cb259174736c2830a5dfe07f81b214ef3faa.1739469950.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Shuah Khan (Samsung OSG) <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/mm/madvise.c~mm-allow-guard-regions-in-file-backed-and-read-only-mappings
+++ a/mm/madvise.c
@@ -1051,13 +1051,7 @@ static bool is_valid_guard_vma(struct vm
 	if (!allow_locked)
 		disallowed |= VM_LOCKED;
 
-	if (!vma_is_anonymous(vma))
-		return false;
-
-	if ((vma->vm_flags & (VM_MAYWRITE | disallowed)) != VM_MAYWRITE)
-		return false;
-
-	return true;
+	return !(vma->vm_flags & disallowed);
 }
 
 static bool is_guard_pte_marker(pte_t ptent)
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-simplify-vma-merge-structure-and-expand-comments.patch
mm-further-refactor-commit_merge.patch
mm-eliminate-adj_start-parameter-from-commit_merge.patch
mm-make-vmg-target-consistent-and-further-simplify-commit_merge.patch
mm-completely-abstract-unnecessary-adj_start-calculation.patch
mm-madvise-split-out-mmap-locking-operations-for-madvise-fix.patch
mm-use-read-write_once-for-vma-vm_flags-on-migrate-mprotect.patch
mm-refactor-rmap_walk_file-to-separate-out-traversal-logic.patch
mm-provide-mapping_wrprotect_range-function.patch
fb_defio-do-not-use-deprecated-page-mapping-index-fields.patch
fb_defio-do-not-use-deprecated-page-mapping-index-fields-fix.patch
mm-allow-guard-regions-in-file-backed-and-read-only-mappings.patch
selftests-mm-rename-guard-pages-to-guard-regions.patch
tools-selftests-expand-all-guard-region-tests-to-file-backed.patch
tools-selftests-add-file-shmem-backed-mapping-guard-region-tests.patch

