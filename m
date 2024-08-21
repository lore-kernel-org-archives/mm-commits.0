Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B838753370
	for <mm-commits@vger.kernel.org>; Wed, 21 Aug 2024 02:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724206076; cv=none; b=AS4LTJpDYFaKm9VL9ooODnyiUzvhxKCzAJUKFjEAO7E0yFhkij3VqRAbQnLHcb9Ky0jj7oewbwI1Pi7lwBJzXnUHcjs9/CTwYVTJNyMynnALycIt2fpYI3N4223YUz1FyL4LuSe4CK0ai/IRvtJk5iGqOGjyrdSmKOdIBC47RZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724206076; c=relaxed/simple;
	bh=ej/6DknchUdQGqSTsiRV13NMrt9kkgbgQQXa77eb110=;
	h=Date:To:From:Subject:Message-Id; b=h2npLQdRPwWLjGTIh7UWhgrn+H4Ul/GmAoMxGMtpUZev+ECOMItiY4Nr6+Z8xKFMmV1tBifuZlcuiyGBLvWj/SXzEPPctNKxjf8R/fkF7c/Lr4Y86AqZK1hGnAwJHkmiNmZSSbX2CdGPeVRSIgFF9DbCEhICug9ZVQmEWnPzldQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kDSiFicS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kDSiFicS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28AA3C4AF12;
	Wed, 21 Aug 2024 02:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724206076;
	bh=ej/6DknchUdQGqSTsiRV13NMrt9kkgbgQQXa77eb110=;
	h=Date:To:From:Subject:From;
	b=kDSiFicSzGjHNU0mobF/Cb6IPE3BGqs4rHOZ6cQhnEJHNLRdC6jkwyRS8a7o7FsvB
	 xzQXEVolDY47PjMAI3Vvge6nfRHnuP2L13exICHp6OTp0Ki9VFsSQpWNFLQei/H+OR
	 pXMWc2xa89WuHYa5NxglWEBTU5TKMqY/vuq+4rvM=
Date: Tue, 20 Aug 2024 19:07:55 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,torvalds@linux-foundation.org,shuah@kernel.org,mpe@ellerman.id.au,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,kees@kernel.org,jeffxu@chromium.org,pedro.falcato@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mprotect-replace-can_modify_mm-with-can_modify_vma.patch added to mm-unstable branch
Message-Id: <20240821020756.28AA3C4AF12@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mprotect: replace can_modify_mm with can_modify_vma
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mprotect-replace-can_modify_mm-with-can_modify_vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mprotect-replace-can_modify_mm-with-can_modify_vma.patch

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
From: Pedro Falcato <pedro.falcato@gmail.com>
Subject: mm/mprotect: replace can_modify_mm with can_modify_vma
Date: Sat, 17 Aug 2024 01:18:30 +0100

Avoid taking an extra trip down the mmap tree by checking the vmas
directly.  mprotect (per POSIX) tolerates partial failure.

Link: https://lkml.kernel.org/r/20240817-mseal-depessimize-v3-3-d8d2e037df30@gmail.com
Signed-off-by: Pedro Falcato <pedro.falcato@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/mm/mprotect.c~mm-mprotect-replace-can_modify_mm-with-can_modify_vma
+++ a/mm/mprotect.c
@@ -611,6 +611,9 @@ mprotect_fixup(struct vma_iterator *vmi,
 	unsigned long charged = 0;
 	int error;
 
+	if (!can_modify_vma(vma))
+		return -EPERM;
+
 	if (newflags == oldflags) {
 		*pprev = vma;
 		return 0;
@@ -769,15 +772,6 @@ static int do_mprotect_pkey(unsigned lon
 		}
 	}
 
-	/*
-	 * checking if memory is sealed.
-	 * can_modify_mm assumes we have acquired the lock on MM.
-	 */
-	if (unlikely(!can_modify_mm(current->mm, start, end))) {
-		error = -EPERM;
-		goto out;
-	}
-
 	prev = vma_prev(&vmi);
 	if (start > vma->vm_start)
 		prev = vma;
_

Patches currently in -mm which might be from pedro.falcato@gmail.com are

selftests-mm-add-mseal-test-for-no-discard-madvise.patch
selftests-mm-add-mseal-test-for-no-discard-madvise-fix.patch
mm-move-can_modify_vma-to-mm-vmah.patch
mm-munmap-replace-can_modify_mm-with-can_modify_vma.patch
mm-mprotect-replace-can_modify_mm-with-can_modify_vma.patch
mm-mremap-replace-can_modify_mm-with-can_modify_vma.patch
mseal-replace-can_modify_mm_madv-with-a-vma-variant.patch
mm-remove-can_modify_mm.patch
selftests-mm-add-more-mseal-traversal-tests.patch

