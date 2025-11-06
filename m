Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC30586353;
	Thu,  6 Nov 2025 00:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762388163; cv=none; b=HFm7v5q4bAPxNeASqIch0G+7p2rKJHyPpqJkXpt71+KkN8colQ81f7feXhv0cdSs+HSdRJZ2EfWPoxrx0WtO3ou2z5EwVgIcD5iNnQb/xK6XGtnBiE0d5h5B0jqhhIPOxwDKdXJVngy9sdEk/1RwkoU5fyVTvAouOWjODmg/CqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762388163; c=relaxed/simple;
	bh=mGG+rVZlYh7bw+UneqUVmMxRTOaJtDp9CDpsp6AyxA4=;
	h=Date:To:From:Subject:Message-Id; b=IZb3UZDTqWoeNs1QVDZLXDSUIX5u8fJmseaXKRpcQdx1oJiBV4wzVZVbNok8QLgCjsnFMEwY1ayx0A4Xfie3fXVcK1yHquBpJtK2xo8UPoXcmcNkVRBdI2HP1RA4dANpDU/k7i1TAFW2Gxp+h+EjNGcdi2ENJmvhRCpnMJVmhBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uUSwirQi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uUSwirQi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44B19C4CEFB;
	Thu,  6 Nov 2025 00:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762388163;
	bh=mGG+rVZlYh7bw+UneqUVmMxRTOaJtDp9CDpsp6AyxA4=;
	h=Date:To:From:Subject:From;
	b=uUSwirQiV1wKWv7Glwjg4sR6ycFqj9JbedGCR/4sASzf/eAm1LDcrqzSk6Vfol+sk
	 sC32NJZ/pVc5OYDTt9vxFbhmGsueIMwZ+FTSLhgW99FkVTeMsCdsei4ebQQuMearMg
	 pm14FlPdR1PerCJtHDNRL6/xo5+2uoxJ3PaIOmHI=
Date: Wed, 05 Nov 2025 16:16:02 -0800
To: mm-commits@vger.kernel.org,zohar@linux.ibm.com,stable@vger.kernel.org,roberto.sassu@huawei.com,graf@amazon.com,chenste@linux.microsoft.com,bhe@redhat.com,piliu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-kexec-fix-ima-when-allocation-happens-in-cma-area.patch added to mm-hotfixes-unstable branch
Message-Id: <20251106001603.44B19C4CEFB@smtp.kernel.org>
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
Date: Wed, 5 Nov 2025 21:09:22 +0800

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

Link: https://lkml.kernel.org/r/20251105130922.13321-2-piliu@redhat.com
Fixes: 0091d9241ea2 ("kexec: define functions to map and unmap segments")
Signed-off-by: Pingfan Liu <piliu@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Mimi Zohar <zohar@linux.ibm.com>
Cc: Roberto Sassu <roberto.sassu@huawei.com>
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
+		return cma;
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

