Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3D0145B3E
	for <mm-commits@vger.kernel.org>; Sun, 26 Oct 2025 04:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761451895; cv=none; b=aR/PX2dZz1+fvDfDIwS98g06XSX1v6zuCIht3dXncIosu6HlrzWpEuQGdYmIdrGaW1wVJgOxKmYxC8gEpi+w9eai952CmTwMNbUOsHRS/KO0PTmzjocnU7MZ31qOZIzPD5pM//TDsdXBryWaEOeLtF3l79PvCxn/7GYcIF1PORk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761451895; c=relaxed/simple;
	bh=y6LyZNLlTuwZBWtxkdTvxdJZAifeWK7FDjittNLatCs=;
	h=Date:To:From:Subject:Message-Id; b=Ovc5BGGUKErW1Rz9hTSCgvqNWz+AhMurteJt44372OrZ5ZxaHJ03jBurLuYJwypWD6Qo+p2uS/2CkXacJxNOtgyqCJfIptfghSh1Dfe18AR6p724hkzRhm6pKfDdmMipSRoW3aFjvPxJ51jxtCT6h7PcxQFXbgRMXKcK1/iXOx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VUqbE2MM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VUqbE2MM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF477C4CEE7;
	Sun, 26 Oct 2025 04:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761451895;
	bh=y6LyZNLlTuwZBWtxkdTvxdJZAifeWK7FDjittNLatCs=;
	h=Date:To:From:Subject:From;
	b=VUqbE2MM5FduX3VPk9IKsT0NROUw5Hb8A9ASzYoTcTu6gMHKtsyg+N+Fo5d8pmPLD
	 gF9jbDR/qmwFHzImy6swtboU/ilmB5RFHBBa9uLnLpKwBn3gAElMhP7VLSfKSunxJs
	 LdUQQXke5zEROWgroB4+bVizff7/E9j0kfBwvDPc=
Date: Sat, 25 Oct 2025 21:11:34 -0700
To: mm-commits@vger.kernel.org,yan.y.zhao@intel.com,pmladek@suse.com,mpdesouza@suse.com,mario.limonciello@amd.com,gunnarku@amazon.com,graf@amazon.com,bhe@redhat.com,andriy.shevchenko@intel.com,jbouron@amazon.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec_core-remove-superfluous-page-offset-handling-in-segment-loading-v3.patch added to mm-nonmm-unstable branch
Message-Id: <20251026041134.EF477C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kexec_core-remove-superfluous-page-offset-handling-in-segment-loading-v3
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec_core-remove-superfluous-page-offset-handling-in-segment-loading-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec_core-remove-superfluous-page-offset-handling-in-segment-loading-v3.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Justinien Bouron <jbouron@amazon.com>
Subject: kexec_core-remove-superfluous-page-offset-handling-in-segment-loading-v3
Date: Fri, 24 Oct 2025 08:50:09 -0700

Removed unused variable in kimage_load_cma_segment() which was causing a
warning and failing build with `make W=1`.  Thanks Andy Shevchenko for
finding this issue

Link: https://lkml.kernel.org/r/20251024155009.39502-1-jbouron@amazon.com
Signed-off-by: Justinien Bouron <jbouron@amazon.com>
Reviewed-by: Gunnar Kudrjavets <gunnarku@amazon.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Marcos Paulo de Souza <mpdesouza@suse.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/kernel/kexec_core.c~kexec_core-remove-superfluous-page-offset-handling-in-segment-loading-v3
+++ a/kernel/kexec_core.c
@@ -742,7 +742,6 @@ static int kimage_load_cma_segment(struc
 	struct kexec_segment *segment = &image->segment[idx];
 	struct page *cma = image->segment_cma[idx];
 	char *ptr = page_address(cma);
-	unsigned long maddr;
 	size_t ubytes, mbytes;
 	int result = 0;
 	unsigned char __user *buf = NULL;
@@ -754,7 +753,6 @@ static int kimage_load_cma_segment(struc
 		buf = segment->buf;
 	ubytes = segment->bufsz;
 	mbytes = segment->memsz;
-	maddr = segment->mem;
 
 	/* Then copy from source buffer to the CMA one */
 	while (mbytes) {
@@ -782,7 +780,6 @@ static int kimage_load_cma_segment(struc
 		}
 
 		ptr    += mchunk;
-		maddr  += mchunk;
 		mbytes -= mchunk;
 
 		cond_resched();
_

Patches currently in -mm which might be from jbouron@amazon.com are

kexec_core-remove-superfluous-page-offset-handling-in-segment-loading.patch
kexec_core-remove-superfluous-page-offset-handling-in-segment-loading-v3.patch

