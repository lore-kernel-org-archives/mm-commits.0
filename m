Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE115367F28
	for <mm-commits@vger.kernel.org>; Thu, 29 Jan 2026 21:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769723810; cv=none; b=l+Gyw2fP9ePT3vQ/ROCYkBWH7snRgn3bRF+TLhd9QKnPytCYsCoPSE19dFR4HwHw8lDNSVMvIs29LVN9VuH57XTLHBJVFHwuFn/VUJ0e3C4NsejhSScnV+LdvkLWZEFd+dZ9Kl0NWR4krLT/Oe0x2nbYY7vlqXYq82m4rOP9Lwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769723810; c=relaxed/simple;
	bh=Bp52rFN4qQLDAF898j65IXI2uhrAUAaNTiSmocR1sUw=;
	h=Date:To:From:Subject:Message-Id; b=NuvcXXJQWuQbIv7eiBXKFvmi0JySTSyW/CCLdx1CM4iTJO+mb3InXuwqqD+ePc5PUt1zU7xIrFkP+7OTWxyCVHjpaiO40wWiEg2RxzYAXhOlKguNZMG5x2CUyDFo3B+1JtzN6HU9QCGEo0iGu07YPElkmsaKJpFAxMGhGLs3mOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nbR2sDft; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nbR2sDft"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B361C4CEF7;
	Thu, 29 Jan 2026 21:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769723810;
	bh=Bp52rFN4qQLDAF898j65IXI2uhrAUAaNTiSmocR1sUw=;
	h=Date:To:From:Subject:From;
	b=nbR2sDftrg84/yChzHEy9Q5e/7ZMxKyq9CUybpj+dRN60qykcEmDzm/0Phlevxc9M
	 SbOYTaMnOoNXgpWeTi311ymo8jrFRbzH8RBoQ+Y8XN4Bvgto65QWWqpUXAegnDaYCZ
	 //6oDBgNoCGdE2L20HOR0Oadnd8uGywBoW49hVVs=
Date: Thu, 29 Jan 2026 13:56:49 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,mykyta.yatsenko5@gmail.com,Liam.Howlett@Oracle.com,andrii@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + procfs-avoid-fetching-build-id-while-holding-vma-lock-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20260129215650.3B361C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: procfs-avoid-fetching-build-id-while-holding-vma-lock-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     procfs-avoid-fetching-build-id-while-holding-vma-lock-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/procfs-avoid-fetching-build-id-while-holding-vma-lock-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: procfs-avoid-fetching-build-id-while-holding-vma-lock-fix
Date: Thu Jan 29 01:54:41 PM PST 2026

fix kerneldoc, per Mykyta Yatsenko

Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Mykyta Yatsenko <mykyta.yatsenko5@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/buildid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/buildid.c~procfs-avoid-fetching-build-id-while-holding-vma-lock-fix
+++ a/lib/buildid.c
@@ -315,7 +315,7 @@ out:
 	return ret;
 }
 
-/*
+/**
  * Parse build ID of ELF file mapped to vma
  * @vma:      vma object
  * @build_id: buffer to store build id, at least BUILD_ID_SIZE long
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-add-wq_percpu-to-alloc_workqueue-users-fix.patch
mm-add-wq_percpu-to-alloc_workqueue-users-fix-fix.patch
sparc-mm-export-symbols-for-lazy_mmu_mode-kunit-tests-fix.patch
mm-vma-document-possible-vma-vm_refcnt-values-and-reference-comment-fix.patch
mm-vma-introduce-helper-struct-thread-through-exclusive-lock-fns-fix.patch
mm-pagewalk-use-min-to-simplify-the-code-fix.patch
mm-relocate-the-page-table-ceiling-and-floor-definitions-fix.patch
mm-update-shmem__file_-functions-to-use-vma_flags_t-fix.patch
procfs-avoid-fetching-build-id-while-holding-vma-lock-fix.patch

