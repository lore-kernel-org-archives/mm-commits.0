Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145D8288AD
	for <mm-commits@vger.kernel.org>; Fri, 10 Oct 2025 02:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760062356; cv=none; b=eNmxXcrd464sEGX62VlkiAqNUADTEebNNCEC8Z2+Nz7qrjbPjuqynl71tYzLerPnBgLqiy3S/OYfSU/xP38P5352BtvNnHreFOBfUsZDWeJG+BpRx0Xt6OpEMaD1OUB++fFTpFyq5sPKAqdWmkGEzIHnJkSzj3S6+pnU/E+jUi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760062356; c=relaxed/simple;
	bh=tqgnzf/MBxORJpiL7ZC6EFq+EkUBTZCrYBHFKbPKxUc=;
	h=Date:To:From:Subject:Message-Id; b=IqNpCcHdkZm3nwgMMVBTjmZi0dcYX5P9tbBOmS8yCWS/ljCbZh5+tZ06cMtOsprtxvfv7vqs8Ld34Voi89HXVOvGwc+s3hE+WKjgIhkT5CjVH6bDwtqP9gNmW9xhBf/FtIiTkvgjghUj+8i0VxhDtUorhpw7Y/2ktBrLFUR7c8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pW8kKnqK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pW8kKnqK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81596C4CEE7;
	Fri, 10 Oct 2025 02:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760062355;
	bh=tqgnzf/MBxORJpiL7ZC6EFq+EkUBTZCrYBHFKbPKxUc=;
	h=Date:To:From:Subject:From;
	b=pW8kKnqKFt3IZr4Ah2/362bkAffnDEv10IVTG+WS0DX7EH1725StRDh2se4LKOTui
	 Cy7F8bQlZZxibKniUC9F72peYoRIatgK6qp2ybuW+fymXKfbQmMcOQWIIYbjaQovhj
	 lk2KNT0TB6VNfGk35orv3HhzTG8rC/lMYJd6pSw4=
Date: Thu, 09 Oct 2025 19:12:34 -0700
To: mm-commits@vger.kernel.org,yan.y.zhao@intel.com,pmladek@suse.com,mpdesouza@suse.com,mario.limonciello@amd.com,gunnarku@amazon.com,graf@amazon.com,bhe@redhat.com,jbouron@amazon.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec_core-remove-superfluous-page-offset-handling-in-segment-loading.patch added to mm-nonmm-unstable branch
Message-Id: <20251010021235.81596C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kexec_core: Remove superfluous page offset handling in segment loading
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
Subject: kexec_core: Remove superfluous page offset handling in segment loading
Date: Mon, 29 Sep 2025 09:02:20 -0700

During kexec_segment loading, when copying the content of the segment
(i.e.  kexec_segment::kbuf or kexec_segment::buf) to its associated pages,
kimage_load_{cma,normal,crash}_segment handle the case where the physical
address of the segment is not page aligned, e.g.  in
kimage_load_normal_segment:

	page = kimage_alloc_page(image, GFP_HIGHUSER, maddr);
	// ...
	ptr = kmap_local_page(page);
	// ...
	ptr += maddr & ~PAGE_MASK;
	mchunk = min_t(size_t, mbytes,
		PAGE_SIZE - (maddr & ~PAGE_MASK));
	// ^^^^ Non page-aligned segments handled here ^^^
	// ...
	if (image->file_mode)
		memcpy(ptr, kbuf, uchunk);
	else
		result = copy_from_user(ptr, buf, uchunk);

(similar logic is present in kimage_load_{cma,crash}_segment).

This is actually not needed because, prior to their loading, all
kexec_segments first go through a vetting step in
`sanity_check_segment_list`, which rejects any segment that is not
page-aligned:

	for (i = 0; i < nr_segments; i++) {
		unsigned long mstart, mend;
		mstart = image->segment[i].mem;
		mend   = mstart + image->segment[i].memsz;
		// ...
		if ((mstart & ~PAGE_MASK) || (mend & ~PAGE_MASK))
			return -EADDRNOTAVAIL;
		// ...
	}

In case `sanity_check_segment_list` finds a non-page aligned the whole
kexec load is aborted and no segment is loaded.

This means that `kimage_load_{cma,normal,crash}_segment` never actually
have to handle non page-aligned segments and `(maddr & ~PAGE_MASK) == 0`
is always true no matter if the segment is coming from a file (i.e. 
`kexec_file_load` syscall), from a user-space buffer (i.e.  `kexec_load`
syscall) or created by the kernel through `kexec_add_buffer`.  In the
latter case, `kexec_add_buffer` actually enforces the page alignment:

	/* Ensure minimum alignment needed for segments. */
	kbuf->memsz = ALIGN(kbuf->memsz, PAGE_SIZE);
	kbuf->buf_align = max(kbuf->buf_align, PAGE_SIZE);

Link: https://lkml.kernel.org/r/20250929160220.47616-1-jbouron@amazon.com
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

 kernel/kexec_core.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

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
@@ -839,9 +837,7 @@ static int kimage_load_normal_segment(st
 		ptr = kmap_local_page(page);
 		/* Start with a clear page */
 		clear_page(ptr);
-		ptr += maddr & ~PAGE_MASK;
-		mchunk = min_t(size_t, mbytes,
-				PAGE_SIZE - (maddr & ~PAGE_MASK));
+		mchunk = min_t(size_t, mbytes, PAGE_SIZE);
 		uchunk = min(ubytes, mchunk);
 
 		if (uchunk) {
@@ -904,9 +900,7 @@ static int kimage_load_crash_segment(str
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

