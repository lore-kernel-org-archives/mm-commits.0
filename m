Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD9215E5C2
	for <mm-commits@vger.kernel.org>; Mon, 11 Nov 2024 08:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731313701; cv=none; b=vEy6MIXZQkKra0n1M57fdCz9p0NwAEJ7r4y2R+1jfXQJLhUWG13tqhfenrh0LzZ6wTqTu7y7siylhIwM1ezQMtyzzY27Uqej+ykVNmn0BeFOJ2bayrAPvJxFrZZ5bj2lzRJrksgc0varSYVeWnehQ0b/r104zvvXaTxMtx1sA/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731313701; c=relaxed/simple;
	bh=Fi08IISbxRCl1uh1suixH9N+OAh0thx2pdlUrBSW7wc=;
	h=Date:To:From:Subject:Message-Id; b=i0pryvgtz9FpKGRxUGFNCxMsJucoP9HBfeDDbRD1AJ5UfMoSjEGJpQ/029HBUcAf+ilErkjgc3Rfp9Xr44p7ZY9NyA1Tv7xVRvUIfVIXgqmCBmU2pg+CE1e7MxCTifmIsxBBi3NjiuyVRtXb/4UZbcbCaFavU33i0FVNb26IOeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nfV4PbgT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nfV4PbgT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ABA1C4CED0;
	Mon, 11 Nov 2024 08:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731313701;
	bh=Fi08IISbxRCl1uh1suixH9N+OAh0thx2pdlUrBSW7wc=;
	h=Date:To:From:Subject:From;
	b=nfV4PbgTB57FTJv/eDfVDunRVNc0NytXtMXatHZEevehZjGZg8M0Hk5qCShaL1j0z
	 4M9mc6dhy6tktNEnNPG++6NOnZDEqYHSrVRzQbVsp8ATbFbGPEfN/kghMI+oHFjWg7
	 S4k0y3fKZE2uK44JL88G3QElfLGWghftX/wQEmOE=
Date: Mon, 11 Nov 2024 00:28:20 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabkba@suse.cz,vbabka@suse.cz,tsbogend@alpha.franken.de,surenb@google.com,skhan@linuxfoundation.org,sidhartha.kumar@oracle.com,shuah@kernel.org,richard.henderson@linaro.org,paulmck@kernel.org,muchun.song@linux.dev,mattst88@gmail.com,Liam.Howlett@Oracle.com,jhubbard@nvidia.com,jeffxu@chromium.org,jcmvbkbc@gmail.com,jannh@google.com,James.Bottomley@HansenPartnership.com,hch@infradead.org,deller@gmx.de,david@redhat.com,chris@zankel.net,brauner@kernel.org,arnd@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-pte_marker_guard-pte-marker.patch removed from -mm tree
Message-Id: <20241111082821.6ABA1C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add PTE_MARKER_GUARD PTE marker
has been removed from the -mm tree.  Its filename was
     mm-add-pte_marker_guard-pte-marker.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: add PTE_MARKER_GUARD PTE marker
Date: Mon, 28 Oct 2024 14:13:28 +0000

Add a new PTE marker that results in any access causing the accessing
process to segfault.

This is preferable to PTE_MARKER_POISONED, which results in the same
handling as hardware poisoned memory, and is thus undesirable for cases
where we simply wish to 'soft' poison a range.

This is in preparation for implementing the ability to specify guard pages
at the page table level, i.e.  ranges that, when accessed, should cause
process termination.

Additionally, rename zap_drop_file_uffd_wp() to zap_drop_markers() - the
function checks the ZAP_FLAG_DROP_MARKER flag so naming it for this single
purpose was simply incorrect.

We then reuse the same logic to determine whether a zap should clear a
guard entry - this should only be performed on teardown and never on
MADV_DONTNEED or MADV_FREE.

We additionally add a WARN_ON_ONCE() in hugetlb logic should a guard
marker be encountered there, as we explicitly do not support this
operation and this should not occur.

Link: https://lkml.kernel.org/r/f47f3d5acca2dcf9bbf655b6d33f3dc713e4a4a0.1730123433.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Vlastimil Babka <vbabkba@suse.cz>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Suggested-by: Jann Horn <jannh@google.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Arnd Bergmann <arnd@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Chris Zankel <chris@zankel.net>
Cc: Helge Deller <deller@gmx.de>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |    2 +-
 include/linux/swapops.h   |   24 +++++++++++++++++++++++-
 mm/hugetlb.c              |    4 ++++
 mm/memory.c               |   18 +++++++++++++++---
 mm/mprotect.c             |    6 ++++--
 5 files changed, 47 insertions(+), 7 deletions(-)

