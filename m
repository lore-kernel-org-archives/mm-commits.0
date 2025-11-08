Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76121F37DA;
	Sat,  8 Nov 2025 00:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762561278; cv=none; b=IU5jin9XYHYgPMoaNiXcYONHWPrbHTmuuvAdoJL9H6bPEXZ1qEiYgVtY9GktD0NzfbI0lay1zDTxU0GVtez32USo7x4v3vswpjx2P38EnP49zA/CTraSpHiDhuz91L11k5rxDRsPu8c6QJdUpdCt3BMY0j1d2j05rrWgm+8qqKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762561278; c=relaxed/simple;
	bh=ubxu3QvUgOY9Xa92eq7fTiKssMWZG1JbPSlx1umseG4=;
	h=Date:To:From:Subject:Message-Id; b=g6G7MbbXgR8DEn91cwxYlVnJdKOfC9oUSUIwNheqcvO+BZEY2KEbJ+CJCDPbMernMA++HteMAiPNiTaZBObJD3GfnPtD31nkZq/RcrvXGw49ohLeiUjfO0c9JRNIbx5bYtA6VLL20S6VYh15Xks+/o775PBaYloV2u3uxUBnIQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1rZgRV4a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1rZgRV4a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6052AC4CEF7;
	Sat,  8 Nov 2025 00:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762561278;
	bh=ubxu3QvUgOY9Xa92eq7fTiKssMWZG1JbPSlx1umseG4=;
	h=Date:To:From:Subject:From;
	b=1rZgRV4aT3aELvwHoEWNoeUzw6KoBHW3W2FfDbYkDYFFneKjhkvi4xnWQOsqCVU7O
	 tL9fRpwojC3j5s3eiykx3cNRo5OAlVFBwuDFTZQq7ZInbZhE3k7y6rLKfO0ukkt76A
	 rHwIbvL7C6QnC8Y1kEkcXvNuSeiBULIdaj9zBoxU=
Date: Fri, 07 Nov 2025 16:21:17 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,graf@amazon.com,chenste@linux.microsoft.com,bhe@redhat.com,piliu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-kexec-fix-ima-when-allocation-happens-in-cma-area.patch added to mm-hotfixes-unstable branch
Message-Id: <20251108002118.6052AC4CEF7@smtp.kernel.org>
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
Date: Thu, 6 Nov 2025 14:59:04 +0800

When I tested kexec with the latest kernel, I ran into the following
warning:

[   40.712410] ------------[ cut here ]------------
[   40.712576] WARNING: CPU: 2 PID: 1562 at kernel/kexec_core.c:1001 kimage_map_segment+0x144/0x198
[...]
[   40.816047] Call trace:
[   40.818498]  kimage_map_segment+0x144/0x198 (P)
[   40.823221]  ima_kexec_post_load+0x58/0xc0
[   40.827246]  __do_sys_kexec_file_load+0x29c/0x368
[...]
[   40.855423] ---[ end trace 0000000000000000 ]---

This is caused by the fact that kexec allocates the destination directly
in the CMA area.  In that case, the CMA kernel address should be exported
directly to the IMA component, instead of using the vmalloc'd address.

Link: https://lkml.kernel.org/r/20251106065904.10772-2-piliu@redhat.com
Fixes: 07d24902977e ("kexec: enable CMA based contiguous allocation")
Signed-off-by: Pingfan Liu <piliu@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Steven Chen <chenste@linux.microsoft.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/kernel/kexec_core.c~kernel-kexec-fix-ima-when-allocation-happens-in-cma-area
+++ a/kernel/kexec_core.c
@@ -967,6 +967,7 @@ void *kimage_map_segment(struct kimage *
 	kimage_entry_t *ptr, entry;
 	struct page **src_pages;
 	unsigned int npages;
+	struct page *cma;
 	void *vaddr = NULL;
 	int i;
 
@@ -974,6 +975,9 @@ void *kimage_map_segment(struct kimage *
 	size = image->segment[idx].memsz;
 	eaddr = addr + size;
 
+	cma = image->segment_cma[idx];
+	if (cma)
+		return page_address(cma);
 	/*
 	 * Collect the source pages and map them in a contiguous VA range.
 	 */
@@ -1014,7 +1018,8 @@ void *kimage_map_segment(struct kimage *
 
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

