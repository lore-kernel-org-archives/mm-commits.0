Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760C8311C1F
	for <mm-commits@vger.kernel.org>; Wed, 10 Sep 2025 21:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757541581; cv=none; b=to+HaOaCQifE8DbLSTlOLBAGjzqlmuOJAI8xKkcX3ueJWD3e3/NJQcgwPGg2KU91mAyVaZclukjvqsdFSXtHqy4HjhWFS1oeurVpBlCkJ+6SVjVEMLjNmTRN3SsBhHYAcC6DK9jpnJCvtGPqRDweL4HRykFJ63BnmaShbPcYubQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757541581; c=relaxed/simple;
	bh=XL9oR1OMq0Dv6bXlyQsem9a3bFP3Vil46nCnke8/18k=;
	h=Date:To:From:Subject:Message-Id; b=lBtWf7OnnRNoraQVdkBsARFnusKCS76jc3OrwxE9bTQcq8CGyGOXm5scxO8uoQKgevRsRDhKkNhFPYdyp+oz2c0B/WXtLHXNpW9/sM+UFb35pxsi9jLXTtZfDOx4VvzUAcC+dfMHIypddqixaJNjJFtcILtua9q3vb0rSBlJVNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DiqmT+2+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DiqmT+2+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A5CC4CEEB;
	Wed, 10 Sep 2025 21:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757541581;
	bh=XL9oR1OMq0Dv6bXlyQsem9a3bFP3Vil46nCnke8/18k=;
	h=Date:To:From:Subject:From;
	b=DiqmT+2+DsBdS47ZhI65SpAbE2fqMLhQsNh90bg+cU8Cw/3EaKm4RbqQ1gQTpjuE4
	 gSBMlQ7btqjeSWnTKkz6J3qBLFWi05wqj8QPvzLZgW4rXk1sE6Fsm/l50RC5ojYNm2
	 8ZP2TWNTuBgAV1Qhe2psImPVg+7ID0FjutzDSjwM=
Date: Wed, 10 Sep 2025 14:59:40 -0700
To: mm-commits@vger.kernel.org,yan.y.zhao@intel.com,pmladek@suse.com,mpdesouza@suse.com,mario.limonciello@amd.com,gunnarku@amazon.com,graf@amazon.com,bhe@redhat.com,jbouron@amazon.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec_core-remove-superfluous-page-offset-handling-in-segment-loading.patch added to mm-nonmm-unstable branch
Message-Id: <20250910215940.E0A5CC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kexec_core: remove superfluous page offset handling in segment loading
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec_core-remove-superfluous-page-offset-handling-in-segment-loading.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec_core-remove-superfluous-page-offset-handling-in-segment-loading.patch

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
Subject: kexec_core: remove superfluous page offset handling in segment loading
Date: Wed, 10 Sep 2025 09:31:16 -0700

Kexec does not accept segments for which the destination address is not
page aligned.  Therefore there is no need for page offset handling when
loading segments.

Link: https://lkml.kernel.org/r/20250910163116.49148-1-jbouron@amazon.com
Signed-off-by: Justinien Bouron <jbouron@amazon.com>
Reviewed-by: Gunnar Kudrjavets <gunnarku@amazon.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Marcos Paulo de Souza <mpdesouza@suse.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

--- a/kernel/kexec_core.c~kexec_core-remove-superfluous-page-offset-handling-in-segment-loading
+++ a/kernel/kexec_core.c
@@ -760,9 +760,7 @@ static int kimage_load_cma_segment(struc
 	while (mbytes) {
 		size_t uchunk, mchunk;
 
-		ptr += maddr & ~PAGE_MASK;
-		mchunk = min_t(size_t, mbytes,
-				PAGE_SIZE - (maddr & ~PAGE_MASK));
+		mchunk = min_t(size_t, mbytes, PAGE_SIZE);
 		uchunk = min(ubytes, mchunk);
 
 		if (uchunk) {
@@ -814,6 +812,7 @@ static int kimage_load_normal_segment(st
 	mbytes = segment->memsz;
 	maddr = segment->mem;
 
+
 	if (image->segment_cma[idx])
 		return kimage_load_cma_segment(image, idx);
 
@@ -839,9 +838,7 @@ static int kimage_load_normal_segment(st
 		ptr = kmap_local_page(page);
 		/* Start with a clear page */
 		clear_page(ptr);
-		ptr += maddr & ~PAGE_MASK;
-		mchunk = min_t(size_t, mbytes,
-				PAGE_SIZE - (maddr & ~PAGE_MASK));
+		mchunk = min_t(size_t, mbytes, PAGE_SIZE);
 		uchunk = min(ubytes, mchunk);
 
 		if (uchunk) {
@@ -904,9 +901,7 @@ static int kimage_load_crash_segment(str
 		}
 		arch_kexec_post_alloc_pages(page_address(page), 1, 0);
 		ptr = kmap_local_page(page);
-		ptr += maddr & ~PAGE_MASK;
-		mchunk = min_t(size_t, mbytes,
-				PAGE_SIZE - (maddr & ~PAGE_MASK));
+		mchunk = min_t(size_t, mbytes, PAGE_SIZE);
 		uchunk = min(ubytes, mchunk);
 		if (mchunk > uchunk) {
 			/* Zero the trailing part of the page */
_

Patches currently in -mm which might be from jbouron@amazon.com are

kexec_core-remove-superfluous-page-offset-handling-in-segment-loading.patch

