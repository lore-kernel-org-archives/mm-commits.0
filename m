Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC33120101D
	for <mm-commits@vger.kernel.org>; Sun, 28 Sep 2025 18:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759084635; cv=none; b=QBw0Py5lWJQJmhMscPOmXj6muk0XBCKAP35RSpu7z5FbBlH/+HoFx5bNm5mDx+ItaXpOCU0D8dRbKZH7pdKOoF4Cz7RlRGBzxsLnQSeA9KVpaNI7tjmC0U1BRPm2YE2YbrOtR5XMCaCHk/kH2a/mqaVFgSkZUxT1s1+hGpN1IB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759084635; c=relaxed/simple;
	bh=eA58ErCjaGqJcCPiesp2uztTpwXA4qC3Ot0j+Qpp2cg=;
	h=Date:To:From:Subject:Message-Id; b=f14EJjxz21ERU7tcrdQT86TGwT6N9GIiu0/Irv3Jw25qfoY1YsdTXneSvebBCUC7uh1AacC8gR3Mc0eqE9OvyqEqGSVLkAeIWvjxyK9rlZxVpyAKZ++qV+PBHThPMfODfNHTN4YnEwQtxtQPY1Uvz0uv+oZyWum0wIvCCyQYCmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J38XwY0V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J38XwY0V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22524C4CEF0;
	Sun, 28 Sep 2025 18:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759084633;
	bh=eA58ErCjaGqJcCPiesp2uztTpwXA4qC3Ot0j+Qpp2cg=;
	h=Date:To:From:Subject:From;
	b=J38XwY0VZTEIliSSAAHn1aXPTscmvaXEbHteQlfKeJDH3vLoI1MFyr9z1XFFaYuSq
	 n+5b+TPxcIfSK6AJeAr9FN9aXkS0bm8F5XMdcCLOyQQAXEdvUqYhPlfRU+nVdrhILM
	 EgvQe9wb7PcBvL+6r3Jb1vP462OguFezEijhPy2k=
Date: Sun, 28 Sep 2025 11:37:12 -0700
To: mm-commits@vger.kernel.org,nico@fluxnic.net,haiyuewa@163.com,dev.jain@arm.com,david@redhat.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] cramfs-fix-incorrect-physical-page-address-calculation.patch removed from -mm tree
Message-Id: <20250928183713.22524C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: cramfs: fix incorrect physical page address calculation
has been removed from the -mm tree.  Its filename was
     cramfs-fix-incorrect-physical-page-address-calculation.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Haiyue Wang <haiyuewa@163.com>
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


