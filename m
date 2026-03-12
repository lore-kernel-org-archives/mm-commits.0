Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D633BADB0
	for <mm-commits@vger.kernel.org>; Thu, 12 Mar 2026 23:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773357760; cv=none; b=Bn/1xk1WRdQLLczej8CQ1j1c1wD6JTykwgCyRnfCoFUPlrZIeiQdnB2vspfW4yKogpikmO/6j4Uri+ujZ+P1g+okzJwtwLr7Vj7SZmDIxu3BvE7TWaI3LLcD8jaq+1yiMvp6XfqjIkPH2H9HaPlL1niAer863meX6h9rzxMXg14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773357760; c=relaxed/simple;
	bh=k4inboIr2oIAk8biEE8VB3aPN5XVeIXKy0cqtyf8CUw=;
	h=Date:To:From:Subject:Message-Id; b=XTc2pLOhyZQRlvCVikBhuL/wHO1Ngv29auPkjFQuRZXmskEWoZV/kk+qxIpXrORYBLZpyFYdUlDxNUdoY5pYkwnchpwuHCwJwKRhboIFfP/Nqvx2airOaskT+6igERfsvcyALezaxEmrFBrEl+lgQ/noDMG5FdLWM9dJs29/7KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SyUfiVFz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SyUfiVFz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC113C4CEF7;
	Thu, 12 Mar 2026 23:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773357759;
	bh=k4inboIr2oIAk8biEE8VB3aPN5XVeIXKy0cqtyf8CUw=;
	h=Date:To:From:Subject:From;
	b=SyUfiVFzdd8Qd+Ib5Q6LPRL7ycDnnP5YHLa8v74YrW011eOLcF6e8/MHa0dZ1hFGC
	 +/xZ/9Cmy64zCtwAehOh9Xl+3fFuAdf+mENldDwC1R0F8w6Jo30vv6CYxFG4dSs4pf
	 pusQMDlaui5zHTSsv1tjm3q3SblCwWNqJ2G6b6XI=
Date: Thu, 12 Mar 2026 16:22:39 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,ljs@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-mmap_action_map_kernel_pages-fix.patch added to mm-new branch
Message-Id: <20260312232239.AC113C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-add-mmap_action_map_kernel_pages-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-add-mmap_action_map_kernel_pages-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-mmap_action_map_kernel_pages-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-mmap_action_map_kernel_pages-fix
Date: Thu Mar 12 04:20:41 PM PDT 2026

s/Returns/Returns:/ for kerneldoc, per Randy

Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/mm.h~mm-add-mmap_action_map_kernel_pages-fix
+++ a/include/linux/mm.h
@@ -2727,7 +2727,7 @@ static inline bool folio_maybe_mapped_sh
  * The caller must add any reference (e.g., from folio_try_get()) it might be
  * holding itself to the result.
  *
- * Returns the expected folio refcount.
+ * Returns: the expected folio refcount.
  */
 static inline int folio_expected_ref_count(const struct folio *folio)
 {
@@ -4243,7 +4243,7 @@ static inline struct vm_area_struct *fin
  * @inner_start: The start of the inner range.
  * @inner_end: The exclusive end of the inner range.
  *
- * Returns %true if [inner_start, inner_end) is a subset of [outer_start,
+ * Returns: %true if [inner_start, inner_end) is a subset of [outer_start,
  * outer_end), otherwise %false.
  */
 static inline bool range_is_subset(unsigned long outer_start,
@@ -4260,7 +4260,7 @@ static inline bool range_is_subset(unsig
  * @start: The start of the range we wish to check.
  * @end: The exclusive end of the range we wish to check.
  *
- * Returns %true if [@start, @end) is a subset of [@vma->vm_start,
+ * Returns: %true if [@start, @end) is a subset of [@vma->vm_start,
  * @vma->vm_end), %false otherwise.
  */
 static inline bool range_in_vma(const struct vm_area_struct *vma,
@@ -4279,7 +4279,7 @@ static inline bool range_in_vma(const st
  * @start: The start of the range we wish to check.
  * @end: The exclusive end of the range we wish to check.
  *
- * Returns %true if [@start, @end) is a subset of [@desc->start, @desc->end),
+ * Returns: %true if [@start, @end) is a subset of [@desc->start, @desc->end),
  * %false otherwise.
  */
 static inline bool range_in_vma_desc(const struct vm_area_desc *desc,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes.patch
maple_tree-add-cp_is_new_root-helper-fix-fix.patch
mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap-fix.patch
mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix.patch
mm-rename-zone-lock-to-zone-_lock-fix.patch
mm-page_reporting-add-page_reporting_order_unspecified-fix.patch
mm-various-small-mmap_prepare-cleanups-fix.patch
mm-add-mmap_action_map_kernel_pages-fix.patch
kernel-panic-increase-buffer-size-for-verbose-taint-logging-fix.patch
decode_stacktrace-decode-caller-address-checkpatch-fixes.patch

