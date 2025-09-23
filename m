Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775D52264BD
	for <mm-commits@vger.kernel.org>; Tue, 23 Sep 2025 03:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758596864; cv=none; b=L8omsdwjKg6PpjW0QdycU6IBgURQFa8roJFq1i+JJBZJVsw+V0+MeEWZrOWl8PksyU2fty6zZxQoWJAT8it+8ugdfWTRClfaEappl/OfplR2yS/AkHKTRbn79nCUtu5BZ9q7pB9LYu1qZuXTay7iNrbyUlBWN36bFoGg0MpUu6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758596864; c=relaxed/simple;
	bh=S0Sxk7s2SbLEIpniK6/jIcNuO7IgJWX4GLuL+bQ+nzI=;
	h=Date:To:From:Subject:Message-Id; b=mv/xsOsH8mU42Otny7SM5YLfjXQJlURYgiZXerWg5xA13cyuIUBguHwCXhki2z4O8NiBM4NQZn0yZSxi1mKO9GiKCbkMZZOFGneklDyglPDKbXVvkvUzb+x8YTzf2mxXS2XMEou9uDmhUVH/DHZP0OpgojJoy1Q96XIyv2MeYv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fHPS8OlW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fHPS8OlW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA58BC4CEF0;
	Tue, 23 Sep 2025 03:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758596864;
	bh=S0Sxk7s2SbLEIpniK6/jIcNuO7IgJWX4GLuL+bQ+nzI=;
	h=Date:To:From:Subject:From;
	b=fHPS8OlWm121KLlGZa60jnAtybDmmdFDcc2fCa0csOBx7E4Fna5wS+92DDBS9ECdw
	 6XlQPdwdL6sQ48tHJGKZw7CoA5+6HNPJ+RNmMYke8tQumAweqX1TkLA1g/YxFMYE2I
	 HbcfyZsCzy2JzJFCNA0nz+39nngM0I+Tui5azDng=
Date: Mon, 22 Sep 2025 20:07:43 -0700
To: mm-commits@vger.kernel.org,yan.y.zhao@intel.com,pmladek@suse.com,nathan@kernel.org,mpdesouza@suse.com,morbo@google.com,mario.limonciello@amd.com,justinstitt@google.com,jbouron@amazon.com,gunnarku@amazon.com,graf@amazon.com,bhe@redhat.com,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kexec_core-remove-superfluous-page-offset-handling-in-segment-loading-fix.patch removed from -mm tree
Message-Id: <20250923030743.EA58BC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kexec: remove unused code in kimage_load_cma_segment()
has been removed from the -mm tree.  Its filename was
     kexec_core-remove-superfluous-page-offset-handling-in-segment-loading-fix.patch

This patch was dropped because it was folded into kexec_core-remove-superfluous-page-offset-handling-in-segment-loading.patch

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

kexec_core-remove-superfluous-page-offset-handling-in-segment-loading.patch

