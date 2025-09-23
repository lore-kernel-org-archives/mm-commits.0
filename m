Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A363A1CD
	for <mm-commits@vger.kernel.org>; Tue, 23 Sep 2025 03:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758598145; cv=none; b=K/jriip/vZMtm0Ubz6Q2t7hwbC4zR8DpwIsTpDR5H2lNYErxH4UXnlHfiGj7xhYl/ruJmCmZAYq+5WRwMZ97TJlNjswtnYj8z/1UC00JlpAKQ9xFLDENC0T1KoVmFC8TdG7e/3/zSCwxAaQRR/HdQJb1/cKmSojTtyIFFik39ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758598145; c=relaxed/simple;
	bh=GJy19n+5fU3p1KcXsTJgR+/00dVQwJ/+U7dhaIHO6Y0=;
	h=Date:To:From:Subject:Message-Id; b=kIxywS96/7/JogQ2eq4FBs8UQIYb72qKSEDARFem2k0gLU7wiwjQCB5kMivoaZxb05XiSWVRu9WgEWzF2q4n3Fayzm5gqz2A5tCyRJh3ePAAv6D2rqCT6BxO7db2NPtHzXCR1rVswX8KmTnbzgFqO3/ot5GggrKeEw3GfOaOfdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SEVdwTxK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SEVdwTxK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A86A8C4CEF0;
	Tue, 23 Sep 2025 03:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758598144;
	bh=GJy19n+5fU3p1KcXsTJgR+/00dVQwJ/+U7dhaIHO6Y0=;
	h=Date:To:From:Subject:From;
	b=SEVdwTxK6pEf2FK4gckZIVUPqs1DfZxXaAjHPh4kpGrbIBK59tQFySM8J56BSxGPI
	 7QrFMRVB9alsePDPy+qrlcwDatlbarYFRYBL1fY7JLT2r468EzArXNFWz15xPFFhCD
	 OPHbJUJRYXxNF/VR6r/eNWMEZtwCFGbfqNTvt+Ic=
Date: Mon, 22 Sep 2025 20:29:04 -0700
To: mm-commits@vger.kernel.org,nico@fluxnic.net,haiyuewa@163.com,david@redhat.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + cramfs-fix-incorrect-physical-page-address-calculation.patch added to mm-nonmm-unstable branch
Message-Id: <20250923032904.A86A8C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: cramfs: fix incorrect physical page address calculation
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     cramfs-fix-incorrect-physical-page-address-calculation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/cramfs-fix-incorrect-physical-page-address-calculation.patch

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
From: Alistair Popple <apopple@nvidia.com>
Subject: cramfs: fix incorrect physical page address calculation
Date: Tue, 23 Sep 2025 10:53:33 +1000

Commit 21aa65bf82a7 ("mm: remove callers of pfn_t functionality")
incorrectly replaced the pfn with the physical address when calling
vmf_insert_mixed().  Instead the phys_to_pfn_t() call should have been
replaced with PHYS_PFN().

Found by inspection after a similar issue was noted in fuse virtio_fs.

Link: https://lkml.kernel.org/r/20250923005333.3165032-1-apopple@nvidia.com
Fixes: 21aa65bf82a7 ("mm: remove callers of pfn_t functionality")
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Cc: Haiyue Wang <haiyuewa@163.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Nicolas Pitre <nico@fluxnic.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cramfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cramfs/inode.c~cramfs-fix-incorrect-physical-page-address-calculation
+++ a/fs/cramfs/inode.c
@@ -412,7 +412,7 @@ static int cramfs_physmem_mmap(struct fi
 			vm_fault_t vmf;
 			unsigned long off = i * PAGE_SIZE;
 			vmf = vmf_insert_mixed(vma, vma->vm_start + off,
-					address + off);
+					PHYS_PFN(address + off));
 			if (vmf & VM_FAULT_ERROR)
 				ret = vm_fault_to_errno(vmf, 0);
 		}
_

Patches currently in -mm which might be from apopple@nvidia.com are

cramfs-fix-incorrect-physical-page-address-calculation.patch

