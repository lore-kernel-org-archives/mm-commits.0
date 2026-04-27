Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AAA93BA239
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 12:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777294526; cv=none; b=PJ/f4Q023g9SGoOvxgkdEnuB6w5Zr3hxm7QivXM5fEHwuICpGq5xxPVY0RmvFmHNO1DC3eEBJUgMp5M1Q1ZTfZJVhw/h2Zwr3uRpmRLEeGlSPXwXDZFHGgUFcv2pFzxe1qVsZYgJ3FJegb4tPw707lH8dgL86MmNAwcxj4Hf+2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777294526; c=relaxed/simple;
	bh=/SLSKbEVu3l6hK1r5zozAmCAcb6Pe2cA6EyW0AMKsnc=;
	h=Date:To:From:Subject:Message-Id; b=sAg6e5sr61/lut3qKb2NrAVwANPpoyUwrCslVeTmCH0lPfaQeKzafvj0Ih1R5TdKnCwqvX1MCv8wAUKRIBONZy+k//+AzAj9EqZAgbKcRU+hYI0IQmcBJZ4bHAjHOU58/IefSmYrZMIfxherE29suqjycTiJAY5bBBAG+UOo1Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ux/n9EYz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ux/n9EYz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1267FC19425;
	Mon, 27 Apr 2026 12:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777294526;
	bh=/SLSKbEVu3l6hK1r5zozAmCAcb6Pe2cA6EyW0AMKsnc=;
	h=Date:To:From:Subject:From;
	b=Ux/n9EYzCZihlmAALr1nvTRgQyRdejMttXBOKq8Yo9aISJkLLtWhhMFcD2FXeW3sc
	 WzJNv39cqCJ+1zWDAgMU7RvpZyTS1t69NmB3gF0dpdYml60WhOMB8MqheQtoNbz5yH
	 zQ8tZlxLSaYIQx1L/XraKzTkKLtsemkQGHC5KpKg=
Date: Mon, 27 Apr 2026 05:55:25 -0700
To: mm-commits@vger.kernel.org,usama.arif@linux.dev,rppt@kernel.org,peterx@redhat.com,ljs@kernel.org,liam.howlett@oracle.com,jannh@google.com,devnexen@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-userfaultfd-detect-vma-type-change-after-copy-retry-in-mfill_copy_folio_retry.patch removed from -mm tree
Message-Id: <20260427125526.1267FC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/userfaultfd: detect VMA type change after copy retry in mfill_copy_folio_retry()
has been removed from the -mm tree.  Its filename was
     mm-userfaultfd-detect-vma-type-change-after-copy-retry-in-mfill_copy_folio_retry.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-hugetlb-restore-reservation-on-error-in-hugetlb_mfill_atomic_pte-resubmission-path.patch
mm-page_io-rename-swap_iocb-fields-for-clarity.patch

