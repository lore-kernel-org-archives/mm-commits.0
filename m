Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3CEF139D
	for <mm-commits@vger.kernel.org>; Wed,  3 Apr 2024 22:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712183684; cv=none; b=S3T0Sz73w4MK+5Gy+kSPJ8pxPqhinWuGzAF0lwZSRoBem52GkV0eB/SyoVvmJwaRPsgeaBpFmJHaLy0RAHRmmdbcc35ke1/0xxuT/QOcUVdpe7D7G4R8OJqO6YWtsdpyxTzB7YT42ijuS1dpCQfWy20GY9zLsuTzhlSp08r4OO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712183684; c=relaxed/simple;
	bh=lIgu72kOYbDY+krGdQCH/+GQy0Fb90na7ygU0QIyAbo=;
	h=Date:To:From:Subject:Message-Id; b=CFMDHfA/xHRnqpCDf1uUNjo/XlMUyE9u/kAkB6Ru7BgoPuwVElbXmq+T0LkKMGjFoNXoyjnsr+SpcbcVxYvR4w3cFP8tVs+lXctnsbS9w+r62qCj4NgiZoBJcVvZHXffzhjJrLSizjz4MJ35qSErKsI6UuyMkpu8H7KyYTck+vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Xs0Kx/Bj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Xs0Kx/Bj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50034C433F1;
	Wed,  3 Apr 2024 22:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712183684;
	bh=lIgu72kOYbDY+krGdQCH/+GQy0Fb90na7ygU0QIyAbo=;
	h=Date:To:From:Subject:From;
	b=Xs0Kx/BjZKN/yTZ9xGTdRBco60n71q1E3IyL/Ll+8OxAVrQg1hm0KPbcDFIa0RtLK
	 68DkX/g2nhnBdS1ooES/Hh3RnU496hMzR1+JyLtbyx0zUD3mHir/B9b11Eb0kEizs3
	 1FAB0G91rpq4nzGKM5m4p6McaOl+9u4NE1zVM7/s=
Date: Wed, 03 Apr 2024 15:34:43 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,peterx@redhat.com,jhubbard@nvidia.com,jgg@nvidia.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-gup-fast-instead-fast-gup-in-remaining-comments.patch added to mm-unstable branch
Message-Id: <20240403223444.50034C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: use "GUP-fast" instead "fast GUP" in remaining comments
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-gup-fast-instead-fast-gup-in-remaining-comments.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-gup-fast-instead-fast-gup-in-remaining-comments.patch

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
Subject: mm: use "GUP-fast" instead "fast GUP" in remaining comments
Date: Tue, 2 Apr 2024 14:55:16 +0200

Let's fixup the remaining comments to consistently call that thing
"GUP-fast".  With this change, we consistently call it "GUP-fast".

Link: https://lkml.kernel.org/r/20240402125516.223131-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c    |    2 +-
 mm/khugepaged.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/mm/filemap.c~mm-use-gup-fast-instead-fast-gup-in-remaining-comments
+++ a/mm/filemap.c
@@ -1810,7 +1810,7 @@ EXPORT_SYMBOL(page_cache_prev_miss);
  * C. Return the page to the page allocator
  *
  * This means that any page may have its reference count temporarily
- * increased by a speculative page cache (or fast GUP) lookup as it can
+ * increased by a speculative page cache (or GUP-fast) lookup as it can
  * be allocated by another user before the RCU grace period expires.
  * Because the refcount temporarily acquired here may end up being the
  * last refcount on the page, any page allocation must be freeable by
--- a/mm/khugepaged.c~mm-use-gup-fast-instead-fast-gup-in-remaining-comments
+++ a/mm/khugepaged.c
@@ -1153,7 +1153,7 @@ static int collapse_huge_page(struct mm_
 	 * huge and small TLB entries for the same virtual address to
 	 * avoid the risk of CPU bugs in that area.
 	 *
-	 * Parallel fast GUP is fine since fast GUP will back off when
+	 * Parallel GUP-fast is fine since GUP-fast will back off when
 	 * it detects PMD is changed.
 	 */
 	_pmd = pmdp_collapse_flush(vma, address, pmd);
_

Patches currently in -mm which might be from david@redhat.com are

mm-secretmem-fix-gup-fast-succeeding-on-secretmem-folios.patch
x86-mm-pat-fix-vm_pat-handling-in-cow-mappings.patch
mm-madvise-make-madv_populate_readwrite-handle-vm_fault_retry-properly.patch
mm-madvise-dont-perform-madvise-vma-walk-for-madv_populate_readwrite.patch
mm-userfaultfd-dont-place-zeropages-when-zeropages-are-disallowed.patch
s390-mm-re-enable-the-shared-zeropage-for-pv-and-skeys-kvm-guests.patch
mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared.patch
mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared-fix.patch
selftests-memfd_secret-add-vmsplice-test.patch
mm-merge-folio_is_secretmem-and-folio_fast_pin_allowed-into-gup_fast_folio_allowed.patch
mm-optimize-config_per_vma_lock-member-placement-in-vm_area_struct.patch
mm-remove-prot-parameter-from-move_pte.patch
mm-gup-consistently-name-gup-fast-functions.patch
mm-treewide-rename-config_have_fast_gup-to-config_have_gup_fast.patch
mm-use-gup-fast-instead-fast-gup-in-remaining-comments.patch

