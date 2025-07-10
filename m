Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828EF2905
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126190; cv=none; b=WI4DhwnF9BYhLaJUDzxNhSBRjLZQDdSvPJGA3lPnHIJ8laSNQFyDmKZex4KI0OZGghD1EF313jIvOexAje4EP15VzpNpDiSIctX2RYK5WG9WrDhrurAg0jjj9o8V/FKrvs8spSt9LSLy7H1K7OJiTpSljKX07NO9MMTtgN8EadA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126190; c=relaxed/simple;
	bh=eQji4vW2lNikCGG4dz4I4E+FEJMSHJt4LUy0f7BMT24=;
	h=Date:To:From:Subject:Message-Id; b=b4KJ7LfNsqTRH28T+I5yBISZWzz/FHkORNdrG3FoqbUkviWpMC+0bsSw7zFvE3Yi0FHOzfcVHzYEPZayRGXt/wIurUK6XNKrsn+/zvM7GHpZ74AwJjmbleoAsZJkUwwZbLTMPZNuWY3Z+l7nL1+s+u2OLt/iySuLzPsdpq8epQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wp5h8Pk7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wp5h8Pk7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEC0BC4CEE3;
	Thu, 10 Jul 2025 05:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126189;
	bh=eQji4vW2lNikCGG4dz4I4E+FEJMSHJt4LUy0f7BMT24=;
	h=Date:To:From:Subject:From;
	b=wp5h8Pk7okJ4Kfbfbk1Ch+h0WrHkrS/Mm1mfDpdhchArQevY1lfqKWTOkl7uKWv4z
	 uPRN01XQiB8dvcKYtJO6lzbVRk5Kv38jf5oiLJnQPC7Ypv+KZ8pgd6qy7503PgoL3Q
	 5F9312R6ttniax3K+IqDl6GUWEtPK7Yk9LwjO/0Y=
Date: Wed, 09 Jul 2025 22:43:09 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,liam.howlett@oracle.com,jannh@google.com,corbet@lwn.net,bagasdotme@gmail.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-expand-vma-doc-to-highlight-pte-freeing-non-vma-traversal.patch removed from -mm tree
Message-Id: <20250710054309.CEC0BC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs/mm: expand vma doc to highlight pte freeing, non-vma traversal
has been removed from the -mm tree.  Its filename was
     docs-mm-expand-vma-doc-to-highlight-pte-freeing-non-vma-traversal.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: docs/mm: expand vma doc to highlight pte freeing, non-vma traversal
Date: Wed, 4 Jun 2025 19:03:08 +0100

The process addresses documentation already contains a great deal of
information about mmap/VMA locking and page table traversal and
manipulation.

However it waves it hands about non-VMA traversal.  Add a section for this
and explain the caveats around this kind of traversal.

Additionally, commit 6375e95f381e ("mm: pgtable: reclaim empty PTE page in
madvise(MADV_DONTNEED)") caused zapping to also free empty PTE page
tables.  Highlight this.

Link: https://lkml.kernel.org/r/20250604180308.137116-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/process_addrs.rst |   54 ++++++++++++++++++++++++---
 1 file changed, 48 insertions(+), 6 deletions(-)

--- a/Documentation/mm/process_addrs.rst~docs-mm-expand-vma-doc-to-highlight-pte-freeing-non-vma-traversal
+++ a/Documentation/mm/process_addrs.rst
@@ -303,7 +303,9 @@ There are four key operations typically
 1. **Traversing** page tables - Simply reading page tables in order to traverse
    them. This only requires that the VMA is kept stable, so a lock which
    establishes this suffices for traversal (there are also lockless variants
-   which eliminate even this requirement, such as :c:func:`!gup_fast`).
+   which eliminate even this requirement, such as :c:func:`!gup_fast`). There is
+   also a special case of page table traversal for non-VMA regions which we
+   consider separately below.
 2. **Installing** page table mappings - Whether creating a new mapping or
    modifying an existing one in such a way as to change its identity. This
    requires that the VMA is kept stable via an mmap or VMA lock (explicitly not
@@ -335,15 +337,13 @@ ahead and perform these operations on pa
 operations that perform writes also acquire internal page table locks to
 serialise - see the page table implementation detail section for more details).
 
