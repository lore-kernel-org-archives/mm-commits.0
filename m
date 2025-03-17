Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132D22165EA
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188369; cv=none; b=R+mPCSC2QeNsFP/b9sdWXYdQRHgDrQR1Zj27yVwLMb7PJ0yqGHXlyARb9aBlAGu36iY1rD9slYpDKN8DrlGz7W0sK7NYGekWEMbGpLMIwzAKFIpZyTi5h0DmlY8pop+TRcZESuktZml3QEHPX7yS2OkvZw3gUp8mxkHaoHYq7yE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188369; c=relaxed/simple;
	bh=PACBrH+dYgYrHlAtJnvtDeBtnqTb2vlzP57yhSgXB6w=;
	h=Date:To:From:Subject:Message-Id; b=ZEUyr+ua7nj6bz13pFw3nqY0avRj4DkiWg2YMdPXmAmyFd29I6VZpJBScN8XPjyOCSB5QGaZh7vD1zrhrIRS29RkaGxFwT39KyPi0vTbQe666q3GdiP2VyREzxazFaF1vAdzc/6YCy6Q4I8xoe57ANMyWONf+dES7jaUbVDCHRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fuhtQy+O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fuhtQy+O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E8D0C4CEEC;
	Mon, 17 Mar 2025 05:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188368;
	bh=PACBrH+dYgYrHlAtJnvtDeBtnqTb2vlzP57yhSgXB6w=;
	h=Date:To:From:Subject:From;
	b=fuhtQy+OtVE0FUPJ8hJJweE3CHaX2FJ/mTU9GHfMZDh3vkTS37mDaJkabcLKXtMet
	 ZywWrkFtCXxUzvOhA1Iz51o4toTjXWIz/coh0Y8khv37JG4Ah6KKOCCD7TX1CHKE5/
	 47btnoJm0K3CMVhy5Q1aSI/IcDuGCynnHMVdPOh4=
Date: Sun, 16 Mar 2025 22:12:48 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,usamaarif642@gmail.com,roman.gushchin@linux.dev,peterz@infradead.org,osalvador@suse.de,muchun.song@linux.dev,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,joao.m.martins@oracle.com,hca@linux.ibm.com,hannes@cmpxchg.org,gor@linux.ibm.com,david@redhat.com,dave.hansen@linux.intel.com,dan.carpenter@linaro.org,arnd@arndb.de,agordeev@linux.ibm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-mm-make-register_page_bootmem_memmap-handle-pte-mappings.patch removed from -mm tree
Message-Id: <20250317051248.8E8D0C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/mm: make register_page_bootmem_memmap handle PTE mappings
has been removed from the -mm tree.  Its filename was
     x86-mm-make-register_page_bootmem_memmap-handle-pte-mappings.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Frank van der Linden <fvdl@google.com>
Subject: x86/mm: make register_page_bootmem_memmap handle PTE mappings
Date: Fri, 28 Feb 2025 18:29:09 +0000

register_page_bootmem_memmap expects that vmemmap pages handed to it are
PMD-mapped, and that the number of pages to call get_page_bootmem on is
PMD-aligned.

This is currently a correct assumption, but will no longer be true once
pre-HVO of hugetlb pages is implemented.

Make it handle PTE-mapped vmemmap pages and a nr_pages argument that is
not necessarily PAGES_PER_SECTION.

Link: https://lkml.kernel.org/r/20250228182928.2645936-9-fvdl@google.com
Signed-off-by: Frank van der Linden <fvdl@google.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- a/arch/x86/mm/init_64.c~x86-mm-make-register_page_bootmem_memmap-handle-pte-mappings
+++ a/arch/x86/mm/init_64.c
@@ -1599,11 +1599,14 @@ void register_page_bootmem_memmap(unsign
 		}
 		get_page_bootmem(section_nr, pud_page(*pud), MIX_SECTION_INFO);
 
-		if (!boot_cpu_has(X86_FEATURE_PSE)) {
+		pmd = pmd_offset(pud, addr);
+		if (pmd_none(*pmd)) {
+			next = (addr + PAGE_SIZE) & PAGE_MASK;
+			continue;
+		}
+
+		if (!boot_cpu_has(X86_FEATURE_PSE) || !pmd_leaf(*pmd)) {
 			next = (addr + PAGE_SIZE) & PAGE_MASK;
-			pmd = pmd_offset(pud, addr);
-			if (pmd_none(*pmd))
-				continue;
 			get_page_bootmem(section_nr, pmd_page(*pmd),
 					 MIX_SECTION_INFO);
 
@@ -1614,12 +1617,7 @@ void register_page_bootmem_memmap(unsign
 					 SECTION_INFO);
 		} else {
 			next = pmd_addr_end(addr, end);
-
-			pmd = pmd_offset(pud, addr);
-			if (pmd_none(*pmd))
-				continue;
-
-			nr_pmd_pages = 1 << get_order(PMD_SIZE);
+			nr_pmd_pages = (next - addr) >> PAGE_SHIFT;
 			page = pmd_page(*pmd);
 			while (nr_pmd_pages--)
 				get_page_bootmem(section_nr, page++,
_

Patches currently in -mm which might be from fvdl@google.com are


