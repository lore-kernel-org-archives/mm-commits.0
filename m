Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1401F2C21E6
	for <mm-commits@vger.kernel.org>; Wed,  1 Apr 2026 03:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775015430; cv=none; b=r/+JbGShGteu4atpeGkqjlgZVToWgz2sncnYUKfZEEtIrjQoXVTfenu260FXH+DmZtQ7YrpJUemmD/isfcZmEg+u4SCrSke8DdQWC/xETzSxHrz/iys6t1BKFRZ2uu0CqteusL+R/BIlzXtTkH9IQjJFB0AZK5GoxaUD3RbizPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775015430; c=relaxed/simple;
	bh=rL/WNzG3SI/lQRXXBTIVVafNygEwq5qg03g6m1iDsk8=;
	h=Date:To:From:Subject:Message-Id; b=aHPggJrpGg0GDrJxqLVCjdfw3x/Fcufzsz2vXAGl+tsp7c8KIdbtvuqRp+6w19XC8Hv+tZAaIjlSHvCx5cRJ7XuWTaJG63dfEZ9qXEehjbSjLQ8lzkya7MuXWvSJBh5gjAds+6M70oVCO8SrF7qdzsIfWFxKwY4XaVV5tisMacs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tKFy3J2G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tKFy3J2G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD06C4CEF7;
	Wed,  1 Apr 2026 03:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775015429;
	bh=rL/WNzG3SI/lQRXXBTIVVafNygEwq5qg03g6m1iDsk8=;
	h=Date:To:From:Subject:From;
	b=tKFy3J2GUZkCAPNWcYv2WFScuQWY76OIQRsBNH11nKlbJERlsoiu3qdhdSt+0fieF
	 9cNsECv0Q920Jlh3SxKFpIOEZcsN15tFLZCdSMbo1giozGcoILX8PTUA6USlLNVZeV
	 Ip32CfD5TQNi2sd54Zoi2pEWAlhyWOJ5FeASEyNI=
Date: Tue, 31 Mar 2026 20:50:29 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,peterx@redhat.com,devnexen@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + shmem-userfaultfd-implement-shmem-uffd-operations-using-vm_uffd_ops-fix.patch added to mm-unstable branch
Message-Id: <20260401035029.9DD06C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/userfaultfd: detect VMA replacement after copy retry in mfill_copy_folio_retry()
has been added to the -mm mm-unstable branch.  Its filename is
     shmem-userfaultfd-implement-shmem-uffd-operations-using-vm_uffd_ops-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/shmem-userfaultfd-implement-shmem-uffd-operations-using-vm_uffd_ops-fix.patch

This patch will later appear in the mm-unstable branch at
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
shmem-userfaultfd-implement-shmem-uffd-operations-using-vm_uffd_ops-fix.patch

