Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55653481A3
	for <mm-commits@vger.kernel.org>; Sun, 23 Feb 2025 03:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740280383; cv=none; b=KZUQiZph1zocOnfMQkKSS23QZPLDm+AoQgVO0Uh+xLEvUOsh+ncANFsiJLX+6Q2hKM4YFVNOfbY+nUQEl+PNekl/eBpeNZ3Dnsf9GaFzG1h32Wg1z5y545pAuXHiMXipH2NhYDZ1bNHL8d9d8ABayLuzBa1g2H2lsKd4tFRTScw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740280383; c=relaxed/simple;
	bh=THKj4yEzNaPlSPAjndzSft40VYxePm7vBh1NkTv/oVA=;
	h=Date:To:From:Subject:Message-Id; b=oE0ubJNqHv4k0dPpMtx37KSCk0Qj2CfubHS3+4myPaFUFEp/OynXefMWYBARGZJN2V4EyFmXY9kQARNXb3gKqLxs6VYHrGKFquofS5T6AGYJBkEQppQLTmKBWrv9S8uIKwAvRMgl/l2fOttBR4dPyh81hDLdgznq++URX/3HrK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z0rUmgmx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z0rUmgmx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF82C4CEE4;
	Sun, 23 Feb 2025 03:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740280382;
	bh=THKj4yEzNaPlSPAjndzSft40VYxePm7vBh1NkTv/oVA=;
	h=Date:To:From:Subject:From;
	b=z0rUmgmxF/6Zr7vYSQ8Bmwzs8gdkIOGl+NQq3b50EGDezfPKoZHFc74xiLeJNo0J+
	 b4RQyzt/97T2kIFe7Z3x7oatdLPbQHLZuukAvaSZeqkOOaLgtRx652wcCuPN4fosO1
	 i/J7oVyqtHeWH/wsGVqzeqGywboUC692lG2cXt5o=
Date: Sat, 22 Feb 2025 19:13:02 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,paulmck@kernel.org,liam.howlett@oracle.com,kaleshsingh@google.com,jannh@google.com,david@redhat.com,corbet@lwn.net,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-task_mmu-add-guard-region-bit-to-pagemap.patch added to mm-unstable branch
Message-Id: <20250223031302.AEF82C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc/task_mmu: add guard region bit to pagemap
has been added to the -mm mm-unstable branch.  Its filename is
     fs-proc-task_mmu-add-guard-region-bit-to-pagemap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-task_mmu-add-guard-region-bit-to-pagemap.patch

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
Subject: fs/proc/task_mmu: add guard region bit to pagemap
Date: Fri, 21 Feb 2025 12:05:22 +0000

Patch series "fs/proc/task_mmu: add guard region bit to pagemap".

Currently there is no means of determining whether a given page in a
mapping range is designated a guard region (as installed via madvise()
using the MADV_GUARD_INSTALL flag).

This is generally not an issue, but in some instances users may wish to
determine whether this is the case.

This series adds this ability via /proc/$pid/pagemap, updates the
documentation and adds a self test to assert that this functions
correctly.


This patch (of 2):

Currently there is no means by which users can determine whether a given
page in memory is in fact a guard region, that is having had the
MADV_GUARD_INSTALL madvise() flag applied to it.

This is intentional, as to provide this information in VMA metadata would
contradict the intent of the feature (providing a means to change fault
behaviour at a page table level rather than a VMA level), and would
require VMA metadata operations to scan page tables, which is
unacceptable.

In many cases, users have no need to reflect and determine what regions
have been designated guard regions, as it is the user who has established
them in the first place.

But in some instances, such as monitoring software, or software that
relies upon being able to ascertain the nature of mappings within a remote
process for instance, it becomes useful to be able to determine which
pages have the guard region marker applied.

This patch makes use of an unused pagemap bit (58) to provide this
information.

This patch updates the documentation at the same time as making the change
such that the implementation of the feature and the documentation of it
are tied together.

Link: https://lkml.kernel.org/r/cover.1740139449.git.lorenzo.stoakes@oracle.com
Link: https://lkml.kernel.org/r/521d99c08b975fb06a1e7201e971cc24d68196d1.1740139449.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Shuah Khan (Samsung OSG) <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/pagemap.rst |    3 ++-
 fs/proc/task_mmu.c                       |    6 +++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/mm/pagemap.rst~fs-proc-task_mmu-add-guard-region-bit-to-pagemap
+++ a/Documentation/admin-guide/mm/pagemap.rst
@@ -21,7 +21,8 @@ There are four components to pagemap:
     * Bit  56    page exclusively mapped (since 4.2)
     * Bit  57    pte is uffd-wp write-protected (since 5.13) (see
       Documentation/admin-guide/mm/userfaultfd.rst)
-    * Bits 58-60 zero
+    * Bit  58    pte is a guard region (since 6.15) (see madvise (2) man page)
+    * Bits 59-60 zero
     * Bit  61    page is file-page or shared-anon (since 3.5)
     * Bit  62    page swapped
     * Bit  63    page present
--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-add-guard-region-bit-to-pagemap
+++ a/fs/proc/task_mmu.c
@@ -1632,6 +1632,7 @@ struct pagemapread {
 #define PM_SOFT_DIRTY		BIT_ULL(55)
 #define PM_MMAP_EXCLUSIVE	BIT_ULL(56)
 #define PM_UFFD_WP		BIT_ULL(57)
+#define PM_GUARD_REGION		BIT_ULL(58)
 #define PM_FILE			BIT_ULL(61)
 #define PM_SWAP			BIT_ULL(62)
 #define PM_PRESENT		BIT_ULL(63)
@@ -1732,6 +1733,8 @@ static pagemap_entry_t pte_to_pagemap_en
 			page = pfn_swap_entry_to_page(entry);
 		if (pte_marker_entry_uffd_wp(entry))
 			flags |= PM_UFFD_WP;
+		if (is_guard_swp_entry(entry))
+			flags |=  PM_GUARD_REGION;
 	}
 
 	if (page) {
@@ -1931,7 +1934,8 @@ static const struct mm_walk_ops pagemap_
  * Bit  55    pte is soft-dirty (see Documentation/admin-guide/mm/soft-dirty.rst)
  * Bit  56    page exclusively mapped
  * Bit  57    pte is uffd-wp write-protected
- * Bits 58-60 zero
+ * Bit  58    pte is a guard region
+ * Bits 59-60 zero
  * Bit  61    page is file-page or shared-anon
  * Bit  62    page swapped
  * Bit  63    page present
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-abort-vma_modify-on-merge-out-of-memory-failure.patch
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
fs-proc-task_mmu-add-guard-region-bit-to-pagemap.patch
tools-selftests-add-guard-region-test-for-proc-pid-pagemap.patch
tools-selftests-add-guard-region-test-for-proc-pid-pagemap-fix.patch

