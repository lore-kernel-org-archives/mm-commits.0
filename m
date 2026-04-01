Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A35039934A
	for <mm-commits@vger.kernel.org>; Wed,  1 Apr 2026 17:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775065049; cv=none; b=GlA/k3dZuqjLzoy+iGXO8hak/XbH0WJPfzx7/xJ12b2A0K9CUqpbnxs7aTgftHjvplOiilCd75Y1HGmZtLlp5sDOJQ0K3R+q4MvK9WUDyGtq3lvU0n/OLX106t6RhYTEdUQlVkfCB7ORrr+PHDCkXzW+vPj7Br9ArJ8dGLgrptA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775065049; c=relaxed/simple;
	bh=iLCqNqIkKBTZ2jGmKB9vQrXz69TW184meNdmcTU/pLY=;
	h=Date:To:From:Subject:Message-Id; b=SDrXDtO92AxndyEJvzmQcNIhY3crnV+w/GnDkm1RCpxwiLN8jauBTREMuJJGGlie1QFxgDjOiNNl8/xElSKtHRdCeV23aieM0/1cNGF7Op9pwDye4jAYx06GdhRWkRqSDh34ERdzsNM1Eu8i4fSYFH8p0piFOHXkpIhgGFNNcOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ADFzkGxB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ADFzkGxB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2A6FC4CEF7;
	Wed,  1 Apr 2026 17:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775065048;
	bh=iLCqNqIkKBTZ2jGmKB9vQrXz69TW184meNdmcTU/pLY=;
	h=Date:To:From:Subject:From;
	b=ADFzkGxBIa9DP+yZV2r+B3c5OPF+0QmMw0b1IJHL9xRrq1+j6sg3h54qYKLlez/73
	 Hy5RRAQ95iZRG1qML8c4ZMusadqPz3daZj8UBSQsYBfabYgxWChadGPOwcC8uUiP+n
	 dqavmLNVNlFd0xfJVHXFoT3s/gt1/V9Bxox8CpFQ=
Date: Wed, 01 Apr 2026 10:37:28 -0700
To: mm-commits@vger.kernel.org,harry@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-introduce-struct-mfill_state-fix.patch added to mm-unstable branch
Message-Id: <20260401173728.A2A6FC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: userfaultfd-introduce-struct-mfill_state-fix
has been added to the -mm mm-unstable branch.  Its filename is
     userfaultfd-introduce-struct-mfill_state-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-introduce-struct-mfill_state-fix.patch

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
From: Mike Rapoport <rppt@kernel.org>
Subject: userfaultfd-introduce-struct-mfill_state-fix
Date: Wed, 1 Apr 2026 10:36:03 +0300

fix bisection hole, per Harry

Link: https://lkml.kernel.org/r/aczK4-vrULRiTvyh@kernel.org
Signed-off-by: Mike Rapoport <rppt@kernel.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/userfaultfd.c~userfaultfd-introduce-struct-mfill_state-fix
+++ a/mm/userfaultfd.c
@@ -764,6 +764,7 @@ retry:
 		err = PTR_ERR(dst_vma);
 		goto out;
 	}
+	state.vma = dst_vma;
 
 	/*
 	 * If memory mappings are changing because of non-cooperative
@@ -804,8 +805,6 @@ retry:
 	    uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE))
 		goto out_unlock;
 
-	state.vma = dst_vma;
-
 	while (state.src_addr < src_start + len) {
 		VM_WARN_ON_ONCE(state.dst_addr >= dst_start + len);
 
_

Patches currently in -mm which might be from rppt@kernel.org are

userfaultfd-introduce-mfill_copy_folio_locked-helper.patch
userfaultfd-introduce-struct-mfill_state.patch
userfaultfd-introduce-struct-mfill_state-fix.patch
userfaultfd-introduce-mfill_establish_pmd-helper.patch
userfaultfd-introduce-mfill_get_vma-and-mfill_put_vma.patch
userfaultfd-retry-copying-with-locks-dropped-in-mfill_atomic_pte_copy.patch
userfaultfd-move-vma_can_userfault-out-of-line.patch
userfaultfd-introduce-vm_uffd_ops.patch
shmem-userfaultfd-use-a-vma-callback-to-handle-uffdio_continue.patch
userfaultfd-introduce-vm_uffd_ops-alloc_folio.patch
shmem-userfaultfd-implement-shmem-uffd-operations-using-vm_uffd_ops.patch
userfaultfd-mfill_atomic-remove-retry-logic.patch

