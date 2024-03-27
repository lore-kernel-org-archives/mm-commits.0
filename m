Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889B514D280
	for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2024 19:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711567278; cv=none; b=ZCIBUeKhdMfd9S3Yr5HJWJ2qP9YFK+/3ZgAqRcqTbZFNfZFIEtiGf4XwOguZbd5WiVYq/qp20lq0dK5PqqgWQ8IZLiYiYS4nS24Q3HO2o6ThDgCPLIqGWLXTF+Y1JTPseHUA4skM5aFkjeHHppQxqlBBf55T60F495FSjwusN84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711567278; c=relaxed/simple;
	bh=MG5h8oZobTQQvSaPa4k4iw7pU/2HTlEJAJ6M9JeH3t4=;
	h=Date:To:From:Subject:Message-Id; b=ndCJmuUAEgeUGPEYbtBUJtqHDz9BFsSzDPteK7vBAgeYROryBj14LmiPOj9EogxaspaM7w0mFJzbwHCJpXmRrWp2EVps/QVX33Txhk014u5BQQAyXklv/bwyOgkiteXDH+3rQLaFd9Jl3NhhRYWilQfSTmvywkUFoRo7rmFAu0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MzH32Tuo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MzH32Tuo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13936C433F1;
	Wed, 27 Mar 2024 19:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711567278;
	bh=MG5h8oZobTQQvSaPa4k4iw7pU/2HTlEJAJ6M9JeH3t4=;
	h=Date:To:From:Subject:From;
	b=MzH32Tuo9ONdfaxiO5FCWVJnaRgw4V0GKYnQXEcucqwtQU8af8iBDA8GG9Nd41W4P
	 tOpvpFSx4MzfQrE8BQ9dwfwWIwfQ6uQa7QB6WwaawPjY2Exb/egSAl0jwUoPkBQ5Rm
	 65QMvipZv9LIgwJOnaJCzyxkNC/bxSDr6Bwt95cc=
Date: Wed, 27 Mar 2024 12:21:17 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-optimize-config_per_vma_lock-member-placement-in-vm_area_struct.patch added to mm-unstable branch
Message-Id: <20240327192118.13936C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: optimize CONFIG_PER_VMA_LOCK member placement in vm_area_struct
has been added to the -mm mm-unstable branch.  Its filename is
     mm-optimize-config_per_vma_lock-member-placement-in-vm_area_struct.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-optimize-config_per_vma_lock-member-placement-in-vm_area_struct.patch

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
Subject: mm: optimize CONFIG_PER_VMA_LOCK member placement in vm_area_struct
Date: Wed, 27 Mar 2024 15:35:48 +0100

Currently, we end up wasting some memory in each vm_area_struct. Pahole
states that:
	[...]
	int                        vm_lock_seq;          /*    40     4 */

	/* XXX 4 bytes hole, try to pack */

	struct vma_lock *          vm_lock;              /*    48     8 */
	bool                       detached;             /*    56     1 */

	/* XXX 7 bytes hole, try to pack */
	[...]

Let's reduce the holes and memory wastage by moving the bool:
	[...]
	bool                       detached;             /*    40     1 */

	/* XXX 3 bytes hole, try to pack */

	int                        vm_lock_seq;          /*    44     4 */
	struct vma_lock *          vm_lock;              /*    48     8 */
	[...]

Effectively shrinking the vm_area_struct with CONFIG_PER_VMA_LOCK by
8 byte.

Likely, we could place "detached" in the lowest bit of vm_lock, but at
least on 64bit that won't really make a difference, so keep it simple.

Link: https://lkml.kernel.org/r/20240327143548.744070-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/mm_types.h~mm-optimize-config_per_vma_lock-member-placement-in-vm_area_struct
+++ a/include/linux/mm_types.h
@@ -671,6 +671,9 @@ struct vm_area_struct {
 	};
 
 #ifdef CONFIG_PER_VMA_LOCK
+	/* Flag to indicate areas detached from the mm->mm_mt tree */
+	bool detached;
+
 	/*
 	 * Can only be written (using WRITE_ONCE()) while holding both:
 	 *  - mmap_lock (in write mode)
@@ -687,9 +690,6 @@ struct vm_area_struct {
 	 */
 	int vm_lock_seq;
 	struct vma_lock *vm_lock;
-
-	/* Flag to indicate areas detached from the mm->mm_mt tree */
-	bool detached;
 #endif
 
 	/*
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
mm-merge-folio_is_secretmem-and-folio_fast_pin_allowed-into-gup_fast_folio_allowed.patch
mm-optimize-config_per_vma_lock-member-placement-in-vm_area_struct.patch

