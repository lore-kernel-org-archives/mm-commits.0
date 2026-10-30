Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793321551;
	b=nDkgsqUQ6dnV971k45tjLGrjDy84jIJ21MNSevOJQtJDFd3q6mLxTGhpmfW7BY6NGsU/
	 5LnTwoVRqKIk0AjgxVLJCnR3LfjkpJAABUTB1jByYU21okTLJYcIf0t6N4+AZq5+ybATQ
	 NgxdzR/J452zk7cXYp8PiBAYEsRljKP9tiwvNZbqgnUSjc27KDer3ENDPMYuzORFNgm85
	 QCnTJwaQrG7D41LGEw5kXmCV8RODolkAHItcfmHG8kAayu4aHOjo25kPeeVTsYcnWi55d
	 Z7sSth7gyJ0vGH0a4sJgUGYF3bhOd2u8Vo8ennHQfNlNEzPe69G8zlEzNEHstoBX+6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793321551;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=KTyLfqpPqJPW4V7IJFkvueSZBNZx2dnR4ZDJatY9jgY=;
	b=sr6oNoygP+E3y9fJ72bw67EG2OdxWf2QdUFkZ0bR/TxjNThE7rvpDT6vRwxZtiwQRfM/
	 HGnpGXPvXcr29wmOfMObslokgyLgPlFwP7LuOJDS6UWDPcfdbYEFcVYM5wdhPD2Guq6UB
	 0socp9Aa+E5rmXbKbd2HrYNt/c7qX12+c8RMxmIL9x/rx/resN11Pxd/1bzKMosjfr5WO
	 EBb407vyiK16PZZtXyD55QiPq5/k7QkoC6cHVzLWaDpHfpNsMDRZ1BggFYNJ8GH7lqu3e
	 xJzf/VfCf17sr42GtMzjQEpdvgavSKqSiNX4aAXkLfVFfOORip4u/aKWmSU3PkwIy2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=vHTynKP4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E58D606A31A
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 00:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=vHTynKP4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F67A1F000C1;
	Fri, 30 Oct 2026 00:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793321550;
	bh=KTyLfqpPqJPW4V7IJFkvueSZBNZx2dnR4ZDJatY9jgY=;
	h=Date:To:From:Subject;
	b=vHTynKP4iRy5nX7XFlLO5k6L9uov2UqmdJPuJLtxT3lWelHq/rRbxhmp7ytng6Feu
	 VycgLWJZzqM28ng05RUDjdB9CgvksSp1uUiFITAwGupVd7TjYsW3j2roeunZDkBaAn
	 aPhjQ6ZMDxiNVckcZIC3a+iMu0o/b5GMxueE/XUM=
Date: Thu, 29 Oct 2026 17:52:30 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	sshegde@linux.ibm.com,skhan@linuxfoundation.org,rppt@kernel.org,
	ritesh.list@gmail.com,rdunlap@infradead.org,qi.zheng@linux.dev,
	osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,mhocko@suse.com,
	maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,
	david@kernel.org,corbet@lwn.net,chleroy@kernel.org,muchun.song@linux.dev,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-mm-map-shared-vmemmap-tail-pages-as-read-only.patch added to mm-new branch
Message-Id: <20261030005230.8F67A1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: powerpc/mm: map shared vmemmap tail pages as read-only
has been added to the -mm mm-new branch.  Its filename is
     powerpc-mm-map-shared-vmemmap-tail-pages-as-read-only.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-mm-map-shared-vmemmap-tail-pages-as-read-only.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Muchun Song <muchun.song@linux.dev>
Subject: powerpc/mm: map shared vmemmap tail pages as read-only
Date: Mon, 19 Oct 2026 17:08:28 +0800

PowerPC radix uses an architecture-specific vmemmap population path for
shared tail mappings, so it does not inherit the read-only protection added
to the common path.

Protect these mappings as well so illegal writes fault instead of
corrupting metadata shared by multiple tail pages.

Link: https://lore.kernel.org/20261019090830.1917657-3-songmuchun@bytedance.com
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <chleroy@kernel.org>
Cc: Shrikanth Hegde <sshegde@linux.ibm.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
---

 arch/powerpc/mm/book3s64/radix_pgtable.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/powerpc/mm/book3s64/radix_pgtable.c~powerpc-mm-map-shared-vmemmap-tail-pages-as-read-only
+++ a/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -1059,6 +1059,9 @@ static pte_t * __meminit radix__vmemmap_
 
 		VM_BUG_ON(!PAGE_ALIGNED(addr));
 		entry = pfn_pte(__pa(p) >> PAGE_SHIFT, PAGE_KERNEL);
+		/* Map the shared tail page as read-only to catch illegal writes. */
+		if (reuse)
+			entry = pte_wrprotect(entry);
 		set_pte_at(&init_mm, addr, pte, entry);
 		asm volatile("ptesync": : :"memory");
 	}
_

Patches currently in -mm which might be from muchun.song@linux.dev are

riscv-mm-fix-hotplug-page-table-destructor-handling.patch
riscv-mm-fix-missing-destructor-for-hotplug-pud-tables.patch
mm-fix-missing-page-table-destructor-in-pagetable_free.patch
arm64-mm-fix-destructor-for-unconstructed-hotplug-page-tables.patch
mm-sparse-vmemmap-map-shared-vmemmap-tail-pages-as-read-only.patch
powerpc-mm-map-shared-vmemmap-tail-pages-as-read-only.patch
mm-hugetlb_vmemmap-remove-vmemmap_wrprotect_hvo.patch
mm-hugetlb_vmemmap-remove-hugetlb_vmemmap_optimize_bootmem_folios.patch

