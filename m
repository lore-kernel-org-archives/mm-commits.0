Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0735B2264BD
	for <mm-commits@vger.kernel.org>; Tue, 23 Sep 2025 03:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758596898; cv=none; b=skInfLOLEIt1727U4UN11rrFWmpuWM7hnXH5YjNYdX63zSKDdosYR0HEy7C4uDzS2/JkT47NZANVMrx0T46YQN/eNE5qi1xdnlQZyyxTxqumu+6yxv6YlDEPOlzKrFcWQn/64bBfpJHMiYKBfp9+wBMqoTNmQMVcTB8JqcuZAtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758596898; c=relaxed/simple;
	bh=sL7G/OJ//JBsYcImw/g512wGUyh3fe3pjgtB+9RIC2c=;
	h=Date:To:From:Subject:Message-Id; b=s4eDwkUHjmvfW0cgfe1Bka8/4K4SnMutLjCv0SXDogtmXrVDgBeJWSrRpFNhUzQFFDQxlnMM9Vco6xMqxpASxaDsYZVyLBliUMxwAB/pRIUhNWZX822dMV7pXkZkwWW1+kLRaDlj1rGm9qgB1PDgsBhP0wdXOoT9MCSZCIh6VPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OmpIMMVR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OmpIMMVR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3AC2C4CEF0;
	Tue, 23 Sep 2025 03:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758596897;
	bh=sL7G/OJ//JBsYcImw/g512wGUyh3fe3pjgtB+9RIC2c=;
	h=Date:To:From:Subject:From;
	b=OmpIMMVRiwoKyGHMom0kd8JpcU/ekrhI0+U8G85WSV/RSHBZ9Y6vG/r7olGLpju8p
	 3mugJZZFVIOaulCosjQsy9u/ERu8uh96RRunOsa9KyTsxBZASJbuhlIA3V5Uz+v0yp
	 UBkOqLRtYM1+d8/Tw9/HKe2Lng/lsi2B3jaefQmI=
Date: Mon, 22 Sep 2025 20:08:17 -0700
To: mm-commits@vger.kernel.org,yan.y.zhao@intel.com,pmladek@suse.com,nathan@kernel.org,mpdesouza@suse.com,morbo@google.com,mario.limonciello@amd.com,justinstitt@google.com,gunnarku@amazon.com,graf@amazon.com,bhe@redhat.com,andriy.shevchenko@linux.intel.com,jbouron@amazon.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] kexec_core-remove-superfluous-page-offset-handling-in-segment-loading.patch removed from -mm tree
Message-Id: <20250923030817.C3AC2C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kexec_core: remove superfluous page offset handling in segment loading
has been removed from the -mm tree.  Its filename was
     kexec_core-remove-superfluous-page-offset-handling-in-segment-loading.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Justinien Bouron <jbouron@amazon.com>
Subject: kexec_core: remove superfluous page offset handling in segment loading
Date: Wed, 10 Sep 2025 09:31:16 -0700

Kexec does not accept segments for which the destination address is not
page aligned.  Therefore there is no need for page offset handling when
loading segments.

[andriy.shevchenko@linux.intel.com: remove unused code in kimage_load_cma_segment()]
  Link: https://lkml.kernel.org/r/20250916125124.3094021-2-andriy.shevchenko@linux.intel.com
Link: https://lkml.kernel.org/r/20250910163116.49148-1-jbouron@amazon.com
Signed-off-by: Justinien Bouron <jbouron@amazon.com>
Reviewed-by: Gunnar Kudrjavets <gunnarku@amazon.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Marcos Paulo de Souza <mpdesouza@suse.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>
Cc: Andriy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

--- a/kernel/kexec_core.c~kexec_core-remove-superfluous-page-offset-handling-in-segment-loading
+++ a/kernel/kexec_core.c
@@ -742,7 +742,6 @@ static int kimage_load_cma_segment(struc
 	struct kexec_segment *segment = &image->segment[idx];
 	struct page *cma = image->segment_cma[idx];
 	char *ptr = page_address(cma);
-	unsigned long maddr;
 	size_t ubytes, mbytes;
 	int result = 0;
 	unsigned char __user *buf = NULL;
@@ -754,15 +753,12 @@ static int kimage_load_cma_segment(struc
 		buf = segment->buf;
 	ubytes = segment->bufsz;
 	mbytes = segment->memsz;
-	maddr = segment->mem;
 
 	/* Then copy from source buffer to the CMA one */
 	while (mbytes) {
 		size_t uchunk, mchunk;
 
-		ptr += maddr & ~PAGE_MASK;
-		mchunk = min_t(size_t, mbytes,
-				PAGE_SIZE - (maddr & ~PAGE_MASK));
+		mchunk = min_t(size_t, mbytes, PAGE_SIZE);
 		uchunk = min(ubytes, mchunk);
 
 		if (uchunk) {
@@ -784,7 +780,6 @@ static int kimage_load_cma_segment(struc
 		}
 
 		ptr    += mchunk;
-		maddr  += mchunk;
 		mbytes -= mchunk;
 
 		cond_resched();
@@ -814,6 +809,7 @@ static int kimage_load_normal_segment(st
 	mbytes = segment->memsz;
 	maddr = segment->mem;
 
+
 	if (image->segment_cma[idx])
 		return kimage_load_cma_segment(image, idx);
 
@@ -839,9 +835,7 @@ static int kimage_load_normal_segment(st
 		ptr = kmap_local_page(page);
 		/* Start with a clear page */
 		clear_page(ptr);
-		ptr += maddr & ~PAGE_MASK;
-		mchunk = min_t(size_t, mbytes,
-				PAGE_SIZE - (maddr & ~PAGE_MASK));
+		mchunk = min_t(size_t, mbytes, PAGE_SIZE);
 		uchunk = min(ubytes, mchunk);
 
 		if (uchunk) {
@@ -904,9 +898,7 @@ static int kimage_load_crash_segment(str
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


