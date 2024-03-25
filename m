Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DFF24A2D
	for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2024 18:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711391810; cv=none; b=PaAq+k3a2wlaC9ri1ZBMxK5VUuzAvQwpnQmbOCa2RVh1Ko+AMhFMdP4iejnV7Ml6E/aXP0AM8+zCtLBNGIJXe+yJzOU/ad9Wag3H1GITdmnVf/Krr3nQEclDj0YFVSCVcPSmiersIImmqW5WcreUtCx7ZE4VfrBPlAb+PKBZ6o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711391810; c=relaxed/simple;
	bh=+AvIqTTqv4u6a2FjcqOH9eaWkrkvvD4MJaTLPuRbFAo=;
	h=Date:To:From:Subject:Message-Id; b=lLQV/jRtEbKQ84pD7ULQZNp5JJHmnp8uJXOWZ3qOrhxid9qvFrs2Myn8peBWDWMsMFP0KzpXpe0lB+80QEebla5fWSwzrSeBlxfYima9Mj0ydUBKK4SGMkml59S6MkXSb2jiNgXwiMEimWzr3Z4zH10CpZ7GzNIhBC2cp/wpnXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qsmvKfbU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qsmvKfbU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C37D7C433F1;
	Mon, 25 Mar 2024 18:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711391809;
	bh=+AvIqTTqv4u6a2FjcqOH9eaWkrkvvD4MJaTLPuRbFAo=;
	h=Date:To:From:Subject:From;
	b=qsmvKfbUJ/PhTo3DWyPJ0sDSzbA61Lwp2ehz3ydvufsXaK6mfteAmtik96giA4kbs
	 J0McOlxSkXbFSU9Leiqq4q1izlRKC/rJ92LpFj9Rz5NDLb9phWfuvT7gFdnRqrpYK8
	 CxgO7NA0ki53dLKg8M5RZDVbn4+spNMzx0S1+IjI=
Date: Mon, 25 Mar 2024 11:36:49 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared-fix.patch added to mm-unstable branch
Message-Id: <20240325183649.C37D7C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: folio_likely_mapped_shared() kerneldoc fixup
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared-fix.patch

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
Subject: folio_likely_mapped_shared() kerneldoc fixup
Date: Mon, 25 Mar 2024 09:23:03 +0100

Fixup "mm: convert folio_estimated_sharers() to
folio_likely_mapped_shared()".

Link: https://lkml.kernel.org/r/dd0ad9f2-2d7a-45f3-9ba3-979488c7dd27@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

--- a/include/linux/mm.h~mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared-fix
+++ a/include/linux/mm.h
@@ -2183,23 +2183,25 @@ static inline size_t folio_size(struct f
  * at most once into an MM, and they cannot be partially mapped.
  *
  * For other folios, the result can be fuzzy:
- * (a) For partially-mappable large folios (THP), the return value can wrongly
- *     indicate "mapped exclusively" (false negative) when the folio is
- *     only partially mapped into at least one MM.
- * (b) For pagecache folios (including hugetlb), the return value can wrongly
- *     indicate "mapped shared" (false positive) when two VMAs in the same MM
- *     cover the same file range.
- * (c) For (small) KSM folios, the return value can wrongly indicate "mapped
- *     shared" (false negative), when the folio is mapped multiple times into
- *     the same MM.
+ *    #. For partially-mappable large folios (THP), the return value can wrongly
+ *       indicate "mapped exclusively" (false negative) when the folio is
+ *       only partially mapped into at least one MM.
+ *    #. For pagecache folios (including hugetlb), the return value can wrongly
+ *       indicate "mapped shared" (false positive) when two VMAs in the same MM
+ *       cover the same file range.
+ *    #. For (small) KSM folios, the return value can wrongly indicate "mapped
+ *       shared" (false negative), when the folio is mapped multiple times into
+ *       the same MM.
  *
  * Further, this function only considers current page table mappings that
- * are tracked using the folio mapcount(s). It does not consider:
- * (1) If the folio might get mapped in the (near) future (e.g., swapcache,
- *     pagecache, temporary unmapping for migration).
- * (2) If the folio is mapped differently (VM_PFNMAP).
- * (3) If hugetlb page table sharing applies. Callers might want to check
- *     hugetlb_pmd_shared().
+ * are tracked using the folio mapcount(s).
+ *
+ * This function does not consider:
+ *    #. If the folio might get mapped in the (near) future (e.g., swapcache,
+ *       pagecache, temporary unmapping for migration).
+ *    #. If the folio is mapped differently (VM_PFNMAP).
+ *    #. If hugetlb page table sharing applies. Callers might want to check
+ *       hugetlb_pmd_shared().
  *
  * Return: Whether the folio is estimated to be mapped into more than one MM.
  */
_

Patches currently in -mm which might be from david@redhat.com are

mm-secretmem-fix-gup-fast-succeeding-on-secretmem-folios.patch
mm-madvise-make-madv_populate_readwrite-handle-vm_fault_retry-properly.patch
mm-madvise-dont-perform-madvise-vma-walk-for-madv_populate_readwrite.patch
mm-userfaultfd-dont-place-zeropages-when-zeropages-are-disallowed.patch
s390-mm-re-enable-the-shared-zeropage-for-pv-and-skeys-kvm-guests.patch
mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared.patch
mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared-fix.patch
selftests-memfd_secret-add-vmsplice-test.patch
mm-merge-folio_is_secretmem-into-folio_fast_pin_allowed.patch

