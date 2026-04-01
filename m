Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DCB9364051
	for <mm-commits@vger.kernel.org>; Wed,  1 Apr 2026 20:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775075342; cv=none; b=fFid0ZCgWl2BreDY5l1iE6LgdhAhTNKoCuwMFEDXXEmRjs9sbE1MYQ6OdnK1PyCJAgP11w453q1CricWEzX/+X1LymVwFmm3x6colQ+ny4iC0ptZHc3xXaPfvsgfgAMXZGE/CZtDVCmKq6NL9OaJ402KiMCd2XXYxZftqeyWAaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775075342; c=relaxed/simple;
	bh=esbNAGt1YtV7pWX0LCDQvnzdSUPnLzMdP12rfxmeDnQ=;
	h=Date:To:From:Subject:Message-Id; b=lpX0RpDMRBREmvtGLm8ArxteJtBTxW4LCmBIYubZjCFYcj8QtVQOB7WCgBiN6cIVhzwiQzbpYr1rs+nkyUq1NC3jlfFCCV6DVKTGS/tmR57kljIVQJlca79tVLZp89mmLDznkHkhIHwgUIkGcH+Q6CDs0MJXzW5iLikvpBZznBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k8NfK/lm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k8NfK/lm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A81C116C6;
	Wed,  1 Apr 2026 20:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775075341;
	bh=esbNAGt1YtV7pWX0LCDQvnzdSUPnLzMdP12rfxmeDnQ=;
	h=Date:To:From:Subject:From;
	b=k8NfK/lm34yr/A+blxG43fr83E5pWasGZCWbwpHWNif42PeMhrKufbWnPqcFiQhZ4
	 i44LFX4shbXr2x08C3BJsWFltnxudyG6HmP+DptBJZHYnAKtqfU01iUI3ZEFxl5QJ/
	 Ww4VejGS+irxwfsUUqvRV2Dw/P4eQNPdsZsN5Od8=
Date: Wed, 01 Apr 2026 13:29:01 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,peterx@redhat.com,devnexen@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] shmem-userfaultfd-implement-shmem-uffd-operations-using-vm_uffd_ops-fix.patch removed from -mm tree
Message-Id: <20260401202901.D1A81C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/userfaultfd: detect VMA replacement after copy retry in mfill_copy_folio_retry()
has been removed from the -mm tree.  Its filename was
     shmem-userfaultfd-implement-shmem-uffd-operations-using-vm_uffd_ops-fix.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: David Carlier <devnexen@gmail.com>
Subject: mm/userfaultfd: detect VMA replacement after copy retry in mfill_copy_folio_retry()
Date: Tue, 31 Mar 2026 14:41:58 +0100

In mfill_copy_folio_retry(), all locks are dropped to retry
copy_from_user() with page faults enabled.  During this window, the VMA
can be replaced entirely (e.g.  munmap + mmap + UFFDIO_REGISTER by another
thread), but the caller proceeds with a folio allocated from the original
VMA's backing store.

Checking ops alone is insufficient: the replacement VMA could be the same
type (e.g.  shmem -> shmem) with identical flags but a different backing
inode.  Take a snapshot of the VMA's file and flags before dropping locks,
and compare after re-acquiring them.  If anything changed, bail out with
-EINVAL.

Use get_file()/fput() rather than ihold()/iput() to hold the file
reference across the lock-dropped window, avoiding potential deadlocks
from filesystem eviction under mmap_lock.

Link: https://lkml.kernel.org/r/20260331134158.622084-1-devnexen@gmail.com
Signed-off-by: David Carlier <devnexen@gmail.com>
Suggested-by: Peter Xu <peterx@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   63 ++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 56 insertions(+), 7 deletions(-)

--- a/mm/userfaultfd.c~shmem-userfaultfd-implement-shmem-uffd-operations-using-vm_uffd_ops-fix
+++ a/mm/userfaultfd.c
@@ -444,33 +444,82 @@ static int mfill_copy_folio_locked(struc
 	return ret;
 }
 
+struct vma_snapshot {
+	struct file *file;
+	vma_flags_t flags;
+};
+
+static void vma_snapshot_take(struct vm_area_struct *vma,
+			      struct vma_snapshot *s)
+{
+	memcpy(&s->flags, &vma->flags, sizeof(s->flags));
+	if (vma->vm_file)
+		s->file = get_file(vma->vm_file);
+	else
+		s->file = NULL;
+}
+
+static bool vma_snapshot_changed(struct vm_area_struct *vma,
+				 struct vma_snapshot *s)
+{
+	if (memcmp(&s->flags, &vma->flags, sizeof(s->flags)))
+		return true;
+
+	if (s->file && (!vma->vm_file ||
+	    vma->vm_file->f_inode != s->file->f_inode))
+		return true;
+
+	if (!s->file && !vma_is_anonymous(vma))
+		return true;
+
+	return false;
+}
+
+static void vma_snapshot_release(struct vma_snapshot *s)
+{
+	if (s->file) {
+		fput(s->file);
+		s->file = NULL;
+	}
+}
+
 static int mfill_copy_folio_retry(struct mfill_state *state, struct folio *folio)
 {
 	unsigned long src_addr = state->src_addr;
+	struct vma_snapshot s;
 	void *kaddr;
 	int err;
 
+	/* Take a quick snapshot of the current vma */
+	vma_snapshot_take(state->vma, &s);
+
 	/* retry copying with mm_lock dropped */
 	mfill_put_vma(state);
 
 	kaddr = kmap_local_folio(folio, 0);
 	err = copy_from_user(kaddr, (const void __user *) src_addr, PAGE_SIZE);
 	kunmap_local(kaddr);
-	if (unlikely(err))
-		return -EFAULT;
+	if (unlikely(err)) {
+		err = -EFAULT;
+		goto out;
+	}
 
 	flush_dcache_folio(folio);
 
 	/* reget VMA and PMD, they could change underneath us */
 	err = mfill_get_vma(state);
 	if (err)
-		return err;
+		goto out;
 
-	err = mfill_establish_pmd(state);
-	if (err)
-		return err;
+	if (vma_snapshot_changed(state->vma, &s)) {
+		err = -EINVAL;
+		goto out;
+	}
 
-	return 0;
+	err = mfill_establish_pmd(state);
+out:
+	vma_snapshot_release(&s);
+	return err;
 }
 
 static int __mfill_atomic_pte(struct mfill_state *state,
_

Patches currently in -mm which might be from devnexen@gmail.com are

mm-hugetlb-restore-reservation-on-error-in-hugetlb_mfill_atomic_pte-resubmission-path.patch
mm-page_io-fix-pswpin-undercount-for-large-folios-in-sio_read_complete.patch

