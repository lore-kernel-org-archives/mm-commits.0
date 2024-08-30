Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53652AE84
	for <mm-commits@vger.kernel.org>; Fri, 30 Aug 2024 22:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725055852; cv=none; b=IBm9tbhcWRS8SDoPN+eDRHxXFgy81AMI6Cw5d44Hf2P6HKxng8FhekHM5X92zLKqX2Wpivt4PoqN3CUAHLwohXYKrQKtZMfC8fi4WDl+39JerGEWdxZv6oru8MQrQ3pWCDJZQlELoaas1zatmjm9vSf62yryKEj+gtDATPBGmoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725055852; c=relaxed/simple;
	bh=u8+ZG3zGtamyVNaJLU55UAbNU9iXsQlMF1rH0PPNmKo=;
	h=Date:To:From:Subject:Message-Id; b=BymADlFYd30IzhvuFcy32gZpv/5cchWxHYZKlh58W8eSV3MmO5kZT/tLw62NlzgdKFVdsJas+P7WxphjjqrFCE/DHTTjxIClQHndFoRV2gw5sumh0NGLYCLzM+Ps/YJ0i6UT3+je2lrPRAhsLx5FlUddPgimg7Jjxq46box1bp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1Isu7WlY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1Isu7WlY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69895C4CEC2;
	Fri, 30 Aug 2024 22:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725055852;
	bh=u8+ZG3zGtamyVNaJLU55UAbNU9iXsQlMF1rH0PPNmKo=;
	h=Date:To:From:Subject:From;
	b=1Isu7WlYJBOpsTD/zIE/571UWbjE0HDR969EhYjTn+VoRl/+QLcdCljS+Ai1uchfd
	 RPfgHBsdYZCR/h+ZnsvPhg+BstExriF/jRTbuJIk5PlJJZxAE29fgebggyAtS0SuN3
	 zu7OaAHkFhQmcLISx5mlHkX+Z3yt5870vDl37cjU=
Date: Fri, 30 Aug 2024 15:10:51 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,spasswolf@web.de,sidhartha.kumar@oracle.com,paul@paul-moore.com,paulmck@kernel.org,olsajiri@gmail.com,lstoakes@gmail.com,lorenzo.stoakes@oracle.com,kees@kernel.org,jeffxu@chromium.org,broonie@kernel.org,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-correctly-position-vma_iterator-in-__split_vma.patch added to mm-unstable branch
Message-Id: <20240830221052.69895C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: correctly position vma_iterator in __split_vma()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vma-correctly-position-vma_iterator-in-__split_vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-correctly-position-vma_iterator-in-__split_vma.patch

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
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/vma: correctly position vma_iterator in __split_vma()
Date: Fri, 30 Aug 2024 00:00:41 -0400

Patch series "Avoid MAP_FIXED gap exposure", v8.

It is now possible to walk the vma tree using the rcu read locks and is
beneficial to do so to reduce lock contention.  Doing so while a MAP_FIXED
mapping is executing means that a reader may see a gap in the vma tree
that should never logically exist - and does not when using the mmap lock
in read mode.  The temporal gap exists because mmap_region() calls
munmap() prior to installing the new mapping.

This patch set stops rcu readers from seeing the temporal gap by splitting
up the munmap() function into two parts.  The first part prepares the vma
tree for modifications by doing the necessary splits and tracks the vmas
marked for removal in a side tree.  The second part completes the
munmapping of the vmas after the vma tree has been overwritten (either by
a MAP_FIXED replacement vma or by a NULL in the munmap() case).

Please note that rcu walkers will still be able to see a temporary state
of split vmas that may be in the process of being removed, but the
temporal gap will not be exposed.  vma_start_write() are called on both
parts of the split vma, so this state is detectable.

If existing vmas have a vm_ops->close(), then they will be called prior to
mapping the new vmas (and ptes are cleared out).  Without calling
->close(), hugetlbfs tests fail (hugemmap06 specifically) due to resources
still being marked as 'busy'.  Unfortunately, calling the corresponding
->open() may not restore the state of the vmas, so it is safer to keep the
existing failure scenario where a gap is inserted and never replaced.  The
failure scenario is in its own patch (0015) for traceability.


This patch (of 21):

The vma iterator may be left pointing to the newly created vma.  This
happens when inserting the new vma at the end of the old vma (!new_below).

The incorrect position in the vma iterator is not exposed currently since
the vma iterator is repositioned in the munmap path and is not reused in
any of the other paths.

This has limited impact in the current code, but is required for future
changes.

Link: https://lkml.kernel.org/r/20240830040101.822209-2-Liam.Howlett@oracle.com
Fixes: b2b3b886738f ("mm: don't use __vma_adjust() in __split_vma()")
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Bert Karwatzki <spasswolf@web.de>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Jiri Olsa <olsajiri@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/vma.c~mm-vma-correctly-position-vma_iterator-in-__split_vma
+++ a/mm/vma.c
@@ -177,7 +177,7 @@ void unmap_region(struct mm_struct *mm,
 /*
  * __split_vma() bypasses sysctl_max_map_count checking.  We use this where it
  * has already been checked or doesn't make sense to fail.
- * VMA Iterator will point to the end VMA.
+ * VMA Iterator will point to the original VMA.
  */
 static int __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		       unsigned long addr, int new_below)
@@ -246,6 +246,9 @@ static int __split_vma(struct vma_iterat
 	/* Success. */
 	if (new_below)
 		vma_next(vmi);
+	else
+		vma_prev(vmi);
+
 	return 0;
 
 out_free_mpol:
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are

maple_tree-remove-rcu_read_lock-from-mt_validate.patch
mm-vma-correctly-position-vma_iterator-in-__split_vma.patch
mm-vma-introduce-abort_munmap_vmas.patch
mm-vma-introduce-vmi_complete_munmap_vmas.patch
mm-vma-extract-the-gathering-of-vmas-from-do_vmi_align_munmap.patch
mm-vma-introduce-vma_munmap_struct-for-use-in-munmap-operations.patch
mm-vma-change-munmap-to-use-vma_munmap_struct-for-accounting-and-surrounding-vmas.patch
mm-vma-extract-validate_mm-from-vma_complete.patch
mm-vma-inline-munmap-operation-in-mmap_region.patch
mm-vma-expand-mmap_region-munmap-call.patch
mm-vma-support-vma-==-null-in-init_vma_munmap.patch
mm-mmap-reposition-vma-iterator-in-mmap_region.patch
mm-vma-track-start-and-end-for-munmap-in-vma_munmap_struct.patch
mm-clean-up-unmap_region-argument-list.patch
mm-mmap-avoid-zeroing-vma-tree-in-mmap_region.patch
mm-change-failure-of-map_fixed-to-restoring-the-gap-on-failure.patch
mm-mmap-use-phys_pfn-in-mmap_region.patch
mm-mmap-use-vms-accounted-pages-in-mmap_region.patch
ipc-shm-mm-drop-do_vma_munmap.patch
mm-move-may_expand_vm-check-in-mmap_region.patch
mm-vma-drop-incorrect-comment-from-vms_gather_munmap_vmas.patch
mm-vmah-optimise-vma_munmap_struct.patch

