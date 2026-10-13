Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360F05326A3;
	Tue, 13 Oct 2026 18:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791916174; cv=none; b=nt/MPwFAe04Fbd2oO53XxHmRiQ7OeooNIl/LmsDqc9Puw+mO4C7Y7nUqJes7eTjge0nLpGjTMTkdoE1x83HQg7M4lZrODsxF5wTMlFZJ7LXcwV02V7TNeHMueXHPt0obzvxg95MLyeMYXEqI8PXPlrLczsjTuc6rt7zzL6U+LgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791916174; c=relaxed/simple;
	bh=sY4ri5KkRDP1f9PCewyGC2xiEt/fnwA2LJGprVDBQeE=;
	h=Date:To:From:Subject:Message-Id; b=Yfdo48m93d0urFP7vXXJKluIsqiXOOvjNllJjTlFvlCxCqDVoUUNtmGNJXkECtW155BfCX5U8AWu17llXPCnNmn+11QjG0s0A/hynUMn4Mp8qIcay113S/NPVgtA3sY6wwb8wQP8j2h+xnxQ7/h8/N10yZhWOp+0R6ldokWNKkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q3K8Qpsw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q3K8Qpsw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 918131F000FF;
	Tue, 13 Oct 2026 18:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791916172;
	bh=GwxJ6gi2tw0TyLjuKIxJ+++k7TKkTsP9XUDRa+tV2Qk=;
	h=Date:To:From:Subject;
	b=q3K8Qpswmy3B8F2z1fYKksQJRWVO884N7l/qeFqQzOVlcXAOSKthUg84KG3cqsPPq
	 DsmOEys8EoY1xyeB8EPNTjPmJuy3cXgl6Yn6kJs4GvKonTKDBPkDfrmXkfFL3RFuwX
	 595ON5rd7e3f+dxtJUVRmFTMdB1S0YJ4S7vIjbQQ=
Date: Tue, 13 Oct 2026 11:29:32 -0700
To: mm-commits@vger.kernel.org,tgopinath@linux.microsoft.com,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,peterx@redhat.com,david@kernel.org,AutonomousCodeSecurity@microsoft.com,aarcange@redhat.com,cenzhang@linux.microsoft.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-fix-uffdio_move-livelock-on-large-folio-with-extra-references.patch added to mm-new branch
Message-Id: <20261013182932.918131F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: userfaultfd: fix UFFDIO_MOVE livelock on large folio with extra references
has been added to the -mm mm-new branch.  Its filename is
     userfaultfd-fix-uffdio_move-livelock-on-large-folio-with-extra-references.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-fix-uffdio_move-livelock-on-large-folio-with-extra-references.patch

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
From: "Cen Zhang (Microsoft)" <cenzhang@linux.microsoft.com>
Subject: userfaultfd: fix UFFDIO_MOVE livelock on large folio with extra references
Date: Mon, 12 Oct 2026 16:15:14 -0400

To move one page out of a large folio, move_pages_ptes() first has to
split the folio.  __folio_split() refuses if the folio has any reference
beyond its page table mappings and the caller's own, and it reports the
refusal as -EAGAIN.  move_pages() treats returned -EAGAIN as a transient
race and keeps retrying the same address, holding the VMA read locks the
whole time.  This is incorrect since in some cases userspace can hold such
a reference indefinitely, such as by registering the page as an io_uring
buffer.

An unprivileged user can trigger this with three threads: first holds such
a reference on a page of a THP, second calls UFFDIO_MOVE on another page
of the same THP and spins in the kernel forever holding the VMA read
locks, and third calls fork() or mprotect(), which takes mmap_lock for
writing and then waits forever for those read locks.  From then on every
mmap_lock user of that mm hangs, including other processes inspecting it
through /proc/<pid>/, until the process is SIGKILLed.  The hung task
detector reports the blocked tasks (third one), and with
kernel.hung_task_panic=1 the machine panics:

  INFO: task wedge:95 blocked for more than 122 seconds.
  task:wedge  state:D stack:12528 pid:95 tgid:95 ppid:94
  Call Trace:
   __schedule+0x596/0x1110
   schedule+0x36/0xf0
   __vma_start_exclude_readers+0x100/0x170
   __vma_start_write+0x51/0xd0
   __split_vma+0x208/0x3d0
   vma_modify+0x6a8/0x840
   vma_modify_flags+0xce/0x110
   mprotect_fixup+0xbe/0x480
   do_mprotect_pkey+0x2d9/0x580
   __x64_sys_mprotect+0x1a/0x30

Fix by returning -EBUSY instead of -EAGAIN in move_pages_ptes(), the
caller of split_folio(), when the split fails.  Thus, move_pages() does
not retry -EBUSY and the ioctl drops its locks and returns to userspace
instead of spinning.

Link: https://lore.kernel.org/20261012201514.97015-1-cenzhang@linux.microsoft.com
Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Signed-off-by: Cen Zhang (Microsoft) <cenzhang@linux.microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: <AutonomousCodeSecurity@microsoft.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: LLM
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: <tgopinath@linux.microsoft.com>
Cc: <stable@vger.kernel.org>
---

 mm/userfaultfd.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/userfaultfd.c~userfaultfd-fix-uffdio_move-livelock-on-large-folio-with-extra-references
+++ a/mm/userfaultfd.c
@@ -1637,8 +1637,12 @@ retry:
 			pte_unmap(dst_pte);
 			src_pte = dst_pte = NULL;
 			ret = split_folio(src_folio);
-			if (ret)
+			if (ret) {
+				/* do not retry, extra refs may be held forever */
+				if (ret == -EAGAIN)
+					ret = -EBUSY;
 				goto out;
+			}
 			/* have to reacquire the folio after it got split */
 			folio_unlock(src_folio);
 			folio_put(src_folio);
_

Patches currently in -mm which might be from cenzhang@linux.microsoft.com are

userfaultfd-fix-uffdio_move-livelock-on-large-folio-with-extra-references.patch

