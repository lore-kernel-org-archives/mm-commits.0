Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90CA7275118
	for <mm-commits@vger.kernel.org>; Tue, 29 Apr 2025 22:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745966270; cv=none; b=XIg8dBQKwFtQMtC+iuIe9xRoD0wVztCRdRM78Y6AuQjtEO/p/VQcLGNYAOUE2ZdCID/ayl2c+Ny1u0465bDbI4MKB8c8TvfXrSgT/idYstvPOGQ+vybvOr/h1yRD9s/duDyzXZbls5bu684hDHCPXS+H006ICU+/UkYtX7lQ5lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745966270; c=relaxed/simple;
	bh=T3fwBwj3tp49X3FEM2YKzGyJzfhM8eWJIh/Vm1TmXdA=;
	h=Date:To:From:Subject:Message-Id; b=Qrm3tZdk2x8r754mievKOB3OdLu/iZWVfYiQ+L+2XPT6qsct6dwOJ4jr8jfa9jzBYvR4B+hNvHFBbeoGFdJp4XRsOH5eug0CczFyejqrzbrN1JVS7cimUz+vHo37dTE1nKdYgSHYFAAr0zr6iYdxiKSgLqFXsrCes2lgtptg7wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u3ORqNio; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u3ORqNio"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8AEC4CEE3;
	Tue, 29 Apr 2025 22:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745966269;
	bh=T3fwBwj3tp49X3FEM2YKzGyJzfhM8eWJIh/Vm1TmXdA=;
	h=Date:To:From:Subject:From;
	b=u3ORqNioRf5+G3d1XzwqxAur5UJMdDxLhZ88rYLTDcxOE6AZUnVX7rhp8RulDfn0P
	 VWLsYrpP4co96HrjJje/kSXj+MYuLK2zVDc9MGY2sH467pPqiY/DEBiLahHFATAcOA
	 xioFf8I/zqiGXbQfPMojgOJrqI8kwWHVkBHFaDCY=
Date: Tue, 29 Apr 2025 15:37:49 -0700
To: mm-commits@vger.kernel.org,hca@linux.ibm.com,bhe@redhat.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-fix-false-warning-for-large-allocation-with-thp_swap.patch added to mm-hotfixes-unstable branch
Message-Id: <20250429223749.AB8AEC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: fix false warning for large allocation with !THP_SWAP
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-swap-fix-false-warning-for-large-allocation-with-thp_swap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-fix-false-warning-for-large-allocation-with-thp_swap.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: fix false warning for large allocation with !THP_SWAP
Date: Tue, 29 Apr 2025 17:48:03 +0800

The !CONFIG_THP_SWAP check existed before just fine because slot cache
would reject high order allocation and let the caller split all folios and
try again.

But slot cache is gone, so large allocation will directly go to the
allocator, and the allocator should just fail silently to inform caller to
do the folio split, this is totally fine and expected.

Remove this meaningless warning.

Link: https://lkml.kernel.org/r/20250429094803.85518-1-ryncsn@gmail.com
Fixes: 0ff67f990bd4 ("mm, swap: remove swap slot cache")
Signed-off-by: Kairui Song <kasong@tencent.com>
Reported-by: Heiko Carstens <hca@linux.ibm.com>
Closes: https://lore.kernel.org/linux-mm/20250428135252.25453B17-hca@linux.ibm.com/
Tested-by: Heiko Carstens <hca@linux.ibm.com>
Cc: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

--- a/mm/swapfile.c~mm-swap-fix-false-warning-for-large-allocation-with-thp_swap
+++ a/mm/swapfile.c
@@ -1272,13 +1272,22 @@ int folio_alloc_swap(struct folio *folio
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_FOLIO(!folio_test_uptodate(folio), folio);
 
-	/*
-	 * Should not even be attempting large allocations when huge
-	 * page swap is disabled. Warn and fail the allocation.
-	 */
-	if (order && (!IS_ENABLED(CONFIG_THP_SWAP) || size > SWAPFILE_CLUSTER)) {
-		VM_WARN_ON_ONCE(1);
-		return -EINVAL;
+	if (order) {
+		/*
+		 * Reject large allocation when THP_SWAP is disabled,
+		 * the caller should split the folio and try again.
+		 */
+		if (!IS_ENABLED(CONFIG_THP_SWAP))
+			return -EAGAIN;
+
+		/*
+		 * Allocation size should never exceed cluster size
+		 * (HPAGE_PMD_SIZE).
+		 */
+		if (size > SWAPFILE_CLUSTER) {
+			VM_WARN_ON_ONCE(1);
+			return -EINVAL;
+		}
 	}
 
 	local_lock(&percpu_swap_cluster.lock);
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-memory-fix-mapcount-refcount-sanity-check-for-mthp-reuse.patch
mm-swap-fix-false-warning-for-large-allocation-with-thp_swap.patch