+.. note:: We free empty PTE tables on zap under the RCU lock - this does not
+          change the aforementioned locking requirements around zapping.
+
 When **installing** page table entries, the mmap or VMA lock must be held to
 keep the VMA stable. We explore why this is in the page table locking details
 section below.
 
-.. warning:: Page tables are normally only traversed in regions covered by VMAs.
-             If you want to traverse page tables in areas that might not be
-             covered by VMAs, heavier locking is required.
-             See :c:func:`!walk_page_range_novma` for details.
-
 **Freeing** page tables is an entirely internal memory management operation and
 has special requirements (see the page freeing section below for more details).
 
@@ -355,6 +355,44 @@ has special requirements (see the page f
              from the reverse mappings, but no other VMAs can be permitted to be
              accessible and span the specified range.
 
+Traversing non-VMA page tables
+------------------------------
+
+We've focused above on traversal of page tables belonging to VMAs. It is also
+possible to traverse page tables which are not represented by VMAs.
+
+Kernel page table mappings themselves are generally managed but whatever part of
+the kernel established them and the aforementioned locking rules do not apply -
+for instance vmalloc has its own set of locks which are utilised for
+establishing and tearing down page its page tables.
+
+However, for convenience we provide the :c:func:`!walk_kernel_page_table_range`
+function which is synchronised via the mmap lock on the :c:macro:`!init_mm`
+kernel instantiation of the :c:struct:`!struct mm_struct` metadata object.
+
+If an operation requires exclusive access, a write lock is used, but if not, a
+read lock suffices - we assert only that at least a read lock has been acquired.
+
+Since, aside from vmalloc and memory hot plug, kernel page tables are not torn
+down all that often - this usually suffices, however any caller of this
+functionality must ensure that any additionally required locks are acquired in
+advance.
+
+We also permit a truly unusual case is the traversal of non-VMA ranges in
+**userland** ranges, as provided for by :c:func:`!walk_page_range_debug`.
+
+This has only one user - the general page table dumping logic (implemented in
+:c:macro:`!mm/ptdump.c`) - which seeks to expose all mappings for debug purposes
+even if they are highly unusual (possibly architecture-specific) and are not
+backed by a VMA.
+
+We must take great care in this case, as the :c:func:`!munmap` implementation
+detaches VMAs under an mmap write lock before tearing down page tables under a
+downgraded mmap read lock.
+
+This means such an operation could race with this, and thus an mmap **write**
+lock is required.
+
 Lock ordering
 -------------
 
@@ -461,6 +499,10 @@ Locking Implementation Details
 Page table locking details
 --------------------------
 
+.. note:: This section explores page table locking requirements for page tables
+          encompassed by a VMA. See the above section on non-VMA page table
+          traversal for details on how we handle that case.
+
 In addition to the locks described in the terminology section above, we have
 additional locks dedicated to page tables:
 
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-madvise-remove-the-visitor-pattern-and-thread-anon_vma-state.patch
mm-madvise-thread-mm_struct-through-madvise_behavior.patch
mm-madvise-thread-vma-range-state-through-madvise_behavior.patch
mm-madvise-thread-all-madvise-state-through-madv_behavior.patch
mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma.patch
mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma-fix.patch
tools-testing-selftests-add-mremap-unfaulted-faulted-test-cases.patch
mm-mremap-perform-some-simple-cleanups.patch
mm-mremap-refactor-initial-parameter-sanity-checks.patch
mm-mremap-put-vma-check-and-prep-logic-into-helper-function.patch
mm-mremap-cleanup-post-processing-stage-of-mremap.patch
mm-mremap-use-an-explicit-uffd-failure-path-for-mremap.patch
mm-mremap-use-an-explicit-uffd-failure-path-for-mremap-fix.patch
mm-mremap-check-remap-conditions-earlier.patch
mm-mremap-move-remap_is_valid-into-check_prep_vma.patch
mm-mremap-clean-up-mlock-populate-behaviour.patch
mm-mremap-permit-mremap-move-of-multiple-vmas.patch
tools-testing-selftests-extend-mremap_test-to-test-multi-vma-mremap.patch

