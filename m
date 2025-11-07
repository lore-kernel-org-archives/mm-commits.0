Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93220262FE5;
	Fri,  7 Nov 2025 00:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762475405; cv=none; b=ux3Bmqo0fQ9alh6quByC4XeQdVf5JGXlWl1ivERTbvPJ/l3ZYZNyADMDbpYc2f9Afz/qa0Bpt5jLzur5eETRpkDPJ9y8Dwr6YoEIp3DQux8ZHph1gZZlIvD0RD0oBpFioIS6NmqQl/wRBYI6cJzRlm/MdtG+pwY6E4vIU088tEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762475405; c=relaxed/simple;
	bh=o0kWHOE4xqTibPtbd9hzD+JdjRV1c0ZVzgaQ10Lkd2w=;
	h=Date:To:From:Subject:Message-Id; b=cp7ZpV6f35r3A/IxzwiecpwvR7D3h5HABBGKDRaq4SQaoOaNv+Ujnc5ZFiIIFkCDpT1kpSnuetI2OJMP73N4hSkvtDejhC0B6IPyDfIAWjzQkbRzEr5gFx2qhCQ5O4+L5povbXC4Ewijm7q1Icysn+O0BL4Q+BpCkUYLTaTuhl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D/qYM9Rn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D/qYM9Rn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 107D6C4CEFB;
	Fri,  7 Nov 2025 00:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762475405;
	bh=o0kWHOE4xqTibPtbd9hzD+JdjRV1c0ZVzgaQ10Lkd2w=;
	h=Date:To:From:Subject:From;
	b=D/qYM9Rnp+Gz3Ek7Dcn9erth58UME259rwXuwNKniHgiO1JFzXcW32JMU4n70l9oz
	 35x9U2p8jtuV16jycWjsOV6IRj8VEVD29HYDe5GXrOLNFOkENkR7LBNfnW8beKws7a
	 dvlKoGNldutJjmjkF+9rnyJsoV8mgG8r+qJfrCdA=
Date: Thu, 06 Nov 2025 16:30:04 -0800
To: mm-commits@vger.kernel.org,zohar@linux.ibm.com,stable@vger.kernel.org,roberto.sassu@huawei.com,graf@amazon.com,chenste@linux.microsoft.com,bhe@redhat.com,piliu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] kernel-kexec-fix-ima-when-allocation-happens-in-cma-area.patch removed from -mm tree
Message-Id: <20251107003005.107D6C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel/kexec: fix IMA when allocation happens in CMA area
has been removed from the -mm tree.  Its filename was
     kernel-kexec-fix-ima-when-allocation-happens-in-cma-area.patch

This patch was dropped because an updated version will be issued

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


