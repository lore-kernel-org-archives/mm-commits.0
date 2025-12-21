Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C02761373;
	Sun, 21 Dec 2025 00:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766277265; cv=none; b=VmNwoh6ubw34xc5F0ZBuhDlCMufjpCDdQuQ03QkIc6SNAZ0Xbb8oVkfSkqgghJh2EEdtxF2jEu1IefpLqITMXTz5gXBtfzUwtFqt+fhugZq0SrxU3B6OCzyCZrms6GeoYftO9kWEb9u+xcdWglOQxchk1gLxhawWIAcAsMXfP5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766277265; c=relaxed/simple;
	bh=mt19WlHMn4QDFFY72gkaNDN9At3wZPfrx2tUE6tKYV4=;
	h=Date:To:From:Subject:Message-Id; b=TjLjDEvbUPqnAtfsCaRvJIoJcItMROBvEAtp1sVkB3pwrmXVO40ZqjTj4wdIRdK+0KbVDF80+9zBMkVXPZqgMRjcjeF6rSako8Cm9YFUVrrixtOkIEycDj7Qsw5fPJWw3ne88kfa33iBCi8t/4GjVvB9bOg8jdQ2DHQuewbEXLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NiVQeZqm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NiVQeZqm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA8FC4CEF5;
	Sun, 21 Dec 2025 00:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766277265;
	bh=mt19WlHMn4QDFFY72gkaNDN9At3wZPfrx2tUE6tKYV4=;
	h=Date:To:From:Subject:From;
	b=NiVQeZqms9w+4S/MvgXBd9M/Od3Aq1HxT8ea3L4oMxx8YN2dt2q5bkp2KOYIr4eoU
	 AFGxEeQSnzHHPvlE3X5Uk3C0AXIAzo0rsOClLFYa/GvZ8MZ6SMbfvmAVtHsp0Ib6nR
	 2XxvwBxB3Dnh3x53q6FgAtK7f9QS4LIGf7R9z/CM=
Date: Sat, 20 Dec 2025 16:34:24 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,pfalcato@suse.de,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,jannh@google.com,david@redhat.com,christian.koenig@amd.com,alexander.deucher@amd.com,mpatocka@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fix-amdgpu-failure-with-periodic-signal.patch added to mm-hotfixes-unstable branch
Message-Id: <20251221003425.3BA8FC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: AMDGPU: fix failure with periodic signal
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fix-amdgpu-failure-with-periodic-signal.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fix-amdgpu-failure-with-periodic-signal.patch

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
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: AMDGPU: fix failure with periodic signal
Date: Fri, 7 Nov 2025 18:48:01 +0100 (CET)

If a process sets up a timer that periodically sends a signal in short
intervals and if it uses OpenCL on AMDGPU at the same time, we get random
errors.  Sometimes, probing the OpenCL device fails (strace shows that
open("/dev/kfd") failed with -EINTR).  Sometimes we get the message
"amdgpu: init_user_pages: Failed to register MMU notifier: -4" in the
syslog.

The bug can be reproduced with this program:
http://www.jikos.cz/~mikulas/testcases/opencl/opencl-bug-small.c

The root cause for these failures is in the function mm_take_all_locks. 
This function fails with -EINTR if there is pending signal.  The -EINTR is
propagated up the call stack to userspace and userspace fails if it gets
this error.

There is the following call chain: kfd_open -> kfd_create_process ->
create_process -> mmu_notifier_get -> mmu_notifier_get_locked ->
__mmu_notifier_register -> mm_take_all_locks -> "return -EINTR"

If the failure happens in init_user_pages, there is the following call
chain: init_user_pages -> amdgpu_hmm_register ->
mmu_interval_notifier_insert -> mmu_notifier_register ->
__mmu_notifier_register -> mm_take_all_locks -> "return -EINTR"

In order to fix these failures, this commit changes
signal_pending(current) to fatal_signal_pending(current) in
mm_take_all_locks, so that it is interrupted only if the signal is
actually killing the process.

Also, this commit skips pr_err in init_user_pages if the process is being
killed - in this situation, there was no error and so we don't want to
report it in the syslog.

I'm submitting this patch for the stable kernels, because this bug may
cause random failures in any OpenCL code.

Link: https://lkml.kernel.org/r/6f16b618-26fc-3031-abe8-65c2090262e7@redhat.com
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alexander Deucher <alexander.deucher@amd.com>
Cc: Christan König <christian.koenig@amd.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c |    9 +++++++--
 mm/vma.c                                         |    8 ++++----
 2 files changed, 11 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c~fix-amdgpu-failure-with-periodic-signal
+++ a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1070,8 +1070,13 @@ static int init_user_pages(struct kgd_me
 
 	ret = amdgpu_hmm_register(bo, user_addr);
 	if (ret) {
-		pr_err("%s: Failed to register MMU notifier: %d\n",
-		       __func__, ret);
+		/*
+		 * If we got EINTR because the process was killed, don't report
+		 * it, because no error happened.
+		 */
+		if (!(fatal_signal_pending(current) && ret == -EINTR))
+			pr_err("%s: Failed to register MMU notifier: %d\n",
+			       __func__, ret);
 		goto out;
 	}
 
--- a/mm/vma.c~fix-amdgpu-failure-with-periodic-signal
+++ a/mm/vma.c
@@ -2166,14 +2166,14 @@ int mm_take_all_locks(struct mm_struct *
 	 * is reached.
 	 */
 	for_each_vma(vmi, vma) {
-		if (signal_pending(current))
+		if (fatal_signal_pending(current))
 			goto out_unlock;
 		vma_start_write(vma);
 	}
 
 	vma_iter_init(&vmi, mm, 0);
 	for_each_vma(vmi, vma) {
-		if (signal_pending(current))
+		if (fatal_signal_pending(current))
 			goto out_unlock;
 		if (vma->vm_file && vma->vm_file->f_mapping &&
 				is_vm_hugetlb_page(vma))
@@ -2182,7 +2182,7 @@ int mm_take_all_locks(struct mm_struct *
 
 	vma_iter_init(&vmi, mm, 0);
 	for_each_vma(vmi, vma) {
-		if (signal_pending(current))
+		if (fatal_signal_pending(current))
 			goto out_unlock;
 		if (vma->vm_file && vma->vm_file->f_mapping &&
 				!is_vm_hugetlb_page(vma))
@@ -2191,7 +2191,7 @@ int mm_take_all_locks(struct mm_struct *
 
 	vma_iter_init(&vmi, mm, 0);
 	for_each_vma(vmi, vma) {
-		if (signal_pending(current))
+		if (fatal_signal_pending(current))
 			goto out_unlock;
 		if (vma->anon_vma)
 			list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
_

Patches currently in -mm which might be from mpatocka@redhat.com are

fix-amdgpu-failure-with-periodic-signal.patch

