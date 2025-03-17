Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336BE216602
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188394; cv=none; b=svWdVwCs2wZ2RCtOVpZuWLDG8RIZhM48bHOGl+Z7GobCdLPzejhDt7K+TJSbQgEiCyaYLuaqOFo+iH3b/QGR/d31H+xI9WRs1jEz3qOcSRIonMwPohQvPDMfPepTrpXUi2VET74I5zBxl5WZ01HbZye6TrhcBjrsb+LQIj63QRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188394; c=relaxed/simple;
	bh=CdmYJxI3Py2ZjauyfZwLOTXmktS92IWFhvZdD9AMPVk=;
	h=Date:To:From:Subject:Message-Id; b=qgm8huF2b0I+XDnxoeGutQXkM0HmszLZ3mI9OrPUgafAJapYSgqBdCKhQM16jqcnvcY07vhIJx1GfVBsRRjFIYeR2PPwXMdXGzs89mXUDYd07rfhxYoewjDhHaSUJ5qlYw1dOzf1FARL5oA1UL0p1DCA8WncTT6m6hMLyJ5ldzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j3jxAlGK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j3jxAlGK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A284CC4CEEC;
	Mon, 17 Mar 2025 05:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188393;
	bh=CdmYJxI3Py2ZjauyfZwLOTXmktS92IWFhvZdD9AMPVk=;
	h=Date:To:From:Subject:From;
	b=j3jxAlGK/nFvYiDz2YUP1E0DmWwSc2QYLnqJ5UQDqi/KTRHpdH7RFsigffHC/NDiV
	 lkrwAWa/wmc4EllhCVsUNQU2I8LsnQ8++JOjsSr5mYLiWaZq41Hq5DobtlWuSeI1C9
	 87QsA9xXLKEV/Mz6G0ydGRkeCLaSS6d1z0Wqeeys=
Date: Sun, 16 Mar 2025 22:13:13 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,usamaarif642@gmail.com,roman.gushchin@linux.dev,peterz@infradead.org,osalvador@suse.de,muchun.song@linux.dev,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,joao.m.martins@oracle.com,hca@linux.ibm.com,hannes@cmpxchg.org,gor@linux.ibm.com,david@redhat.com,dave.hansen@linux.intel.com,dan.carpenter@linaro.org,arnd@arndb.de,agordeev@linux.ibm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-mm-set-arch_want_hugetlb_vmemmap_preinit.patch removed from -mm tree
Message-Id: <20250317051313.A284CC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/mm: set ARCH_WANT_HUGETLB_VMEMMAP_PREINIT
has been removed from the -mm tree.  Its filename was
     x86-mm-set-arch_want_hugetlb_vmemmap_preinit.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Frank van der Linden <fvdl@google.com>
Subject: x86/mm: set ARCH_WANT_HUGETLB_VMEMMAP_PREINIT
Date: Fri, 28 Feb 2025 18:29:22 +0000

Now that hugetlb bootmem pages are allocated earlier, and available for
section preinit (HVO-style), set ARCH_WANT_HUGETLB_VMEMMAP_PREINIT for
x86_64, so that is can be done.

This enables pre-HVO on x86_64.

Link: https://lkml.kernel.org/r/20250228182928.2645936-22-fvdl@google.com
Signed-off-by: Frank van der Linden <fvdl@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/Kconfig~x86-mm-set-arch_want_hugetlb_vmemmap_preinit
+++ a/arch/x86/Kconfig
@@ -146,6 +146,7 @@ config X86
 	select ARCH_WANT_LD_ORPHAN_WARN
 	select ARCH_WANT_OPTIMIZE_DAX_VMEMMAP	if X86_64
 	select ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP	if X86_64
+	select ARCH_WANT_HUGETLB_VMEMMAP_PREINIT if X86_64
 	select ARCH_WANTS_THP_SWAP		if X86_64
 	select ARCH_HAS_PARANOID_L1D_FLUSH
 	select BUILDTIME_TABLE_SORT
_

Patches currently in -mm which might be from fvdl@google.com are


