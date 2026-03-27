Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4235478D
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 23:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774652704; cv=none; b=mUgk8zLVypvc35DQqyMhSuA+ycRHWi9Wb+rXdGNHUJ3wupaIFmMhGSt8JqYsyWgaBppB+ETvprUkSjjYfUiXR2+e8K5ia6thQJjU7b5603uLS9TmMiF52D2QrZd4C5GQ469sOEwju5mEwImLBbGfsn4T/nJYdxb1+Ep/CYZM6ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774652704; c=relaxed/simple;
	bh=qonTJvaj18aZxmrzkhz3b2NYmwaETU2b5HPDTYLps2s=;
	h=Date:To:From:Subject:Message-Id; b=eQwoNOmDGM8XHDLugA+9ilvvCORJn8V/zAc21nyLmRaHUox/OWA2QQSQQD1S24+M86GA68XzLBcbUPwWzPZBwrGJWPT8vZfw3yJC5FZFGpZUJKDGMp8STQds+JvSfNnTJ/FMe0OBJebVTvLbU6wprJpla7o9DGf2dmhPiPNBAec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uUddNsd6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uUddNsd6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED38C19423;
	Fri, 27 Mar 2026 23:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774652703;
	bh=qonTJvaj18aZxmrzkhz3b2NYmwaETU2b5HPDTYLps2s=;
	h=Date:To:From:Subject:From;
	b=uUddNsd6HCOaeK70FofJRCeJjWxPFVcu/9XVu0dtJX/LOLODsF0ULpBDMCsWsddks
	 fSRamoqYFPlPy+4N9833W0iw8v6HySPodJUQLQGkbJWP0n5qPyNyQmjyZkVPGA575O
	 4lFK6gAT+wriuPo2INZ/F/24zS3IP9pF/Wu0078E=
Date: Fri, 27 Mar 2026 16:05:03 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] kvm-ppc-use-vma_start_write_killable-in-kvmppc_memslot_page_merge.patch removed from -mm tree
Message-Id: <20260327230503.CED38C19423@smtp.kernel.org>
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
Date: Thu, 26 Mar 2026 01:08:36 -0700

Replace vma_start_write() with vma_start_write_killable(), improving
reaction time to the kill signal.  Replace vma_start_write() in
kvmppc_memslot_page_merge().

Link: https://lkml.kernel.org/r/20260326080836.695207-7-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
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

a.patch
mm-vmscan-prevent-mglru-reclaim-from-pinning-address-space.patch

