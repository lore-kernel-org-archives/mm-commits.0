Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96CC02A1D8
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188454; cv=none; b=tUL1RhnqsewgqxlbNcA2cU3G6oRdbHFheyuGWreN+DWQsGZ8YA5CFAtxKSI7sew6t4eZ0wUXOGT3Fn2naL6Ipuc06hvgBn4M4miM47Yjax3JDZa3CqocRkVMw8SyCn7rQePaJrf5R2Vv0mDuDHRJe28peW4IGbVU90PdZqAUo+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188454; c=relaxed/simple;
	bh=fnv4VuUkr+ocabxOMEh7N4b8Wi1u0s9uoPxboxK7NLU=;
	h=Date:To:From:Subject:Message-Id; b=VUHFJOn6StsvgMF1lLzyx0zxbHKY+PVIvKEs7OJJJ2UBLNSOTFcXcKnDRA93kg9M1MaGCQsCvgFd2nQAiXrhZf4LTLGCJfc53Zlm+6QsOHi5CnrYdtP/mT8vUmxebWxA3PH9aE6rMpcoUuvM5IM3oB7cIxCxM5EdCXcyggOFdak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yTL26QrR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yTL26QrR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD16C4CEEC;
	Mon, 17 Mar 2025 05:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188454;
	bh=fnv4VuUkr+ocabxOMEh7N4b8Wi1u0s9uoPxboxK7NLU=;
	h=Date:To:From:Subject:From;
	b=yTL26QrRhY0/stwRiOt1/ZGIdiRvmvEAbAMdDAmstJmOJ8sWS0Y2dc5QV8XHl0POP
	 5ZApoqnhe4istNOXykIaqATpMAcBo9G8mx7MTZqnWzszUUmE5Dzxz9dX18ZrMzeiXC
	 xEK++pq8A+2LMKHxpYQo8VMk0y/vOGdVVHBsVXJ4=
Date: Sun, 16 Mar 2025 22:14:13 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,paulmck@kernel.org,liam.howlett@oracle.com,kaleshsingh@google.com,jannh@google.com,david@redhat.com,corbet@lwn.net,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-proc-task_mmu-add-guard-region-bit-to-pagemap.patch removed from -mm tree
Message-Id: <20250317051414.6AD16C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc/task_mmu: add guard region bit to pagemap
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmu-add-guard-region-bit-to-pagemap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
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

mm-mremap-correctly-handle-partial-mremap-of-vma-starting-at-0.patch
mm-mremap-refactor-mremap-system-call-implementation.patch
mm-mremap-introduce-and-use-vma_remap_struct-threaded-state.patch
mm-mremap-initial-refactor-of-move_vma.patch
mm-mremap-complete-refactor-of-move_vma.patch
mm-mremap-refactor-move_page_tables-abstracting-state.patch
mm-mremap-thread-state-through-move-page-table-operation.patch