--- a/include/linux/mm_inline.h~mm-add-pte_marker_guard-pte-marker
+++ a/include/linux/mm_inline.h
@@ -544,7 +544,7 @@ static inline pte_marker copy_pte_marker
 {
 	pte_marker srcm = pte_marker_get(entry);
 	/* Always copy error entries. */
-	pte_marker dstm = srcm & PTE_MARKER_POISONED;
+	pte_marker dstm = srcm & (PTE_MARKER_POISONED | PTE_MARKER_GUARD);
 
 	/* Only copy PTE markers if UFFD register matches. */
 	if ((srcm & PTE_MARKER_UFFD_WP) && userfaultfd_wp(dst_vma))
--- a/include/linux/swapops.h~mm-add-pte_marker_guard-pte-marker
+++ a/include/linux/swapops.h
@@ -426,9 +426,19 @@ typedef unsigned long pte_marker;
  * "Poisoned" here is meant in the very general sense of "future accesses are
  * invalid", instead of referring very specifically to hardware memory errors.
  * This marker is meant to represent any of various different causes of this.
+ *
+ * Note that, when encountered by the faulting logic, PTEs with this marker will
+ * result in VM_FAULT_HWPOISON and thus regardless trigger hardware memory error
+ * logic.
  */
 #define  PTE_MARKER_POISONED			BIT(1)
-#define  PTE_MARKER_MASK			(BIT(2) - 1)
+/*
+ * Indicates that, on fault, this PTE will case a SIGSEGV signal to be
+ * sent. This means guard markers behave in effect as if the region were mapped
+ * PROT_NONE, rather than if they were a memory hole or equivalent.
+ */
+#define  PTE_MARKER_GUARD			BIT(2)
+#define  PTE_MARKER_MASK			(BIT(3) - 1)
 
 static inline swp_entry_t make_pte_marker_entry(pte_marker marker)
 {
@@ -464,6 +474,18 @@ static inline int is_poisoned_swp_entry(
 {
 	return is_pte_marker_entry(entry) &&
 	    (pte_marker_get(entry) & PTE_MARKER_POISONED);
+
+}
+
+static inline swp_entry_t make_guard_swp_entry(void)
+{
+	return make_pte_marker_entry(PTE_MARKER_GUARD);
+}
+
+static inline int is_guard_swp_entry(swp_entry_t entry)
+{
+	return is_pte_marker_entry(entry) &&
+		(pte_marker_get(entry) & PTE_MARKER_GUARD);
 }
 
 /*
--- a/mm/hugetlb.c~mm-add-pte_marker_guard-pte-marker
+++ a/mm/hugetlb.c
@@ -6353,6 +6353,10 @@ vm_fault_t hugetlb_fault(struct mm_struc
 				ret = VM_FAULT_HWPOISON_LARGE |
 				      VM_FAULT_SET_HINDEX(hstate_index(h));
 				goto out_mutex;
+			} else if (WARN_ON_ONCE(marker & PTE_MARKER_GUARD)) {
+				/* This isn't supported in hugetlb. */
+				ret = VM_FAULT_SIGSEGV;
+				goto out_mutex;
 			}
 		}
 
--- a/mm/memory.c~mm-add-pte_marker_guard-pte-marker
+++ a/mm/memory.c
@@ -1455,7 +1455,7 @@ static inline bool should_zap_folio(stru
 	return !folio_test_anon(folio);
 }
 
-static inline bool zap_drop_file_uffd_wp(struct zap_details *details)
+static inline bool zap_drop_markers(struct zap_details *details)
 {
 	if (!details)
 		return false;
@@ -1476,7 +1476,7 @@ zap_install_uffd_wp_if_needed(struct vm_
 	if (vma_is_anonymous(vma))
 		return;
 
-	if (zap_drop_file_uffd_wp(details))
+	if (zap_drop_markers(details))
 		return;
 
 	for (;;) {
@@ -1671,7 +1671,15 @@ static unsigned long zap_pte_range(struc
 			 * drop the marker if explicitly requested.
 			 */
 			if (!vma_is_anonymous(vma) &&
-			    !zap_drop_file_uffd_wp(details))
+			    !zap_drop_markers(details))
+				continue;
+		} else if (is_guard_swp_entry(entry)) {
+			/*
+			 * Ordinary zapping should not remove guard PTE
+			 * markers. Only do so if we should remove PTE markers
+			 * in general.
+			 */
+			if (!zap_drop_markers(details))
 				continue;
 		} else if (is_hwpoison_entry(entry) ||
 			   is_poisoned_swp_entry(entry)) {
@@ -4003,6 +4011,10 @@ static vm_fault_t handle_pte_marker(stru
 	if (marker & PTE_MARKER_POISONED)
 		return VM_FAULT_HWPOISON;
 
+	/* Hitting a guard page is always a fatal condition. */
+	if (marker & PTE_MARKER_GUARD)
+		return VM_FAULT_SIGSEGV;
+
 	if (pte_marker_entry_uffd_wp(entry))
 		return pte_marker_handle_uffd_wp(vmf);
 
--- a/mm/mprotect.c~mm-add-pte_marker_guard-pte-marker
+++ a/mm/mprotect.c
@@ -236,9 +236,11 @@ static long change_pte_range(struct mmu_
 			} else if (is_pte_marker_entry(entry)) {
 				/*
 				 * Ignore error swap entries unconditionally,
-				 * because any access should sigbus anyway.
+				 * because any access should sigbus/sigsegv
+				 * anyway.
 				 */
-				if (is_poisoned_swp_entry(entry))
+				if (is_poisoned_swp_entry(entry) ||
+				    is_guard_swp_entry(entry))
 					continue;
 				/*
 				 * If this is uffd-wp pte marker and we'd like
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

docs-mm-add-vma-locks-documentation.patch
docs-mm-add-vma-locks-documentation-fix.patch

