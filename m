Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19EE14B96E
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 00:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762908565; cv=none; b=IxoqMIXOr6063jWeA8Qnt+joOhWZg9xMIZtW0rF4WyA9KmhK/5j3k967kgPbThya7CoW37ebkxjP6sx8wGVNvFLUdOiFIvNSHfxgE6twgaWzq7W230XEpmvLN0dbfAurQZ2s7Irw466wigtVMrGlvgSq/RlyClY3uAoGNhcx3fM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762908565; c=relaxed/simple;
	bh=SvniA6IRb6Sd19aBwSwYfhfeBKaEMGjGhbdhyl4pSqs=;
	h=Date:To:From:Subject:Message-Id; b=h5tVFUsBBx+NvY78YX38c3wfMfvYpczzC+a/BaOBBKeot7+c+1ixSbxydMhLfpDN6VFZm1KMLl+Y/3ph8sY9ORYd/DY7cBG3e++2YEsvhrnODUe6AiHViDsBMr7ePrg3vy+cLj8MD7k8Cjti4v1va1PRmL/Cc5UTBvtjqiAUDmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SKzPLi8T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SKzPLi8T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3E20C4CEF5;
	Wed, 12 Nov 2025 00:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762908564;
	bh=SvniA6IRb6Sd19aBwSwYfhfeBKaEMGjGhbdhyl4pSqs=;
	h=Date:To:From:Subject:From;
	b=SKzPLi8TjUBIFgCm4YvPd7OIN3ILwdiIIg4vbgctVnwBpNfSyDhRVhwdTKsaNK6YK
	 9d4ypxy5hp2/jB3FjMUjtutp9BV59WlNhj0Ljo4JinyxP4DDzVX0rFbKwxY5fDwTxS
	 xI3hNedm4jrtCnSauTcJj9QVmhp/GGFXCQdyZhO8=
Date: Tue, 11 Nov 2025 16:49:24 -0800
To: mm-commits@vger.kernel.org,yan.y.zhao@intel.com,pmladek@suse.com,mpdesouza@suse.com,mario.limonciello@amd.com,gunnarku@amazon.com,graf@amazon.com,bhe@redhat.com,andriy.shevchenko@intel.com,jbouron@amazon.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kexec_core-remove-superfluous-page-offset-handling-in-segment-loading.patch removed from -mm tree
Message-Id: <20251112004924.C3E20C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kexec_core: remove superfluous page offset handling in segment loading
has been removed from the -mm tree.  Its filename was
     kexec_core-remove-superfluous-page-offset-handling-in-segment-loading.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Justinien Bouron <jbouron@amazon.com>
Subject: kexec_core: remove superfluous page offset handling in segment loading
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

[jbouron@amazon.com: v3]
  Link: https://lkml.kernel.org/r/20251024155009.39502-1-jbouron@amazon.com
Link: https://lkml.kernel.org/r/20250929160220.47616-1-jbouron@amazon.com
Signed-off-by: Justinien Bouron <jbouron@amazon.com>
Reviewed-by: Gunnar Kudrjavets <gunnarku@amazon.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Marcos Paulo de Souza <mpdesouza@suse.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

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
@@ -839,9 +834,7 @@ static int kimage_load_normal_segment(st
 		ptr = kmap_local_page(page);
 		/* Start with a clear page */
 		clear_page(ptr);
-		ptr += maddr & ~PAGE_MASK;
-		mchunk = min_t(size_t, mbytes,
-				PAGE_SIZE - (maddr & ~PAGE_MASK));
+		mchunk = min_t(size_t, mbytes, PAGE_SIZE);
 		uchunk = min(ubytes, mchunk);
 
 		if (uchunk) {
@@ -904,9 +897,7 @@ static int kimage_load_crash_segment(str
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


