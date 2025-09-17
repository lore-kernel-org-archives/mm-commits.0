Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2EB137932
	for <mm-commits@vger.kernel.org>; Wed, 17 Sep 2025 01:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758073357; cv=none; b=UHwA5CZaCLnC3RVWX0eDJI6e1VfDmscHiTvJUlqi0XWLhCDNKzH9zua3ZDGghaiWvr9PXfHIJ9PH7IlEdVXE76DuL0P8/4rd2F0jyvK72siH/oFUQuxU4pSz18fCPC3Gs70y2wMf2IiJhVjsBh2fyoLL4Qk71nL6LezfPOtwLYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758073357; c=relaxed/simple;
	bh=TQB79D2ne5FOcHQbdp3rXmnUf1UrM/odoGDHR8WK0d0=;
	h=Date:To:From:Subject:Message-Id; b=kZ9hS4CC50IBu0FlHm3+cJZ3QK23/nWQ3GlGavI3xrQaPiOycWysTLA4RiLAl2CG0+eSjuqHYiSUSLJCkcpElt9Wd+fhDTSB+7HV5+XM9doVdyo50wQHYpu2WYeiB58Xk/T9w+46xhXUXcuhdNnJFfp278PSe+R+oSps1DtnSao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Eqne8rX+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Eqne8rX+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A9A7C4CEEB;
	Wed, 17 Sep 2025 01:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758073357;
	bh=TQB79D2ne5FOcHQbdp3rXmnUf1UrM/odoGDHR8WK0d0=;
	h=Date:To:From:Subject:From;
	b=Eqne8rX+hDqxtJNz9WIcIIEi7wW8rwxFaDUopg+g5V6D/Hglp8Cpw4r0PS8f77l5T
	 h7mEqkKjs0/qXf2iNL6npfCGRRjArlXgZMkQsyWNF3TcL0c8DItJ/ip7r2ypxmQnX7
	 Wc/pODpHqny9t8DNaryvLzwliDaVbGv0P7TJ/pzc=
Date: Tue, 16 Sep 2025 18:42:36 -0700
To: mm-commits@vger.kernel.org,yan.y.zhao@intel.com,pmladek@suse.com,nathan@kernel.org,mpdesouza@suse.com,morbo@google.com,mario.limonciello@amd.com,justinstitt@google.com,jbouron@amazon.com,gunnarku@amazon.com,graf@amazon.com,bhe@redhat.com,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec_core-remove-superfluous-page-offset-handling-in-segment-loading-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20250917014237.3A9A7C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kexec: remove unused code in kimage_load_cma_segment()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec_core-remove-superfluous-page-offset-handling-in-segment-loading-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec_core-remove-superfluous-page-offset-handling-in-segment-loading-fix.patch

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
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: kexec: remove unused code in kimage_load_cma_segment()
Date: Tue, 16 Sep 2025 14:51:09 +0200

clang is not happy about set but unused variable:

kernel/kexec_core.c:745:16: error: variable 'maddr' set but not used [-Werror,-Wunused-but-set-variable]
  745 |         unsigned long maddr;
      |                       ^
1 error generated.

Fix the compilation breakage (`make W=1` build) by removing unused variable.

As Nathan noted, GCC 16 produces the similar warning;

Link: https://lkml.kernel.org/r/20250916125124.3094021-2-andriy.shevchenko@linux.intel.com
Fixes: f4fecb50d6e1 ("kexec_core: remove superfluous page offset handling in segment loading")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Cc: Andriy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Gunnar Kudrjavets <gunnarku@amazon.com>
Cc: Justinien Bouron <jbouron@amazon.com>
Cc: Marcos Paulo de Souza <mpdesouza@suse.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/kernel/kexec_core.c~kexec_core-remove-superfluous-page-offset-handling-in-segment-loading-fix
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

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

kexec_core-remove-superfluous-page-offset-handling-in-segment-loading-fix.patch

