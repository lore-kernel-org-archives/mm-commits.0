Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 187753F9F46
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 19:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777057847; cv=none; b=MLQJfMJnpq7CECCqdPaND7O0YwOYOEZZ7wPdE1kUhxF/ffwxnsyw0oUf0aGSy3OcpV+2EnBNsiz/iBDMPa4PMH4Ins7GaKLHBZdBydKfXQ6XGjQ67yMIp+2snwO7ZJcyOEhH3ZNoIxKpJ5L0VWgU/yvZEJfaVyrVCIs49UsleII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777057847; c=relaxed/simple;
	bh=Kutt5RziK7B4J9PxLnzTU0lFDw2fwTIBmB5267AXipM=;
	h=Date:To:From:Subject:Message-Id; b=huYDgEa4VuHrt0be/j2aFUrsnar4/c/mwhnQBOGLtB+po86u16yILwrNqGz0nEUX9DVupc57NQbzD4HH+M3D3/qWu/TOzXtRCofEdK9c0+DtneNI+x/nVxToT12OGoIU6yuyKNcNfFhfLEd4swx+IhvRZDkVtQfaqwsiztKQNNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NWof5/Pn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NWof5/Pn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2659C19425;
	Fri, 24 Apr 2026 19:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777057846;
	bh=Kutt5RziK7B4J9PxLnzTU0lFDw2fwTIBmB5267AXipM=;
	h=Date:To:From:Subject:From;
	b=NWof5/Pn6zl4oIWPbHDkhC1O6XHqTgze+wfEeC8oRo1msK5hduCeJX4VmB77Ldgwt
	 g/xDKZ8/MWEywU8RbQXyKkXZ1wnYTujDDVl1lWouR76k76nTnMxaRvzaTZHZE6t8K6
	 Ph+ELLcUhyzjXhBB98/XF6pkStyJoRyCBO+wbu0M=
Date: Fri, 24 Apr 2026 12:10:46 -0700
To: mm-commits@vger.kernel.org,usama.arif@linux.dev,rppt@kernel.org,peterx@redhat.com,ljs@kernel.org,liam.howlett@oracle.com,jannh@google.com,devnexen@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-userfaultfd-detect-vma-type-change-after-copy-retry-in-mfill_copy_folio_retry.patch added to mm-hotfixes-unstable branch
Message-Id: <20260424191046.C2659C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/userfaultfd: detect VMA type change after copy retry in mfill_copy_folio_retry()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-userfaultfd-detect-vma-type-change-after-copy-retry-in-mfill_copy_folio_retry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-userfaultfd-detect-vma-type-change-after-copy-retry-in-mfill_copy_folio_retry.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: David Carlier <devnexen@gmail.com>
Subject: mm/userfaultfd: detect VMA type change after copy retry in mfill_copy_folio_retry()
Date: Fri, 24 Apr 2026 19:36:38 +0100

mfill_copy_folio_retry() drops mmap_lock for the copy_from_user() call.
During this window, the VMA can be replaced with a different type (e.g.
hugetlb), making the caller's ops pointer stale.  Subsequent use of the
stale ops would dispatch into the wrong per-vma handlers.

Capture the VMA's ops via vma_uffd_ops() before dropping the lock and
compare against the current vma_uffd_ops() after re-acquiring it.
Return -EAGAIN if they differ so the operation can be retried.  This
avoids comparing against the caller's ops which may have been
overridden to anon_uffd_ops for MAP_PRIVATE file-backed mappings.

Link: https://lore.kernel.org/20260424183638.196227-1-devnexen@gmail.com
Fixes: 6ab703034f14 ("userfaultfd: mfill_atomic(): remove retry logic")
Reported-by: Usama Arif <usama.arif@linux.dev>
Closes: https://lore.kernel.org/all/20260410114809.3592720-1-usama.arif@linux.dev/
Signed-off-by: David Carlier <devnexen@gmail.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/mm/userfaultfd.c~mm-userfaultfd-detect-vma-type-change-after-copy-retry-in-mfill_copy_folio_retry
+++ a/mm/userfaultfd.c
@@ -443,8 +443,10 @@ static int mfill_copy_folio_locked(struc
 	return ret;
 }
 
-static int mfill_copy_folio_retry(struct mfill_state *state, struct folio *folio)
+static int mfill_copy_folio_retry(struct mfill_state *state,
+				  struct folio *folio)
 {
+	const struct vm_uffd_ops *orig_ops = vma_uffd_ops(state->vma);
 	unsigned long src_addr = state->src_addr;
 	void *kaddr;
 	int err;
@@ -465,6 +467,14 @@ static int mfill_copy_folio_retry(struct
 	if (err)
 		return err;
 
+	/*
+	 * The VMA type may have changed while the lock was dropped
+	 * (e.g. replaced with a hugetlb mapping), making the caller's
+	 * ops pointer stale.
+	 */
+	if (vma_uffd_ops(state->vma) != orig_ops)
+		return -EAGAIN;
+
 	err = mfill_establish_pmd(state);
 	if (err)
 		return err;
_

Patches currently in -mm which might be from devnexen@gmail.com are

mm-userfaultfd-detect-vma-type-change-after-copy-retry-in-mfill_copy_folio_retry.patch
mm-hugetlb-restore-reservation-on-error-in-hugetlb_mfill_atomic_pte-resubmission-path.patch

