Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDCCF37CD2D
	for <mm-commits@vger.kernel.org>; Tue, 31 Mar 2026 18:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774981792; cv=none; b=cCpzj8RjjaO6iXzzuXUrSNGBjasEqIzXnMqZ1NtKLTRKOQjAPaYbG9ln0txj159tHNibeFe2hatalQj3/p53+4sxMWOucGOfBdCZAeaRtKk5QcElUFyy9WaMRdsNSFLFzTQQr2RbWzl5NtyMj8NSJ5umzchNTzdwRqZpAURuNtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774981792; c=relaxed/simple;
	bh=PIsvMsSekJ9c8Iy2ZdiBhnaXZWiKd/CIKYGc2HwR7I8=;
	h=Date:To:From:Subject:Message-Id; b=Rg0BgK227kyyHUqFZZiCb8lG2XO10ugOkCCHho8nNdp0BpSRmkRHhqX+rIugGdA+aURtVstc3Nkj5NU3Sfh3x1b4twiZI/WAy5mY0UGsPcntlbRPsjgP/jmJfsNfM5yLwg0KvP46ilr/UtB8OjrGjMu6JfI6WL4tsdvj4qr3lJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hqKYPECS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hqKYPECS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31542C19423;
	Tue, 31 Mar 2026 18:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774981792;
	bh=PIsvMsSekJ9c8Iy2ZdiBhnaXZWiKd/CIKYGc2HwR7I8=;
	h=Date:To:From:Subject:From;
	b=hqKYPECSorRkhks2aJN1a8z86fKPZGB/Ari6MJTsis23EfRjtvngzaN6IgcXrTxha
	 4bl554LrP1mVLZkLXHE99ZlqpBiq7m2HnU06exg980lFDeq2cclcS2CBI52fRAPgdD
	 Jn3eczx9CdF6RbPR/h8e9DNSlKN39Zw7yUsSqTu0=
Date: Tue, 31 Mar 2026 11:29:51 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] kvm-ppc-use-vma_start_write_killable-in-kvmppc_memslot_page_merge.patch removed from -mm tree
Message-Id: <20260331182952.31542C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: KVM: PPC: use vma_start_write_killable() in kvmppc_memslot_page_merge()
has been removed from the -mm tree.  Its filename was
     kvm-ppc-use-vma_start_write_killable-in-kvmppc_memslot_page_merge.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: KVM: PPC: use vma_start_write_killable() in kvmppc_memslot_page_merge()
Date: Fri, 27 Mar 2026 13:54:57 -0700

Replace vma_start_write() with vma_start_write_killable(), improving
reaction time to the kill signal.  Replace vma_start_write() in
kvmppc_memslot_page_merge().

Link: https://lkml.kernel.org/r/20260327205457.604224-7-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Jann Horn <jannh@google.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kvm/book3s_hv_uvmem.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/powerpc/kvm/book3s_hv_uvmem.c~kvm-ppc-use-vma_start_write_killable-in-kvmppc_memslot_page_merge
+++ a/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -410,7 +410,10 @@ static int kvmppc_memslot_page_merge(str
 			ret = H_STATE;
 			break;
 		}
-		vma_start_write(vma);
+		if (vma_start_write_killable(vma)) {
+			ret = H_STATE;
+			break;
+		}
 		/* Copy vm_flags to avoid partial modifications in ksm_madvise */
 		vm_flags = vma->vm_flags;
 		ret = ksm_madvise(vma, vma->vm_start, vma->vm_end,
_

Patches currently in -mm which might be from surenb@google.com are

mm-vmscan-prevent-mglru-reclaim-from-pinning-address-space.patch

