Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606BF2C1598;
	Tue, 16 Dec 2025 02:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765851325; cv=none; b=TKEvl/bvisXPqEMfdxWqgg3/Zo+RaUPHEOxsoUun0ApjUxVByFRPXoN0AZ1w6A/ubJ4mXmd75b+xO1nSgCeNRQMHN/pjpvnBYtgFJkoL2PKmGGz/ZzHpGgwtAwxZHsraC2uey5Fch8xcJQa0ijykt4tuGEnYbcBIrzRwiUaaIVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765851325; c=relaxed/simple;
	bh=O26idNd+QjbJLPvUhJDbLWnbrlOToUlUBffqriF0N/8=;
	h=Date:To:From:Subject:Message-Id; b=cwki1fNyOXcqXV+zQtmu6YNXAM+lSr9hz07an3WlucLu/h/yJCm/+3lruOvSOwax62R4AraW7RzzErEB3WXmweXxh1+Pof2JHFQnuQiy6aOvViXA79Be3xQd4wuvKJq7eoQ7ZIi9pMEVuZbhluRV9kzetpTqucejFwYw6I7ndoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qXW2HBef; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qXW2HBef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF1CFC19424;
	Tue, 16 Dec 2025 02:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765851324;
	bh=O26idNd+QjbJLPvUhJDbLWnbrlOToUlUBffqriF0N/8=;
	h=Date:To:From:Subject:From;
	b=qXW2HBefWvzl7raRvVGp6lv5MnZZgPyGzVU6SXFqHId1nA6kDcEv7KZ9HmBtWw0pN
	 OJjMsn8sYc3ErndgkjPI0xXd6Cpx3PDD/HQmN7s3psYs19kZDBLd2m1p4YMG9ph/nt
	 GSPPCtpMUs8RxFbrILlWZXtBl2BHU5RFyyxBjd/g=
Date: Mon, 15 Dec 2025 18:15:24 -0800
To: mm-commits@vger.kernel.org,zohar@linux.ibm.com,stable@vger.kernel.org,roberto.sassu@huawei.com,graf@amazon.com,chenste@linux.microsoft.com,bhe@redhat.com,piliu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-kexec-fix-ima-when-allocation-happens-in-cma-area.patch added to mm-hotfixes-unstable branch
Message-Id: <20251216021524.CF1CFC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel/kexec: fix IMA when allocation happens in CMA area
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kernel-kexec-fix-ima-when-allocation-happens-in-cma-area.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-kexec-fix-ima-when-allocation-happens-in-cma-area.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Pingfan Liu <piliu@redhat.com>
Subject: kernel/kexec: fix IMA when allocation happens in CMA area
Date: Tue, 16 Dec 2025 09:48:52 +0800

*** Bug description ***

When I tested kexec with the latest kernel, I ran into the following warning:

[   40.712410] ------------[ cut here ]------------
[   40.712576] WARNING: CPU: 2 PID: 1562 at kernel/kexec_core.c:1001 kimage_map_segment+0x144/0x198
[...]
[   40.816047] Call trace:
[   40.818498]  kimage_map_segment+0x144/0x198 (P)
[   40.823221]  ima_kexec_post_load+0x58/0xc0
[   40.827246]  __do_sys_kexec_file_load+0x29c/0x368
[...]
[   40.855423] ---[ end trace 0000000000000000 ]---

*** How to reproduce ***

This bug is only triggered when the kexec target address is allocated in
the CMA area. If no CMA area is reserved in the kernel, use the "cma="
option in the kernel command line to reserve one.

*** Root cause ***
The commit 07d24902977e ("kexec: enable CMA based contiguous
allocation") allocates the kexec target address directly on the CMA area
to avoid copying during the jump. In this case, there is no IND_SOURCE
for the kexec segment.  But the current implementation of
kimage_map_segment() assumes that IND_SOURCE pages exist and map them
into a contiguous virtual address by vmap().

*** Solution ***
If IMA segment is allocated in the CMA area, use its page_address()
directly.

Link: https://lkml.kernel.org/r/20251216014852.8737-2-piliu@redhat.com
Fixes: 07d24902977e ("kexec: enable CMA based contiguous allocation")
Signed-off-by: Pingfan Liu <piliu@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Steven Chen <chenste@linux.microsoft.com>
Cc: Mimi Zohar <zohar@linux.ibm.com>
Cc: Roberto Sassu <roberto.sassu@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/kernel/kexec_core.c~kernel-kexec-fix-ima-when-allocation-happens-in-cma-area
+++ a/kernel/kexec_core.c
@@ -960,13 +960,17 @@ void *kimage_map_segment(struct kimage *
 	kimage_entry_t *ptr, entry;
 	struct page **src_pages;
 	unsigned int npages;
+	struct page *cma;
 	void *vaddr = NULL;
 	int i;
 
+	cma = image->segment_cma[idx];
+	if (cma)
+		return page_address(cma);
+
 	addr = image->segment[idx].mem;
 	size = image->segment[idx].memsz;
 	eaddr = addr + size;
-
 	/*
 	 * Collect the source pages and map them in a contiguous VA range.
 	 */
@@ -1007,7 +1011,8 @@ void *kimage_map_segment(struct kimage *
 
 void kimage_unmap_segment(void *segment_buffer)
 {
-	vunmap(segment_buffer);
+	if (is_vmalloc_addr(segment_buffer))
+		vunmap(segment_buffer);
 }
 
 struct kexec_load_limit {
_

Patches currently in -mm which might be from piliu@redhat.com are

kernel-kexec-change-the-prototype-of-kimage_map_segment.patch
kernel-kexec-fix-ima-when-allocation-happens-in-cma-area.patch

